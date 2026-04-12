# 首批道具名单

## 1. 文档目的

这份文档用于定义首个制作版本推荐使用的首批道具池，服务于原型与 vertical slice 阶段。

目标不是一开始就把内容堆满。
目标是先做出一个紧凑但足以证明以下几点的道具池：

- 空间摆放有意义
- 职业差异可感知
- 奖励分支成立
- 战斗回报可读

## 2. 范围目标

建议首批制作道具池：

- 总计 24 个道具

建议拆分：

- 8 个偏修士道具
- 8 个偏魔法师道具
- 8 个偏人工智能道具

规则说明：

- 这不代表道具被职业锁死
- 它代表每个职业在前期都应有足够的亲和支持，能形成可辨识的 build 身份

## 3. 道具池结构规则

首批道具应覆盖：

- 引擎件
- 支撑件
- 供能件
- 转换或工具件
- 防御件
- 少量高回报件

首批道具应避免：

- 太多只在边角场景使用的道具
- 纯玩梗道具
- 需要大量例外说明才能理解的道具

## 4. 偏修士道具

### 1. 青锋

- 家族标签：`weapon`
- 功能标签：`engine`, `burst`
- 激活标签：`requires_direction`
- 空间标签：`rotatable`, `layout_sensitive`
- 职业亲和：`cultivator_affinity`
- 来源：普通奖励或商店
- 角色：基础朝向输出引擎

### 2. 灵符串

- 家族标签：`talisman`
- 功能标签：`support`
- 激活标签：`requires_adjacent`, `on_support`
- 空间标签：`adjacency_core`
- 职业亲和：`cultivator_affinity`
- 来源：普通奖励或商店
- 角色：基础相邻支撑件

### 3. 下品灵石

- 家族标签：`spirit_stone`
- 功能标签：`energy_source`
- 激活标签：`start_of_battle`
- 职业亲和：`cultivator_affinity`
- 来源：普通奖励或商店
- 角色：基础供能来源

### 4. 铜炉

- 家族标签：`furnace`
- 功能标签：`setup`, `support`
- 激活标签：`requires_adjacent`, `timed_trigger`
- 空间标签：`occupies_large_space`, `layout_sensitive`
- 职业亲和：`cultivator_affinity`
- 来源：商店或精英奖励
- 角色：偏包围式的支撑引擎

### 5. 玉守印

- 家族标签：`talisman`, `defense`
- 功能标签：`defense_layer`
- 激活标签：`requires_adjacent`
- 职业亲和：`cultivator_affinity`
- 来源：普通奖励或商店
- 角色：相邻型防御支撑

### 6. 经脉针

- 家族标签：`weapon`, `utility`
- 功能标签：`converter`
- 激活标签：`requires_energy`, `on_hit`
- 空间标签：`line_based`
- 职业亲和：`cultivator_affinity`
- 来源：精英奖励
- 角色：把干净供能路径转为精确收益

### 7. 五行罗盘

- 家族标签：`relic`
- 功能标签：`support`, `control`
- 激活标签：`requires_direction`
- 空间标签：`rotatable`
- 职业亲和：`cultivator_affinity`
- 来源：精英奖励或 Boss 明牌三选一
- 角色：朝向型支撑锚点

### 8. 金丹残片

- 家族标签：`relic`
- 功能标签：`burst`, `setup`
- 激活标签：`requires_energy`, `on_cycle_end`
- 职业亲和：`cultivator_affinity`
- 来源：Boss 明牌三选一
- 角色：高回报型灵性爆发件

## 5. 偏魔法师道具

### 9. 余烬法杖

- 家族标签：`focus`, `spell_tool`
- 功能标签：`engine`, `burst`
- 激活标签：`requires_charge`
- 职业亲和：`mage_affinity`
- 来源：普通奖励或商店
- 角色：基础充能输出法术引擎

### 10. 回响法印

- 家族标签：`spell_tool`
- 功能标签：`support`, `setup`
- 激活标签：`requires_adjacent`, `on_support`
- 空间标签：`adjacency_core`
- 职业亲和：`mage_affinity`
- 来源：普通奖励或商店
- 角色：基础法术支撑放大器

### 11. 法力棱镜

- 家族标签：`focus`
- 功能标签：`energy_source`
- 激活标签：`start_of_battle`
- 职业亲和：`mage_affinity`
- 来源：普通奖励或商店
- 角色：基础魔法供能件

### 12. 延时刻印

