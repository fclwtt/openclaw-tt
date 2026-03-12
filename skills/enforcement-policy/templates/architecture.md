# 强制审查策略系统架构

本文档描述系统的强制审查策略实现架构。

## 📁 文件结构

```
~/.openclaw/
├── _GLOBAL_RULES.md              # 全局规则（唯一源头）
├── openclaw.json                 # 配置文件
├── hooks/
│   └── global-rules-injector/    # 自动注入全局规则
│       ├── HOOK.md
│       └── handler.js            # 使用 path 字段
└── skills/
    ├── enforcement-policy/       # 强制审查策略（本技能）
    │   ├── SKILL.md
    │   ├── config.json
    │   ├── scripts/
    │   │   └── check.sh
    │   ├── templates/
    │   └── logs/
    ├── mupeng-skill-router/      # 技能路由
    └── skill-install-gateway/    # 安装审查网关
```

## 🔄 执行流程

```
新会话启动
    ↓
global-rules-injector hook 触发 (agent:bootstrap)
    ↓
读取 ~/.openclaw/_GLOBAL_RULES.md
    ↓
注入到 Project Context (使用 path 字段)
    ↓
Agent 收到用户请求
    ↓
读取 skill-router/SKILL.md 进行意图分析
    ↓
选择最优技能链
    ↓
执行安全审查 (高风险操作确认)
    ↓
执行任务
```

## ⚠️ 关键要点

1. **Hook 必须使用 `path` 字段**，不是 `filePath`
2. **全局规则放在 `~/.openclaw/` 根目录**
3. **修改后需要重启 Gateway**：`openclaw gateway restart`

## 🛠️ 故障排查

如果全局规则未生效：

```bash
# 1. 检查 hook 日志
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log | grep -i "global-rules"

# 2. 运行检查脚本
bash ~/.openclaw/skills/enforcement-policy/scripts/check.sh

# 3. 重启 Gateway
openclaw gateway restart
```