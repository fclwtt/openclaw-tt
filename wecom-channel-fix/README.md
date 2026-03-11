# 🚀 OpenClaw Skill Publisher

**Skill 发布助手** - 自动化创建和发布 OpenClaw Skill 到 GitHub

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://openclaw.ai)

---

## 📋 功能

- ✅ **自动创建 Skill 项目** - 生成标准项目结构
- ✅ **Monorepo 支持** - 推送到统一仓库（如 openclaw-tt）
- ✅ **GitHub 自动推送** - SSH/Token 双模式
- ✅ **Release 创建** - 自动打标签发布
- ✅ **用户引导** - 清晰的 SSH/Token 配置指引

---

## 🚀 安装

```bash
# 从 Monorepo 安装
git clone https://github.com/fclwtt/openclaw-tt.git
cd openclaw-tt/skill-publisher
./install.sh
```

---

## 💡 使用方式

### 创建新 Skill

```bash
# 运行创建脚本
~/.openclaw/skills/skill-publisher/scripts/create-skill.sh

# 交互式输入：
# 1. Skill 名称
# 2. Skill 描述
# 3. 作者名
```

### 推送到 GitHub

```bash
# 推送到 Monorepo
~/.openclaw/skills/skill-publisher/scripts/push-to-github.sh <skill-name>

# 例如：
~/.openclaw/skills/skill-publisher/scripts/push-to-github.sh wecom-channel-fix
```

### 在对话中使用

直接告诉我：
- "创建一个新 skill"
- "发布 skill 到 github"
- "帮我推送 wecom-channel-fix"

我会自动引导你完成整个流程！

---

## 🔧 配置

### Monorepo 配置

编辑 `scripts/push-to-github.sh`：

```bash
GITHUB_USER="fclwtt"           # 你的 GitHub 用户名
MONOREPO="openclaw-tt"         # Monorepo 仓库名
REMOTE="git@github.com:$GITHUB_USER/$MONOREPO.git"
```

### SSH 密钥（推荐）

```bash
# 生成密钥
ssh-keygen -t ed25519 -C "your@email.com"

# 添加到 GitHub
# https://github.com/settings/keys
```

### Personal Access Token

如使用 Token 方式，创建 Token 后设置：

```bash
export GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

---

## 📁 项目结构

Skill Publisher 会创建标准的 OpenClaw Skill 结构：

```
skill-name/
├── skills/
│   └── SKILL.md          # OpenClaw 技能定义
├── docs/
│   ├── INSTALL.md
│   ├── USAGE.md
│   └── TROUBLESHOOTING.md
├── scripts/
│   └── helper.sh
├── install.sh
├── uninstall.sh
├── README.md
├── LICENSE
└── .gitignore
```

---

## 🎯 工作流程

### 1. 创建 Skill

```
用户：创建一个新 skill
  ↓
助手：询问名称、描述、功能
  ↓
创建项目结构
  ↓
✅ 项目创建完成
```

### 2. 推送到 GitHub

```
用户：发布到 github
  ↓
检查 SSH 密钥/Token
  ↓
如无 → 引导配置
  ↓
推送到 Monorepo
  ↓
创建 Release
  ↓
✅ 发布成功
```

---

## 🐛 故障排除

### SSH 连接失败

```bash
# 测试连接
ssh -T git@github.com

# 应看到：Hi username! You've successfully authenticated
```

### 仓库不存在

请先在 GitHub 创建空仓库：
1. 访问 https://github.com/new
2. Repository name: `openclaw-tt`
3. 不要勾选初始化选项
4. 点击 "Create repository"

### Git subtree 失败

```bash
# 如已存在，使用 pull 更新
git subtree pull --prefix=skill-name origin main --squash
```

---

## 📚 相关资源

- [OpenClaw 文档](https://docs.openclaw.ai)
- [ClawHub](https://clawhub.ai)
- [GitHub 文档](https://docs.github.com)

---

**版本：** 1.0.0  
**作者：** tt (fclwtt)
