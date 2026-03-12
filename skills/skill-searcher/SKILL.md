---
name: skill-searcher
description: "技能搜索服务 - 双平台搜索（ClawHub + GitHub）+ 智能评分排序"
version: 1.0.0
license: MIT
author: fclwtt
metadata:
  {
    "openclaw":
      {
        "emoji": "🔍",
        "requires": { "bins": [] }
      }
  }
---

# Skill Searcher 🔍

**技能搜索服务** - 双平台搜索 + 智能评分排序

---

## 🎯 核心功能

1. **双平台搜索** - ClawHub + GitHub
2. **智能评分** - 对口度 50% + 社区 25% + 活跃度 15% + 成熟度 10%
3. **安全预审** - 集成 skill-install-gateway
4. **缓存机制** - 避免重复搜索

---

## 📋 使用方式

```bash
# 搜索技能
./run.sh search <keyword>

# 查看详情
./run.sh info <skill-name>
```

---

## 📝 更新日志

### v1.0.0 (2026-03-12)

- 🎉 首次发布
