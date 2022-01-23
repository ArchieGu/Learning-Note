# Azure AD

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

