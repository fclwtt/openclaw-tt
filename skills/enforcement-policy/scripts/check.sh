#!/bin/bash
# 强制审查策略检查脚本
# 用于验证系统的安全审查和技能优先机制是否正常工作

set -e

OPENCLAW_ROOT="$HOME/.openclaw"

echo "🔍 强制审查策略检查"
echo "===================="
echo ""

# 检查全局规则文件
echo "📄 检查全局规则文件..."
if [ -f "$OPENCLAW_ROOT/_GLOBAL_RULES.md" ]; then
    echo "  ✅ _GLOBAL_RULES.md 存在"
    LINES=$(wc -l < "$OPENCLAW_ROOT/_GLOBAL_RULES.md")
    echo "  📊 行数: $LINES"
else
    echo "  ❌ _GLOBAL_RULES.md 不存在"
fi

echo ""

# 检查 Hook
echo "🪝 检查全局规则注入 Hook..."
if [ -f "$OPENCLAW_ROOT/hooks/global-rules-injector/handler.js" ]; then
    echo "  ✅ global-rules-injector hook 存在"
    # 检查是否使用 path 字段
    if grep -q "path:" "$OPENCLAW_ROOT/hooks/global-rules-injector/handler.js"; then
        echo "  ✅ 使用正确的 path 字段"
    else
        echo "  ⚠️ 可能使用了错误的字段名"
    fi
else
    echo "  ❌ global-rules-injector hook 不存在"
fi

echo ""

# 检查技能
echo "📦 检查相关技能..."

SKILLS=(
    "enforcement-policy"
    "mupeng-skill-router"
    "skill-install-gateway"
)

for skill in "${SKILLS[@]}"; do
    if [ -d "$OPENCLAW_ROOT/skills/$skill" ]; then
        echo "  ✅ $skill 存在"
    else
        echo "  ❌ $skill 不存在"
    fi
done

echo ""

# 检查 openclaw.json 配置
echo "⚙️ 检查 openclaw.json 配置..."
if grep -q "global-rules-injector" "$OPENCLAW_ROOT/openclaw.json"; then
    echo "  ✅ global-rules-injector 已配置"
else
    echo "  ⚠️ global-rules-injector 未配置"
fi

echo ""

# 检查最新日志
echo "📋 检查最新日志..."
LOG_FILE="/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log"
if [ -f "$LOG_FILE" ]; then
    if grep -q "Injected global rules" "$LOG_FILE" 2>/dev/null; then
        echo "  ✅ 全局规则已注入"
    else
        echo "  ⚠️ 未发现全局规则注入记录"
    fi
    
    if grep -q "skipping bootstrap file" "$LOG_FILE" 2>/dev/null; then
        echo "  ⚠️ 发现 bootstrap 文件跳过警告"
    else
        echo "  ✅ 无 bootstrap 文件跳过警告"
    fi
else
    echo "  ⚠️ 日志文件不存在: $LOG_FILE"
fi

echo ""
echo "===================="
echo "✅ 检查完成"