# 🔧 OpenClaw Skill: Enterprise WeChat Channel Fix

**企业微信通道配置诊断与修复技能** - OpenClaw 官方技能

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://openclaw.ai)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](https://github.com/fclwtt/openclaw-skill-wecom-channel-fix/releases)

---

## 📋 技能简介

这是一个 OpenClaw **技能（Skill）**，用于自动诊断和修复企业微信通道的配置问题。

**触发关键词：**
- "企微没反应"
- "企业微信通道配置错误"
- "wecom 连不上"
- "插件 ID 不匹配"
- "多账号模式不支持"

---

## 🚀 安装方式

### 方式 1：ClawHub 安装（推荐）

```bash
# 安装 ClawHub CLI
npm install -g clawhub

# 登录
clawhub login

# 安装技能
clawhub install wecom-channel-fix
```

### 方式 2：Git 克隆安装

```bash
# 克隆仓库
git clone https://github.com/fclwtt/openclaw-skill-wecom-channel-fix.git

# 进入目录
cd openclaw-skill-wecom-channel-fix

# 运行安装脚本
./install.sh
```

### 方式 3：手动安装

```bash
# 下载技能文件
wget https://github.com/fclwtt/openclaw-skill-wecom-channel-fix/archive/refs/tags/v1.0.0.tar.gz

# 解压
tar -xzf v1.0.0.tar.gz

# 复制技能到 OpenClaw 技能目录
cp -r openclaw-skill-wecom-channel-fix-1.0.0/skills/wecom-channel-fix ~/.openclaw/skills/

# 重启 Gateway
openclaw gateway restart
```

### 方式 4：OpenClaw 命令安装

```bash
openclaw skills install wecom-channel-fix
```

---

## 💡 使用示例

技能会自动触发，无需手动调用。

**示例 1：企微通道故障**
```
用户：企微没反应，消息发出去没回复
技能：🔧 正在诊断企业微信通道问题...
     ✅ 检测到插件 ID 不匹配
     🔧 正在修复配置...
     ✅ 配置已修复，Gateway 已重启
     ✅ 通道状态：enabled, configured, running
```

**示例 2：多账号模式问题**
```
用户：wecom 连不上
技能：🔧 正在诊断...
     ⚠️ 检测到多账号模式配置（当前插件不支持）
     🔧 正在回退到单账号模式...
     ✅ 修复完成
```

---

## 📁 技能结构

```
openclaw-skill-wecom-channel-fix/
├── skills/
│   └── SKILL.md              # OpenClaw 技能定义文件（核心）
├── docs/
│   ├── INSTALL.md            # 详细安装指南
│   ├── USAGE.md              # 使用手册
│   └── TROUBLESHOOTING.md    # 故障排除
├── scripts/
│   └── fix-wecom-config.sh   # 辅助修复脚本
├── examples/
│   ├── config-single.json    # 单账号配置示例
│   └── config-multi.json     # 多账号配置示例（参考）
├── install.sh                # 一键安装脚本
├── uninstall.sh              # 卸载脚本
├── README.md                 # 本文件
├── LICENSE                   # MIT 许可证
└── .github/workflows/
    └── release.yml           # 自动发布工作流
```

---

## 🔧 修复的问题

| 问题 | 自动修复 | 说明 |
|------|---------|------|
| 插件 ID 不匹配 | ✅ | `wecom-openclaw-plugin` → `wecom` |
| 多账号模式不支持 | ✅ | 回退到单账号扁平配置 |
| 通道未配置 | ✅ | 引导用户配置 botId/secret |
| WebSocket 连接失败 | ✅ | 诊断并提示解决方案 |
| 认证失败 | ✅ | 验证 botId/secret 有效性 |

---

## 📊 配置要求

**前置要求：**
- OpenClaw >= 2026.2.13
- 已安装企微插件：`@wecom/wecom-openclaw-plugin`
- Node.js >= 18.0.0

**通道配置：**
```json
{
  "channels": {
    "wecom": {
      "enabled": true,
      "botId": "你的 botId",
      "secret": "你的 secret",
      "dmPolicy": "pairing"
    }
  }
}
```

---

## 🧪 测试技能

安装后，发送以下消息测试：

```bash
# 在企微或 webchat 中发送
"企微通道配置错误"
"wecom 连不上"
"插件 ID 不匹配"
```

---

## 📚 文档

- [安装指南](docs/INSTALL.md) - 详细安装步骤
- [使用手册](docs/USAGE.md) - 功能详解
- [故障排除](docs/TROUBLESHOOTING.md) - 常见问题

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

```bash
# Fork 仓库
# 创建功能分支
git checkout -b feature/amazing-feature

# 提交更改
git commit -m 'feat: add amazing feature'

# 推送
git push origin feature/amazing-feature

# 创建 Pull Request
```

---

## 📄 许可证

MIT License - 查看 [LICENSE](LICENSE) 文件

---

## 🔗 相关链接

- [OpenClaw 文档](https://docs.openclaw.ai)
- [ClawHub 技能市场](https://clawhub.ai)
- [企业微信 AI Bot](https://open.work.weixin.qq.com/help?doc_id=21657)
- [Discord 社区](https://discord.com/invite/clawd)

---

**版本：** 1.0.0  
**最后更新：** 2026-03-12  
**作者：** OpenClaw Community
