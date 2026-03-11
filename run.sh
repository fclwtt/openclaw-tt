#!/bin/bash

# Skill Searcher - 通用技能搜索服务
# 支持 ClawHub 和 GitHub 搜索、智能评分、安全预审和缓存

set -e

# 配置
CACHE_DIR="$HOME/.openclaw/skills/skill-searcher/cache"
CONFIG_FILE="$HOME/.openclaw/skills/skill-searcher/config.json"
LOG_FILE="$HOME/.openclaw/skills/skill-searcher/logs/search.log"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 确保目录存在
mkdir -p "$CACHE_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# 检查缓存
check_cache() {
    local query="$1"
    local platform="$2"
    local cache_file="$CACHE_DIR/search_$(echo "$query$platform" | md5sum | cut -d' ' -f1).json"
    
    if [ -f "$cache_file" ]; then
        local expires_at=$(jq -r '.expires_at' "$cache_file" 2>/dev/null || echo "0")
        local now=$(date +%s)
        
        if [ "$now" -lt "$expires_at" ]; then
            echo "$cache_file"
            return 0
        fi
    fi
    
    return 1
}

# 保存到缓存
save_cache() {
    local query="$1"
    local platform="$2"
    local results="$3"
    local ttl_hours="${4:-24}"
    
    local cache_file="$CACHE_DIR/search_$(echo "$query$platform" | md5sum | cut -d' ' -f1).json"
    local now=$(date +%s)
    local expires_at=$((now + ttl_hours * 3600))
    
    echo "$results" | jq --argjson expires "$expires_at" '. + {expires_at: $expires}' > "$cache_file"
    log "Cached search: $query ($platform)"
}

# ClawHub 搜索
search_clawhub() {
    local query="$1"
    local limit="${2:-10}"
    
    log "Searching ClawHub: $query"
    
    # 执行 clawhub search
    local results=$(clawhub search "$query" 2>/dev/null || echo "[]")
    
    echo "$results"
}

# GitHub 搜索
search_github() {
    local query="$1"
    local limit="${2:-10}"
    
    log "Searching GitHub: $query"
    
    # 执行 gh search
    local results=$(gh search repos "$query" --limit "$limit" --json name,owner,description,stargazersCount,updatedAt 2>/dev/null || echo "[]")
    
    echo "$results"
}

# 计算技能对口度评分
calculate_relevance() {
    local query="$1"
    local skill_desc="$2"
    
    # 简单的关键词匹配（实际应该用语义匹配）
    local query_words=$(echo "$query" | tr ' ' '\n' | wc -l)
    local match_count=0
    
    for word in $query; do
        if echo "$skill_desc" | grep -qi "$word"; then
            ((match_count++))
        fi
    done
    
    if [ "$query_words" -gt 0 ]; then
        echo $((match_count * 100 / query_words))
    else
        echo 0
    fi
}

# 计算社区分
calculate_community_score() {
    local downloads_or_stars="$1"
    
    if [ "$downloads_or_stars" -gt 0 ]; then
        # log10 近似计算
        local log_val=$(echo "l($downloads_or_stars)/l(10)" | bc -l 2>/dev/null || echo "1")
        echo $(echo "$log_val * 25" | bc 2>/dev/null || echo "50")
    else
        echo 50
    fi
}

# 计算活跃度
calculate_activity_score() {
    local days_since_update="$1"
    
    if [ "$days_since_update" -lt 7 ]; then
        echo 100
    elif [ "$days_since_update" -lt 30 ]; then
        echo 80
    elif [ "$days_since_update" -lt 90 ]; then
        echo 60
    elif [ "$days_since_update" -lt 180 ]; then
        echo 40
    else
        echo 20
    fi
}

# 计算成熟度
calculate_maturity_score() {
    local version="$1"
    
    # 解析版本号 (major.minor.patch)
    local major=$(echo "$version" | cut -d'.' -f1)
    local minor=$(echo "$version" | cut -d'.' -f2)
    local patch=$(echo "$version" | cut -d'.' -f3)
    
    major=${major:-0}
    minor=${minor:-0}
    patch=${patch:-0}
    
    echo $((major * 40 + minor * 30 + patch * 30))
}

# 综合评分
calculate_total_score() {
    local relevance="$1"
    local community="$2"
    local activity="$3"
    local maturity="$4"
    
    # 权重：对口度 50%, 社区 25%, 活跃度 15%, 成熟度 10%
    local total=$(( (relevance * 50 + community * 25 + activity * 15 + maturity * 10) / 100 ))
    echo "$total"
}

# 安全预审
security_vet() {
    local skill_path="$1"
    local skill_md="$skill_path/SKILL.md"
    
    if [ ! -f "$skill_md" ]; then
        echo "UNKNOWN"
        return
    fi
    
    # 检查红旗标记
    local red_flags=0
    
    # 检查危险模式
    if grep -qiE "(curl|wget).*http" "$skill_md" 2>/dev/null; then
        ((red_flags++))
    fi
    
    if grep -qiE "(password|token|api.?key|secret)" "$skill_md" 2>/dev/null; then
        ((red_flags++))
    fi
    
    if grep -qiE "(eval|exec).*input" "$skill_md" 2>/dev/null; then
        ((red_flags++))
    fi
    
    if grep -qiE "base64.*decode" "$skill_md" 2>/dev/null; then
        ((red_flags++))
    fi
    
    if grep -qiE "(MEMORY\.md|USER\.md|SOUL\.md|IDENTITY\.md)" "$skill_md" 2>/dev/null; then
        ((red_flags++))
    fi
    
    # 风险分级
    if [ "$red_flags" -gt 0 ]; then
        echo "EXTREME"
    else
        echo "LOW"
    fi
}

