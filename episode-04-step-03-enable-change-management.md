# Enable Change Management

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
    - [Terminology](#terminology)
- [Instructions](#instructions)
    - [Configure Change Manager](#configure-change-manager)
    - [Create a change template](#create-a-change-template)
    - [Create a change request](#create-a-change-request)
    - [Approve a change request](#approve-a-change-request)
    - [Review the change request results](#review-the-change-request-results)
- [Next Section](#next-section)

## Summary

In this section you will enable [AWS Systems Manager Change Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/change-manager.html), create a change template, create a change request, approve a change request, and review the results of a change request.

:exclamation: **Important**: For the purpose of this workshop, you will set up Change Manager for a local account. Outside of the workshop, if you use AWS Organizations, you can configure Change Manager to manage changes across multiple AWS accounts and across AWS Regions using a single *delegated administrator* account.

Using Change Manager has two primary advantages. First, it can improve the safety of changes made to application configurations and infrastructures, reducing the risk of service disruptions. It makes operational changes safer by tracking that only approved changes are being implemented. Secondly, it is tightly integrated with other AWS services, such as [WS Organizations](https://aws.amazon.com/organizations/) and [AWS Single Sign-On](https://aws.amazon.com/single-sign-on/), or the integration with the [Systems Manager Change Calendar](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-change-calendar.html) and [Amazon CloudWatch alarms](https://aws.amazon.com/cloudwatch/).

Change Manager provides accountability with a consistent way to report and audit changes made across your organization, their intent, and who approved and implemented them.

### Terminology

**Change Template**: 

Every **change request** is created from a **change template**. Templates define common parameters for all change requests based on them, such as the change request approvers, the actions to perform, or the SNS topic to send notifications of progress. You can enforce the review and approval of templates before they can be used. It makes sense to create multiple templates to handle different type of changes. For example, you can create one template for standard changes, and one for emergency changes that overrides the change calendar. Or you can create different templates for different types of automation run books (documents).

**Emergency change templates**

An **emergency change template** is used for situations when a change must be made even if changes are otherwise blocked by an event in the calendar in use by AWS Systems Manager Change Calendar. Change requests created from an emergency change template must still be approved by its designated approvers, but the requested changes can still run even when the calendar is blocked.

**Change request**

A **change request** is a request in Change Manager to run an Automation runbook that updates one or more resources in your AWS or on-premises environments. A **change request** is created using a change template. 

## Instructions

### Create IAM user for template reviews and change request approval

First, we will create an Identity and Access Management (IAM) user that will act as our change template reviewer and change request approver.

1. Open the AWS IAM console at https://console.aws.amazon.com/iam/
1. In the navigation pane, choose **Users**
1. Choose **Add user**
1. In the **Set user details** section, enter ```approval-user```
1. In the **Select AWS access type** section, choose **AWS Management Console access** 
1. For **Console password**, choose **Custom password** and enter a password
1. For **Require password reset**, deselect **User must create a new password at next sign-in** and choose **Next: Permissions**

    ![](/media/iam-add-user.png)

1. In the **Set permissions** section, choose **Attach existing policies directly**
1. In the search bar, enter ```AmazonSSMFullAccess```, select **AmazonSSMFullAccess** from the results list, and choose **Next: Tags**
1. Skip adding tags and select **Next: Review**
1. Choose **Create user**
1. On the resulting screen, copy the AWS Management console sign-in URL to Notepad for use later in the lab

    ![](/media/iam-console-link.png)
    
#### Task 2: Create an IAM service role for Automation

Next we must create an IAM service role, or *assume role*, that allows the service to perform actions on your behalf during the change operation.

1. Open the AWS IAM console at https://console.aws.amazon.com/iam/
1. In the navigation pane, choose **Roles**
1. Choose **Create role**
1. For **Select type of trusted entity**, leave the default value **AWS service**
1. For **Choose a use case**, select **Systems Manager** in the section **Or select a service to view its use cases**
1. For **Select your use case**, choose **Systems Manager** and choose **Next: Permissions**
1. For **Attach permissions policies**, enter ```AmazonSSMAutomationRole``` in the search field, choose **AmazonSSMAutomationRole**, and choose **Next: Tags**
1. Skip adding tags and choose **Next: Review**
1. For **Role name**, enter ```change-manager-automation-role```, and choose **Create role**

#### Task 3: Configuring Change Manager user identity management and template reviewers

Perform the task in this procedure the first time you access Change Manager. You can update these configuration settings later by returning to Change Manager and choosing **Edit** on the **Settings** tab. 

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/
1. In the navigation pane, choose **Change Manager**.
1. On the service home page, choose **Set up delegated account**
1. For **User identity management**, choose **AWS Identity and Access Management (IAM)
1. For **Template reviewer notification**, choose **Create an Amazon SNS topic**, enter ```sm-workshop-sns``` for the topic name, and choose **Add notification**

    ![](../media/change-manager-sns.png)

1. For **Template reviewers** select **Add**, choose the **approval-user** we created previously, and select **Add approvers**

#### Task 4: Configuring Change Manager change freeze event approvers and best practices

1. For **Approvers for change freeze events** select **Add**, choose the **approval-user** we created previously, and choose **Add approvers**
1. In the **Best practices** section, do the following:

    - For **Check Change Calendar for restricted change events**, choose **Enabled**
    - For **SNS topic for approvers for closed events**, select **Create an Amazon SNS topic**, enter ```sm-workshop-sns```, and choose **Add notification**
    - Leave **Require monitors for all templates** as the default non-enabled state. **Note** In a real world environment, you can ensure that all templates for your organization specify an Amazon CloudWatch alarm to monitor your change operation
    - For **Require template review and approval before**, choose **Enabled**

1. Choose **Submit**

### Configure Change Manager

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Change Manager**](https://console.aws.amazon.com/systems-manager/change-manager).
1. Choose **Set up Change Manager**.

    ![](/media/change-manager-set-up.png)
    
1. Choose the **Settings** tab.
1. Choose **Edit** and perform the following actions:
    
    - In the **User identity management** section, choose **AWS Identity and Access Management (IAM)**.
    - Skip the sections **Template reviewer notification**, **Template reviewers**, and **Approvers for change freeze events**.
        - **Note**: In a real-world environment, it is best practice to specify template reviewers and approvers for change freeze events.
    - In the **Best practices** section, review the available options to enable or disable.
        - To specify that Change Manager checks a calendar in Change Calendar to make sure changes are not blocked by scheduled events, you would select the Enabled check box for **Check Change Calendar for restricted change events**, and then select the calendar to check for restricted events from the Change Calendar list. 
        - If you want to ensure that all templates for your organization or account specify an Amazon CloudWatch alarm to monitor your change operation, you would select the Enabled check box for **Require monitors for all templates**. 
        - To ensure that no change requests are created, and no runbook workflows run, without being based on a template that has been reviewed and approved, you would select the Enabled check box for **Require template review and approval before use**.
    - Ensure **Require template review and approval before use** is not enabled.
    
    ![](/media/review-template-disabled.png)

1. Choose **Save**.

### Create a change template

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose **Change Manager**.
1. Choose **Create template**.
1. For **Name**, enter ```RestartEC2InstanceTemplate```.
1. For **Description**, optionally enter a description such as, ```This is an example template to restart an EC2 instance```.
1. For **Change template type**, leave the default option as **Standard change template**.
1. For **Runbook options**, leave the default option as **Select a single runbook**.
1. For **Runbook**, select ```AWS-RestartEC2Instance``` from the drop-down menu.
1. Leave the default content for **Template information**.
1. For **Change request approvals**, select **Add approvers** under **First-level approvals**, and select **Request specified approvers**.
1. For **Amazon SNS topic for approval notifications**, choose **Create an Amazon SNS topic**, enter ```ssm-workshop-sns``` for the name, and choose **Add notification**.
1. Skip the **Monitoring** section.
1. For **Notifications**, choose **Enter an SNS Amazon Resource Name (ARN)**, enter the ARN of the SNS topic created for the approval notification, and choose **Add notification**.
    
    - The SNS Topic ARN should be similar to the following: ```arn:aws:sns:us-east-1:1234567890:ssm-workshop-sns```.

1. Select **Save and preview**.

    ![](/media/change-create-template.png)
    
1. Select **Submit for review**.
1. (Optionally) Choose the **Templates** tab, choose the **RestartEC2InstanceTemplate** template, and choose **View details**. You can then navigate between the various tabs to review the template details, tasks included, change requests created using the template, and the version history of the template.

### Create a change request

1. Choose **Create request**.
1. For **Select change template**, choose ```RestartEC2InstanceTemplate``` and choose **Next**.
1. For **Name**, enter ```RestartEC2Instance```.
1. Optionally fill out the **Change request information** section.
1. For **Workflow start time**, leave the default **Run the operation as soon as possible after approval**.
1. For **Change request approvals**, choose **Add approver**, select the current IAM user or role you are logged in with, and choose **Add approvers**.
1. Choose **Next**.

    ![](/media/change-manager-change-details.png)

1. For **Automation assume role**, choose the **AWS-SystemsManager-AutomationExecutionRole** created previously.
1. For **Deployment location**, leave the default value as **Apply change to this account**.
1. For **Deployment targets**, perform the following steps:
    - For **Target resources**, choose **Multiple resources**.
    - For **Parameter**, chose **InstanceId**.
    - For **Specify resources**, choose **Choose a resource group**.
    - Choose **ManagedInstances** from the search field.
1. Choose **Next**.

    ![](/media/change-manager-change-parameters.png)

1. On the **Review and submit** page, review the change request details and choose **Submit for approval**.

### Approve a change request



### Review the change request results


## Next Section

You have now completed the workshop **Episode 4: Automating Changes and Preventative Maintenance in an Enterprise Cloud Environment**!

Click the link below to go to the next section to tear down the resources created during the workshop.

[![](media/codify-runbooks.png)](/episode-01-step-02-codify-runbooks.md)