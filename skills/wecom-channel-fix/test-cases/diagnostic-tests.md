# 企微通道诊断测试用例

## 测试环境

- OpenClaw: 2026.3.8
- 企微插件：@wecom/wecom-openclaw-plugin v1.0.8
- Node.js: v22.22.1

---

## 测试用例 1：插件 ID 不匹配

### 前置条件
- 配置中使用 `"wecom-openclaw-plugin"` 作为插件 ID

### 预期行为
- 启动时出现警告：`plugin id mismatch`
- 通道可能无法正常启动

### 修复验证
```bash
# 1. 检查配置
grep -A 5 '"plugins"' ~/.openclaw/openclaw.json

# 2. 修复后应显示
"allow": ["wecom"]
"entries": {"wecom": {"enabled": true}}

# 3. 重启后检查状态
openclaw channels status
# 应显示：enabled, configured, running
```

---

## 测试用例 2：多账号模式不支持

### 前置条件
- 配置使用 `accounts.*` 结构

### 预期行为
- 配置重载失败
- 通道状态：`not configured`

### 修复验证
```bash
# 1. 检查配置结构
openclaw config get channels.wecom

# 2. 如显示 accounts 结构，需回退单账号

# 3. 修复后验证
openclaw channels status
# 应无 accounts 相关错误
```

---

## 测试用例 3：WebSocket 连接

### 前置条件
- botId 和 secret 已正确配置

### 预期日志
```
[default] Establishing WebSocket connection...
[default] WebSocket connection established, sending auth...
[default] Authentication successful
[default] Heartbeat timer started
```

### 失败场景
```
[default] WebSocket error: Invalid WebSocket frame
[default] WebSocket connection closed: code: 1006
```

### 排查命令
```bash
tail -50 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | grep -i wecom
```

---

## 测试用例 4：消息收发

### 测试步骤
1. 在企业微信向机器人发送 "test"
2. 观察日志是否有消息接收记录
3. 确认是否收到回复

### 预期日志
```
[WeCom] Processing direct message from chat: XXX
[WeCom] Sending thinking message
[WeCom] Sent reply: streamId=stream_XXX
```

### 验证命令
```bash
# 查看最新企微消息日志
tail -f /tmp/openclaw/openclaw-*.log | grep -E "(Processing|Sent reply)"
```

---

## 测试用例 5：配对流程

### 测试步骤
1. 新用户向机器人发送消息
2. 检查是否收到配对码
3. 批准配对
4. 再次发送消息确认正常

### 验证命令
```bash
# 查看待配对请求
openclaw pairing list wecom

# 批准配对
openclaw pairing approve wecom <CODE>

# 验证配对成功
openclaw pairing list wecom
# 应显示：No pending wecom pairing requests.
```

---

## 测试用例 6：心跳检测

### 预期行为
- 每 30 秒发送一次心跳
- 收到心跳确认

### 预期日志
```
[default] Heartbeat sent
[default] Received heartbeat ack
```

### 验证命令
```bash
# 持续观察心跳日志
tail -f /tmp/openclaw/openclaw-*.log | grep -i heartbeat
```

---

## 完整诊断流程

```bash
#!/bin/bash
# 企微通道完整诊断脚本

echo "=== 企微通道诊断 ==="
echo ""

echo "1. 通道状态"
openclaw channels status 2>&1 | grep -i wecom
echo ""

echo "2. 配置检查"
openclaw config get channels.wecom 2>&1 | head -10
echo ""

echo "3. 插件配置"
grep -A 10 '"plugins"' ~/.openclaw/openclaw.json | head -12
echo ""

echo "4. 最新日志（最近 10 条 wecom 相关）"
tail -100 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | grep -i wecom | tail -10
echo ""

echo "5. Gateway 状态"
openclaw gateway status 2>&1 | head -5
```

---

## 测试结果记录模板

```markdown
## 测试记录

**日期：** YYYY-MM-DD HH:mm
**测试人：** XXX
**环境：** OpenClaw vX.X.X

### 测试项
- [ ] 插件 ID 配置
- [ ] 通道状态
- [ ] WebSocket 连接
- [ ] 消息收发
- [ ] 配对流程
- [ ] 心跳检测

### 问题记录
（如有问题，详细描述）

### 修复操作
（如执行修复，记录操作步骤）

### 最终状态
- [ ] 全部通过
- [ ] 部分通过（说明：XXX）
- [ ] 失败（原因：XXX）
```

---

**最后更新：** 2026-03-11
