---
description: 从交互式或提供的原则输入创建或更新项目宪法，确保所有依赖模板保持同步。
handoffs: 
  - label: Build Specification
    agent: speckit.specify
    prompt: Implement the feature specification based on the updated constitution. I want to build...
---

## 用户输入

```text
$ARGUMENTS
```

你 **必须** 在继续之前考虑用户输入（如果不为空）。

## 大纲

你正在更新 `.specify/memory/constitution.md` 中的项目宪法。此文件是一个包含方括号中占位符标记（例如 `[PROJECT_NAME]`、`[PRINCIPLE_1_NAME]`）的模板。你的工作是 (a) 收集/推导具体值，(b) 精确填充模板，以及 (c) 在所有依赖工件中传播任何修订。

遵循此执行流程：

1. 加载 `.specify/memory/constitution.md` 中的现有宪法模板。
   - 识别形式为 `[ALL_CAPS_IDENTIFIER]` 的每个占位符标记。
   **重要**：用户可能需要比模板中使用的原则更少或更多的原则。如果指定了数字，请尊重它 - 遵循通用模板。你将相应地更新文档。

2. 收集/推导占位符的值：
   - 如果用户输入（对话）提供了值，请使用它。
   - 否则从现有的仓库上下文（README、文档、以前的宪法版本（如果嵌入））推断。
   - 对于治理日期：`RATIFICATION_DATE` 是最初通过日期（如果未知，询问或标记 TODO），如果进行了更改，`LAST_AMENDED_DATE` 是今天，否则保留以前的日期。
   - `CONSTITUTION_VERSION` 必须根据语义版本控制规则递增：
     - MAJOR：向后不兼容的治理/原则删除或重新定义。
     - MINOR：添加了新原则/部分或实质性扩展了指导。
     - PATCH：澄清、措辞、拼写错误修复、非语义细化。
   - 如果版本升级类型模棱两可，请在定稿前提出理由。

3. 起草更新的宪法内容：
   - 用具体文本替换每个占位符（除了项目选择尚未定义而故意保留的模板槽之外，不留括号标记——明确证明任何留下的合理性）。
   - 保留标题层次结构，一旦替换就可以删除注释，除非它们仍然增加澄清指导。
   - 确保每个原则部分：简洁的名称行，捕获不可协商规则的段落（或项目符号列表），如果不明显则明确理由。
   - 确保治理部分列出修订程序、版本控制策略和合规性审查预期。

4. 一致性传播检查清单（将先前的检查清单转换为活动验证）：
   - 阅读 `.specify/templates/plan-template.md` 并确保任何“宪法检查”或规则与更新的原则一致。
   - 阅读 `.specify/templates/spec-template.md` 以进行范围/需求对齐——如果宪法添加/删除了强制性部分或约束，则更新。
   - 阅读 `.specify/templates/tasks-template.md` 并确保任务分类反映新的或已删除的原则驱动的任务类型（例如，可观测性、版本控制、测试纪律）。
   - 阅读 `.specify/templates/commands/*.md` 中的每个命令文件（包括此文件），以验证在需要通用指导时没有保留过时的引用（如仅限 CLAUDE 的特定于代理的名称）。
   - 阅读任何运行时指导文档（例如，`README.md`、`docs/quickstart.md` 或特定于代理的指导文件（如果存在））。更新对已更改原则的引用。

5. 生成同步影响报告（更新后作为 HTML 注释预置在宪法文件顶部）：
   - 版本更改：旧 → 新
   - 修改的原则列表（如果重命名，旧标题 → 新标题）
   - 添加的部分
   - 删除的部分
   - 需要更新的模板（✅ 已更新 / ⚠ 待定）及文件路径
   - 如果有任何占位符故意推迟，则后续 TODO。

6. 最终输出前的验证：
   - 没有剩余的未解释的括号标记。
   - 版本行与报告匹配。
   - 日期 ISO 格式 YYYY-MM-DD。
   - 原则是声明性的、可测试的，并且没有模糊语言（“should” → 在适当的地方替换为 MUST/SHOULD 理由）。

7. 将完成的宪法写回 `.specify/memory/constitution.md`（覆盖）。

8. 向用户输出最终摘要，包括：
   - 新版本和升级理由。
   - 任何标记为手动跟进的文件。
   - 建议的提交消息（例如，`docs: amend constitution to vX.Y.Z (principle additions + governance update)`）。

格式和样式要求：

- 严格按照模板使用 Markdown 标题（不要降级/升级级别）。
- 换行长理由行以保持可读性（理想情况下 <100 个字符），但不要用尴尬的中断强制执行。
- 在部分之间保留一个空行。
- 避免尾随空格。

如果用户提供部分更新（例如，仅一个原则修订），仍执行验证和版本决策步骤。

如果缺少关键信息（例如，批准日期确实未知），插入 `TODO(<FIELD_NAME>): explanation` 并包含在同步影响报告的推迟项目下。

不要创建新模板；始终在现有的 `.specify/memory/constitution.md` 文件上操作。
