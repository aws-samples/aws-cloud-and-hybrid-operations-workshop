# Schedule and Automate Patching Operations

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

To go back to the previous section, click here: [Enabling Patch Management](/episode-04-step-01-enable-patch.md)

## Table of Contents

- [Summary](#summary)
    - [Running automations in multiple AWS regions and accounts](#running-automations-in-multiple-aws-regions-and-accounts)
- [Instructions](#instructions)
    - [View the custom Automation runbook](#view-the-custom-automation-runbook)
    - [Create a multi-account / multi-Region State Manager association](#create-a-multi-account--multi-region-state-manager-association)
    - [Manually apply the association](#manually-apply-the-association)
    - [Review the S3 bucket and Resource Data Sync contents](#review-the-s3-bucket-and-resource-data-sync-contents)
    - [Review patch compliance using Explorer](#review-patch-compliance-using-explorer)
- [Recap](#recap)
- [Next Section](#next-section)

## Summary

In this section you will use the multi-account / multi-Region functionality of Systems Manager Automation to perform patching operations. The patching operation is scheduled using a State Manager association which initiates a custom Automation runbook for patching. You will then review the information populated by the Resource Data Sync created in [Enabling Patch Management](/episode-04-step-01-enable-patch.md). Additionally, you will review Explorer to see a patch compliance dashboard.

### Running automations in multiple AWS regions and accounts

You can run AWS Systems Manager automations across multiple AWS Regions and AWS accounts or AWS Organizational Units (OUs) from an Automation management account. Running automations in multiple Regions and accounts or OUs reduces the time required to administer your AWS resources while enhancing the security of your computing environment. For example, you can centrally implement patching and security updates, remediate compliance drift on VPC configurations or S3 bucket policies, and manage resources, such as EC2 instances, at scale.

Running automations across multiple Regions and accounts or OUs works by leveraging two IAM roles. In the section [Enabling Patch Management](/episode-04-step-01-enable-patch.md), you created a CloudFormation stack which created the two IAM roles for Systems Manager Automation multi-account / multi-Region. The default names and their functions are as follows:

- **AWS-SystemsManager-AutomationAdministrationRole**: This role gives the user permission to run automations in multiple AWS accounts and OUs. 
- **AWS-SystemsManager-AutomationExecutionRole**: This role gives the service permission to run automations in the target account and OUs.

## Instructions

### View the custom Automation runbook

In the section [Enabling Patch Management](/episode-04-step-01-enable-patch.md), you created a CloudFormation stack which created a custom Automation runbook. The Automation runbook initiates a Run Command task for the document ```AWS-RunPatchBaseline``` and stores the command output an the S3 bucket.

**To view the custom Automation runbook**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Documents**](https://console.aws.amazon.com/systems-manager/documents).
1. Choose the tab **Owned by me**.
1. Choose the Automation runbook created the CloudFormation stack. **Note**: The Automation runbook is named similar to ```ssm-workshop-ep04-document-vgTzxXmhVB0c```.
1. On the **Description** tab, expand the section **Step 1: runPatchBaseline** to view details about the first step.
    
    - This step initiates a Run Command task for ```AWS-RunPatchBaseline``` and targets managed instances using a Resource Group. The command output details are then sent to the S3 bucket created by the CloudFormation template. The **OutputS3KeyPrefix** value leverages [Automation system variables](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-variables.html) to dynamically build the S3 key prefix during the workflow operation. This allows the command output logs to be segmented by account ID, region, and Automation execution ID.
    - **Important**: Managed instances in other accounts and Regions must have access to the S3 bucket specified in order to output the command logs centrally. The [S3 bucket policy](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-policies.html) and the [EC2 IAM instance profile role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html) must allow access. The ```PutObject``` and ```PutObjectAcl``` API calls are made by SSM Agent on the managed instance. For more information about the EC2 IAM instance profile role, see [Task 1: (Optional) Create a custom policy for S3 bucket access ](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-profile.html#instance-profile-custom-s3-policy).

### Create a multi-account / multi-Region State Manager association

Currently, creating multi-account and multi-Region State Manager associations are not supported in the AWS Management console, so instead you will use AWS CloudShell to create the association using the AWS CLI.

**To save the State Manager association configuration file locally**

1. Open the State Manager association configuration JSON at [association_configuration.json](misc/association_configuration.json).
1. Choose **Raw**.

    ![](/media/github-raw.png)

1. Open Notepad and copy the entire text.
1. In the copied text, perform the following steps:
    - Replace ```[DOCUMENT-NAME]``` with the name of the Automation runbook created in [Step 01: Enabling Patch Management](/episode-04-step-01-enable-patch.md).
    - Replace the two occurrences of ```[ACCOUNT-ID]``` with the AWS account ID that you are using; lines 05 and 25.

    ```
    {
        "Name": "[DOCUMENT-NAME]",
        "Parameters": {
            "AutomationAssumeRole": [
                "arn:aws:iam::[ACCOUNT-ID]:role/AWS-SystemsManager-AutomationAdministrationRole"
            ],
            "ResourceGroupName": [
                "ManagedInstances"
            ],
            "RebootOption": [
                "NoReboot"
            ],
            "Operation": [
                "Scan"
            ]
        },
        "ScheduleExpression": "cron(30 09 ? * * *)",
        "AssociationName": "SSMWorkshop-MultiAccountPatch",
        "ComplianceSeverity": "MEDIUM",
        "SyncCompliance": "AUTO",
        "ApplyOnlyAtCronInterval": true,
        "TargetLocations": [
            {
                "Accounts": [
                    "[ACCOUNT-ID]"
                ],
                "Regions": [
                    "us-east-1"
                ],
                "TargetLocationMaxConcurrency": "1",
                "TargetLocationMaxErrors": "1",
                "ExecutionRoleName": "AWS-SystemsManager-AutomationExecutionRole"
            }
        ]
    }
    ```
    
    - **Note**: You can click your IAM user name or role in the upper-right corner to see your AWS account ID.

    ![](/media/episode-03-account-id.png)

1. Save the file to your local machine as ```association_configuration.json```.

**To create the State Manager association using CloudShell**

From the AWS Management Console, you can launch AWS CloudShell by choosing the following options available on the navigation bar:

1. Choose the AWS CloudShell icon.
1. Start typing "cloudshell" in Search box and then choose the CloudShell option.

    ![](https://docs.aws.amazon.com/cloudshell/latest/userguide/images/launch_options.png)

1. Once the CloudShell session has been established, choose **Actions** and choose **Upload file**.

    ![](/media/episode-03-cloudshell-upload.png)
    
1. Choose **Select file**, navigate to the local ```association_configuration.json``` file you created, choose **Open**, and choose **Upload**.
    - **Note**: The ```association_configuration.json``` file will be uploaded to the directory ```/home/cloudshell-user```.

1. To create the State Manager association using the JSON configuration file, enter the following command:

    ```
    aws ssm create-association --cli-input-json file://association_configuration.json
    ```

1. To list the State Manager associations, enter the following command:

    ```
    aws ssm list-associations --association-filter-list key=AssociationName,value=SSMWorkshop-MultiAccountPatch
    ```
    
    - **Note**: The association will remain in a ```Pending``` status as the parameter ```ApplyOnlyAtCronInterval``` was specified as ```true```, meaning that the association will only be applied during the specified cron schedule ```cron(30 09 ? * * *)```.
    
:exclamation: **Important**: For the purpose of this workshop, the State Manager association only invokes an Automation workflow in the same account and region. Outside of the workshop, you can target other accounts and Regions by (1) creating the IAM role **AWS-SystemsManager-AutomationExecutionRole** in each target account and (2) updating the State Manager association configuration to specify the additional accounts and/or Regions. 

:exclamation: **Important**: To see an example State Manager association configuration which targets two accounts (123456789012, 987654321098) and two regions (us-east-1, us-east-2), expand the section below. You can also use AWS Organizational Unit (OU) IDs for targeting in-place of AWS account IDs.

<details>
<summary><b>Example multi-account and multi-Region State Manager association</b></summary><p>

```
{
    "Name": "[DOCUMENT-NAME]",
    "Parameters": {
        "AutomationAssumeRole": [
            "arn:aws:iam::[CENTRAL-ACCOUNT-ID]:role/AWS-SystemsManager-AutomationAdministrationRole"
        ],
        "ResourceGroupName": [
            "ManagedInstances"
        ],
        "RebootOption": [
            "NoReboot"
        ],
        "Operation": [
            "Scan"
        ]
    },
    "ScheduleExpression": "cron(30 09 ? * * *)",
    "AssociationName": "SSMWorkshop-MultiAccountPatch",
    "ComplianceSeverity": "MEDIUM",
    "SyncCompliance": "AUTO",
    "ApplyOnlyAtCronInterval": true,
    "TargetLocations": [
        {
            "Accounts": [
                "123456789012",
                "987654321098"
            ],
            "Regions": [
                "us-east-1",
                "us-east-2"
            ],
            "TargetLocationMaxConcurrency": "1",
            "TargetLocationMaxErrors": "1",
            "ExecutionRoleName": "AWS-SystemsManager-AutomationExecutionRole"
        }
    ]
}
```

</p></details>
    
### Manually apply the association

Rather than waiting for the association to be applied during the next cron interval, we will manually apply the association using the State Manager console.

**To manually apply the association**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**State Manager**](https://console.aws.amazon.com/systems-manager/state-manager).
1. Choose the association **SSMWorkshop-MultiAccountPatch**, choose **Apply association now**, and choose **Apply**.
1. Choose the **Execution history** tab.
1. Choose the most recent **Execution id**.
1. Choose **Output** to view the resulting Automation workflow.

    - You will then be brought to the Automation console where you can view the output of the Automation runbook.
    
    ![](/media/state-multi-account.png)

### Review the S3 bucket and Resource Data Sync contents

1. Open the Amazon S3 console at https://s3.console.aws.amazon.com/s3/home.
1. Choose the resource data sync S3 bucket named similarly to **ssm-resource-sync-us-east-1-123456789012**.
1. Choose the **inventory/** prefix.
1. Within the **inventory** prefix, you will find the data populated by the Resource Data Sync.

    ![](/media/resource-data-sync-contents.png)
    
    - **Note** If you have enabled [Systems Manager Inventory](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-inventory.html) then you will have additional data types stored.

1. (Optionally) Open one of the data types to see that the objects are further segmented by account ID, region, and resource type. Each managed instance has an individual JSON object stored which contains data pertaining to the specific data type.

    ![](/media/resource-data-sync-individual.png)
    
### Review patch compliance using Explorer

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Explorer**](https://console.aws.amazon.com/systems-manager/explorer).
1. Scroll through the console to the widget named **Non-compliant instances for patching** to view patch compliance for the current account and Region.

    - **Note**: If your test managed instances are not missing updates, then you should see zero non-compliant resources.
    
    ![](/media/state-explorer.png)
    
In a real-world environment, you can create a Resource Data Sync for Explorer which enables Explorer to aggregate data from multiple AWS Regions and accounts using the integration with AWS Organizations. After you set up and configure AWS Organizations, you can aggregate data in Explorer by organizational unit (OU) or for an entire organization.

The following diagram shows a resource data sync configured to work with AWS Organizations. In this scenario, the user has two accounts defined in AWS Organizations. Resource data sync aggregates data from both accounts and multiple AWS Regions into the AWS Organizations management account where it is then displayed in Explorer. 

![](https://docs.aws.amazon.com/systems-manager/latest/userguide/images/ExplorerSyncFromSource.png)

For more information, see [Setting up Systems Manager Explorer to display data from multiple accounts and Regions](https://docs.aws.amazon.com/systems-manager/latest/userguide/Explorer-resource-data-sync.html).

## Recap

In this section, you created a State Manager association to invoke a custom Automation runbook on a cron expression based schedule. The Automation runbook subsequently called the Command document ```AWS-RunPatchBaseline``` to perform a scan operation on the target managed instances. There are other options to schedule the multi-account and multi-Region patching operation, such as [Amazon EventBridge rules that trigger on a schedule](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-rule-schedule.html) and [Systems Manager Maintenance Windows](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-maintenance.html).

For a more detailed overview of centralizing operational management for inventory, patching, and compliance see the [AWS Management and Governance samples](https://github.com/aws-samples/aws-management-and-governance-samples) repository package [Operational Management: Inventory, Patching, and Compliance](https://github.com/aws-samples/aws-management-and-governance-samples/tree/master/AWSSystemsManager/CentralizedPatchManagement).

## Next Section

Click the link below to go to the next section.

[![](media/enable-change-management.png)](/episode-04-step-03-enable-change-management.md)