- 家族标签：`spell_tool`
- 功能标签：`setup`
- 激活标签：`requires_charge`, `timed_trigger`
- 职业亲和：`mage_affinity`
- 来源：商店或精英奖励
- 角色：延迟型法术爆发准备件

### 13. 镜面护障

- 家族标签：`spell_tool`, `defense`
- 功能标签：`defense_layer`
- 激活标签：`requires_charge`
- 职业亲和：`mage_affinity`
- 来源：普通奖励或商店
- 角色：充能型魔法防御件

### 14. 奥术闪球

- 家族标签：`focus`
- 功能标签：`burst`
- 激活标签：`requires_chain`, `timed_trigger`
- 职业亲和：`mage_affinity`
- 来源：精英奖励
- 角色：奖励连锁准备的爆发终端

### 15. 符文格阵

- 家族标签：`relic`
- 功能标签：`support`, `converter`
- 激活标签：`requires_chain`
- 空间标签：`layout_sensitive`
- 职业亲和：`mage_affinity`
- 来源：精英奖励或 Boss 明牌三选一
- 角色：把法术时序转化为更广泛支撑价值

### 16. 星界书页

- 家族标签：`relic`
- 功能标签：`setup`, `economy`
- 激活标签：`on_cycle_end`
- 职业亲和：`mage_affinity`
- 来源：Boss 明牌三选一
- 角色：高价值魔法成长件

## 6. 偏人工智能道具

### 17. 逻辑核心

- 家族标签：`processor`
- 功能标签：`engine`
- 激活标签：`requires_link`
- 职业亲和：`ai_affinity`
- 来源：普通奖励或商店
- 角色：基础逻辑链引擎

### 18. 中继节点

- 家族标签：`logic_relay`
- 功能标签：`support`, `energy_link`
- 激活标签：`requires_link`, `on_support`
- 空间标签：`line_based`
- 职业亲和：`ai_affinity`
- 来源：普通奖励或商店
- 角色：链路连接支撑件

### 19. 微型电池

- 家族标签：`processor`, `utility`
- 功能标签：`energy_source`
- 激活标签：`start_of_battle`
- 职业亲和：`ai_affinity`
- 来源：普通奖励或商店
- 角色：基础合成供能源

### 20. 无人机外壳

- 家族标签：`drone_module`
- 功能标签：`setup`, `burst`
- 激活标签：`requires_link`, `timed_trigger`
- 职业亲和：`ai_affinity`
- 来源：商店或精英奖励
- 角色：延迟部署型无人机收益件

### 21. 屏障矩阵

- 家族标签：`logic_relay`, `defense`
- 功能标签：`defense_layer`
- 激活标签：`requires_link`
- 空间标签：`line_based`
- 职业亲和：`ai_affinity`
- 来源：普通奖励或商店
- 角色：链路型结构防御件

### 22. 错误过滤器

- 家族标签：`processor`, `utility`
- 功能标签：`recovery`, `converter`
- 激活标签：`on_destroy`, `on_cycle_end`
- 职业亲和：`ai_affinity`
- 来源：精英奖励
- 角色：降低结构化 build 的失败尖峰

### 23. 优化引擎

- 家族标签：`processor`, `relic`
- 功能标签：`support`, `burst`
- 激活标签：`full_logic_chain`, `on_cycle_end`
- 职业亲和：`ai_affinity`
- 来源：精英奖励或 Boss 明牌三选一
- 角色：奖励完整逻辑链的高收益件

### 24. 预测内核

- 家族标签：`relic`
- 功能标签：`engine`, `control`
- 激活标签：`requires_link`, `timed_trigger`
- 职业亲和：`ai_affinity`
- 来源：Boss 明牌三选一
- 角色：高辨识度的机器心智终端件

## 7. 来源分布建议

建议的首轮来源分布：

- 普通奖励池：基础引擎、支撑件、基础供能、防御件
- 商店池：基础件、工具件、适应类道具
- 精英奖励池：更强的分支件与职业深化件
- Boss 明牌池：高记忆点、高承诺度的身份道具

## 8. 平衡控制备注

这批道具需要重点检查：

- 每个职业方向是否都有足够的基础供能支持
- 每个职业方向是否都有足够的防御件
- 每个职业方向是否同时拥有简单回报件和高级回报件
- 是否存在足够的跨职业通用件，避免 build 被强行锁死

## 9. 对制作的直接影响

下一层规划应继续定义：

- 每个道具的具体形状与尺寸
- 第一版文案与 tooltip
- 初始稀有度分配
- 道具数据表格式
