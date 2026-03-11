# 🐛 故障排除

**OpenClaw Skill: Enterprise WeChat Channel Fix**

---

## 🔍 快速诊断

```bash
# 1. 检查 Gateway
openclaw gateway status

# 2. 检查通道
openclaw channels status

# 3. 查看日志
tail -50 /tmp/openclaw/openclaw-*.log | grep -i wecom
```

---

## ❌ 常见问题

### 插件 ID 不匹配

```
[plugins] plugin id mismatch
```

**解决：** 技能会自动修复，或手动执行：
```bash
sed -i 's/"wecom-openclaw-plugin"/"wecom"/g' ~/.openclaw/openclaw.json
openclaw gateway restart
```

---

### 多账号模式不支持

```
wecom default: 企业微信机器人 ID 或 Secret 未配置
```

**解决：** 技能会提示回退，或手动修改配置为单账号模式。

---

### 技能未触发

**检查：**
```bash
ls ~/.openclaw/skills/wecom-channel-fix/SKILL.md
openclaw gateway restart
```

---

**更多信息：** [INSTALL.md](INSTALL.md) | [USAGE.md](USAGE.md)
