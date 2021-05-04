# Using AWS Systems Manager to manage EC2 instances

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Create test EC2 instance](#create-test-ec2-instance)

- [Next Section](#next-section)

## Summary

In this section you will (1) create test Amazon Linux 2 Elastic Cloud Compute (EC2) instances, (2) install the Amazon CloudWatch agent, (3) connect to the managed instance using Session Manager, (4) use the CloudWatch agent configuration wizard, (5) store the configuration in Systems Manager Parameter Store, (6) create a CloudWatch alarm, (7) review the Systems Manager OpsCenter OpsItem created by the alarm, and (8) resolve the OpsItem using Systems Manager Automation.

To create the test Amazon Linux 2 EC2 instance, you will use [AWS CloudFormation](https://aws.amazon.com/cloudformation/). AWS CloudFormation gives you an easy way to model a collection of related AWS and third-party resources, provision them quickly and consistently, and manage them throughout their lifecycles, by treating infrastructure as code.

## Instructions

### Create test EC2 instance

**To save the CloudFormation template locally**
    
1. Open the CloudFormation template [oe-workshop-episode-01.yml](cfntemplates/oe-workshop-episode-01.yml).
1. Choose **Raw**.

    ![](/media/github-raw.png)

1. Open Notepad and copy the entire text.
1. Save the file to your local machine as ```oe-workshop-episode-01.yml```.

The CloudFormation template will create the resources depicted in the diagram below.

![](/media/ep01-st01.png)

**To create the test EC2 instance**
    
1. Open the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/home).
1. Choose **Create stack**.
1. For **Specify template**, choose **Upload a template file**, choose the file you saved locally ```oe-workshop-episode-01.yml```, and choose **Next**.

    ![](/media/cloudformation-create-stack-ep01.png)

1. For **Stack name**, enter ```oe-workshop```, and choose **Next**.
1. On the **Configure stack options** page, leave the defaults and choose **Next**.
1. On the **Review** page, choose **Create stack**.

CloudFormation will begin provisioning the resources specified within the CloudFormation template and once complete, you will have one Amazon Linux 2 EC2 instance to test and configure using Systems Manager. You can also use the refresh button to see the latest events related to the CloudFormation stack. Once the status of the CloudFormation stack changes to ```CREATE_COMPLETE```, you can proceed with the next steps. This process should complete within 5 minutes.

### Enable AWS Config using Quick Setup

AWS Config is a service that enables you to assess, audit, and evaluate the configurations of your AWS resources. Config continuously monitors and records your AWS resource configurations and allows you to automate the evaluation of recorded configurations against desired configurations. With Config, you can review changes in configurations and relationships between AWS resources, dive into detailed resource configuration histories, and determine your overall compliance against the configurations specified in your internal guidelines. This enables you to simplify compliance auditing, security analysis, change management, and operational troubleshooting.

To enable **AWS Config**, you will use **AWS Systems Manager Quick Setup**. **Quick Setup** allows you to quickly configure frequently used AWS services and features with recommended best practices. You can use Quick Setup in an individual account or across multiple accounts and AWS Regions by integrating with AWS Organizations.

**To enable AWS Config using Quick Setup**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Quick Setup**](https://console.aws.amazon.com/systems-manager/quick-setup).
1. Ensure ```us-east-1``` is selected as the home Region and choose **Get started**.

    ![](/media/quick-setup-get-started.png)

1. Choose **Create new configuration**.
1. For **Configuration type**, choose **Config Recording** and choose **Next**.

    - **Note**: If your AWS account is part of an AWS Organization and you are logged in to the root organization account, you also have an option to configure the Change Manager capability of Systems Manager.

1. On the **Customize Config Recording configuration options** page, perform the following steps:
    - In the section **Configuration options** perform the following steps:
        - For **Choose the AWS resource types to recrod**, choose **Record specific resource types**.
        - In the **Resource types** drop-down menu choose the following resources:
            - **AWS EC2 Instance**
            - **AWS SSM AssociationCompliance**
            - **AWS SSM FileData**
            - **AWS SSM PatchCompliance**
            - **AWS SSM ManagedInstanceInventory**
        - For **Delivery settings** choose **Create a new S3 bucket**.
        - For **Notification options**, leave the default option **Don't stream notifications**.
            - **Note:** In a real-world environment, you can choose a different option to notify you about important AWS Config events using Amazon Simple Notification Service (Amazon SNS).
            
        ![](/media/quick-setup-config-options.png)
        
        - For **Schedule** leave the default setting **Default**.
            - **Note:** In a real-world environment, you can specify a custom frequency to ensure Quick Setup remediates any changes made to the configurations after the initial deployment.
        - For **Targets** leave the default as **Current Region**.
        - Choose **Create**.
    - Systems Manager Quick Setup will begin deploying a CloudFormation stack which enables AWS Config with the defined parameters. After a few moments, the **Config Recording** page should refresh and you can see the **Configuration deployment status**, **Configuration association status**, and **Configuration details** for the **Quick Setup** deployment.

    ![](/media/quick-setup-config-recording.png)

1. Once the **Configuration deployment status** changes to **Success**, choose the radio button for the current account and Region and choose **View details**.    
1. On the **Association drilldown** page, you can review the **Association status**, **Instances per status**, **Schedule rate**, and **Last updated** timestamp for each association created by **Quick Setup**.

    ![](/media/quick-setup-config-drilldown.png)
    
1. Now that AWS Config is enabled, navigate to the AWS Config console at: https://console.aws.amazon.com/config.
1. In the navigation pane, choose [**Resources**](https://console.aws.amazon.com/config/home#/resources).
1. You can now select a resource such as an EC2 instance to see the configuration state recorded by AWS Config. In [Episode 2: Enabling Compliance and Monitoring in an Enterprise Cloud Environment](), you will dive deeper into the AWS Config service.

### Enable Host Management using Quick Setup

Next, you will use Quick Setup to simplify setting up AWS Systems Manager. The **Host Management** configuration type automates common and recommended tasks related to Systems Manager. These tasks include, creating required AWS Identity and Access Management (IAM) instance profile roles and setting up operational best practices, such as periodic patch scans and inventory collection.

**To setup Quick Setup Host Management**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Quick Setup**](https://console.aws.amazon.com/systems-manager/quick-setup).
1. Choose **Create new configuration**.
1. For **Configuration type**, choose **Host Management** and choose **Next**.

    - **Note**: If your AWS account is part of an AWS Organization and you are logged in to the root organization account, you also have an option to configure the Change Manager capability of Systems Manager.
    
1. On the **Customize Host Management configuration options**, ensure the defaults for **Systems Manager** are enabled:

    - Update Systems Manager (SSM) Agent every two weeks.
    - Collect inventory from your instances every 30 minutes.
    - Scan instances for missing patches daily.
    - **Note:** For now, we'll leave the Amazon CloudWatch agent options disabled as we'll enable the CloudWatch agent in [Step 4: Enabling configuration management using parameters](/episode-01-step-04-enable-state.md). In a real-world environment, you may choose to install, configure, and update the CloudWatch agent using Quick Setup.

1. In the **Targets** section, choose **Current Region** and choose **All instances**.
1. Choose **Create**.

    ![](/media/quick-setup-create.png)
    
    - Systems Manager Quick Setup will begin deploying a CloudFormation stack which creates the corresponding resources to enable Systems Manager best practices. After a few moments, the **Host Management** page should refresh and you can see the **Configuration deployment status**, **Configuration association status**, and **Configuration details** for the **Quick Setup** deployment.

    ![](/media/quick-setup-host-mgmt.png)

1. Once the **Configuration deployment status** changes to **Success**, choose the radio button for the current account and Region and choose **View details**.

    - **Note:** You do not need to wait for the **Configuration status** to change to **Success** before proceeding.
  
1. On the **Association drilldown** page, you can review the **Association status**, **Instances per status**, **Schedule rate**, and **Last updated** timestamp for each association created by **Quick Setup**.

    ![](/media/quick-setup-drilldown.png)
    
Optionally, you can navigate to the [EC2 Instances console](https://console.aws.amazon.com/ec2/v2/home?#Instances), select one of the test instances, and see that the ```AmazonSSMRoleForInstancesQuickSetup``` IAM role has been attached. This grants permissions for the SSM Agent on the EC2 instance to communicate with the Systems Manager endpoints.

![](/media/instance-iam-role.png)

### Create and configure an S3 bucket for resource data sync

#### About resource data sync 

You can use [Systems Manager resource data sync](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-inventory-datasync.html) to send inventory data collected from all of your managed instances to a single Amazon Simple Storage Service (Amazon S3) bucket. Resource data sync then automatically updates the centralized data when new inventory data is collected. Additionally, you can [synchronize inventory data from AWS accounts defined in AWS Organizations](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-inventory-datasync.html#systems-manager-inventory-resource-data-sync-AWS-Organizations) to a central Amazon S3 bucket.

**To create and configure an S3 bucket for resource data sync**

1. Navigate to the [S3](https://s3.console.aws.amazon.com/s3) console.
1. Choose **Create Bucket**.
1. For the **Bucket name** enter: ```YOURFIRSTNAME-sm-workshop```.
1. For **Region** select **US-East (N. Virginia)**.
1. Keep all defaults including **Block all public access**.
1. Choose **Create Bucket**.
1. Select your newly created bucket to access the configuration details.
1. Navigate to the **Permissions** tab.
1. Navigate to **Bucket Policy** and choose **Edit**.
1. Copy and paste the policy below into the bucket policy, replace the two _ENTERYOURBUCKET_ entries below with your **Bucket Name**, and choose **Save changes**.

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

1. Now we will configure the **Resource Data Sync** which will ship the inventory data to an S3 bucket.
1. Open the Resource Data Sync console at https://console.aws.amazon.com/systems-manager/managed-instances/resource-data-sync.
1. Select **Create resource data sync**.
1. Configuration details:

    - For **Sync name** enter **YOURNAME-inventory-s3-sync**.
    - For **Bucket name** enter the name of the bucket you created previously.
    - For **Bucket prefix** enter **inventory**.
    - For **Bucket region** enter **This region (us-east-1)**.
    - For **KMS Key ARN - optional** leave this blank for the purpose of the workshop.
    - Choose **Create**

    ![](/media/create-resource-data-sync.png)

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