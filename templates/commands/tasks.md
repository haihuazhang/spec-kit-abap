---
description: 根据可用的设计工件为功能生成可操作的、按依赖顺序排列的 tasks.md。
handoffs: 
  - label: Analyze For Consistency
    agent: speckit.analyze
    prompt: Run a project analysis for consistency
    send: true
  - label: Implement Project
    agent: speckit.implement
    prompt: Start the implementation in phases
    send: true
---

## 用户输入

```text
$ARGUMENTS
```

你 **必须** 在继续之前考虑用户输入（如果不为空）。

## 大纲

1. **设置**：从仓库根目录运行 `.specify/scripts/powershell/check-prerequisites.ps1 -Json` 并解析 FEATURE_DIR 和 AVAILABLE_DOCS 列表。所有路径必须是绝对路径。对于参数中的单引号，如 "I'm Groot"，使用转义语法：例如 'I'\''m Groot'（或者如果可能，使用双引号："I'm Groot"）。

2. **加载设计文档**：从 FEATURE_DIR 读取：
   - **必需**：plan.md（项目结构，实施路线，详细的实现步骤），spec.md（完整的用户需求）
   - 注意：并非所有项目都有所有文档。根据可用内容生成任务。

3. **执行任务生成工作流**：
   - 加载 plan.md 并提取项目结构，实施路线，详细实现步骤和内容
   - 加载 spec.md 并提取用户需求
   - 按用户需求结合项目计划组织生成任务（见下面的任务生成规则）
   - 生成完成用户需求所需要的任务顺序的依赖图
   - 验证任务完整性（用户需求中的每个需求都需要实现）

4. **生成 tasks.md**：使用 `.specify.specify/templates/tasks-template.md` 作为结构，填充：
   - 来自 plan.md 的正确实施任务名称
   - 按照 plan.md 中的计划步骤分别生成对应的子任务
   - 最终阶段：完善和横切关注点
   - 所有任务必须遵循严格的检查清单格式（见下面的任务生成规则）
   - 每个任务的清晰文件路径

5. **报告**：输出生成的 tasks.md 的路径和摘要：
   - 总任务数
   - 格式验证：确认所有任务遵循检查清单格式（复选框、ID、标签、文件路径）

任务生成的上下文：$ARGUMENTS

tasks.md 应该是可立即执行的 - 每个任务必须足够具体，以便 LLM 可以在没有额外上下文的情况下完成它。

## 任务生成规则

**关键**：任务必须按计划中的实现步骤拆分，以实现独立实施。

### 检查清单格式（必需）

每个任务必须严格遵循此格式：

```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**格式组件**：

1. **复选框**：始终以 `- [ ]`（markdown 复选框）开头
2. **任务 ID**：按执行顺序的序列号（T001、T002、T003...）
3. **描述**：带有确切文件路径的清晰检查结果

**示例**：

- ✅ 正确：`- [ ] T001 Create view successful in src/service_definitions/zi_viewname`
- ❌ 错误：`- [ ] Create User model`（缺少 ID）
- ❌ 错误：`T001 [US1] Create model`（缺少复选框）
- ❌ 错误：`- [ ] [US1] Create User model`（缺少任务 ID）
- ❌ 错误：`- [ ] T001 [US1] Create model`（缺少文件路径）