# 主搜索函数
main_search() {
    local query="$1"
    local platform="${2:-both}"
    local limit="${3:-10}"
    local no_cache="${4:-false}"
    local cache_ttl="${5:-24}"
    
    echo -e "${BLUE}🔍 Skill Searcher${NC}"
    echo "═══════════════════════════════════════"
    echo "查询：\"$query\""
    echo "平台：$platform"
    echo "限制：$limit"
    echo "───────────────────────────────────────"
    
    local results="[]"
    local cache_hit=false
    
    # 检查缓存
    if [ "$no_cache" != "true" ]; then
        local cached=$(check_cache "$query" "$platform")
        if [ -n "$cached" ]; then
            results=$(cat "$cached")
            cache_hit=true
            echo -e "缓存：${GREEN}✅ 命中${NC}"
        fi
    fi
    
    # 执行搜索
    if [ "$cache_hit" = false ]; then
        echo -e "缓存：${YELLOW}❌ 未命中${NC} (执行搜索)"
        
        local clawhub_results="[]"
        local github_results="[]"
        
        if [ "$platform" = "both" ] || [ "$platform" = "clawhub" ]; then
            clawhub_results=$(search_clawhub "$query" "$limit")
        fi
        
        if [ "$platform" = "both" ] || [ "$platform" = "github" ]; then
            github_results=$(search_github "$query" "$limit")
        fi
        
        # 合并结果（简化版）
        results=$(echo "{\"clawhub\": $clawhub_results, \"github\": $github_results}" | jq '.')
        
        # 保存到缓存
        save_cache "$query" "$platform" "$results" "$cache_ttl"
    fi
    
    echo "───────────────────────────────────────"
    echo "$results" | jq '.'
    
    log "Search complete: $query ($platform)"
}

# 显示帮助
show_help() {
    echo "Skill Searcher - 通用技能搜索服务"
    echo ""
    echo "用法:"
    echo "  $0 search <query> [options]"
    echo "  $0 evaluate <skill-name>"
    echo "  $0 compare <skill1> <skill2> [skill3...]"
    echo "  $0 cache <list|clear|status>"
    echo ""
    echo "搜索选项:"
    echo "  --platform <clawhub|github|both>  指定平台 (默认：both)"
    echo "  --limit <number>                  结果数量限制 (默认：10)"
    echo "  --no-cache                        不使用缓存"
    echo "  --cache-ttl <hours>               缓存过期时间 (默认：24)"
    echo "  --output <file>                   导出到文件"
    echo ""
    echo "示例:"
    echo "  $0 search \"postgres backup\""
    echo "  $0 search \"pdf editor\" --platform github"
    echo "  $0 search \"automation\" --cache-ttl 48"
}

# 主入口
case "${1:-}" in
    search)
        shift
        query="$1"
        shift
        
        platform="both"
        limit=10
        no_cache=false
        cache_ttl=24
        output=""
        
        while [ $# -gt 0 ]; do
            case "$1" in
                --platform)
                    platform="$2"
                    shift 2
                    ;;
                --limit)
                    limit="$2"
                    shift 2
                    ;;
                --no-cache)
                    no_cache=true
                    shift
                    ;;
                --cache-ttl)
                    cache_ttl="$2"
                    shift 2
                    ;;
                --output)
                    output="$2"
                    shift 2
                    ;;
                *)
                    shift
                    ;;
            esac
        done
        
        if [ -z "$query" ]; then
            echo -e "${RED}错误：请提供搜索查询${NC}"
            show_help
            exit 1
        fi
        
        main_search "$query" "$platform" "$limit" "$no_cache" "$cache_ttl"
        ;;
    
    evaluate)
        shift
        echo "评估技能：$1"
        # TODO: 实现技能评估
        ;;
    
    compare)
        shift
        echo "比较技能：$*"
        # TODO: 实现技能比较
        ;;
    
    cache)
        case "${2:-list}" in
            list)
                echo "缓存文件:"
                ls -la "$CACHE_DIR" 2>/dev/null || echo "无缓存"
                ;;
            clear)
                rm -rf "$CACHE_DIR"/*
                echo "缓存已清除"
                ;;
            status)
                echo "缓存目录：$CACHE_DIR"
                echo "缓存文件数：$(ls -1 "$CACHE_DIR" 2>/dev/null | wc -l)"
                ;;
            *)
                echo "未知缓存命令：$2"
                ;;
        esac
        ;;
    
    help|--help|-h)
        show_help
        ;;
    
    *)
        echo -e "${RED}错误：未知命令${NC}"
        show_help
        exit 1
        ;;
esac
