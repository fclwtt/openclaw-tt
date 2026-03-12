#!/bin/bash
# Skill Publisher - 仅格式化技能（不推送）
# 用法：./format.sh <skill-name> [--output <output-dir>]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_PUBLISHER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$SKILL_PUBLISHER_DIR/templates"
OPENCLAW_ROOT="$HOME/.openclaw"
SKILLS_ROOT="$OPENCLAW_ROOT/skills"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SKILL_NAME=""
OUTPUT_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --output|-o) OUTPUT_DIR="$2"; shift 2 ;;
        *) SKILL_NAME="$1"; shift ;;
    esac
done

if [ -z "$SKILL_NAME" ]; then
    echo "用法：./format.sh <skill-name> [--output <dir>]"
    exit 1
fi

[ -z "$OUTPUT_DIR" ] && OUTPUT_DIR="/tmp/$SKILL_NAME-formatted"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔧 Skill Publisher - 格式化工具${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}技能：${SKILL_NAME}${NC}"

SOURCE_DIR="$SKILLS_ROOT/$SKILL_NAME"
TARGET_DIR="$OUTPUT_DIR/$SKILL_NAME"

[ ! -d "$SOURCE_DIR" ] && echo -e "${RED}❌ 技能目录不存在${NC}" && exit 1
[ ! -f "$SOURCE_DIR/SKILL.md" ] && echo -e "${RED}❌ 缺少 SKILL.md${NC}" && exit 1

# 提取元数据
SKILL_DESC=$(grep "^description:" "$SOURCE_DIR/SKILL.md" 2>/dev/null | head -1 | sed 's/^description: *//' | tr -d '"' || echo "")
SKILL_VER=$(grep "^version:" "$SOURCE_DIR/SKILL.md" 2>/dev/null | head -1 | sed 's/^version: *//' | tr -d '"' || echo "1.0.0")
DATE=$(date +%Y-%m-%d)

rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"/{scripts,templates,docs}

echo -e "${YELLOW}格式化中...${NC}"

# 复制文件
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
    echo "   ✅ README.md (模板生成)"
fi

# 使用模板生成 install.sh
if [ -f "$TEMPLATE_DIR/install.sh.tmpl" ]; then
    cat "$TEMPLATE_DIR/install.sh.tmpl" | \
        sed "s|{{SKILL_NAME}}|$SKILL_NAME|g" \
        > "$TARGET_DIR/install.sh"
    chmod +x "$TARGET_DIR/install.sh"
    echo "   ✅ install.sh (模板生成)"
fi

# 复制 .gitignore 模板
[ -f "$TEMPLATE_DIR/.gitignore.tmpl" ] && cp "$TEMPLATE_DIR/.gitignore.tmpl" "$TARGET_DIR/.gitignore" && echo "   ✅ .gitignore"

# 生成 LICENSE
cat > "$TARGET_DIR/LICENSE" << 'EOF'
MIT License
Copyright (c) 2026 fclwtt
EOF
echo "   ✅ LICENSE"

echo ""
echo -e "${GREEN}✅ 格式化完成！${NC}"
echo -e "${CYAN}输出：${NC}$TARGET_DIR"
