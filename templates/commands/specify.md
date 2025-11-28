---
description: 从自然语言功能描述创建或更新功能规格。
handoffs: 
  - label: Build Technical Plan
    agent: speckit.plan
    prompt: Create a plan for the spec. I am building with...
  - label: Clarify Spec Requirements
    agent: speckit.clarify
    prompt: Clarify specification requirements
    send: true
---

## 用户输入

```text
$ARGUMENTS
```

你 **必须** 在继续之前考虑用户输入（如果不为空）。

## 大纲

用户在触发消息中的 `/speckit.specify` 之后键入的文本 **就是** 需求描述。假设即使 `$ARGUMENTS` 字面上出现在下方，你也可以在此对话中始终获得它。除非用户提供了空命令，否则不要要求用户重复它。

鉴于该功能描述，请执行以下操作：

1. 为分支 **生成简洁的短名称**（2-4 个词）：
   - 分析功能描述并提取最有意义的关键字
   - 创建一个 2-4 个词的短名称，捕捉功能的本质
   - 尽可能使用动作-名词格式（例如，“add-user-auth”、“fix-payment-bug”）
   - 保留技术术语和首字母缩略词（OAuth2、API、JWT 等）
   - 保持简洁但具有描述性，以便一目了然地理解功能
   - 示例：
     - “I want to add user authentication” → “user-auth”
     - “Implement OAuth2 integration for the API” → “oauth2-api-integration”
     - “Create a dashboard for analytics” → “analytics-dashboard”
     - “Fix payment processing timeout bug” → “fix-payment-timeout”

2. **在创建新分支之前检查现有分支**：

   a. 首先，获取所有远程分支以确保我们拥有最新信息：

      ```bash
      git fetch --all --prune
      ```

   b. 查找短名称在所有源中的最高功能编号：
      - 远程分支：`git ls-remote --heads origin | grep -E 'refs/heads/[0-9]+-<short-name>$'`
      - 本地分支：`git branch | grep -E '^[* ]*[0-9]+-<short-name>$'`
      - 规格目录：检查匹配 `specs/[0-9]+-<short-name>` 的目录

   c. 确定下一个可用编号：
      - 从所有三个源中提取所有编号
      - 找到最高编号 N
      - 使用 N+1 作为新分支编号

   d. 使用计算出的编号和短名称运行脚本 `.specify/scripts/powershell/create-new-feature.ps1 -Json "$ARGUMENTS"`：
      - 传递 `--number N+1` 和 `--short-name "your-short-name"` 以及功能描述
      - Bash 示例：`.specify/scripts/powershell/create-new-feature.ps1 -Json "$ARGUMENTS" --json --number 5 --short-name "user-auth" "Add user authentication"`
      - PowerShell 示例：`.specify/scripts/powershell/create-new-feature.ps1 -Json "$ARGUMENTS" -Json -Number 5 -ShortName "user-auth" "Add user authentication"`

   **重要**：
   - 检查所有三个源（远程分支、本地分支、规格目录）以找到最高编号
   - 仅匹配具有确切短名称模式的分支/目录
   - 如果未找到具有此短名称的现有分支/目录，则从编号 1 开始
   - 每个功能只能运行此脚本一次
   - JSON 作为输出在终端中提供 - 始终参考它以获取你要查找的实际内容
   - JSON 输出将包含 BRANCH_NAME 和 SPEC_FILE 路径
   - 对于参数中的单引号，如 "I'm Groot"，使用转义语法：例如 'I'\''m Groot'（或者如果可能，使用双引号："I'm Groot"）

3. 加载 `.specify/templates/spec-template.md` 以了解所需部分。

4. 遵循此执行流程：

    1. 从输入解析用户描述
       如果为空：错误“未提供功能描述”
    2. 从描述中提取关键概念
       识别：参与者、动作、数据、约束
    3. 参考 `.specify/templates/spec-template.md` 来生成需求文档
    4. 填写用户场景
       如果没有清晰的用户流程：错误“无法确定用户场景”
    5. 生成功能需求
       每个需求必须是可测试的
    6. 返回：成功（规格已准备好进行规划）

5. 使用模板结构将规格写入 SPEC_FILE，用从功能描述（参数）派生的具体细节替换占位符，同时保留部分顺序和标题。

6. 报告完成，包括分支名称、规格文件路径、检查清单结果以及下一阶段（`/speckit.clarify` 或 `/speckit.plan`）的准备情况。

**注意：** 该脚本在写入之前创建并检出新分支并初始化规格文件。

## 通用指南

## 快速指南

- 专注于用户需要 **什么** 以及 **为什么**。
- 避免 **如何** 实施（没有技术栈、API、代码结构）。
- 为业务利益相关者编写，而不是开发人员。
- 不要创建任何嵌入在规格中的检查清单。那将是一个单独的命令。

### 部分要求

- **强制性部分**：必须为每个功能完成
- **可选部分**：仅在与功能相关时包括
- 当某个部分不适用时，将其完全删除（不要保留为“N/A”）

### 对于 AI 生成

当从用户提示创建此规格时：

1. **不要额外添加需求**：仅根据用户需求解析目标程序中的所有细节逻辑
2. **避免幻觉**：如果用户未指定某些内容，则不要假设或添加它
3. **标注差异**：对于传统ABAP程序中的功能在切换到RAP中不可用的情况，请进行标注，不需要在RAP中完全复刻实现
4. **不需要添加测试环节**：由于SAP应用的封闭性，无法在本地环境进行测试，所以不需要测试环节
5. **不要自行判断实现方式**：不要自定判断实现方式和路线，采用哪种实施路线将在后续流程中根据constitution中的宪法来判定
