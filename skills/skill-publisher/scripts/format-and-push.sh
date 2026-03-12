#!/bin/bash
# Skill Publisher - 格式化技能为 GitHub 标准并推送
# 用法：./format-and-push.sh <skill-name> [--category <category>] [--version <version>]
#
# 功能：
# 1. 读取本地技能
# 2. 重构为 GitHub 标准格式
# 3. 推送到 Monorepo
# 4. 更新根目录 README.md

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
CYAN='\033[0;36m'
NC='\033[0m'

# 默认值
SKILL_NAME=""
CATEGORY="other"
VERSION=""

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --category)
            CATEGORY="$2"
            shift 2
            ;;
        --version)
            VERSION="$2"
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
    echo -e "${CYAN}🔧 Skill Publisher v2.0.0${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}用法：${NC}"
    echo "  ./format-and-push.sh <skill-name> [options]"
    echo ""
    echo -e "${YELLOW}参数：${NC}"
    echo "  --category <cat>   指定分类 (security|devtools|search|wecom|other)"
    echo "  --version <ver>    指定版本号 (如 1.0.0)"
    echo ""
    echo -e "${YELLOW}示例：${NC}"
    echo "  ./format-and-push.sh enforcement-policy"
    echo "  ./format-and-push.sh my-skill --category security"
    echo "  ./format-and-push.sh my-skill --version 1.0.0"
    exit 1
fi

# 显示标题
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔧 Skill Publisher v2.0.0${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}技能：${SKILL_NAME}${NC}"
echo -e "${GREEN}分类：${CATEGORY}${NC}"
echo ""

# 源目录
SOURCE_DIR="$SKILLS_ROOT/$SKILL_NAME"

# ═══════════════════════════════════════════════════════════
# 步骤 1: 检查源技能目录
# ═══════════════════════════════════════════════════════════
echo -e "${YELLOW}[1/6] 检查源技能目录...${NC}"

if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}❌ 技能目录不存在: $SOURCE_DIR${NC}"
    exit 1
fi

if [ ! -f "$SOURCE_DIR/SKILL.md" ]; then
    echo -e "${RED}❌ 缺少必需文件: SKILL.md${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 源技能目录存在${NC}"
echo "   $SOURCE_DIR"

# ═══════════════════════════════════════════════════════════
# 步骤 2: 提取元数据
# ═══════════════════════════════════════════════════════════
echo -e "${YELLOW}[2/6] 提取技能元数据...${NC}"

# 从 SKILL.md 提取信息
SKILL_DESC=$(grep -A1 "^description:" "$SOURCE_DIR/SKILL.md" 2>/dev/null | tail -1 | sed 's/^ *//' | tr -d '"' || echo "无描述")
SKILL_VER=$(grep -A1 "^version:" "$SOURCE_DIR/SKILL.md" 2>/dev/null | tail -1 | sed 's/^ *//' | tr -d '"' || echo "1.0.0")
SKILL_AUTHOR=$(grep -A1 "^author:" "$SOURCE_DIR/SKILL.md" 2>/dev/null | tail -1 | sed 's/^ *//' | tr -d '"' || echo "unknown")

# 命令行参数优先
if [ -n "$VERSION" ]; then
    SKILL_VER="$VERSION"
fi

echo -e "   名称: ${CYAN}$SKILL_NAME${NC}"
echo -e "   描述: ${CYAN}$SKILL_DESC${NC}"
echo -e "   版本: ${CYAN}$SKILL_VER${NC}"
echo -e "   作者: ${CYAN}$SKILL_AUTHOR${NC}"
echo -e "${GREEN}✅ 元数据提取完成${NC}"

# ═══════════════════════════════════════════════════════════
# 步骤 3: 创建格式化目录
# ═══════════════════════════════════════════════════════════
echo -e "${YELLOW}[3/6] 创建 GitHub 标准结构...${NC}"

FORMAT_DIR=$(mktemp -d)
TARGET_DIR="$FORMAT_DIR/$SKILL_NAME"
mkdir -p "$TARGET_DIR"/{scripts,templates,docs}

echo -e "${GREEN}✅ 标准目录结构已创建${NC}"

# ═══════════════════════════════════════════════════════════
# 步骤 4: 复制并整理文件
# ═══════════════════════════════════════════════════════════
echo -e "${YELLOW}[4/6] 复制并整理文件...${NC}"

# 复制 SKILL.md（必需）
cp "$SOURCE_DIR/SKILL.md" "$TARGET_DIR/"
echo "   ✅ SKILL.md"

# 复制 config.json（如存在）
if [ -f "$SOURCE_DIR/config.json" ]; then
    cp "$SOURCE_DIR/config.json" "$TARGET_DIR/"
    echo "   ✅ config.json"
fi

