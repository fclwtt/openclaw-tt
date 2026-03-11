---
name: skill-publisher
description: OpenClaw Skill 发布助手。当用户想要创建新 Skill、发布 Skill 到 GitHub、推送到 ClawHub 时激活。支持 Monorepo 方案、自动创建项目结构、GitHub 推送、Release 创建。
version: 1.0.0
license: MIT
author: tt (fclwtt)
metadata:
  {
    "openclaw":
      {
        "emoji": "🚀",
        "always": false,
        "requires":
          {
            "bins": ["git"],
          },
      },
  }
---

# OpenClaw Skill 发布助手

帮助用户自动化创建和发布 OpenClaw Skill 到 GitHub。

## 触发场景

- "创建一个新 skill"
- "发布 skill 到 github"
- "把项目推送到 github"
- "开源我的 skill"
- "创建 skill 项目"

## 工作流程

### 阶段 1：项目初始化

1. **询问项目信息**
   - Skill 名称
   - Skill 描述
   - 功能特性
   - 作者信息

2. **创建项目结构**
   ```
   skill-name/
   ├── skills/
   │   └── SKILL.md
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
   └── .github/workflows/
       └── release.yml
   ```

### 阶段 2：GitHub 配置

3. **检查 GitHub 连接**
   ```bash
   # 检查 SSH 密钥
   ls -la ~/.ssh/id_ed25519* 2>/dev/null
   
   # 测试 GitHub 连接
   ssh -T git@github.com
   ```

4. **引导用户配置（如需要）**
   - 如无 SSH 密钥：指导生成并添加到 GitHub
   - 如使用 Token：指导创建 Personal Access Token

### 阶段 3：推送发布

5. **推送到 Monorepo 仓库**
   ```bash
   # 默认仓库：fclwtt/openclaw-tt
   git remote add origin git@github.com:fclwtt/openclaw-tt.git
   git subtree add --prefix=<skill-name> . main
   git push origin main
   ```

6. **创建 Release**
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0 - <skill-name>"
   git push origin v1.0.0
   ```

## 配置项

### Monorepo 配置

```json
{
  "github": {
    "username": "fclwtt",
    "monorepo": "openclaw-tt",
    "remote": "git@github.com:fclwtt/openclaw-tt.git"
  }
}
```

### 项目模板

使用 `templates/` 目录中的标准模板：
- `README.md.tmpl`
- `SKILL.md.tmpl`
- `install.sh.tmpl`

## 命令参考

### 创建新 Skill

```bash
# 交互式创建
./scripts/create-skill.sh

# 或命令行参数
./scripts/create-skill.sh --name my-skill --desc "描述"
```

### 推送到 GitHub

```bash
# 推送到 Monorepo
./scripts/push-to-github.sh <skill-name>

# 推送到独立仓库
./scripts/push-to-github.sh <skill-name> --standalone
```

### 创建 Release

```bash
./scripts/create-release.sh <skill-name> v1.0.0
```

## 用户指引

### SSH 密钥配置

如检测到无 SSH 密钥，输出：

```
🔑 需要配置 SSH 密钥

请执行以下步骤：

1. 生成 SSH 密钥：
   ssh-keygen -t ed25519 -C "your@email.com"

2. 查看公钥：
   cat ~/.ssh/id_ed25519.pub

3. 添加到 GitHub：
   - 访问 https://github.com/settings/keys
   - 点击 "New SSH key"
   - 粘贴公钥内容
   - 点击 "Add SSH key"

完成后回复"done"或"已完成"继续推送。
```

### GitHub Token 配置

如使用 Token 方式，输出：

```
🔐 需要 GitHub Personal Access Token

请执行以下步骤：

1. 访问 https://github.com/settings/tokens

2. 点击 "Generate new token (classic)"

3. 填写：
   - Note: OpenClaw Skill Publisher
   - Expiration: 90 days（或更长）
   - Scopes: 勾选 repo, workflow

4. 复制生成的 token（格式：ghp_xxxxxxxxxxxx）

5. 回复我你的 token，我会帮你推送

⚠️ 注意：Token 只显示一次，请妥善保存！
```

## 错误处理

| 错误 | 处理方案 |
|------|---------|
| Repository not found | 引导用户在 GitHub 创建空仓库 |
| Permission denied | 检查 SSH 密钥或 Token 权限 |
| Already exists | 提示用户技能已存在，是否更新 |
| Git not installed | 指导安装 Git |

## 示例对话

**用户：** 我想创建一个新 skill 并发布到 github

**助手：**
```
🚀 好的！我来帮你创建和发布 OpenClaw Skill。

请提供以下信息：

1. Skill 名称（英文，小写，连字符分隔）：
   例如：wecom-channel-fix

2. Skill 描述（一句话说明功能）：
   例如：企业微信通道配置诊断与修复

3. 主要功能（列出 3-5 个）：
   例如：
   - 自动诊断企微通道问题
   - 插件 ID 不匹配修复
   - 多账号模式检测

准备好了吗？请告诉我这些信息。
```

**用户：** 名称：my-skill，描述：...，功能：...

**助手：**
```
✅ 项目创建中...

📁 已创建项目结构：
/home/tt/.openclaw/workspace/my-skill/
├── skills/SKILL.md
├── docs/
├── README.md
├── install.sh
└── ...

🔍 检查 GitHub 连接...
✅ SSH 密钥已配置
✅ GitHub 连接正常

🚀 推送到 Monorepo 仓库 (fclwtt/openclaw-tt)...
✅ 推送成功！

📦 创建 Release v1.0.0...
✅ Release 已创建！

🎉 完成！

访问你的项目：
https://github.com/fclwtt/openclaw-tt/tree/main/my-skill

安装方式：
git clone https://github.com/fclwtt/openclaw-tt.git
cd openclaw-tt/my-skill
./install.sh
```

## 注意事项

1. **Monorepo 优先**：默认推送到 openclaw-tt，除非用户指定独立仓库
2. **用户确认**：关键步骤（如推送、发布）需要用户确认
3. **错误恢复**：如推送失败，提供详细的故障排除指南
4. **本地备份**：推送前自动备份到本地

## 参考资料

- [OpenClaw Skill 规范](https://docs.openclaw.ai/skills)
- [ClawHub 发布指南](https://clawhub.ai/publish)
- [GitHub 最佳实践](https://docs.github.com/en/repositories)
