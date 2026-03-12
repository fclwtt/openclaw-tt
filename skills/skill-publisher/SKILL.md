---
name: skill-publisher
description: "技能格式化工具 - 将本地技能重构为符合 GitHub 标准的项目结构，然后推送到 Monorepo"
version: 2.0.0
license: MIT
author: fclwtt
metadata:
  {
    "openclaw":
      {
        "emoji": "🔧",
        "requires": { "bins": ["git"] }
      }
  }
---

# Skill Publisher 🔧

**技能格式化工具** - 将技能重构为 GitHub 标准格式并推送

---

## 🎯 核心功能

1. **格式化技能** - 将本地技能重构为 GitHub 标准项目结构
2. **生成标准文件** - 自动生成 README.md、LICENSE、install.sh 等
3. **推送到 Monorepo** - 推送到统一的 openclaw-skills 仓库
4. **更新索引** - 自动更新仓库根目录 README.md

---

## 📁 GitHub 标准技能结构

转换后的技能结构：

```
skills/<skill-name>/
├── README.md           # 项目说明（必需）
├── SKILL.md            # OpenClaw 技能定义（必需）
├── config.json         # 配置文件（可选）
├── LICENSE             # MIT 许可证（必需）
├── install.sh          # 安装脚本（必需）
├── .gitignore          # Git 忽略规则（可选）
├── scripts/            # 脚本目录（可选）
├── templates/          # 模板目录（可选）
└── docs/               # 文档目录（可选）
```

---

## 📋 使用方式

### 格式化并发布技能

```bash
# 将技能格式化为 GitHub 标准，然后推送
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh <skill-name>
```

### 仅格式化（不推送）

```bash
# 只重构格式，不推送到 GitHub
bash ~/.openclaw/skills/skill-publisher/scripts/format.sh <skill-name>
```

### 示例

```bash
# 格式化并推送 enforcement-policy
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh enforcement-policy

# 只格式化，预览结果
bash ~/.openclaw/skills/skill-publisher/scripts/format.sh my-skill
```

---

## 🔄 格式化流程

```
1. 读取源技能目录
   ├── SKILL.md（必需）
   └── 其他文件

2. 分析技能元数据
   ├── name（从 SKILL.md 提取）
   ├── description（从 SKILL.md 提取）
   ├── version（从 SKILL.md 提取）
   └── author（从 SKILL.md 提取）

3. 生成标准文件
   ├── README.md（如不存在）
   ├── LICENSE（如不存在）
   ├── install.sh（如不存在）
   └── .gitignore（如不存在）

4. 组织目录结构
   ├── scripts/（整理脚本文件）
   ├── templates/（整理模板文件）
   └── docs/（整理文档文件）

5. 推送到 Monorepo
   └── 更新根目录 README.md
```

---

## 📝 生成的文件内容

### README.md

自动从 SKILL.md 提取信息生成：

```markdown
# <skill-name>

<description>

## 📋 功能

<从 SKILL.md 提取的功能列表>

## 🚀 安装

\`\`\`bash
./install.sh
\`\`\`

## 📁 结构

<目录结构>

## 📝 更新日志

### v<version> (<date>)
- 🎉 首次发布
```

### install.sh

```bash
#!/bin/bash
# 安装脚本
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCLAW_SKILLS="$HOME/.openclaw/skills"
SKILL_NAME="$(basename "$SCRIPT_DIR")"

echo "📦 安装 $SKILL_NAME..."
cp -r "$SCRIPT_DIR" "$OPENCLAW_SKILLS/$SKILL_NAME/"
echo "✅ 安装完成"
```

---

## ⚙️ 配置

编辑 `config.json`：

```json
{
  "github": {
    "user": "fclwtt",
    "repo": "openclaw-skills"
  },
  "categories": {
    "security": "🔒 安全与治理",
    "devtools": "🛠️ 开发工具",
    "search": "🔍 搜索与发现",
    "wecom": "📱 企业微信",
    "other": "📦 其他"
  }
}
```

---

## 🔧 脚本说明

| 脚本 | 功能 |
|------|------|
| `format.sh` | 格式化技能为 GitHub 标准 |
| `format-and-push.sh` | 格式化并推送到 GitHub |
| `update-readme.sh` | 更新仓库根目录 README.md |

---

## 📝 更新日志

### v2.0.0 (2026-03-12)

- 🎉 重构：核心功能改为"格式化技能"
- ✨ 自动生成 README.md、LICENSE、install.sh
- ✨ 自动整理目录结构
- ✨ 支持技能分类

### v1.0.0 (2026-03-12)

- 🎉 首次发布