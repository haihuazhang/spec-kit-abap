---
description: 根据可用的设计工件，将现有任务转换为该功能的可操作的、按依赖顺序排列的 GitHub 问题。
tools: ['github/github-mcp-server/issue_write']
---

## 用户输入

```text
$ARGUMENTS
```

你 **必须** 在继续之前考虑用户输入（如果不为空）。

## 大纲

1. 从仓库根目录运行 `.specify/scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks` 并解析 FEATURE_DIR 和 AVAILABLE_DOCS 列表。所有路径必须是绝对路径。对于参数中的单引号，如 "I'm Groot"，使用转义语法：例如 'I'\''m Groot'（或者如果可能，使用双引号："I'm Groot"）。
1. 从执行的脚本中，提取 **tasks** 的路径。
1. 通过运行以下命令获取 Git 远程：

```bash
git config --get remote.origin.url
```

## 仅当远程是 GITHUB URL 时才继续执行后续步骤

1. 对于列表中的每个任务，使用 GitHub MCP 服务器在代表 Git 远程的存储库中创建一个新问题。

## 在任何情况下都不要在不匹配远程 URL 的存储库中创建问题**
