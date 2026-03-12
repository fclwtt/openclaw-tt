# 🔧 企业微信通道配置诊断与修复技能

**OpenClaw Skill** - 用于诊断和修复企业微信通道配置问题

---

## 📋 技能信息

| 项目 | 值 |
|------|-----|
| **名称** | `wecom-channel-fix` |
| **版本** | 1.0.0 |
| **作者** | OpenClaw Community |
| **创建日期** | 2026-03-11 |
| **适用插件** | `@wecom/wecom-openclaw-plugin` v1.0.8 |

---

## 🎯 功能

- ✅ 企微通道状态诊断
- ✅ 插件 ID 不匹配修复
- ✅ 多账号模式兼容性处理
- ✅ WebSocket 连接问题排查
- ✅ 配置验证与测试

---

## 🚀 安装

### 方式 1：手动安装

将 `skills/` 目录复制到你的 OpenClaw 技能目录：

```bash
cp -r wecom-channel-fix/skills/* ~/.openclaw/skills/
```

### 方式 2：通过 ClawHub（待发布）

```bash
openclaw skills install wecom-channel-fix
```

---

## 💡 使用场景

### 场景 1：企微通道无法连接

```
用户：企微没反应，消息发出去没回复
```

**技能激活后：**
1. 检查通道状态
2. 查看日志错误
3. 自动修复配置问题

---

### 场景 2：插件 ID 不匹配

```
日志：plugin id mismatch (config uses "wecom-openclaw-plugin", export uses "wecom")
```

**修复操作：**
- 将配置中的 `wecom-openclaw-plugin` 改为 `wecom`
- 重启 gateway

---

### 场景 3：多账号模式不支持

```
错误：wecom default: 企业微信机器人 ID 或 Secret 未配置
配置：使用了 accounts.* 多账号结构
```

**修复操作：**
- 回退到单账号扁平配置
- 更新 binding 规则
- 重启 gateway

---

## 📁 文件结构

```
wecom-channel-fix/
├── SKILL.md              # 技能主文件（核心逻辑）
├── README.md             # 这个文件
├── references/           # 参考资料
│   ├── wecom-plugin-docs.md
│   └── config-examples.json
├── scripts/              # 辅助脚本
│   └── fix-wecom-config.sh
└── test-cases/           # 测试用例
    └── diagnostic-tests.md
```

---

## 🔍 诊断命令

### 快速诊断

```bash
# 1. 检查通道状态
openclaw channels status

# 2. 检查配置
openclaw config get channels.wecom

# 3. 查看日志
tail -50 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | grep -i wecom
```

### 详细诊断

```bash
# 检查插件
openclaw plugins list | grep wecom

# 检查配对状态
openclaw pairing list wecom

# 检查 gateway
openclaw gateway status
```

---

## 🛠️ 修复操作

### 自动修复（推荐）

技能会自动检测并修复常见问题：

1. 备份当前配置
2. 修复插件 ID
3. 修复通道配置
4. 重启 gateway
5. 验证修复结果

### 手动修复

参考 `SKILL.md` 中的详细步骤。

---

## 📊 配置模板

### 单账号模式（当前支持）

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

### 多账号模式（暂不支持）

```json
{
  "channels": {
    "wecom": {
      "enabled": true,
      "defaultAccount": "main",
      "accounts": {
        "main": {"botId": "...", "secret": "..."}
      }
    }
  }
}
```

> ⚠️ 注意：企微插件 v1.0.8 不支持多账号模式

---

## ✅ 验证清单

修复完成后确认：

- [ ] `openclaw channels status` → `enabled, configured, running`
- [ ] 日志无 `plugin id mismatch` 警告
- [ ] 日志显示 `Authentication successful`
- [ ] 企微消息能收到回复
- [ ] WebSocket 心跳正常

---

## 🐛 已知问题

| 问题 | 状态 | 说明 |
|------|------|------|
| 多账号模式不支持 | ⚠️ 待修复 | 需要插件更新支持 |
| 插件 ID 混淆 | ✅ 已解决 | 配置使用 `wecom` 而非包名 |

---

## 📚 参考资料

- [企业微信 AI Bot 官方文档](https://open.work.weixin.qq.com/help?doc_id=21657)
- [OpenClaw 通道文档](https://docs.openclaw.ai/channels)
- [企微插件源码](https://github.com/openclaw/wecom-openclaw-plugin)

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 测试反馈

如在使用中遇到问题，请提供：

1. OpenClaw 版本
2. 企微插件版本
3. 错误日志
4. 配置片段（脱敏）

---

## 📄 许可证

MIT License

---

**最后更新：** 2026-03-11
