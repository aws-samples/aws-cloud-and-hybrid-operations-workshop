# Schedule and Automate Patching Operations

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Enable AWS Config](#enable-aws-config)
    - [Use Systems Manager Quick Setup](#use-systems-manager-quick-setup)
    - [Create and configure an S3 bucket for resource data sync](#create-and-configure-an-s3-bucket-for-resource-data-sync)
    - [Create a Resource Data Sync](#create-a-resource-data-sync)
- [Next Section](#next-section)

## Summary

In this section you will (1) enable AWS Config to monitor and record your AWS resource configurations,(2) use Systems Manager Quick Setup to enable Systems Manager best practices, (3) create an S3 bucket to store Systems Manager Inventory data, (4) create a resource data sync to send inventory data to the S3 bucket, and (5) use the detailed view tab for Inventory.

## Instructions

### Enable AWS Config

AWS Config is a service that enables you to assess, audit, and evaluate the configurations of your AWS resources. Config continuously monitors and records your AWS resource configurations and allows you to automate the evaluation of recorded configurations against desired configurations. With Config, you can review changes in configurations and relationships between AWS resources, dive into detailed resource configuration histories, and determine your overall compliance against the configurations specified in your internal guidelines. This enables you to simplify compliance auditing, security analysis, change management, and operational troubleshooting.

**To enable AWS Config**

1. Open the [AWS Config console](https://console.aws.amazon.com/config/home).
1. Select **1-click setup**.

    ![](/media/aws-config-1-click.png)
    
1. Select **Confirm**.

    ![](/media/aws-config-confirm.png)
    
1. Once AWS Config completes setting up, you will be brought to the AWS Config dashboard and can continue with the next steps.

### Use Systems Manager Quick Setup

Use AWS Systems Manager Quick Setup to quickly configure frequently used AWS services and features with recommended best practices. You can use Quick Setup in an individual account or across multiple accounts and AWS Regions by integrating with AWS Organizations. Quick Setup simplifies setting up services, including AWS Systems Manager, by automating common or recommended tasks. These tasks include, for example, creating required AWS Identity and Access Management (IAM) instance profile roles and setting up operational best practices, such as periodic patch scans and inventory collection.

**To setup Quick Setup Host Management**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Quick Setup**](https://console.aws.amazon.com/systems-manager/quick-setup).
1. Choose **Create**.
1. Choose **Host Management** and choose **Next**.

    - **Note**: If your AWS account is part of an AWS Organization and you are logged in to the root organization account, you also have an option to configure the Change Manager capability of Systems Manager.
    
1. On the **Customize Host Management configuration options**, ensure the defaults for **Systems Manager** are enabled:

    - Update Systems Manager (SSM) Agent every two weeks.
    - Collect inventory from your instances every 30 minutes.
    - Scan instances for missing patches daily.

1. In the **Targets** section, choose **Current Region** and choose **All instances**.
1. Choose **Create**.

    ![](/media/quick-setup-create.png)
    
    - Systems Manager Quick Setup will begin deploying a CloudFormation stack which creates the corresponding resources to enable Systems Manager best practices. After a few moments, the **Host Management** page should refresh and you can see the **Configuration deployment status**, **Configuration association status**, and **Configuration details** for the **Quick Setup** deployment.

    ![](/media/quick-setup-host-mgmt.png)

1. Choose the radio button for the current account and Region and choose **View details**.    
1. On the **Association drilldown** page, you can review the **Association status**, **Instances per status**, **Schedule rate**, and **Last updated** timestamp for each association created by **Quick Setup**.

    ![](/media/quick-setup-drilldown.png)

### Create and configure an S3 bucket for resource data sync

Now that AWS Config is enabled, you will create an S3 bucket to store Systems Manager inventory data collected from all of your managed instances. The resource data sync created in the next section  automatically updates the centralized data when new inventory data is collected.

**To create and configure an S3 bucket for resource data sync**

1. Navigate to the [S3](https://s3.console.aws.amazon.com/s3) console.
1. Select **Create Bucket**.
1. For the **Bucket name** enter: ```YOURFIRSTNAME-sm-workshop```.
1. For **Region** select **US-East (N. Virginia)**.
1. Keep all defaults including **Block all public access**.
1. Choose **Create Bucket**.
1. Select your newly created bucket to access the configuration details.
1. Navigate to the **Permissions** tab.
1. Navigate to **Bucket Policy** and select **Edit**.
1. Copy and paste the policy below into the bucket policy, replace the two _ENTERYOURBUCKET_ entries below with your **Bucket Name**, and select **Save changes**.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SSMBucketPermissionsCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "ssm.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::ENTERYOURBUCKET"
        },
        {
            "Sid": " SSMBucketDelivery",
            "Effect": "Allow",
            "Principal": {
                "Service": "ssm.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::ENTERYOURBUCKET/inventory/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
```

![](/media/inventory-bucket-policy.png)

### Create a Resource Data Sync

1. Now we will configure the **Resource Data Sync** which will ship the inventory data to an S3 bucket for further processing.
1. Open the Resource Data Sync console at https://console.aws.amazon.com/systems-manager/managed-instances/resource-data-sync.
1. Select **Create resource data sync**.
1. Configuration details:

    - For **Sync name** enter **YOURNAME-inventory-s3-sync**.
    - For **Bucket name** enter the name of the bucket you created previously.
    - For **Bucket prefix** enter **inventory**.
    - For **Bucket region** enter **This region (us-east-1)**.
    - For **KMS Key ARN - optional** leave this blank for the purpose of the workshop.
    - Choose **Create**

1. Switch back to your bucket and you can now see the data being synced.

    ![](/media/image23.png)

    - Now we have a clean data structure for inventory data.
    - From here you can utilize Athena and Quicksight to gain deeper insight about the inventory data gathered. **Note:** For the purpose of this workshop, we will not be covering these steps.
    - **User Guide Documentation:**
        <https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-inventory-datasync.html>

    ![](/media/image24.png)

## Next Section

Click the link below to go to the next section.

[![](media/codify-runbooks.png)](/episode-01-step-02-codify-runbooks.md)