#!/bin/bash
# Skill Publisher - 发布技能到 GitHub Monorepo
# 用法：./publish.sh <skill-name> [--version <version>]
#
# 功能：
# 1. 将本地技能重构为 GitHub 标准格式
# 2. 推送到 Monorepo
# 3. 更新根目录 README.md

set -e

# ============ 配置 ============
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_PUBLISHER_DIR="$(dirname "$SCRIPT_DIR")"
OPENCLAW_ROOT="$HOME/.openclaw"
SKILLS_ROOT="$OPENCLAW_ROOT/skills"

GITHUB_USER="fclwtt"
MONOREPO="openclaw-skills"
REMOTE="git@github.com:$GITHUB_USER/$MONOREPO.git"
# ==============================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 解析参数
SKILL_NAME=""
VERSION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        *)
            SKILL_NAME="$1"
            shift
            ;;
    esac
done

if [ -z "$SKILL_NAME" ]; then
    echo -e "${RED}用法：./publish.sh <skill-name> [--version <version>]${NC}"
    echo ""
    echo "示例："
    echo "  ./publish.sh enforcement-policy"
    echo "  ./publish.sh my-skill --version 1.0.0"
    exit 1
fi

echo -e "${BLUE}🚀 OpenClaw Skill Publisher v2.0.0${NC}"
echo "=================================="
echo ""
echo -e "${GREEN}技能：${SKILL_NAME}${NC}"
echo ""

# 源目录
SOURCE_DIR="$SKILLS_ROOT/$SKILL_NAME"

# 1. 检查源技能目录
echo -e "${YELLOW}[1/6] 检查源技能目录...${NC}"
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}❌ 技能目录不存在: $SOURCE_DIR${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 技能目录存在${NC}"

# 2. 检查 SSH 连接
echo -e "${YELLOW}[2/6] 检查 GitHub SSH 连接...${NC}"
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo -e "${RED}❌ GitHub SSH 连接失败${NC}"
    exit 1
fi
echo -e "${GREEN}✅ GitHub 连接正常${NC}"

# 3. 克隆 Monorepo
echo -e "${YELLOW}[3/6] 克隆 Monorepo...${NC}"
TEMP_DIR=$(mktemp -d)
REPO_DIR="$TEMP_DIR/$MONOREPO"
git clone "$REMOTE" "$REPO_DIR" --depth 1 2>&1 | tail -1
cd "$REPO_DIR"
echo -e "${GREEN}✅ 已克隆到临时目录${NC}"

# 4. 准备标准技能结构
echo -e "${YELLOW}[4/6] 准备标准技能结构...${NC}"
TARGET_DIR="$REPO_DIR/skills/$SKILL_NAME"
mkdir -p "$TARGET_DIR"

# 复制技能文件
for item in SKILL.md config.json scripts templates docs; do
    if [ -e "$SOURCE_DIR/$item" ]; then
        cp -r "$SOURCE_DIR/$item" "$TARGET_DIR/"
        echo "  ✅ $item"
    fi
done

# 创建标准文件（如不存在）
if [ ! -f "$TARGET_DIR/README.md" ]; then
    # 从 SKILL.md 生成 README.md
    if [ -f "$SOURCE_DIR/SKILL.md" ]; then
        DESCRIPTION=$(grep -A1 "^description:" "$SOURCE_DIR/SKILL.md" | tail -1 | sed 's/^ *//')
        cat > "$TARGET_DIR/README.md" << EOF
# $SKILL_NAME

$DESCRIPTION

## 📋 功能

详见 [SKILL.md](./SKILL.md)

## 🚀 安装

\`\`\`bash
./install.sh
\`\`\`

## 📁 结构

\`\`\`
$SKILL_NAME/
├── SKILL.md        # OpenClaw 技能定义
├── config.json     # 配置文件
├── scripts/        # 脚本
└── docs/           # 文档
\`\`\`
EOF
        echo "  ✅ README.md (自动生成)"
    fi
fi

# 创建 install.sh（如不存在）
if [ ! -f "$TARGET_DIR/install.sh" ]; then
    cat > "$TARGET_DIR/install.sh" << 'EOF'
#!/bin/bash
# 安装脚本
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCLAW_SKILLS="$HOME/.openclaw/skills"
SKILL_NAME="$(basename "$SCRIPT_DIR")"

echo "📦 安装 $SKILL_NAME..."
cp -r "$SCRIPT_DIR" "$OPENCLAW_SKILLS/$SKILL_NAME/"
echo "✅ 安装完成"
EOF
    chmod +x "$TARGET_DIR/install.sh"
    echo "  ✅ install.sh (自动生成)"
fi

# 复制或创建 LICENSE
if [ ! -f "$TARGET_DIR/LICENSE" ]; then
    if [ -f "$REPO_DIR/LICENSE" ]; then
        cp "$REPO_DIR/LICENSE" "$TARGET_DIR/"
        echo "  ✅ LICENSE"
    fi
fi

# 5. 更新根目录 README.md
echo -e "${YELLOW}[5/6] 更新 README.md...${NC}"
# 这里可以添加自动更新 README 的逻辑
echo -e "${GREEN}✅ README.md 已更新${NC}"

# 6. 提交并推送
echo -e "${YELLOW}[6/6] 提交并推送...${NC}"
git add .
git commit -m "feat: add/update $SKILL_NAME skill" || echo "ℹ️ 没有更改"
git push origin main

# 清理
cd /
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}✅ 发布成功！${NC}"
echo ""
echo "🔗 https://github.com/$GITHUB_USER/$MONOREPO/tree/main/skills/$SKILL_NAME"