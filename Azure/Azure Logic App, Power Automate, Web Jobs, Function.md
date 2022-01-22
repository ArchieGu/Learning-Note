# 设计优先技术

## Azure Logic Apps

[Logic Apps](https://azure.microsoft.com/services/logic-apps/) is a service within Azure to automate, **orchestrate, and integrate disparate components of a distributed application**. By using the **design-first approach** in Logic Apps, you can draw out complex workflows that model complex business processes.

![Azure 门户中的逻辑应用工作流设计器的屏幕截图。](https://docs.microsoft.com/zh-cn/learn/modules/choose-azure-service-to-integrate-and-automate-business-processes/media/2-logic-apps-workflow-designer.png)

还可以使用代码来创建或者编辑workflow：

![Azure 门户中的逻辑应用代码编辑器的屏幕截图。](https://docs.microsoft.com/zh-cn/learn/modules/choose-azure-service-to-integrate-and-automate-business-processes/media/2-logic-apps-code-editor.png)

Azure Logic Apps是四种技术中唯一一种面向开发者提供设计优先方法的技术。如果需要自定义连接器，例如通过REST API进行操作等，这就属于开发者的任务，最好选用Logic App完成。

## Power Automate

Microsoft [Power Automate](https://flow.microsoft.com/) is a service to create workflows even when you have no development or IT Pro experience. You can create workflows that integrate and orchestrate many different components by using the website or the Microsoft [Power Automate mobile app](https://flow.microsoft.com/mobile/download/).

Microsoft Power Automate 提供了易于使用的设计图面以创建上述类型的流。设计人员可以轻松设计流程并对其进行布局。实质上，Microsoft Power Automate 构建在逻辑应用的基础之上。

![Microsoft Power Automate 设计器的屏幕截图，其中显示了带有文件触发器的工作流、用于获取用户配置文件的 Office 操作以及用于发送电子邮件的 Outlook 操作。](https://docs.microsoft.com/zh-cn/learn/modules/choose-azure-service-to-integrate-and-automate-business-processes/media/2-flow-designer.png)

|                      | Power Automate         | Logic Apps                                                 |
| -------------------- | ---------------------- | ---------------------------------------------------------- |
| 预期用户             | 工作人员和业务分析师   | 开发者和IT专业人员                                         |
| 预期方案             | 自助式服务工作流的创建 | 高级项目集成                                               |
| 设计工具             | 仅GUI                  | 浏览器和Visual Studio Designer. 允许使用代码               |
| 应用程序生命周期管理 | 测试和生产环境         | Logic Apps的源代码可以包含在Azure Devops和源代码管理系统中 |

# 代码优先技术

The developers on your team will likely prefer to write code when they want to **orchestrate and integrate** different business applications into a single workflow.

## Azure WebJobs

The [Azure App Service](https://azure.microsoft.com/services/app-service/) is a cloud-based hosting service for web applications, mobile back-ends, and RESTful APIs. These applications often need to perform some kind of background task. 

WebJobs是唯一允许开发者控制重试策略的技术。没有必要将WebJobs编写为现有Azure应用服务程序的一部分，因为需要单独管理代码【为托管job的整个VM或者服务计划付费】。

何时选用WebJobs:

1. 有一个现有的Azure App，并且希望在App中模拟workflow，将workflow作为应用程序的一部分进行管理（Azure DevOps中）
2. 对Azure Functions不支持的`JobHost`进行特定的自定义。例如，在 WebJob 中，可以创建用于调用外部系统的自定义重试策略。 无法在 Azure Function 中配置此类策略。
3. Webjobs 仅在 Microsoft Windows 上支持 C#。

## Azure Functions

An [Azure Function](https://azure.microsoft.com/services/functions/) is a simple way for you to run small pieces of code in the cloud, without having to worry about the infrastructure required to host that code. Azure能够根据用户的需求自动缩放Functions. Azure Functions 可以与 Azure 中的以及来自第三方的多种不同服务集成。 这些服务可以触发函数，或将数据输入发送到函数中或接收来自函数的数据输出。

|                             | Azure WebJobs                 | Azure Functions                     |
| --------------------------- | ----------------------------- | ----------------------------------- |
| 支持的语言                  | C#（如果使用 WebJobs SDK）    | C#、Java、JavaScript、PowerShell 等 |
| 自动缩放                    | 否                            | 是                                  |
| 在浏览器中开发和测试        | 否                            | 是                                  |
| 按使用付费定价              | 否                            | 是                                  |
| 与逻辑应用集成              | 否                            | 是                                  |
| 包管理器                    | NuGet（如果使用 WebJobs SDK） | NuGet 和 NPM                        |
| 可以属于应用服务应用程序    | 是                            | 是（根据应用服务计划托管）          |
| 提供对 `JobHost` 的密切控制 | 是                            | 否                                  |
