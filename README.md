# Skill Searcher Usage

## 快速开始

### 基本搜索

```bash
# 搜索技能（双平台）
skill-searcher search "postgres backup"

# 仅搜索 ClawHub
skill-searcher search "pdf editor" --platform clawhub

# 仅搜索 GitHub
skill-searcher search "notion api" --platform github
```

### 高级选项

```bash
# 指定结果数量
skill-searcher search "automation" --limit 5

# 不使用缓存
skill-searcher search "github actions" --no-cache

# 自定义缓存时间（48 小时）
skill-searcher search "excel" --cache-ttl 48

# 导出结果到文件
skill-searcher search "skill publisher" --output results.json
```

### 缓存管理

```bash
# 查看缓存列表
skill-searcher cache list

# 查看缓存状态
skill-searcher cache status

# 清除所有缓存
skill-searcher cache clear
```

## 与其他代理集成

### 在子代理中调用

```bash
# 通过 sessions_spawn 调用
sessions_spawn \
  --task "search skills for xiaohongshu publishing" \
  --agentId skill-searcher \
  --mode run
```

### 通过 skill-router 自动调用

```
用户："我需要一个技能来发布小红书"
↓
skill-router 自动调用 skill-searcher
↓
返回最优技能
```

## 输出格式

搜索结果包含：
- 技能名称和来源平台
- 综合得分（0-100）
- 分项评分（对口度、社区分、活跃度、成熟度）
- 安全风险等级
- 操作建议

## 注意事项

1. **缓存默认启用** - 避免重复搜索，节省时间和 API 调用
2. **对口度优先** - 评分算法中对口度权重最高（50%）
3. **安全第一** - 单一技能先安装后审查，多个技能先审查后推荐
4. **定期清理缓存** - 建议每周清理一次过期缓存
