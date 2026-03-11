#!/bin/bash
# 企业微信通道配置修复脚本
# 用法：./fix-wecom-config.sh [--backup] [--fix-plugin-id] [--fix-multi-account]

set -e

CONFIG_FILE="$HOME/.openclaw/openclaw.json"
BACKUP_DIR="$HOME/.openclaw/backups"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

echo "🔧 企业微信通道配置修复工具"
echo "=========================="
echo ""

# 备份配置
backup_config() {
    mkdir -p "$BACKUP_DIR"
    cp "$CONFIG_FILE" "$BACKUP_DIR/openclaw.json.backup.$TIMESTAMP"
    echo "✅ 配置已备份：$BACKUP_DIR/openclaw.json.backup.$TIMESTAMP"
}

# 修复插件 ID
fix_plugin_id() {
    echo "📝 修复插件 ID 配置..."
    
    if grep -q '"wecom-openclaw-plugin"' "$CONFIG_FILE"; then
        sed -i 's/"wecom-openclaw-plugin"/"wecom"/g' "$CONFIG_FILE"
        echo "✅ 插件 ID 已修复（wecom-openclaw-plugin → wecom）"
    else
        echo "ℹ️  插件 ID 配置正确，无需修复"
    fi
}

# 检查多账号模式
check_multi_account() {
    if grep -q '"accounts":' "$CONFIG_FILE"; then
        echo "⚠️  检测到多账号模式配置（当前插件不支持）"
        echo ""
        read -p "是否回退到单账号模式？(y/N): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo "📝 请手动修改配置，参考 README.md 中的单账号模板"
            # 自动修复需要更复杂的 JSON 处理，建议手动操作
        fi
    else
        echo "✅ 配置为单账号模式"
    fi
}

# 验证配置
validate_config() {
    echo ""
    echo "🔍 验证配置..."
    
    if command -v openclaw &> /dev/null; then
        openclaw channels status 2>&1 | grep -E "(企业微信|wecom)"
    else
        echo "⚠️  openclaw 命令不可用，跳过验证"
    fi
}

# 主流程
main() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "❌ 配置文件不存在：$CONFIG_FILE"
        exit 1
    fi
    
    # 备份
    if [[ "$1" == "--backup" ]] || [[ -z "$1" ]]; then
        backup_config
    fi
    
    # 修复插件 ID
    if [[ "$1" == "--fix-plugin-id" ]] || [[ -z "$1" ]]; then
        fix_plugin_id
    fi
    
    # 检查多账号
    check_multi_account
    
    # 验证
    validate_config
    
    echo ""
    echo "=========================="
    echo "✅ 修复完成！"
    echo ""
    echo "下一步："
    echo "1. 重启 gateway: openclaw gateway restart"
    echo "2. 测试企微消息"
    echo "3. 查看日志：tail -f /tmp/openclaw/openclaw-*.log | grep wecom"
}

main "$@"
