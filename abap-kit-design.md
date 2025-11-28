# abap-kit 设计方案

## 目标
- 基于 Spec Kit 规范，支持 ABAP 旧代码向 RAP + Fiori 现代化的落地。
- 复用 Spec Kit CLI 体验，同时增加 ABAP 场景的专属 prompts、模板与文档结构。
- 按开发/转换类型组织 prompts，保证指导可发现、可审计。

## 拟支持的开发/转换类型
- 经典事务对话（DYNPRO/CMOD/SMOD）→ RAP BO + Fiori elements 应用
- 报表/ALV 输出 → RAP 查询服务 + Fiori 列表/报表应用
- 函数模块/RFC/BAPI → RAP 服务 + REST/OData Facade
- 批处理作业/程序 → RAP Action 或后台服务 + 监控 UI
- 增强点/User Exit → RAP 行为扩展实现
- 表单/SmartForms/SAPScript → RAP 打印服务 + UI 触发（可选）

## 方案 A：在 CLI 初始化时选择开发类型（新增参数）
**流程**
- 扩展 CLI（如 `specify init --kit abap --dev-type <type>`），在 `abap-kit/` 命名空间下生成 prompts 与共享模板。
- 生成基础模板（spec、plan、tasks、checklist 等）+ 针对类型的 prompt 文件。
- prompts 按 `<dev-type>/<command>.md` 存放，command 名与 Spec Kit 一致：specify、plan、clarify、implement、tasks、checklist、analyze。

**优点**
- Prompt 选择确定，不依赖运行时类型推断。
- 文档结构清晰，易于审计和按类型演进。
- 与现有初始化约定一致（输入驱动生成产物）。
- 可为不同类型提供默认模板（如 RAP BO、CDS/视图样例），避免单个 prompt 过载。

**缺点**
- 需改动 CLI（参数校验、帮助文案、映射）。
- 需要用户前置选择类型；切换类型需重新 init 或手动拷贝。

**适用场景**
- 已有清晰 ABAP 模式库，追求确定性与可审计的团队。
- 合规/评审要求显式意图的场合。

## 方案 B：保持 CLI 流程，新增自动识别类型的路由 Prompt
**流程**
- 不改 CLI 步骤，新增一组与现有命令同名的 prompts。
- 入口 prompt 要求 AI 先读 ABAP 原代码，推断开发类型，再加载 `dev-types/<type>/<command>.md` 的角色指导。
- 结构：路由文件（如 `prompts/abap-kit/router.md`）+ 各类型子目录。

**优点**
- CLI 改动最小，用户无感接入。
- 适合不了解具体类型的新用户。

**缺点**
- 依赖模型判别，存在误判风险。
- 难以做确定性测试，路由提示易随模型行为漂移。
- 文档/可发现性间接。

**适用场景**
- 早期试验，开发类型分类可能频繁变动。
- 优先降低使用门槛的团队。

## Prompt 与模板目录建议（两种方案通用）
```
templates/abap-kit/
  shared/
    glossary.md              # 术语、禁用写法、质量门槛（ABAP→RAP/Fiori）
    constraints.md           # 性能、安全、权限、可扩展性规则
    checklist.md             # 跨类型审查项（权限、i18n、UI5 注解、CDS 等）
    examples/                # 小型前后对照示例
  command/
    specify.md               # 入口路由版（同名命令，对应方案 B）
    plan.md
    clarify.md
    implement.md
    tasks.md
    checklist.md
    analyze.md
    constitution.md
    dev-types/
      transactional-dialog/
        specify.md
        plan.md
        clarify.md
        implement.md
        tasks.md
        checklist.md
        analyze.md
        constitution.md
      report-alv/
        ...
      rfc-api/
        ...
      batch-job/
        ...
      enhancement/
        ...
      forms/
        ...
  templates/
    spec-template.md         # 面向 ABAP→RAP 的 spec 模板
    plan-template.md
    tasks-template.md
    checklist-template.md
    agent-file-template.md   # 如需新增 agent
```

