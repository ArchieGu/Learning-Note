# Subscriptions

![Scope for a role assignment](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/scope-overview/rbac-scope-no-label.png)

Resources can be moved to another resource groups and subscriptions. However you'll need to make sure certain conditions are met based on that resource. 

You can also transfer subscriptions between different tenants. 

A single tenant can have multiple subscriptions.

Each subscription has **limits** or **quotas on the amount of resources you can create or use**. Organizations can use subscriptions to manage costs and the resources that are created by users, teams or projects.

**Management groups are created to help manage access, assign policy and compliance among multiple subscriptions.**

## Cost Management

Analyze costs and trends using ***Cost Analysis***.

***Coost Alerts*** can be generated to alert when a threshold you define is met

Apply ***Budgets*** to apply cost thresholds and limits to control your Azure spend.

***Recommendations*** display ways to control costs through identifying trends in your usage..

## Apply Tags

Tags are used to organize resources and management hierarchy. Each tag consists of a name and value pair. And in order to assign tags, you must have write access to Microsoft.Resources/tags.

***Tags are not inheritable.***

# Governance

## Management Groups

Management groups are used to efficiently manage access, policies and compliance. They provide a level of scope over subscriptions. Subscriptions within a group inherit policies applied to the group.

Each Azure Active Directory  has a single top-level group called the "Root". This group is built into the hierarchy to have all the management groups and subscriptions fold up into it. Root Management Group cannot be moved or deleted. Allows for **global policies** and **RBAC assignments at the directory level**. AD Global admin needs to elevate to **User Access Administrator role** of this root group initially. After elevating that access, then they can assign RBAC roles to other directory users or groups to manage the hierarchy.

## Azure Policy

Policy is used to create, assign and manage policies in Azure. It enforce rules to ensure your **resources remain compliant**. Focuses on resources properties for both new deployments and existing. **It does not apply remediations to resources that are not compliant**.

A **policy definition** is a rule. [Azure has build in rules]

An **assignment** is an application of an initiative or a policy to a specific scope.

An **initiative** is a collection of policy definitions.
