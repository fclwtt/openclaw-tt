#!/bin/bash
# Skill Publisher - 格式化并推送
# 用法：./format-and-push.sh <skill-name> [--category <cat>] [--version <ver>]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_PUBLISHER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$SKILL_PUBLISHER_DIR/templates"
OPENCLAW_ROOT="$HOME/.openclaw"
SKILLS_ROOT="$OPENCLAW_ROOT/skills"

GITHUB_USER="fclwtt"
MONOREPO="openclaw-skills"
REMOTE="git@github.com:$GITHUB_USER/$MONOREPO.git"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SKILL_NAME=""
CATEGORY="other"
VERSION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --category) CATEGORY="$2"; shift 2 ;;
        --version) VERSION="$2"; shift 2 ;;
        *) SKILL_NAME="$1"; shift ;;
    esac
done

if [ -z "$SKILL_NAME" ]; then
    echo "用法：./format-and-push.sh <skill-name> [--category <cat>] [--version <ver>]"
    exit 1
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔧 Skill Publisher v2.0.0${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}技能：${SKILL_NAME}${NC}"

SOURCE_DIR="$SKILLS_ROOT/$SKILL_NAME"
DATE=$(date +%Y-%m-%d)

# 检查源目录
echo -e "${YELLOW}[1/5] 检查源技能...${NC}"
[ ! -d "$SOURCE_DIR" ] && echo -e "${RED}❌ 目录不存在${NC}" && exit 1
[ ! -f "$SOURCE_DIR/SKILL.md" ] && echo -e "${RED}❌ 缺少 SKILL.md${NC}" && exit 1
echo -e "${GREEN}✅ 源技能存在${NC}"

# 提取元数据
echo -e "${YELLOW}[2/5] 提取元数据...${NC}"
SKILL_DESC=$(grep "^description:" "$SOURCE_DIR/SKILL.md" 2>/dev/null | head -1 | sed 's/^description: *//' | tr -d '"' || echo "")
SKILL_VER=$(grep "^version:" "$SOURCE_DIR/SKILL.md" 2>/dev/null | head -1 | sed 's/^version: *//' | tr -d '"' || echo "1.0.0")
[ -n "$VERSION" ] && SKILL_VER="$VERSION"
echo -e "   名称: ${CYAN}$SKILL_NAME${NC}"
echo -e "   版本: ${CYAN}$SKILL_VER${NC}"
echo -e "${GREEN}✅ 元数据完成${NC}"

# 格式化
echo -e "${YELLOW}[3/5] 格式化（使用模板）...${NC}"
FORMAT_DIR=$(mktemp -d)
TARGET_DIR="$FORMAT_DIR/$SKILL_NAME"
mkdir -p "$TARGET_DIR"/{scripts,templates,docs}

cp "$SOURCE_DIR/SKILL.md" "$TARGET_DIR/" && echo "   ✅ SKILL.md"
[ -f "$SOURCE_DIR/config.json" ] && cp "$SOURCE_DIR/config.json" "$TARGET_DIR/" && echo "   ✅ config.json"
[ -d "$SOURCE_DIR/scripts" ] && cp -r "$SOURCE_DIR/scripts"/* "$TARGET_DIR/scripts/" 2>/dev/null && echo "   ✅ scripts/"
[ -d "$SOURCE_DIR/templates" ] && cp -r "$SOURCE_DIR/templates"/* "$TARGET_DIR/templates/" 2>/dev/null && echo "   ✅ templates/"
[ -d "$SOURCE_DIR/docs" ] && cp -r "$SOURCE_DIR/docs"/* "$TARGET_DIR/docs/" 2>/dev/null && echo "   ✅ docs/"

# 使用模板生成 README.md
if [ -f "$TEMPLATE_DIR/README.md.tmpl" ]; then
    cat "$TEMPLATE_DIR/README.md.tmpl" | \
        sed "s|{{SKILL_NAME}}|$SKILL_NAME|g" | \
        sed "s|{{SKILL_DESCRIPTION}}|$SKILL_DESC|g" | \
        sed "s|{{VERSION}}|$SKILL_VER|g" | \
        sed "s|{{DATE}}|$DATE|g" \
        > "$TARGET_DIR/README.md"
    echo "   ✅ README.md (模板)"
fi

# 使用模板生成 install.sh
if [ -f "$TEMPLATE_DIR/install.sh.tmpl" ]; then
    cat "$TEMPLATE_DIR/install.sh.tmpl" | sed "s|{{SKILL_NAME}}|$SKILL_NAME|g" > "$TARGET_DIR/install.sh"
    chmod +x "$TARGET_DIR/install.sh"
    echo "   ✅ install.sh (模板)"
fi

[ -f "$TEMPLATE_DIR/.gitignore.tmpl" ] && cp "$TEMPLATE_DIR/.gitignore.tmpl" "$TARGET_DIR/.gitignore" && echo "   ✅ .gitignore"

cat > "$TARGET_DIR/LICENSE" << 'EOF'
MIT License
Copyright (c) 2026 fclwtt
EOF
echo "   ✅ LICENSE"

echo -e "${GREEN}✅ 格式化完成${NC}"

# 推送
echo -e "${YELLOW}[4/5] 推送到 GitHub...${NC}"
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo -e "${RED}❌ SSH 连接失败${NC}"
    rm -rf "$FORMAT_DIR"
    exit 1
fi

REPO_DIR="$FORMAT_DIR/$MONOREPO"
git clone "$REMOTE" "$REPO_DIR" --depth 1 2>&1 | tail -1
cd "$REPO_DIR"
[ -d "skills/$SKILL_NAME" ] && rm -rf "skills/$SKILL_NAME"
mkdir -p skills
cp -r "$TARGET_DIR" "skills/"
git add .
git commit -m "feat: add/update $SKILL_NAME v$SKILL_VER" || echo "ℹ️  无更改"
git push origin main 2>&1
echo -e "${GREEN}✅ 推送成功${NC}"

# 清理
echo -e "${YELLOW}[5/5] 清理...${NC}"
cd /
rm -rf "$FORMAT_DIR"
echo -e "${GREEN}✅ 完成${NC}"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ 发布成功！${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "🔗 https://github.com/$GITHUB_USER/$MONOREPO/tree/main/skills/$SKILL_NAME"
