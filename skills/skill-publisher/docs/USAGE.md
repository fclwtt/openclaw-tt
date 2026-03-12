# 使用指南

## 基本用法

### 发布技能

```bash
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh <skill-name>
```

### 仅格式化

```bash
bash ~/.openclaw/skills/skill-publisher/scripts/format.sh <skill-name>
```

## 参数

| 参数 | 说明 |
|------|------|
| `--category` | 指定分类 (security/devtools/search/wecom/other) |
| `--version` | 指定版本号 |
| `--output` | 输出目录（仅 format.sh） |

## 示例

```bash
# 发布到 security 分类
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh my-skill --category security

# 指定版本
bash ~/.openclaw/skills/skill-publisher/scripts/format-and-push.sh my-skill --version 1.0.0

# 格式化到桌面
bash ~/.openclaw/skills/skill-publisher/scripts/format.sh my-skill --output ~/Desktop/
```
