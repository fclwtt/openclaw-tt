# 企业微信插件文档摘要

**插件名称：** @wecom/wecom-openclaw-plugin  
**当前版本：** 1.0.8  
**导出 ID：** `wecom`  
**包名：** `@wecom/wecom-openclaw-plugin`

---

## 关键发现

### 插件 ID 问题

在 `openclaw.plugin.json` 中定义：
```json
{
  "id": "wecom-openclaw-plugin",
  "channels": ["wecom"],
  "skills": ["./skills"]
}
```

但实际导出时，OpenClaw 使用 `id` 字段作为插件标识。

**配置时应使用：** `"wecom"`（导出 ID）  
**而非：** `"wecom-openclaw-plugin"`（包名）

---

## 多账号模式支持状态

**当前状态：** ❌ 不支持（v1.0.8）

**原因：** 插件期望扁平配置结构：
```json
{
  "channels": {
    "wecom": {
      "botId": "...",
      "secret": "..."
    }
  }
}
```

**不支持：**
```json
{
  "channels": {
    "wecom": {
      "accounts": {
        "main": {...},
        "agent-2": {...}
      }
    }
  }
}
```

---

## 配置参数参考

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `botId` | string | ✅ | 企业微信机器人 ID |
| `secret` | string | ✅ | 企业微信机器人 Secret |
| `enabled` | boolean | ✅ | 是否启用通道 |
| `dmPolicy` | string | ❌ | 私聊策略：`pairing`/`open`/`allowlist`/`disabled` |
| `allowFrom` | array | ❌ | 私聊白名单用户 ID |
| `groupPolicy` | string | ❌ | 群聊策略：`open`/`allowlist`/`disabled` |
| `websocketUrl` | string | ❌ | WebSocket 地址（默认官方地址） |

---

## 常见问题

### 1. 插件 ID 不匹配

**错误信息：**
```
[plugins] plugin id mismatch (config uses "wecom-openclaw-plugin", export uses "wecom")
```

**解决方案：** 将配置中的 `wecom-openclaw-plugin` 改为 `wecom`

---

### 2. 通道未配置

**错误信息：**
```
wecom default: 企业微信机器人 ID 或 Secret 未配置
```

**解决方案：**
```bash
openclaw config set channels.wecom.botId <BOT_ID>
openclaw config set channels.wecom.secret <SECRET>
openclaw gateway restart
```

---

### 3. WebSocket 连接失败

**可能原因：**
- botId 或 secret 错误
- 机器人未在企业微信中正确配置
- 网络问题

**排查步骤：**
1. 检查日志：`tail -f /tmp/openclaw/openclaw-*.log | grep wecom`
2. 验证 botId/secret 是否正确
3. 确认企业微信机器人已启用

---

## 官方资源

- **GitHub:** https://github.com/openclaw/wecom-openclaw-plugin
- **企业微信文档:** https://open.work.weixin.qq.com/help?doc_id=21657
- **OpenClaw 文档:** https://docs.openclaw.ai/channels

---

**文档更新时间：** 2026-03-11