## Prompt 内容要点
- 入口上下文：源系统信息、RAP 目标层次（CDS、行为、服务绑定、UI 注解）、Fiori elements 指引、权限/鉴权（CDS 角色、Auth 对象）、性能（DB hints、缓冲）、可扩展性（BAdI、云限制）。
- `specify.md`：要求输入（原程序标识、表、现有权限对象、UI 模式），确定 RAP BO 命名、数据模型、行为、服务绑定；输出迁移风险清单。
- `plan.md`：步骤化拆解（静态分析、CDS 建模、行为定义、服务投影/绑定、UI 注解、端到端测试），包含 RAP 编译与 UI5/Fiori 预览检查点。
- `implement.md`：强调保守改写（禁动态 SQL，强制 CDS 分析型注解，锁语义），并给出 ABAP 语句到 RAP 行为/动作的映射。
- `tasks.md` 与 `checklist.md`：覆盖权限、性能、i18n、离线/打印需求、迁移后验证（事务等价、批处理调度）。
- `constitution.md`：全局工作方式与护栏，宜保持跨类型一致，避免碎片化。

### 哪些命令需要按类型拆分？
- 强烈建议按类型拆分：`specify`、`plan`、`implement`、`tasks`、`checklist`、`analyze`。这些步骤依赖业务流形态、数据访问模式和 UI 形态，类型差异对输出影响大。
- 可保持全局共享或仅轻微差异：`constitution`（团队工作方式、质量护栏跨类型通用，避免碎片化）；`clarify`（核心澄清问题可以 80% 共享，可在各类型下追加专属问法，或在入口 prompt 中基于类型插入附加问题）。
- 折中做法：入口命令（如 `specify.md`）按类型拆分，但内部引用一组共享子段（如通用澄清问题、通用风险清单），减少维护成本；同理 `plan` 可将 70% 的步骤放共享片段，仅差异化步骤放类型目录。

## CLI 影响
- 方案 A：新增参数（`--kit abap`、`--dev-type <enum>`），映射到 `templates/abap-kit/dev-types/<type>/`，并更新帮助文案/README；模板尽量共享。
- 方案 B：无需改 CLI，只需新增名为 `abap-kit` 的同名命令集，入口 prompt 路由到 `dev-types/<type>/<command>.md`，并指示模型先判定类型。
- 两种方案都需要新增文档，说明支持的类型、示例输入输出、如何再生 prompts。

## 推荐
- 生产优先选择方案 A：确定性强、文档清晰、易测试。方案 B 可作为实验路径提供路由 prompt，但需提示误判风险。

## 方案 B 入口路由 Prompt（示例草案，直接复用命令名）
**用途**：每个命令都需要单独文件供 agent 识别，入口文件放在 `templates/abap-kit/command/<命令>.md`（如 `specify.md`）。文件内容要求模型先判定类型，再加载 `templates/abap-kit/command/dev-types/` 下的对应命令文件。

```markdown
---
description: "ABAP→RAP/Fiori 路由入口"
---

你是一名 ABAP 现代化顾问，先完成「开发类型判定」，再加载对应类型的命令文件：

1) 阅读输入的 ABAP 代码/需求，判定开发类型（仅选其一）：
   - transactional-dialog
   - report-alv
   - rfc-api
   - batch-job
   - enhancement
   - forms
   若无法确定，要求用户补充信息并列出所需信号。

2) 根据当前命令名（specify/plan/clarify/implement/tasks/checklist/analyze/constitution），从 `command/dev-types/<类型>/<命令>.md` 加载角色指导，再继续执行。

3) 始终应用共享上下文：
   - `shared/glossary.md`、`shared/constraints.md`、`shared/checklist.md`
   - 约束：RAP 行为一致性、Fiori elements 注解、权限/CDS 角色、性能（避免动态 SQL、锁语义清晰）、可扩展性（BAdI/云限制）。

4) 输出格式需符合当前命令的期望（如 specify 输出规范、plan 输出计划、implement 输出具体改造步骤等）。
```

## 建议的后续行动
- 确定最终的类型列表与命名（小写、短横线）。
- 先写 shared 词汇/约束，并完成一个完整类型（如 transactional-dialog）作为样板。
- 决定是否暴露 CLI 参数 `--kit abap` + `--dev-type`（若选方案 A，需要更新 CLI 帮助与 README）。
- 在 `docs/` 补充用例：输入 ABAP，输出 RAP 工件 + Fiori 预览的端到端示例。
