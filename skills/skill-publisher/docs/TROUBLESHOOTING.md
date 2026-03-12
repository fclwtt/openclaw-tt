# 故障排除

## SSH 连接失败

```bash
# 测试连接
ssh -T git@github.com

# 应看到：Hi fclwtt! You've successfully authenticated
```

## 技能目录不存在

```bash
# 检查目录
ls -la ~/.openclaw/skills/<skill-name>/

# 确保有 SKILL.md
ls ~/.openclaw/skills/<skill-name>/SKILL.md
```

## 推送失败

```bash
# 检查远程仓库
git ls-remote git@github.com:fclwtt/openclaw-skills.git
```

## 权限问题

```bash
# 确保脚本可执行
chmod +x ~/.openclaw/skills/skill-publisher/scripts/*.sh
```
