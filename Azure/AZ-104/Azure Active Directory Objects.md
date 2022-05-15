# Azure AD Objects

## Azure AD user types

Azure Active Directory is the identity service used in Microsoft cloud platform. There are 3 types of AAD user types:

1. Cloud identities:
   1. Local Azure AD (create in cloud)
   2. External Azure AD (user account is defined in another AAD instance) [**Azure AD tenant** refers to **an individual instance of the Azure AD directory**. And a business can have one or more Azure AD tenants.]
2. Hybrid identities: Directory-synchronized (have local Active Directory Domain Services domains on-premises and you want to reuse those accounts on cloud)
3. Guest identities:
   1. Azure AD B2B Collaboration ( invite a external user into your Azure AD directory as a guest user)
   2. External identities

### Azure AD B2B Collaboration

Before B2B collaboration service, everybody coming in had to be a Microsoft account, because Microsoft needs an authentication context for every user that's coming into your directory from outside. But with Direct federation and Google federation, people can come in directly with a trust relationship between your Azure AD tenant and Google (and some others). Like Microsoft trusts what Google has authenticated.

All this workflows (OTP and google federation) help customers overcome the barrier of having to have a personal Microsoft account to come in as a guest.

![Screenshot showing the redemption flow diagram](https://docs.microsoft.com/en-us/azure/active-directory/external-identities/media/redemption-experience/invitation-redemption-flow.png)

## Azure AD Groups

You can use groups in local AD to organize your users and to make authorization easier. You can assign permissions to the groups once instead of may times individually.

### Security Group

Security group is used for resource access, application access, etc.

### Microsoft 364 Group

Microsoft 365 Groups is a service that works with the Microsoft 365 tools you use already so you can collaborate with your teammates when writing documents, creating spreadsheets, working on project plans, scheduling meetings, or sending email.

### Group concepts

1. Owner: delegate group ownership to somebody and he will be in charge with populating the group
2. Two memberships:
   1. Assigned membership: you have an owner and he would manually add users, subtract users to the group
   2. Dynamic membership: **Azure AD controls group membership**. You write expressions based on Azure  AD user properties, and if the user's property matches , they will be automatically added to the group. In dynamic membership, owners will not be able to populate the group, but they can change the dynamic rule, add / remove licenses
3. Group-assigned licenses and roles

## Administrative Unit

An administrative unit is an Azure AD resource that can be **a container for other Azure AD resources**. An administrative unit can **contain only users and groups.**

***Logically organize your Azure AD users and groups.***

***Delegate administrative permissions:***

- Password resets
- Enforce least-privilege administration (without AU all changes can be tenant scope)

## Administer Azure AD Devices

Devices: A computer system that can register with or join Azure AD and be managed with Azure MDM tools. [MDM: Mobile Device Management. Organization-owned device that supports Azure AD device sign-in]

BYOD: Bring Your Own Device. Devices don't belong to your organization but also need you to protect its data.

### Azure AD Register VS Join

Registered: **Personally owned device**; with Microsoft Account  or local account sign-in (apple account or google account etc.) **[Lighter touch, a personally-owned device, but you want to give the user the ability to use their Azure AD credentials to get single sign-on (SSO) to corporate data and Azure protected data]**

Join: **Organization owned-device**; with Azure AD sign-in;

Hybrid Azure AD join: (you have local AD domain services and use Azure AD Connect to synchronize identities from your local AD into Azure AD.) Organization-owned device;  AD DS sign in with cloud identity (AADC)

### Azure AD Device Management

For AAD-Joined Devices:

1. SSO to SaaS apps and Azure services
2. Enterprise State Roaming
3. Windows Hello
4. Conditional Access policy

***Microsoft Intune:***  Like a portable app store where you can use SSO to get access

Part of the Microsoft Endpoint Manager product family:

- System Center Configuration Manager:
  - Desktop Analytics
- Windows Autopilot

Covers MDM and MAM scenarios

## Configure Azure AD Resources

### Self-service Password Reset and Azure MFA  (at least Premium 1 license)

### Conditional Access (Premium 2 license)

### Manage Multiple Directories

We have **one-to-one trust** between individual Azure subscriptions and an Azure AD tenant, but we can also **consolidate** **n number of your Azure subscriptions** and have them all trust the same Azure AD tenant, and that unlocks the possibility of consistent governance.

![An example organization with multiple subscriptions all using the same Azure AD tenant.](https://docs.microsoft.com/en-us/microsoft-365/media/subscriptions/subscriptions-fig3.png?view=o365-worldwide)

## Manage Role-Based Access Control

Role-based access control can be used to assign permissions to: users, Groups, Applications

The scope of role assignment can be: Subscription (The assignment will be inherited to all child resources ), Resource Group; Single resource.

### **Security Principals:**

Users who has a profile in Azure AD, can be assigned to users in other tenants.

Multiple users are assigned to a group, roles assigned to group impact all the users.

A ***service principal*** is a security ID for applications or services

A ***managed identity*** is typically used in developing cloud applications to handle credential management

### ***Roles:***

Owner: full access to all resources and grant access

Contributor (to the resource itself not the data it contains): can create/manage all resources, cannot grant access

Reader: can view existing resources

User Access Administrator: manage user access

### Deny Assignments

Block users from performing specific actions even if a role assignment allows it

Created and managed in Azure to protect resources

Can only be created using Azure Blue Prints or managed apps

### RBAC Scope

Inherited:

![Scope for a role assignment](https://docs.microsoft.com/en-us/azure/role-based-access-control/media/scope-overview/rbac-scope-no-label.png)

### Create a Custom Role

```powershell
$role = Get-AzRoleDefinition "Virtual Machine Contributor"
$role.Id = $null
$role.Name = "Virtual Machine Operator"
$role.Description = "Can monitor and restart virtual machines."
$role.Actions.Clear()
$role.Actions.Add("Microsoft.Storage/*/read")
$role.Actions.Add("Microsoft.Network/*/read")
$role.Actions.Add("Microsoft.Compute/*/read")
$role.Actions.Add("Microsoft.Compute/virtualMachines/start/action")
$role.Actions.Add("Microsoft.Compute/virtualMachines/restart/action")
$role.Actions.Add("Microsoft.Authorization/*/read")
$role.Actions.Add("Microsoft.ResourceHealth/availabilityStatuses/read")
$role.Actions.Add("Microsoft.Resources/subscriptions/resourceGroups/read")
$role.Actions.Add("Microsoft.Insights/alertRules/*")
$role.Actions.Add("Microsoft.Support/*")
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/00000000-0000-0000-0000-000000000000")
$role.AssignableScopes.Add("/subscriptions/11111111-1111-1111-1111-111111111111")
New-AzRoleDefinition -Role $role
```