# 复制 scripts/ 目录
if [ -d "$SOURCE_DIR/scripts" ]; then
    cp -r "$SOURCE_DIR/scripts"/* "$TARGET_DIR/scripts/" 2>/dev/null || true
    echo "   ✅ scripts/"
fi

# 复制 templates/ 目录
if [ -d "$SOURCE_DIR/templates" ]; then
    cp -r "$SOURCE_DIR/templates"/* "$TARGET_DIR/templates/" 2>/dev/null || true
    echo "   ✅ templates/"
fi

# 复制 docs/ 目录
if [ -d "$SOURCE_DIR/docs" ]; then
    cp -r "$SOURCE_DIR/docs"/* "$TARGET_DIR/docs/" 2>/dev/null || true
    echo "   ✅ docs/"
fi

# 生成 README.md（如不存在）
if [ ! -f "$SOURCE_DIR/README.md" ]; then
    cat > "$TARGET_DIR/README.md" << EOF
# $SKILL_NAME

$SKILL_DESC

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://openclaw.ai)
[![Version](https://img.shields.io/badge/version-$SKILL_VER-green.svg)](https://github.com/fclwtt/openclaw-skills)

---

## 📋 功能

详见 [SKILL.md](./SKILL.md)

---

## 🚀 安装

\`\`\`bash
./install.sh
\`\`\`

---

## 📁 结构

\`\`\`
$SKILL_NAME/
├── README.md       # 本文档
├── SKILL.md        # OpenClaw 技能定义
├── config.json     # 配置文件
├── scripts/        # 脚本目录
└── templates/      # 模板目录
\`\`\`

---

## 📝 更新日志

### v$SKILL_VER ($(date +%Y-%m-%d))

- 🎉 首次发布

---

**仓库:** [fclwtt/openclaw-skills](https://github.com/fclwtt/openclaw-skills)
EOF
    echo "   ✅ README.md (自动生成)"
else
    cp "$SOURCE_DIR/README.md" "$TARGET_DIR/"
    echo "   ✅ README.md"
fi

# 生成 install.sh
cat > "$TARGET_DIR/install.sh" << EOF
#!/bin/bash
# 安装 $SKILL_NAME
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
OPENCLAW_SKILLS="\$HOME/.openclaw/skills"
SKILL_NAME="$SKILL_NAME"

echo "📦 安装 \$SKILL_NAME..."
mkdir -p "\$OPENCLAW_SKILLS/\$SKILL_NAME"
cp -r "\$SCRIPT_DIR"/* "\$OPENCLAW_SKILLS/\$SKILL_NAME/"
echo "✅ 安装完成！"
echo ""
echo "重启 OpenClaw Gateway 使技能生效："
echo "  openclaw gateway restart"
EOF
chmod +x "$TARGET_DIR/install.sh"
echo "   ✅ install.sh (自动生成)"

# 生成 LICENSE
cat > "$TARGET_DIR/LICENSE" << 'EOF'
MIT License

Copyright (c) 2026 fclwtt

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
echo "   ✅ LICENSE"

# 生成 .gitignore
cat > "$TARGET_DIR/.gitignore" << 'EOF'
# Logs
logs/
*.log

# OS
.DS_Store
Thumbs.db

# Editor
.idea/
.vscode/
*.swp

# Temp
*.tmp
*.temp
EOF
echo "   ✅ .gitignore"

echo -e "${GREEN}✅ 文件整理完成${NC}"

# ═══════════════════════════════════════════════════════════
# 步骤 5: 推送到 Monorepo
# ═══════════════════════════════════════════════════════════
echo -e "${YELLOW}[5/6] 推送到 GitHub Monorepo...${NC}"

# 检查 SSH 连接
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo -e "${RED}❌ GitHub SSH 连接失败${NC}"
    rm -rf "$FORMAT_DIR"
    exit 1
fi

# 克隆 Monorepo
REPO_DIR="$FORMAT_DIR/$MONOREPO"
git clone "$REMOTE" "$REPO_DIR" --depth 1 2>&1 | tail -1
cd "$REPO_DIR"

# 删除旧版本（如存在）
if [ -d "skills/$SKILL_NAME" ]; then
    rm -rf "skills/$SKILL_NAME"
fi

# 复制格式化后的技能
mkdir -p skills
cp -r "$TARGET_DIR" "skills/"

# 提交
git add .
git commit -m "feat: add/update $SKILL_NAME skill v$SKILL_VER

Category: $CATEGORY
Description: $SKILL_DESC

Generated by skill-publisher v2.0.0" || echo "ℹ️  没有更改"

# 推送
git push origin main 2>&1

echo -e "${GREEN}✅ 推送成功${NC}"

# ═══════════════════════════════════════════════════════════
# 步骤 6: 清理
# ═══════════════════════════════════════════════════════════
echo -e "${YELLOW}[6/6] 清理临时文件...${NC}"
cd /
rm -rf "$FORMAT_DIR"
echo -e "${GREEN}✅ 清理完成${NC}"

# ═══════════════════════════════════════════════════════════
# 完成
# ═══════════════════════════════════════════════════════════
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ 发布成功！${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}🔗 访问地址：${NC}"
echo "   https://github.com/$GITHUB_USER/$MONOREPO/tree/main/skills/$SKILL_NAME"
echo ""
echo -e "${CYAN}📥 安装方式：${NC}"
echo "   git clone https://github.com/$GITHUB_USER/$MONOREPO.git"
echo "   cd $MONOREPO/skills/$SKILL_NAME"
echo "   ./install.sh"