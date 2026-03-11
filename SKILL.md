---
name: skill-searcher
description: 通用技能搜索服务，支持 ClawHub 和 GitHub 搜索。提供技能筛选、自动评分排序、安全预审和缓存机制。Use when: searching for skills on ClawHub/GitHub, evaluating skill quality, comparing multiple skills, or caching search results for reuse.
version: 1.0.0
author: 小美 (for 老板)
metadata:
  {
    "openclaw":
      {
        "emoji": "🔍",
        "requires":
          {
            "bins": ["clawhub", "gh"],
          },
        "install":
          [
            {
              "id": "node",
              "kind": "node",
              "package": "clawhub",
              "bins": ["clawhub"],
              "label": "Install ClawHub CLI (npm)",
            },
          ],
      },
  }
---

# Skill Searcher 🔍

通用技能搜索服务 - 支持 ClawHub 和 GitHub 搜索、智能评分、安全预审和缓存

---

## 🎯 核心功能

### 1. 双平台搜索
- ✅ **ClawHub 搜索** - 使用 `clawhub search` 命令
- ✅ **GitHub 搜索** - 使用 `gh` CLI 搜索技能仓库

### 2. 智能评分排序
- **技能对口度** (优先级最高) - 根据用户查询匹配度评分
- **下载量/Stars** - 社区认可度
- **更新时间** - 活跃度
- **版本号** - 成熟度

### 3. 安全审查
- **预审查** - 安装前扫描红旗标记
- **后审查** - 安装后深度审查（单一技能时）
- **风险分级** - 🟢 LOW / 🟡 MEDIUM / 🟠 HIGH / 🔴 EXTREME

### 4. 缓存机制
- **搜索缓存** - 避免重复搜索
- **结果缓存** - 缓存评分和审查结果
- **缓存过期** - 可配置过期时间（默认 24 小时）

---

## 📋 使用方式

### 基本搜索

```bash
# 搜索 ClawHub 技能
skill-searcher search --platform clawhub "postgres backup"

# 搜索 GitHub 技能
skill-searcher search --platform github "pdf editor"

# 双平台搜索（默认）
skill-searcher search "skill publisher"
```

### 高级选项

```bash
# 指定缓存过期时间（小时）
skill-searcher search "automation" --cache-ttl 48

# 强制刷新缓存
skill-searcher search "github actions" --no-cache

# 仅返回前 N 个结果
skill-searcher search "notion" --limit 5

# 导出搜索结果
skill-searcher search "excel" --output results.json
```

### 技能评估

```bash
# 评估单个技能
skill-searcher evaluate --skill my-skill

# 比较多个技能
skill-searcher compare skill-a skill-b skill-c

# 查看缓存
skill-searcher cache list

# 清除缓存
skill-searcher cache clear
```

---

## 🔄 执行流程

### 搜索流程

```
1. 检查缓存
   ├─ 缓存命中 → 返回缓存结果
   └─ 缓存未命中 → 执行搜索

2. 执行搜索
   ├─ ClawHub: clawhub search <query>
   └─ GitHub: gh search repos <query>

3. 技能对口度评分
   ├─ 提取技能描述和触发器
   ├─ 计算与查询的语义匹配度
   └─ 生成对口度分数 (0-100)

4. 自动评分排序
   ├─ 对口度 (权重 50%)
   ├─ 下载量/Stars (权重 25%)
   ├─ 更新时间 (权重 15%)
   └─ 版本号 (权重 10%)
   └─ 综合得分排序

5. 安全预审
   ├─ 读取 SKILL.md
   ├─ 检查红旗标记
   └─ 风险分级

6. 缓存结果
   └─ 保存到 ~/.openclaw/skills/skill-searcher/cache/

7. 返回结果
```

### 安装决策流程

```
单一对口技能：
1. 对口度 > 80 且无其他匹配 → 先安装后审查
2. 执行 skill-install-gateway 后审查
3. 审查失败 → 卸载并报告

多个对口技能：
1. 自动评分排序
2. 前 3 名预审查
3. 推荐最优技能
4. 用户确认后安装
```

---

## 📊 评分算法

### 综合得分计算公式

```
综合得分 = (对口度 × 0.5) + (社区分 × 0.25) + (活跃度 × 0.15) + (成熟度 × 0.10)

其中：
- 对口度 (0-100): 语义匹配度
- 社区分 (0-100): log10(下载量) × 25 或 log10(Stars) × 25
- 活跃度 (0-100): 根据最后更新时间计算
  • <7 天：100
  • <30 天：80
  • <90 天：60
  • <180 天：40
  • >180 天：20
- 成熟度 (0-100): 版本号解析 (major×40 + minor×30 + patch×30)
```

---

## 🛡️ 安全审查标准

### 红旗标记（自动拒绝）

```
🚨 REJECT IMMEDIATELY:
─────────────────────────────────────────
• curl/wget 到未知 URL
• 发送数据到外部服务器
• 请求凭证/Token/API Key
• 读取 ~/.ssh, ~/.aws, ~/.config
• 访问 MEMORY.md, USER.md, SOUL.md, IDENTITY.md
• 使用 base64 解码
• 使用 eval() 或 exec() 处理外部输入
• 修改系统文件
• 混淆代码
• 请求提权/sudo 权限
─────────────────────────────────────────
```

