# Enable Change Management

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
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

## Instructions

### Configure Change Manager

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Change Manager**](https://console.aws.amazon.com/systems-manager/change-manager).
1. Choose **Set up Change Manager**.

    ![](/media/change-manager-set-up.png)

### Create a change template



### Create a change request



### Approve a change request



### Review the change request results


## Next Section

You have now completed the workshop **Episode 4: Automating Changes and Preventative Maintenance in an Enterprise Cloud Environment**!

Click the link below to go to the next section to tear down the resources created during the workshop.

[![](media/codify-runbooks.png)](/episode-01-step-02-codify-runbooks.md)