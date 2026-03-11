#!/bin/bash
# Skill Publisher - 创建新 Skill 项目
# 用法：./create-skill.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../templates"
WORKSPACE_DIR="$HOME/.openclaw/workspace"

echo "🚀 OpenClaw Skill 创建工具"
echo "=========================="
echo ""

# 询问项目信息
echo "请提供以下信息："
echo ""
read -p "1. Skill 名称（英文，小写，连字符分隔）: " SKILL_NAME
read -p "2. Skill 描述（一句话）: " SKILL_DESC
read -p "3. 作者名: " AUTHOR

# 验证名称
if [[ ! "$SKILL_NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo "❌ 名称格式错误，只能使用小写字母、数字和连字符"
    exit 1
fi

# 创建项目目录
PROJECT_DIR="$WORKSPACE_DIR/$SKILL_NAME"
echo ""
echo "📁 正在创建项目结构..."
mkdir -p "$PROJECT_DIR"/{skills,docs,scripts}

# 复制模板文件
cp "$TEMPLATES_DIR/README.md.tmpl" "$PROJECT_DIR/README.md"
cp "$TEMPLATES_DIR/install.sh.tmpl" "$PROJECT_DIR/install.sh"

# 替换模板变量
sed -i "s/{{SKILL_NAME}}/$SKILL_NAME/g" "$PROJECT_DIR/README.md"
sed -i "s/{{SKILL_DESCRIPTION}}/$SKILL_DESC/g" "$PROJECT_DIR/README.md"
sed -i "s/{{AUTHOR}}/$AUTHOR/g" "$PROJECT_DIR/README.md"
sed -i "s/{{SKILL_NAME}}/$SKILL_NAME/g" "$PROJECT_DIR/install.sh"

# 创建 SKILL.md
cat > "$PROJECT_DIR/skills/SKILL.md" << EOF
---
name: $SKILL_NAME
description: $SKILL_DESC
version: 1.0.0
license: MIT
author: $AUTHOR
---

# $SKILL_NAME

$SKILL_DESC

## 触发场景

- 

## 功能



EOF

# 创建许可证
cat > "$PROJECT_DIR/LICENSE" << 'EOF'
MIT License

Copyright (c) 2026

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

# 创建 .gitignore
cat > "$PROJECT_DIR/.gitignore" << 'EOF'
node_modules/
*.log
.DS_Store
.env
EOF

# 完成
echo ""
echo "=========================="
echo "✅ 项目创建完成！"
echo ""
echo "项目位置：$PROJECT_DIR"
echo ""
echo "下一步："
echo "1. 编辑 $PROJECT_DIR/skills/SKILL.md 添加技能逻辑"
echo "2. 编辑 $PROJECT_DIR/README.md 完善文档"
echo "3. 运行 ./scripts/push-to-github.sh 推送到 GitHub"
