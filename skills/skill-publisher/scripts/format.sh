#!/bin/bash
# Skill Publisher - 仅格式化技能（不推送）
# 用法：./format.sh <skill-name> [--output <output-dir>]
#
# 功能：
# 1. 读取本地技能
# 2. 重构为 GitHub 标准格式
# 3. 输出到指定目录（默认 /tmp）

set -e

# ============ 配置 ============
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_PUBLISHER_DIR="$(dirname "$SCRIPT_DIR")"
OPENCLAW_ROOT="$HOME/.openclaw"
SKILLS_ROOT="$OPENCLAW_ROOT/skills"
# ==============================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 默认值
SKILL_NAME=""
OUTPUT_DIR=""

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --output|-o)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -*)
            echo -e "${RED}未知参数: $1${NC}"
            exit 1
            ;;
        *)
            SKILL_NAME="$1"
            shift
            ;;
    esac
done

# 检查参数
if [ -z "$SKILL_NAME" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🔧 Skill Publisher - 格式化工具${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}用法：${NC}"
    echo "  ./format.sh <skill-name> [--output <dir>]"
    echo ""
    echo -e "${YELLOW}参数：${NC}"
    echo "  --output, -o   输出目录（默认 /tmp/<skill-name>-formatted）"
    echo ""
    echo -e "${YELLOW}示例：${NC}"
    echo "  ./format.sh enforcement-policy"
    echo "  ./format.sh my-skill --output ~/Desktop/"
    exit 1
fi

# 设置输出目录
if [ -z "$OUTPUT_DIR" ]; then
    OUTPUT_DIR="/tmp/$SKILL_NAME-formatted"
fi

# 显示标题
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔧 Skill Publisher - 格式化工具${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}技能：${SKILL_NAME}${NC}"
echo -e "${GREEN}输出：${OUTPUT_DIR}${NC}"
echo ""

# 源目录
SOURCE_DIR="$SKILLS_ROOT/$SKILL_NAME"

# 检查源技能目录
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}❌ 技能目录不存在: $SOURCE_DIR${NC}"
    exit 1
fi

if [ ! -f "$SOURCE_DIR/SKILL.md" ]; then
    echo -e "${RED}❌ 缺少必需文件: SKILL.md${NC}"
    exit 1
fi

# 提取元数据
SKILL_DESC=$(grep -A1 "^description:" "$SOURCE_DIR/SKILL.md" 2>/dev/null | tail -1 | sed 's/^ *//' | tr -d '"' || echo "无描述")
SKILL_VER=$(grep -A1 "^version:" "$SOURCE_DIR/SKILL.md" 2>/dev/null | tail -1 | sed 's/^ *//' | tr -d '"' || echo "1.0.0")

# 创建输出目录
TARGET_DIR="$OUTPUT_DIR/$SKILL_NAME"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"/{scripts,templates,docs}

echo -e "${YELLOW}格式化中...${NC}"

# 复制文件
[ -f "$SOURCE_DIR/SKILL.md" ] && cp "$SOURCE_DIR/SKILL.md" "$TARGET_DIR/" && echo "   ✅ SKILL.md"
[ -f "$SOURCE_DIR/config.json" ] && cp "$SOURCE_DIR/config.json" "$TARGET_DIR/" && echo "   ✅ config.json"
[ -d "$SOURCE_DIR/scripts" ] && cp -r "$SOURCE_DIR/scripts"/* "$TARGET_DIR/scripts/" 2>/dev/null && echo "   ✅ scripts/"
[ -d "$SOURCE_DIR/templates" ] && cp -r "$SOURCE_DIR/templates"/* "$TARGET_DIR/templates/" 2>/dev/null && echo "   ✅ templates/"
[ -d "$SOURCE_DIR/docs" ] && cp -r "$SOURCE_DIR/docs"/* "$TARGET_DIR/docs/" 2>/dev/null && echo "   ✅ docs/"

# 生成 README.md
if [ ! -f "$SOURCE_DIR/README.md" ]; then
    cat > "$TARGET_DIR/README.md" << EOF
# $SKILL_NAME

$SKILL_DESC

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🚀 安装

\`\`\`bash
./install.sh
\`\`\`

---

**仓库:** [fclwtt/openclaw-skills](https://github.com/fclwtt/openclaw-skills)
EOF
    echo "   ✅ README.md (生成)"
else
    cp "$SOURCE_DIR/README.md" "$TARGET_DIR/"
    echo "   ✅ README.md"
fi

# 生成 install.sh
cat > "$TARGET_DIR/install.sh" << EOF
#!/bin/bash
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
OPENCLAW_SKILLS="\$HOME/.openclaw/skills"
SKILL_NAME="$SKILL_NAME"
echo "📦 安装 \$SKILL_NAME..."
cp -r "\$SCRIPT_DIR" "\$OPENCLAW_SKILLS/\$SKILL_NAME/"
echo "✅ 完成"
EOF
chmod +x "$TARGET_DIR/install.sh"
echo "   ✅ install.sh"

# 生成 LICENSE
cat > "$TARGET_DIR/LICENSE" << 'EOF'
MIT License
Copyright (c) 2026 fclwtt
EOF
echo "   ✅ LICENSE"

echo ""
echo -e "${GREEN}✅ 格式化完成！${NC}"
echo ""
echo -e "${CYAN}输出目录：${NC}$TARGET_DIR"
echo ""
echo -e "${CYAN}文件列表：${NC}"
ls -la "$TARGET_DIR"