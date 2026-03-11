#!/bin/bash
# OpenClaw Skill 卸载脚本
# 用法：./uninstall.sh

set -e

SKILL_NAME="wecom-channel-fix"
SKILLS_DIR="$HOME/.openclaw/skills"

echo "🔧 OpenClaw Skill 卸载程序"
echo "=========================="
echo ""

# 检查技能是否存在
if [ ! -d "$SKILLS_DIR/$SKILL_NAME" ]; then
    echo "❌ 技能未安装"
    exit 1
fi

echo "📍 技能位置：$SKILLS_DIR/$SKILL_NAME"
echo ""
echo "⚠️  确定要卸载吗？(y/N)"
read -r confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "❌ 卸载取消"
    exit 0
fi

# 删除技能
echo "🗑️  正在删除技能..."
rm -rf "$SKILLS_DIR/$SKILL_NAME"

# 验证删除
if [ ! -d "$SKILLS_DIR/$SKILL_NAME" ]; then
    echo "✅ 技能已删除"
else
    echo "❌ 错误：删除失败"
    exit 1
fi

# 重启 Gateway
echo ""
echo "🔄 正在重启 Gateway..."
openclaw gateway restart

# 等待 Gateway 启动
sleep 3

echo ""
echo "=========================="
echo "✅ 卸载完成！"
echo ""
