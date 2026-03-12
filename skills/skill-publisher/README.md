# 🔧 Skill Publisher

**技能格式化工具** - 将技能重构为 GitHub 标准格式并推送

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://openclaw.ai)
[![Version](https://img.shields.io/badge/version-2.0.0-green.svg)](https://github.com/fclwtt/openclaw-skills)

---

## 📖 目录

- [简介](#简介)
- [快速开始](#快速开始)
- [GitHub 标准技能结构](#github-标准技能结构)
- [使用方式](#使用方式)
- [格式化流程](#格式化流程)
- [生成的文件](#生成的文件)
- [配置](#配置)
- [故障排除](#故障排除)
- [更新日志](#更新日志)

---

## 简介

Skill Publisher 是一个**技能格式化工具**，核心功能是：

1. **读取本地技能** - 从 `~/.openclaw/skills/<skill-name>/` 读取技能
2. **重构为 GitHub 标准** - 生成 README.md、LICENSE、install.sh 等标准文件
3. **推送到 Monorepo** - 推送到 `fclwtt/openclaw-skills` 仓库
4. **更新索引** - 自动更新仓库根目录的 README.md

---

## 快速开始

### 一键发布

```bash
# 格式化技能并推送到 GitHub
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh <skill-name>
```

### 示例

```bash
# 发布 enforcement-policy
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh enforcement-policy

# 发布 my-new-skill
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh my-new-skill
```

---

## GitHub 标准技能结构

格式化后的技能结构：

```
skills/<skill-name>/
├── README.md           # 📖 项目说明（必需）
├── SKILL.md            # ⚙️ OpenClaw 技能定义（必需）
├── config.json         # 🔧 配置文件（可选）
├── LICENSE             # 📄 MIT 许可证（必需）
├── install.sh          # 📥 安装脚本（必需）
├── .gitignore          # 🚫 Git 忽略规则（可选）
├── scripts/            # 📜 脚本目录（可选）
│   ├── main.sh
│   └── helper.sh
├── templates/          # 📑 模板目录（可选）
│   └── example.md
└── docs/               # 📚 文档目录（可选）
    ├── INSTALL.md
    └── USAGE.md
```

### 文件说明

| 文件 | 必需 | 说明 |
|------|------|------|
| `README.md` | ✅ | 项目说明文档 |
| `SKILL.md` | ✅ | OpenClaw 技能定义文件 |
| `config.json` | ❌ | 配置文件（如技能需要配置） |
| `LICENSE` | ✅ | MIT 许可证 |
| `install.sh` | ✅ | 一键安装脚本 |
| `.gitignore` | ❌ | Git 忽略规则 |
| `scripts/` | ❌ | 存放脚本文件 |
| `templates/` | ❌ | 存放模板文件 |
| `docs/` | ❌ | 存放文档文件 |

---

## 使用方式

### 命令列表

```bash
# 格式化并推送（推荐）
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh <skill-name>

# 仅格式化（预览结果，不推送）
bash ~/.openclaw/skills/skill-publisher/scripts/format.sh <skill-name>

# 更新仓库 README.md
bash ~/.openclaw/skills/skill-publisher/scripts/update-readme.sh
```

### 参数说明

```bash
# 指定分类
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh <skill-name> --category security

# 指定版本
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh <skill-name> --version 1.0.0
```

---

## 格式化流程

```
┌─────────────────────────────────────────────────────────────┐
│                    格式化流程                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1️⃣ 读取源技能                                              │
│     ├── 检查 SKILL.md（必需）                               │
│     ├── 读取 config.json（可选）                            │
│     └── 扫描 scripts/、templates/、docs/ 目录               │
│                                                             │
│  2️⃣ 提取元数据                                              │
│     ├── name（技能名称）                                    │
│     ├── description（描述）                                 │
│     ├── version（版本）                                     │
│     └── author（作者）                                      │
│                                                             │
│  3️⃣ 生成标准文件                                            │
│     ├── README.md（如不存在则生成）                         │
│     ├── LICENSE（复制 MIT 许可证）                          │
│     ├── install.sh（生成安装脚本）                          │
│     └── .gitignore（生成忽略规则）                          │
│                                                             │
│  4️⃣ 整理目录结构                                            │
│     ├── *.sh → scripts/                                     │
│     ├── *.tmpl → templates/                                 │
│     └── *.md（除 README/SKILL）→ docs/                      │
│                                                             │
│  5️⃣ 推送到 Monorepo                                         │
│     ├── 克隆 openclaw-skills                                │
│     ├── 复制技能到 skills/ 目录                             │
│     ├── 更新根目录 README.md                                │
│     └── git push                                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 生成的文件

### README.md 示例

```markdown
# enforcement-policy

强制审查策略 - 整合安全审查机制和技能优先机制

## 📋 功能

- ✅ 安全审查机制
- ✅ 技能优先机制
- ✅ 自动注入全局规则

## 🚀 安装

\`\`\`bash
./install.sh
\`\`\`

## 📁 结构

\`\`\`
enforcement-policy/
├── README.md
├── SKILL.md
├── config.json
├── scripts/
└── templates/
\`\`\`

## 📝 更新日志

### v1.0.0 (2026-03-12)
- 🎉 首次发布
```

### install.sh 示例

```bash
#!/bin/bash
# 安装 enforcement-policy
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCLAW_SKILLS="$HOME/.openclaw/skills"
SKILL_NAME="enforcement-policy"

echo "📦 安装 $SKILL_NAME..."
mkdir -p "$OPENCLAW_SKILLS/$SKILL_NAME"
cp -r "$SCRIPT_DIR"/* "$OPENCLAW_SKILLS/$SKILL_NAME/"
echo "✅ 安装完成！"
echo ""
echo "重启 OpenClaw Gateway 使技能生效："
echo "  openclaw gateway restart"
```

---

## 配置

### config.json

```json
{
  "version": "2.0.0",
  "github": {
    "user": "fclwtt",
    "repo": "openclaw-skills",
    "branch": "main"
  },
  "categories": {
    "security": {
      "name": "🔒 安全与治理",
      "description": "安全审查、权限管理相关技能"
    },
    "devtools": {
      "name": "🛠️ 开发工具",
      "description": "开发、发布、调试工具"
    },
    "search": {
      "name": "🔍 搜索与发现",
      "description": "搜索、发现、索引相关技能"
    },
    "wecom": {
      "name": "📱 企业微信",
      "description": "企业微信相关技能"
    },
    "other": {
      "name": "📦 其他",
      "description": "其他类型技能"
    }
  },
  "templates": {
    "readme": "templates/skill-template/README.md.tmpl",
    "install": "templates/skill-template/install.sh.tmpl",
    "gitignore": "templates/skill-template/.gitignore.tmpl"
  }
}
```

---

## 故障排除

### Q: 技能目录不存在？

```bash
# 检查技能目录
ls -la ~/.openclaw/skills/<skill-name>/

# 确保有 SKILL.md 文件
ls ~/.openclaw/skills/<skill-name>/SKILL.md
```

### Q: SSH 连接失败？

```bash
# 测试 SSH 连接
ssh -T git@github.com

# 应看到：Hi fclwtt! You've successfully authenticated
```

### Q: 推送失败？

```bash
# 检查远程仓库
git ls-remote git@github.com:fclwtt/openclaw-skills.git
```

---

## 更新日志

### v2.0.0 (2026-03-12)

- 🎉 **重构**：核心功能改为"格式化技能为 GitHub 标准"
- ✨ 自动生成 README.md、LICENSE、install.sh
- ✨ 自动整理目录结构（scripts/、templates/、docs/）
- ✨ 支持技能分类
- ✨ 自动更新仓库根目录 README.md
- 📝 详细的使用文档

### v1.0.0 (2026-03-12)

- 🎉 首次发布

---

## 📄 许可证

MIT License - 详见 [LICENSE](./LICENSE)

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**作者:** fclwtt  
**仓库:** [fclwtt/openclaw-skills](https://github.com/fclwtt/openclaw-skills)  
**问题反馈:** [GitHub Issues](https://github.com/fclwtt/openclaw-skills/issues)