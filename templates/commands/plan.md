---
sdescription: 使用计划模板执行实施规划工作流以生成设计工件。
handoffs: 
  - label: Create Tasks
    agent: speckit.tasks
    prompt: Break the plan into tasks
    send: true
  - label: Create Checklist
    agent: speckit.checklist
    prompt: Create a checklist for the following domain...
---
## 用户输入

```text
$ARGUMENTS
```

你 **必须** 在继续之前考虑用户输入（如果不为空）。

## 大纲

1. **设置**：从仓库根目录运行 `.specify/scripts/powershell/setup-plan.ps1 -Json` 并解析 JSON 以获取 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。对于参数中的单引号，如 "I'm Groot"，使用转义语法：例如 'I'\''m Groot'（或者如果可能，使用双引号："I'm Groot"）。
2. **加载上下文**：阅读 FEATURE_SPEC 和 `.specify/memory/constitution.md`。加载 IMPL_PLAN 模板（已复制）。
3. **执行计划工作流**：遵循 IMPL_PLAN 模板中的结构以：

   - 实施计划
      - 填写摘要
      - 确定转换策略
      - 评估门槛（如果违规不合理，则报错）
      - 宪法检查
      - 确定项目结构
      - 根据转换策略输出对应的实施计划路线（仅保留需要部分）
   - 设计后重新评估宪法检查
4. **停止并报告**：命令在 IMPL_PLAN 规划后结束。报告分支、IMPL_PLAN 路径和生成的工件。

## 关键规则

1. 确保仅选择了一种实施路线，当选择了其中一种实施路线时，另一种实施路线不得包含在plan中。
2. 针对实施路线中的每个步骤，使用实际的需求和任务步骤来替换占位符文本。
3. 针对每一种实施路线中标注为 `(可选)` 部分的步骤，如果判定不需要实施，则删除此部分内容，不得包含在plan中。
4. 确保实际的plan中包含实际的任务步骤，模板中的描述性文本不得包含在最终的plan中。
