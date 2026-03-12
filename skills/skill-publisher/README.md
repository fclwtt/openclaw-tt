# 🚀 Skill Publisher

**技能发布工具** - 自动将技能重构为 GitHub 标准格式并推送

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://openclaw.ai)
[![Version](https://img.shields.io/badge/version-2.0.0-green.svg)](https://github.com/fclwtt/openclaw-skills)

---

## 📋 功能

- ✅ **标准化重构** - 自动将技能重构为 GitHub 标准项目格式
- ✅ **Monorepo 支持** - 推送到统一仓库，每个技能独立目录
- ✅ **README 自动更新** - 自动更新仓库根目录的技能列表
- ✅ **版本管理** - 自动处理版本号和更新日志

---

## 🚀 快速开始

### 发布技能

```bash
~/.openclaw/skills/skill-publisher/scripts/publish.sh <skill-name>
```

### 示例

```bash
# 发布 enforcement-policy
~/.openclaw/skills/skill-publisher/scripts/publish.sh enforcement-policy

# 指定版本
~/.openclaw/skills/skill-publisher/scripts/publish.sh my-skill --version 1.0.0
```

---

## 📁 标准技能结构

```
skills/<skill-name>/
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
检查源技能 → 检查 SSH → 克隆 Monorepo → 重构技能结构 → 推送
```

---

## 📝 更新日志

### v2.0.0 (2026-03-12)

- 🎉 重构为 Monorepo 架构
- ✨ 自动重构技能为 GitHub 标准格式

---

**仓库:** [fclwtt/openclaw-skills](https://github.com/fclwtt/openclaw-skills)
