---
name: enforcement-policy
description: "强制审查策略 - 整合安全审查机制和技能优先机制，确保所有 agent 在执行任务前进行安全审查并优先使用技能。"
version: 1.0.0
license: MIT
author: OpenClaw
metadata:
  {
    "openclaw":
      {
        "emoji": "🔒",
        "always": true,
        "priority": "highest",
        "requires": { "bins": [], "skills": ["skill-router", "skill-install-gateway"] }
      }
  }
---

# 强制审查策略 (Enforcement Policy)

**统一的安全审查和技能优先执行框架**

---

## 🎯 核心功能

本技能整合了系统的强制审查策略，确保所有 agent 在执行任务前：

1. **安全审查** - 对高风险操作进行安全评估
2. **技能优先** - 通过 skill-router 选择最优技能
3. **规则注入** - 通过 global-rules-injector 自动加载全局规则

---

## 📋 执行流程

```
用户请求
    ↓
┌─────────────────────────────────────┐
│  阶段 1: 加载全局规则                │
│  global-rules-injector hook 自动执行  │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│  阶段 2: 技能路由                    │
│  读取 skill-router/SKILL.md         │
│  分析意图 → 选择技能链               │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│  阶段 3: 安全审查                    │
│  评估操作风险 → 确认必要性            │
│  高风险操作 → 询问用户确认            │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│  阶段 4: 执行任务                    │
│  使用选定技能 → 监控执行过程          │
└─────────────────────────────────────┘
```

---

## 🔒 安全审查机制

### 需要安全审查的操作

| 操作类型 | 工具/命令 | 风险等级 |
|---------|----------|---------|
| Shell 命令执行 | `exec` | 🔴 高 |
| 文件写入 | `write`, `edit` | 🟠 中高 |
| 网页浏览 | `browser` | 🟡 中 |
| 安装技能/插件 | `clawhub install` | 🔴 高 |
| 发送外部消息 | `message` | 🟡 中 |
| 访问敏感目录 | `read` 敏感路径 | 🔴 高 |

### 安全审查步骤

```
1. 评估风险
   - 操作可能产生什么影响？
   - 是否涉及敏感数据？
   - 是否有不可逆的后果？

2. 确认必要性
   - 操作是否真正需要？
   - 是否是用户明确要求的？
   - 是否有更安全的方式？

3. 考虑替代方案
   - 是否可以用更安全的方式实现？
   - 是否可以先在沙盒中测试？

4. 必要时询问用户
   - 高风险操作必须确认
   - 涉及外部发送必须确认
   - 不确定时主动询问
```

### 风险等级决策

| 风险等级 | 自动处理 | 用户确认 |
|---------|---------|---------|
| 🟢 LOW | ✅ 直接执行 | 不需要 |
| 🟡 MEDIUM | ⚠️ 记录日志 | 可选 |
| 🟠 HIGH | 🔒 需要确认 | 必须 |
| 🔴 EXTREME | ❌ 禁止执行 | 必须审批 |

---

## ⚡ 技能优先机制

### 执行原则

**有技能，先走技能；没技能，再自己来。**

### 技能路由流程

```
用户请求
    ↓
读取 skill-router/SKILL.md
    ↓
分析意图类型
    ↓
┌─────────────┬─────────────┬─────────────┐
│   单技能     │   技能链    │   无匹配    │
│   1:1映射    │   1:N组合   │   通用处理  │
└──────┬──────┴──────┬──────┴──────┬──────┘
       ↓             ↓             ↓
   直接执行      顺序/并行执行    自己处理
```

### 常见技能映射

| 用户意图 | 技能选择 |
|---------|---------|
| 网页搜索 | multi-search-engine |
| GitHub 操作 | github |
| 文档操作 | wecom-doc |
| 代码任务 | coding-agent |
| 小红书操作 | xiaohongshu-skills |
| 天气查询 | weather |
| PDF 编辑 | nano-pdf |
| 邮件处理 | himalaya |

### 例外情况（跳过技能路由）

- 简单问候/寒暄
- 用户明确指定不使用技能
- 系统维护/状态查询
- `/` 开头的命令

---

## 📁 系统架构

```
~/.openclaw/
├── _GLOBAL_RULES.md              # 全局规则（唯一源头）
├── openclaw.json                 # 配置文件
├── hooks/
│   └── global-rules-injector/    # 自动注入全局规则
└── skills/
    ├── enforcement-policy/       # 本技能（强制审查策略）
    ├── skill-router/             # 技能路由
    ├── skill-install-gateway/    # 安装审查网关
    └── ...                       # 其他技能
```

---

## 🔗 集成组件

### 1. global-rules-injector (Hook)

- **位置**: `~/.openclaw/hooks/global-rules-injector/`
- **事件**: `agent:bootstrap`
- **功能**: 自动将 `_GLOBAL_RULES.md` 注入所有会话

### 2. skill-router (Skill)

- **位置**: `~/.openclaw/skills/mupeng-skill-router/`
- **功能**: 分析意图，选择最优技能链

### 3. skill-install-gateway (Skill)

- **位置**: `~/.openclaw/skills/skill-install-gateway/`
- **功能**: 安装技能前的安全扫描

### 4. OpenClaw 模板修改

- **位置**: `~/.npm-global/lib/node_modules/openclaw/docs/reference/templates/AGENTS.md`
- **功能**: 新 agent 自动包含全局规则引用

---

## 📝 配置

### openclaw.json 配置

```json
{
  "hooks": {
    "internal": {
      "enabled": true,
      "entries": {
        "global-rules-injector": {
          "enabled": true
        },
        "session-memory": {
          "enabled": true
        },
        "command-logger": {
          "enabled": true
        }
      }
    }
  }
}
```

### 全局规则文件

编辑 `~/.openclaw/_GLOBAL_RULES.md` 修改规则内容。

修改后执行 `openclaw gateway restart` 生效。

---

## 🛠️ 使用方式

### 自动执行

本技能在每次会话中自动生效，无需手动触发。

### 手动检查

```bash
# 检查全局规则是否生效
cat ~/.openclaw/_GLOBAL_RULES.md

# 检查 hook 状态
openclaw hooks list

# 检查 Gateway 日志
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | grep -i "global-rules"
```

---

## ⚠️ 重要提示

1. **不要绕过安全审查** - 高风险操作必须确认
2. **优先使用技能** - 有现成技能就用，不要自己造轮子
3. **定期检查日志** - 确保规则正常工作
4. **及时更新规则** - 根据需要调整全局规则

---

## 🔄 更新维护

### 修改全局规则

```bash
nano ~/.openclaw/_GLOBAL_RULES.md
openclaw gateway restart
```

### 更新 Hook

```bash
nano ~/.openclaw/hooks/global-rules-injector/handler.js
openclaw gateway restart
```

### 检查系统状态

```bash
openclaw status
openclaw hooks list
```

---

**安全第一，技能优先！🔒**

---

**版本**: 1.0.0  
**日期**: 2026-03-12  
**作者**: OpenClaw