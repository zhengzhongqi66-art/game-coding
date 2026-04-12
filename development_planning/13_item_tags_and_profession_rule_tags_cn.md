# 道具标签与职业规则标签

## 1. 文档目的

这份文档用于定义首版标准化标签体系，覆盖：

- 道具身份
- 道具行为
- 职业判定
- 空间与激活逻辑

目标是让未来的内容设计、平衡、UI 和代码都能用同一套概念说话。

## 2. 标签设计原则

首版标签系统应满足：

- 数量足够小，便于管理
- 表达能力足够支撑职业规则
- 设计师能直接读懂
- 工具层容易做校验

标签系统不能变成无限膨胀的关键词垃圾堆。

## 3. 标签分类

首版建议把标签拆成这些组：

- 道具家族标签
- 功能标签
- 激活标签
- 空间标签
- 职业亲和标签
- 世界来源标签

每个标签应尽量只承担一个主要含义。

## 4. 道具家族标签

这类标签描述“它本质上是什么”。

建议的首版家族标签：

- `weapon`
- `talisman`
- `spirit_stone`
- `furnace`
- `relic`
- `focus`
- `spell_tool`
- `processor`
- `drone_module`
- `logic_relay`
- `defense`
- `utility`

规则：

- 每个道具至少应有一个家族标签
- 大多数道具最好只拥有一到两个家族标签

## 5. 功能标签

这类标签描述“它在 build 里主要负责什么”。

建议的首版功能标签：

- `engine`
- `support`
- `energy_source`
- `energy_link`
- `converter`
- `burst`
- `sustain`
- `defense_layer`
- `economy`
- `recovery`
- `control`
- `setup`

规则：

- 每个道具应有一个主功能标签
- 如有必要，可以再给一个次功能标签

## 6. 激活标签

这类标签描述“它是怎么被激活或怎么获得价值的”。

建议的首版激活标签：

- `requires_adjacent`
- `requires_direction`
- `requires_energy`
- `requires_link`
- `requires_charge`
- `requires_chain`
- `start_of_battle`
- `timed_trigger`
- `on_hit`
- `on_support`
- `on_destroy`
- `on_cycle_end`

规则：

- 激活标签应同时服务模拟层和 UI 层
- 职业规则应尽量引用这些标签，而不是硬编码具体道具名

## 7. 空间标签

这类标签描述空间结构与摆放特征。

建议的首版空间标签：

- `rotatable`
- `line_based`
- `adjacency_core`
- `occupies_large_space`
- `backline_pref`
- `frontline_pref`
- `storage_friendly`
- `layout_sensitive`

规则：

- 空间标签应帮助 UI 做预览和快速筛选
- 不是每个道具都必须有空间标签，但对布局敏感的道具必须标

## 8. 职业亲和标签

这类标签表示某个道具天然更适合哪个职业。

建议的首版职业亲和标签：

- `cultivator_affinity`
- `mage_affinity`
- `ai_affinity`

规则：

- 亲和标签表示协同倾向，而不是硬限制
- 一个道具可以同时服务多个职业
- 首版尽量避免职业锁死型道具

## 9. 世界来源标签

这类标签表示主题或世界来源。

建议的首版世界标签：

- `xianxia_origin`
- `arcane_origin`
- `synthetic_origin`

规则：

- 世界标签应服务于内容分组、奖励倾向和美术统一
- 世界标签不能自动等同于职业协同

## 10. 职业规则标签

除了道具标签外，系统还应定义一组可复用的“规则状态标签”，用于职业判定。

建议的首版职业规则标签：

- `clean_alignment`
- `valid_energy_path`
- `valid_support_target`
- `charged_state`
- `spell_sequence_ready`
- `full_logic_chain`
- `stable_cycle`

作用：

- 这些标签描述的是“当前 build 已满足的结构状态”
- 职业被动可以直接奖励这些状态
- UI 也能更清楚地解释这些状态

## 11. 首批职业的标签使用方向

### 修士

应最常和这些标签发生关系：

- `talisman`
- `spirit_stone`
- `weapon`
- `requires_direction`
- `requires_energy`
- `valid_energy_path`
- `clean_alignment`

### 魔法师

应最常和这些标签发生关系：

- `focus`
- `spell_tool`
- `requires_charge`
- `requires_chain`
- `charged_state`
- `spell_sequence_ready`

### 人工智能

应最常和这些标签发生关系：

- `processor`
- `drone_module`
- `logic_relay`
- `requires_link`
- `full_logic_chain`
- `stable_cycle`

## 12. 数据规则

建议的最小道具数据字段：

- `id`
- `name`
- `family_tags`
- `function_tags`
- `activation_tags`
- `spatial_tags`
- `profession_affinity_tags`
- `world_tags`

后续可选字段：

- `rule_state_outputs`
- `tooltip_keywords`
- `ai_evaluation_notes`

## 13. 验证规则

只有当以下问题大多能回答“是”时，这套标签系统才算成立：

- 设计师在给新道具打标签时不会困惑
- 职业规则大多可以通过标签实现
- UI 说明可以复用同一套术语
- 平衡复盘能按标签聚合道具
- 标签总量仍保持可理解

## 14. 对制作的直接影响

下一层规划应继续定义：

- 带完整标签的首批道具名单
- 使用这些标签的职业被动 UI 文案
- 标签误用的数据校验规则
- 按职业与世界标签做奖励倾向的逻辑
