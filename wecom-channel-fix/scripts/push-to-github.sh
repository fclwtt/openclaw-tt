#!/bin/bash
# Skill Publisher - 推送到 GitHub Monorepo
# 用法：./push-to-github.sh <skill-name>

set -e

SKILL_NAME="${1:-}"
GITHUB_USER="fclwtt"
MONOREPO="openclaw-tt"
REMOTE="git@github.com:$GITHUB_USER/$MONOREPO.git"

if [ -z "$SKILL_NAME" ]; then
    echo "用法：./push-to-github.sh <skill-name>"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."

echo "🚀 OpenClaw Skill GitHub 推送工具"
echo "=================================="
echo ""
echo "技能：$SKILL_NAME"
echo "仓库：$GITHUB_USER/$MONOREPO (Monorepo)"
echo ""

# 检查 Git
if ! command -v git &> /dev/null; then
    echo "❌ Git 未安装"
    exit 1
fi

# 检查 SSH 密钥
echo "🔍 检查 GitHub 连接..."
if ! ls -la ~/.ssh/id_ed25519* &> /dev/null; then
    echo ""
    echo "🔑 未检测到 SSH 密钥"
    echo ""
    echo "请执行以下步骤："
    echo ""
    echo "1. 生成 SSH 密钥："
    echo "   ssh-keygen -t ed25519 -C \"your@email.com\""
    echo ""
    echo "2. 查看公钥："
    echo "   cat ~/.ssh/id_ed25519.pub"
    echo ""
    echo "3. 添加到 GitHub："
    echo "   - 访问 https://github.com/settings/keys"
    echo "   - 点击 'New SSH key'"
    echo "   - 粘贴公钥内容"
    echo ""
    echo "完成后回复 'done' 继续推送。"
    exit 1
fi

# 测试 GitHub 连接
if ! ssh -T git@github.com &> /dev/null; then
    echo "❌ GitHub SSH 连接失败"
    echo "请检查 SSH 密钥是否正确添加到 GitHub"
    exit 1
fi

echo "✅ GitHub 连接正常"
echo ""

# 初始化 Git（如未初始化）
cd "$PROJECT_DIR"
if [ ! -d ".git" ]; then
    echo "📦 初始化 Git 仓库..."
    git init
    git add .
    git commit -m "Initial commit: $SKILL_NAME"
fi

# 添加远程仓库
if ! git remote | grep -q origin; then
    echo "🔗 配置远程仓库..."
    git remote add origin "$REMOTE"
fi

# 推送到 Monorepo（使用 subtree）
echo ""
echo "🚀 推送到 Monorepo..."
echo "   仓库：https://github.com/$GITHUB_USER/$MONOREPO"
echo "   路径：$SKILL_NAME/"
echo ""

# 检查远程仓库是否存在
if ! git ls-remote origin &> /dev/null; then
    echo "⚠️  远程仓库不存在或无法访问"
    echo ""
    echo "请先在 GitHub 创建空仓库："
    echo "1. 访问 https://github.com/new"
    echo "2. Repository name: $MONOREPO"
    echo "3. 不要勾选任何初始化选项"
    echo "4. 点击 'Create repository'"
    echo ""
    echo "完成后回复 'done' 继续推送。"
    exit 1
fi

# 使用 subtree 推送
git subtree add --prefix="$SKILL_NAME" . main --squash || {
    echo "⚠️  subtree add 失败（可能已存在）"
    echo "尝试更新..."
    git subtree pull --prefix="$SKILL_NAME" origin main --squash || true
}

git push origin main

echo ""
echo "✅ 推送成功！"
echo ""
echo "访问你的项目："
echo "https://github.com/$GITHUB_USER/$MONOREPO/tree/main/$SKILL_NAME"
echo ""
echo "安装方式："
echo "git clone https://github.com/$GITHUB_USER/$MONOREPO.git"
echo "cd $MONOREPO/$SKILL_NAME"
echo "./install.sh"
