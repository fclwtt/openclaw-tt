# 📦 安装指南

**OpenClaw Skill: Enterprise WeChat Channel Fix**

---

## 🎯 前置要求

- ✅ OpenClaw >= 2026.2.13
- ✅ Node.js >= 18.0.0
- ✅ 已安装企微插件：`@wecom/wecom-openclaw-plugin`

---

## 🚀 安装方式

### 方式 1：ClawHub（推荐）

```bash
# 安装 ClawHub CLI
npm install -g clawhub

# 登录 ClawHub
clawhub login

# 安装技能
clawhub install wecom-channel-fix

# 验证安装
openclaw gateway restart
```

---

### 方式 2：Git 克隆

```bash
# 克隆仓库
git clone https://github.com/fclwtt/openclaw-skill-wecom-channel-fix.git

# 进入目录
cd openclaw-skill-wecom-channel-fix

# 运行安装脚本
./install.sh
```

---

### 方式 3：手动安装

```bash
# 1. 下载技能包
wget https://github.com/fclwtt/openclaw-skill-wecom-channel-fix/archive/refs/tags/v1.0.0.tar.gz

# 2. 解压
tar -xzf v1.0.0.tar.gz
cd openclaw-skill-wecom-channel-fix-1.0.0

# 3. 复制到技能目录
cp -r skills/wecom-channel-fix ~/.openclaw/skills/

# 4. 重启 Gateway
openclaw gateway restart
```

---

## ✅ 验证安装

```bash
# 1. 检查技能文件
ls -la ~/.openclaw/skills/wecom-channel-fix/SKILL.md

# 2. 检查 Gateway
openclaw gateway status

# 3. 测试技能
# 在企微或 webchat 中发送："企微通道配置错误"
```

---

## 🐛 故障排除

### 问题：权限错误

```bash
chmod +x install.sh
./install.sh
```

### 问题：OpenClaw 未找到

```bash
npm install -g openclaw
```

### 问题：Gateway 重启失败

```bash
tail -50 /tmp/openclaw/openclaw-*.log
openclaw gateway stop
openclaw gateway start
```

---

**详细文档：** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
