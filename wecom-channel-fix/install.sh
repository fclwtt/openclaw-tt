#!/bin/bash
# OpenClaw Skill 安装脚本
# 用法：./install.sh

set -e

SKILL_NAME="wecom-channel-fix"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCLAW_DIR="$HOME/.openclaw"
SKILLS_DIR="$OPENCLAW_DIR/skills"

echo "🔧 OpenClaw Skill 安装程序"
echo "=========================="
echo ""

# 检查 OpenClaw 是否安装
if ! command -v openclaw &> /dev/null; then
    echo "❌ 错误：未检测到 OpenClaw"
    echo "请先安装 OpenClaw: npm install -g openclaw"
    exit 1
fi

echo "✅ OpenClaw 已安装"

# 创建技能目录
mkdir -p "$SKILLS_DIR"
echo "✅ 技能目录：$SKILLS_DIR"

# 检查是否已安装
if [ -d "$SKILLS_DIR/$SKILL_NAME" ]; then
    echo "⚠️  技能已安装，是否覆盖？(y/N)"
    read -r confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$SKILLS_DIR/$SKILL_NAME"
        echo "🗑️  已删除旧版本"
    else
        echo "❌ 安装取消"
        exit 0
    fi
fi

# 复制技能文件
echo "📦 正在安装技能..."
mkdir -p "$SKILLS_DIR/$SKILL_NAME"
cp -r "$SCRIPT_DIR/skills/"* "$SKILLS_DIR/$SKILL_NAME/"

# 验证安装
if [ -f "$SKILLS_DIR/$SKILL_NAME/SKILL.md" ]; then
    echo "✅ 技能文件已复制"
else
    echo "❌ 错误：技能文件复制失败"
    exit 1
fi

# 重启 Gateway
echo ""
echo "🔄 正在重启 Gateway..."
openclaw gateway restart

# 等待 Gateway 启动
sleep 3

# 验证 Gateway 状态
if openclaw gateway status &> /dev/null; then
    echo "✅ Gateway 运行正常"
else
    echo "⚠️  Gateway 状态异常，请手动检查"
fi

echo ""
echo "=========================="
echo "✅ 安装完成！"
echo ""
echo "使用方法："
echo "1. 在企微或 webchat 中说：'企微通道配置错误'"
echo "2. 或说：'wecom 连不上'"
echo "3. 或说：'插件 ID 不匹配'"
echo ""
echo "技能位置：$SKILLS_DIR/$SKILL_NAME"
echo ""
