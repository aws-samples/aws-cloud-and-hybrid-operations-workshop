# Enabling AWS Config

![](media/config-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Deploy AWS Config Prerequisites](#deploy-aws-config-prerequisites)
    - [Enable AWS Config](#enable-aws-config)
- [Next Section](#next-section)

## Summary

In this section you will (1) enable AWS Config to monitor and record your AWS resource configurations.

Prior to enabling these features, you will create several IAM Roles, Policies and a S3 bucket needed for AWS Config Conformance Packs and Autoremdiation. [AWS CloudFormation](https://aws.amazon.com/cloudformation/). AWS CloudFormation gives you an easy way to model a collection of related AWS and third-party resources, provision them quickly and consistently, and manage them throughout their lifecycles, by treating infrastructure as code.

## Instructions

### Deploy AWS Config Prerequisites

**To save the CloudFormation template locally**
    
1. Open the CloudFormation template [workshop-config-prerequisites.yml](cfntemplates/workshop-config-prerequisites.yml).
1. Choose **Raw**.

    ![](/media/github-raw.png)

1. Open Notepad and copy the entire text.
1. Save the file to your local machine as ```workshop-config-prerequisites.yml```.

The CloudFormation template will create the resources depicted in the diagram below.

![](/media/cloudformation-stack-ep02.png)

**To deploy Cloudformation template for AWS Config Prerequisites**
    
1. Open the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/home).
1. Choose **Create stack**.
1. For **Specify template**, choose **Upload a template file**, choose the file you saved locally ```workshop-config-prerequisites.yml```, and choose **Next**.

    ![](/media/cloudformation-create-stack-ep02.png)

1. For **Stack name**, enter ```workshop-config-prerequisites```, and choose **Next**.
1. On the **Configure stack options** page, leave the defaults and choose **Next**.
1. On the **Review** page, check the box **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** and choose **Create stack**.


CloudFormation will begin provisioning the resources specified within the CloudFormation template and once complete, you will have a two S3 Bucket with a S3 Bucket Policy, and some IAM Roles that we will be using together with AWS Config for Autoremediation. You can also use the refresh button to see the latest events related to the CloudFormation stack. Once the status of the CloudFormation stack changes to ```CREATE_COMPLETE```, you can proceed with the next steps. This process should complete within 5 minutes.

### Enable AWS Config

AWS Config is a service that enables you to assess, audit, and evaluate the configurations of your AWS resources. Config continuously monitors and records your AWS resource configurations and allows you to automate the evaluation of recorded configurations against desired configurations. With Config, you can review changes in configurations and relationships between AWS resources, dive into detailed resource configuration histories, and determine your overall compliance against the configurations specified in your internal guidelines. This enables you to simplify compliance auditing, security analysis, change management, and operational troubleshooting.

**To enable AWS Config using General Setup**

1. Search for the Config Service under the Management Tools Section in the console, and then click on Config.
1.	Click on Get started, and we will follow the setup wizard.

    ![](/media/config-gettingstarted-ep02.png)

1.	On the Settings page make the following selections

    ![](/media/config-settings-ep02.png)

    - Record all resources in this region
    - Include global resources
    - Create AWS Config service-linked role
    - Create a bucket (and accept the default bucket name)
1.	Click Next on the next screen, bypassing rule selection. We will setup Config rules in the next steps.
1.	On the last screen click on Confirm.

## Next Section

Click the link below to go to the next section.

[![](media/config-rule.png)](/operational_excellence/episode-02-step-02-config-rule.md)
