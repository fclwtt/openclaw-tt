#!/bin/bash
# Skill Publisher - 更新 Monorepo 根目录 README.md
# 用法：./update-readme.sh

set -e

# ============ 配置 ============
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_PUBLISHER_DIR="$(dirname "$SCRIPT_DIR")"

GITHUB_USER="fclwtt"
MONOREPO="openclaw-skills"
REMOTE="git@github.com:$GITHUB_USER/$MONOREPO.git"
# ==============================

echo "📝 更新 Monorepo README.md..."

# 克隆仓库
TEMP_DIR=$(mktemp -d)
REPO_DIR="$TEMP_DIR/$MONOREPO"
git clone "$REMOTE" "$REPO_DIR" --depth 1 2>&1 | tail -1
cd "$REPO_DIR"

# 分类定义
declare -A CATEGORIES
CATEGORIES["security"]="🔒 安全与治理"
CATEGORIES["devtools"]="🛠️ 开发工具"
CATEGORIES["search"]="🔍 搜索与发现"
CATEGORIES["wecom"]="📱 企业微信"
CATEGORIES["other"]="📦 其他"

# 分类技能
declare -A SKILL_CATS
SKILL_CATS["enforcement-policy"]="security"
SKILL_CATS["skill-publisher"]="devtools"
SKILL_CATS["skill-searcher"]="search"
SKILL_CATS["wecom-channel-fix"]="wecom"

# 读取现有技能
SKILLS=()
for dir in skills/*/; do
    if [ -d "$dir" ]; then
        name=$(basename "$dir")
        SKILLS+=("$name")
    fi
done

# 生成 README.md
cat > README.md << 'EOF'
# 📦 OpenClaw Skills Collection

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-Compatible-blue)](https://openclaw.ai)

一套高质量的 OpenClaw 技能集合，采用 Monorepo 架构管理。

---

## 📋 技能列表

EOF

# 按分类输出
for cat in security devtools search wecom other; do
    cat_name="${CATEGORIES[$cat]}"
    
    # 检查该分类是否有技能
    has_skills=false
    for skill in "${SKILLS[@]}"; do
        skill_cat="${SKILL_CATS[$skill]:-other}"
        if [ "$skill_cat" == "$cat" ]; then
            has_skills=true
            break
        fi
    done
    
    if [ "$has_skills" = true ]; then
        echo "### $cat_name" >> README.md
        echo "" >> README.md
        echo "| 技能 | 版本 | 描述 |" >> README.md
        echo "|------|------|------|" >> README.md
        
        for skill in "${SKILLS[@]}"; do
            skill_cat="${SKILL_CATS[$skill]:-other}"
            if [ "$skill_cat" == "$cat" ]; then
                # 读取版本和描述
                version="1.0.0"
                desc="无描述"
                if [ -f "skills/$skill/SKILL.md" ]; then
                    version=$(grep -A1 "^version:" "skills/$skill/SKILL.md" 2>/dev/null | tail -1 | sed 's/^ *//' | tr -d '"' || echo "1.0.0")
                    desc=$(grep -A1 "^description:" "skills/$skill/SKILL.md" 2>/dev/null | tail -1 | sed 's/^ *//' | tr -d '"' | head -c 50 || echo "无描述")
                fi
                echo "| [$skill](./skills/$skill) | v$version | $desc |" >> README.md
            fi
        done
        echo "" >> README.md
    fi
done

# 添加通用内容
cat >> README.md << 'EOF'

---

## 🚀 快速开始

```bash
# 克隆仓库
git clone https://github.com/fclwtt/openclaw-skills.git
cd openclaw-skills

# 安装技能
cd skills/<skill-name>
./install.sh
```

---

## 📄 许可证

MIT License

---

**维护者:** [fclwtt](https://github.com/fclwtt)
EOF

# 提交并推送
git add README.md
git commit -m "docs: update README.md" || echo "No changes"
git push origin main 2>&1

# 清理
cd /
rm -rf "$TEMP_DIR"

echo "✅ README.md 已更新"