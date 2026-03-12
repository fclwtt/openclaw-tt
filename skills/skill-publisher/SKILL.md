---
name: skill-publisher
description: "技能发布工具 - 自动将技能重构为 GitHub 标准格式并推送到仓库。支持 Monorepo 模式，自动更新 README。"
version: 2.0.0
license: MIT
author: fclwtt
metadata:
  {
    "openclaw":
      {
        "emoji": "🚀",
        "requires": { "bins": ["git"] }
      }
  }
---

# Skill Publisher 🚀

**技能发布工具** - 自动将技能重构为 GitHub 标准格式并推送

---

## 🎯 核心功能

1. **标准化重构** - 自动将技能重构为 GitHub 标准项目格式
2. **Monorepo 支持** - 推送到统一仓库，每个技能独立目录
3. **README 自动更新** - 自动更新仓库根目录的技能列表
4. **版本管理** - 自动处理版本号和更新日志

---

## 📋 使用方式

### 发布新技能

```bash
# 发布技能到 GitHub
~/.openclaw/skills/skill-publisher/scripts/publish.sh <skill-name>
```

### 创建新技能

```bash
# 创建新技能（自动生成标准结构）
~/.openclaw/skills/skill-publisher/scripts/create-skill.sh <skill-name>
```

---

## 📁 标准技能结构

```skills/<skill-name>/
├── README.md           # 详细文档
├── SKILL.md            # OpenClaw 技能定义
├── config.json         # 配置文件
├── LICENSE             # MIT 许可证
├── install.sh          # 安装脚本
├── scripts/            # 脚本目录
├── templates/          # 模板目录
└── docs/               # 文档目录
```

---

## 🔄 发布流程

```
1. 读取本地技能目录
   ↓
2. 重构为 GitHub 标准格式
   ↓
3. 克隆 Monorepo
   ↓
4. 添加/更新技能目录
   ↓
5. 更新根目录 README.md
   ↓
6. 提交并推送
```

---

## ⚙️ 配置

编辑 `config.json`：

```json
{
  "github": {
    "user": "fclwtt",
    "repo": "openclaw-skills",
    "branch": "main"
  },
  "monorepo": {
    "skillsDir": "skills"
  }
}
```

---

## 📝 更新日志

### v2.0.0 (2026-03-12)

- 🎉 重构为 Monorepo 架构
- ✨ 自动重构技能为 GitHub 标准格式
- ✨ 自动更新根目录 README.md
- 📦 支持技能分类

### v1.1.0 (2026-03-12)

- ✨ 改进 Monorepo 推送逻辑
- 🐛 修复目录结构问题

### v1.0.0 (2026-03-12)

- 🎉 首次发布