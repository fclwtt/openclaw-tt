# 📦 OpenClaw Skills Collection

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-Compatible-blue)](https://openclaw.ai)

一套高质量的 OpenClaw 技能集合，采用 Monorepo 架构管理。

---

## 📋 技能列表

### 🔒 安全与治理

| 技能 | 版本 | 描述 |
|------|------|------|
| [enforcement-policy](./skills/enforcement-policy) | v1.0.0 | 强制审查策略 - 安全审查机制 + 技能优先机制 |

### 🛠️ 开发工具

| 技能 | 版本 | 描述 |
|------|------|------|
| [skill-publisher](./skills/skill-publisher) | v2.0.0 | 技能发布工具 - 自动重构为 GitHub 标准格式并推送 |

### 🔍 搜索与发现

| 技能 | 版本 | 描述 |
|------|------|------|
| [skill-searcher](./skills/skill-searcher) | v1.0.0 | 技能搜索服务 - 双平台搜索 + 智能评分 |

### 📱 企业微信

| 技能 | 版本 | 描述 |
|------|------|------|
| [wecom-channel-fix](./skills/wecom-channel-fix) | v1.0.0 | 企业微信通道配置诊断与修复 |

---

## 🚀 快速开始

### 安装单个技能

```bash
# 克隆仓库
git clone https://github.com/fclwtt/openclaw-skills.git
cd openclaw-skills

# 安装技能
cp -r skills/<skill-name> ~/.openclaw/skills/<skill-name>/
```

### 安装所有技能

```bash
cd openclaw-skills
./install-all.sh
```

---

## 📖 文档

- [安装指南](./docs/INSTALL.md)
- [贡献指南](./docs/CONTRIBUTING.md)
- [技能开发指南](./docs/SKILL_DEVELOPMENT.md)

---

## 🔧 技能结构

每个技能都遵循标准的 GitHub 项目结构：

```
skills/
└── <skill-name>/
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

## 📝 更新日志

### 2026-03-12

- 🎉 初始化 Monorepo 架构
- 📦 添加 enforcement-policy v1.0.0
- 📦 添加 skill-publisher v2.0.0
- 📦 添加 skill-searcher v1.0.0
- 📦 添加 wecom-channel-fix v1.0.0

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](./LICENSE) 文件。

---

## 🤝 贡献

欢迎贡献！请查看 [贡献指南](./docs/CONTRIBUTING.md)。

---

**维护者:** [fclwtt](https://github.com/fclwtt)