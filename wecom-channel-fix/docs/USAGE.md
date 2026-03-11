# 📖 使用手册

**OpenClaw Skill: Enterprise WeChat Channel Fix**

---

## 🎯 触发场景

技能会自动触发，以下消息会激活诊断：

- "企微没反应"
- "企业微信通道配置错误"
- "wecom 连不上"
- "插件 ID 不匹配"
- "多账号模式不支持"
- "企微消息无回复"

---

## 🔍 诊断流程

技能会自动执行以下步骤：

1. **检查通道状态** - `openclaw channels status`
2. **检查配置文件** - `openclaw config get channels.wecom`
3. **检查插件配置** - 查看 `openclaw.json`
4. **分析日志** - 查看 `/tmp/openclaw/openclaw-*.log`
5. **自动修复** - 根据问题类型执行修复
6. **验证结果** - 确认修复成功

---

## 🛠️ 修复的问题

| 问题 | 自动修复 | 说明 |
|------|---------|------|
| 插件 ID 不匹配 | ✅ | 将 `wecom-openclaw-plugin` 改为 `wecom` |
| 多账号模式 | ✅ | 回退到单账号扁平配置 |
| 通道未配置 | ✅ | 引导配置 botId/secret |
| WebSocket 失败 | ✅ | 诊断并提示解决方案 |

---

## 📊 配置示例

### 单账号模式（支持）

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

## 🧪 测试

```bash
# 在企微或 webchat 中发送测试消息
"test"

# 查看日志确认技能触发
tail -f /tmp/openclaw/openclaw-*.log | grep -i skill
```

---

**详细文档：** [INSTALL.md](INSTALL.md) | [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
