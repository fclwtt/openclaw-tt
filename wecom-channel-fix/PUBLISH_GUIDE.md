# 🚀 发布到 GitHub 指南

**OpenClaw Skill: wecom-channel-fix**

---

## 📋 发布步骤

### 步骤 1：创建 GitHub 仓库

1. 访问 https://github.com/new
2. 填写：
   - **Repository name:** `openclaw-skill-wecom-channel-fix`
   - **Description:** `OpenClaw Skill - Enterprise WeChat channel diagnostic and fix`
   - **Visibility:** Public
   - **不要** 初始化 README/.gitignore/license

3. 点击 "Create repository"

---

### 步骤 2：推送代码

```bash
# 进入项目目录
cd /mnt/e/openclaw-skills/wecom-channel-fix-github

# 添加远程仓库（替换 fclwtt）
git remote add origin https://github.com/fclwtt/openclaw-skill-wecom-channel-fix.git

# 推送
git push -u origin main
```

---

### 步骤 3：创建 Release

```bash
# 创建版本标签
git tag -a v1.0.0 -m "Release v1.0.0 - OpenClaw Skill"

# 推送标签
git push origin v1.0.0
```

或在 GitHub 网页：
1. 访问 https://github.com/fclwtt/openclaw-skill-wecom-channel-fix/releases
2. 点击 "Create a new release"
3. Tag version: `v1.0.0`
4. 点击 "Publish release"

---

### 步骤 4：启用 Actions

1. 访问 https://github.com/fclwtt/openclaw-skill-wecom-channel-fix/actions
2. 启用 GitHub Actions

---

## 📦 安装方式（发布后）

### ClawHub
```bash
clawhub install wecom-channel-fix
```

### Git
```bash
git clone https://github.com/fclwtt/openclaw-skill-wecom-channel-fix.git
cd openclaw-skill-wecom-channel-fix
./install.sh
```

### 手动下载
```bash
wget https://github.com/fclwtt/openclaw-skill-wecom-channel-fix/releases/download/v1.0.0/wecom-channel-fix-v1.0.0.tar.gz
tar -xzf wecom-channel-fix-v1.0.0.tar.gz
cp -r skills/wecom-channel-fix ~/.openclaw/skills/
```

---

## ✅ 检查清单

- [ ] GitHub 仓库已创建
- [ ] 代码已推送
- [ ] Release 已创建
- [ ] Actions 已启用
- [ ] README 中 fclwtt 已替换

---

**版本：** 1.0.0