### 风险分级

| 等级 | 标准 | 处理 |
|------|------|------|
| 🟢 LOW | 无红旗，权限最小化 | 自动安装 |
| 🟡 MEDIUM | 文件操作/网络访问 | 小美审核后安装 |
| 🟠 HIGH | 敏感 API/外部调用 | 老板审批后安装 |
| 🔴 EXTREME | 发现红旗标记 | 禁止安装 |

---

## 📁 缓存结构

```
~/.openclaw/skills/skill-searcher/cache/
├── search_results.json       # 搜索结果缓存
├── skill_scores.json         # 评分缓存
├── security_audits.json      # 审查结果缓存
└── metadata.json             # 缓存元数据
```

### 缓存元数据

```json
{
  "query": "postgres backup",
  "platform": "clawhub",
  "timestamp": 1710230400,
  "ttl_hours": 24,
  "expires_at": 1710316800,
  "result_count": 5,
  "top_skill": "postgres-backup-pro"
}
```

---

## 🔧 配置选项

在 `~/.openclaw/skills/skill-searcher/config.json` 中配置：

```json
{
  "search": {
    "defaultLimit": 10,
    "maxLimit": 50,
    "platforms": ["clawhub", "github"]
  },
  "scoring": {
    "weights": {
      "relevance": 0.5,
      "community": 0.25,
      "activity": 0.15,
      "maturity": 0.10
    }
  },
  "cache": {
    "enabled": true,
    "defaultTtlHours": 24,
    "maxCacheSize": 100,
    "path": "~/.openclaw/skills/skill-searcher/cache/"
  },
  "security": {
    "autoInstallSingleMatch": true,
    "requireApprovalFor": ["MEDIUM", "HIGH", "EXTREME"],
    "vetAfterInstall": true
  }
}
```

---

## 📤 输出格式

### 搜索结果输出

```
SKILL SEARCH RESULTS
═══════════════════════════════════════
查询："postgres backup"
平台：ClawHub + GitHub
时间：2026-03-12 04:15:00
缓存：❌ 未命中 (执行搜索)
───────────────────────────────────────
TOP 5 SKILLS (按综合得分排序):

#1 ⭐ postgres-backup-pro (ClawHub)
   综合得分：92.5/100
   ├─ 对口度：95/100
   ├─ 社区分：88/100 (1,234 下载)
   ├─ 活跃度：95/100 (3 天前更新)
   └─ 成熟度：90/100 (v2.3.1)
   安全：🟢 LOW
   操作：[安装] [详情] [对比]

#2 🥈 pg-backup-automator (GitHub)
   综合得分：87.3/100
   ├─ 对口度：88/100
   ├─ 社区分：92/100 (456 stars)
   ├─ 活跃度：80/100 (15 天前更新)
   └─ 成熟度：85/100 (v1.8.0)
   安全：🟡 MEDIUM
   操作：[安装] [详情] [对比]

#3 🥉 database-backup-kit (ClawHub)
   综合得分：79.1/100
   ...
───────────────────────────────────────
💡 建议：推荐安装 #1 postgres-backup-pro
   理由：对口度最高，社区活跃，安全风险低
═══════════════════════════════════════
```

---

## 🔄 与其他技能集成

### 被 skill-router 调用

```
用户："我需要一个技能来发布小红书"
↓
skill-router → skill-searcher "xiaohongshu publish"
↓
skill-searcher 返回最优技能
↓
skill-router 调用该技能执行任务
```

### 被 skill-install-gateway 调用

```
用户："安装 my-skill"
↓
skill-install-gateway → skill-searcher evaluate my-skill
↓
skill-searcher 返回安全审查结果
↓
skill-install-gateway 决定是否安装
```

---

## 🛠️ 故障处理

### 搜索失败

```bash
# 查看错误日志
skill-searcher logs --last

# 重试搜索
skill-searcher search "query" --retry

# 切换平台
skill-searcher search "query" --platform clawhub
```

### 缓存问题

```bash
# 查看缓存状态
skill-searcher cache status

# 清除特定缓存
skill-searcher cache clear --query "postgres"

# 清除全部缓存
skill-searcher cache clear --all
```

---

## 📞 联系小美

如有问题或需要调整搜索策略，请联系：
- **负责人：** 小美
- **角色：** 老板的私人助理
- **职责：** 技能搜索、安全审查、任务调度

---

## ⚠️ 重要提示

1. **缓存优先** - 默认使用缓存，避免重复搜索
2. **安全第一** - 单一技能先安装后审查，多个技能先审查后推荐
3. **对口度优先** - 评分算法中对口度权重最高 (50%)
4. **定期清理** - 建议每周清理一次过期缓存

---

**版本：** 1.0.0  
**日期：** 2026-03-12  
**开发者：** 小美 💼  
**许可证：** MIT
