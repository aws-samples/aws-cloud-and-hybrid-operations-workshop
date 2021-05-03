# Enabling Patch Management

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

To go back to the previous section, click here: [# Episode 4: Automating Changes and Preventative Maintenance in an Enterprise Cloud Environment](/episode-04-step-00-overview.md)

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Create prerequisite resources using CloudFormation](#create-prerequisite-resources-using-cloudformation)
    - [Create a patch baseline](#create-a-patch-baseline)
    - [Create and assign a patch group](#create-and-assign-a-patch-group)
    - [Scan instances for missing updates](#scan-instances-for-missing-updates)
    - [Review patch compliance](#review-patch-compliance)
    - [Export patch compliance](#export-patch-compliance)
    - [Install missing updates](#install-missing-updates)
- [Next Section](#next-section)

## Summary

In this section you will first create prerequisite resources for AWS Systems Manager Patch Manager, Automation, and Change Manager using an AWS CloudFormation Stack. Following this step, you will create a patch baseline, scan instances for missing updates, review patch compliance, export patch results, and install missing updates.

## Instructions

### Create prerequisite resources using CloudFormation

The [CloudFormation template](cfntemplates/ssm-workshop-resources-episode-04.yml) creates a test Windows EC2 instance and IAM instance profile role for System Manager.

### Create test resources using CloudFormation

**To save the CloudFormation template locally**
    
1. Open the CloudFormation template [ssm-workshop-resources-episode-04.yml](cfntemplates/ssm-workshop-resources-episode-04.yml).
1. Choose **Raw**.

    ![](/media/github-raw.png)

1. Open Notepad and copy the entire text.
1. Save the file to your local machine as ```ssm-workshop-resources-episode-04.yml```.

The CloudFormation template will create the resources depicted in the diagram below.

![](/media/ep04-st01.png)

**To create the workshop test resources**
    
1. Open the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/home).
1. Choose **Create stack**.
1. For **Specify template**, choose **Upload a template file**, choose the file you saved locally ```ssm-workshop-resources-episode-04.yml```, and choose **Next**.

    ![](/media/cloudformation-create-stack-ep04.png)

1. For **Stack name**, enter ```ssm-workshop-ep04```, and choose **Next**.
1. On the **Configure stack options** page, leave the defaults and choose **Next**.
1. On the **Review ssm-workshop-ep04** page, choose **I acknowledge that AWS CloudFormation might create IAM resources with custom names.**
1. Choose **Create stack**.

CloudFormation will begin provisioning the resources specified within the CloudFormation template and once complete, you will have one Windows EC2 instance to work with during this workshop. You can also use the refresh button to see the latest events related to the CloudFormation stack. Once the status of the CloudFormation stack changes to ```CREATE_COMPLETE```, you can proceed with the next steps. This process should complete within 7 minutes.

### Create a patch baseline

Patch Manager uses **patch baselines**, which include rules for auto-approving patches within days of their release, as well as a list of approved and rejected patches. Later in this workshop we will schedule patching to occur on a regular basis using a Systems Manager Maintenance Window task. Patch Manager integrates with AWS Identity and Access Management (IAM), AWS CloudTrail, and Amazon EventBridge to provide a secure patching experience that includes event notifications and the ability to audit usage.

:warning: **Important**: AWS does not test patches for Windows Server or Linux before making them available in Patch Manager. Also, Patch Manager doesn't support upgrading major versions of operating systems, such as Windows Server 2016 to Windows Server 2019, or SUSE Linux Enterprise Server (SLES) 12.0 to SLES 15.0. Always test patches thoroughly before deploying to production environments. This is a customer owned responsibility.

**To create a patch baseline**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Patch Manager**](https://console.aws.amazon.com/systems-manager/patch-manager).
1. Select the **View predefined patch baselines** link under the **Configure patching** button on the upper right.

    **Note**: If you have previously configured Patch Manager, choose the **Patch baselines** tab.
    
1. Choose **Create patch baseline**.
1. On the **Create patch baseline** page, in the **Patch baseline details** section, perform the following steps:

    - For **Name**, enter ```AmazonLinux2SecAndNonSecBaseline```.
    - For **Description**, optionally enter a description, such as: ```Amazon Linux 2 patch baseline including security and non-security patches```.
    - For **Operating system**, choose **Amazon Linux 2** from the list.

1. In the **Approval rules** section, perform the following steps:

    - For **Rule 1**:
        - For **Product**, choose **All**.
        - For **Classification**, choose **Security** and **Bugfix**.
        - For **Severity**, choose **All**.
        - Leave the **Auto approval delay** at its default of **0 days**.
        - For **Compliance reporting - optional**, choose **Critical**.
    - Choose **Add rule**.
    - For **Rule 2**:
        - For **Product**, choose **All**.
        - Do not select options for **Classification** or **Severity**.
        - Leave the **Auto approval delay** at its default of **0 days**.
        - For **Compliance reporting - optional**, choose **Medium**.
        - Choose **Include non-security updates**.
    - **Note** If an approved patch is reported as missing, the option you select in **Compliance reporting**, such as ```Critical``` or ```Medium```, determines the severity of the compliance violation reported in System Manager **Compliance**.
    
    ![](/media/patch-create-baseline.png)

1. In the **Patch exceptions** section, perform the following steps:

    - In the **Approved patches** text box, enter ```kernel*```.
    - In the **Approved patches compliance level - optional** section, choose **High** from the drop-down list.
    - Choose **Approved patches include non-security updates**.
    
    ![](/media/patch-add-exceptions.png)

    - **Note**: For Linux operating systems, you can optionally define an [alternative patch source repository](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-how-it-works-alt-source-repository.html).

1.  Select **Create patch baseline** and you will go to the **Patch Baselines** page where the AWS provided default patch baselines are displayed. Your custom baseline can be found on the second page or choose **View details** in the banner displayed.

    ![](/media/patch-view-baseline.png)
    
1. Choose **Actions** and **Modify patch groups**.
1. On the **Modify patch groups** page, perform the following steps:

    - For **Patch groups**, enter ```App``` and choose **Add**.

    ![](/media/patch-patch-group.png)

    - Choose **Close**.

### Create and assign a patch group

A [patch group](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-patch-patchgroups.html) is an optional method to organize instances for patching. For example, you can create patch groups for different operating systems (Linux or Windows), different environments (Development, Test, and Production), or different server functions (web servers, file servers, databases) and register each patch group to an appropriate patch baseline. Patch groups help ensure that you are deploying the appropriate patches, based on the associated patch baseline rules, to the correct set of instances. Patch groups can also help you avoid deploying patches before they have been adequately tested.

You create a patch group by using resource tags. Unlike other tagging scenarios across Systems Manager, a patch group must be defined with the tag key: ```Patch Group``` (tag keys are case sensitive). You can specify any value (for example, ```web-servers```) but the key must be ```Patch Group```. Additionally, a patch group can be registered with only one patch baseline for each operating system type; also an instance can only be in one patch group.

**Important:** When targeting managed instances for patch scan or install operations, you can target existing resource tags on the managed instance and do not need target the **Patch Group** key-value pair. For example, you can target ```ENV : DEV``` and patch baseline determination will be performed by the SSM Agent installed on each managed instance. For an example on targeting a common tag across multiple instances that use different baselines, see the topic [How it works](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-patch-patchgroups.html#how-it-works-patch-groups) in the Patch Manager section of the AWS Systems Manager User Guide.

1. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2.
1. In the navigation pane, choose **Tags**.
1. Select **Manage Tags**.
1. Select the two EC2 instances with the tag ```Name``` and values: ```App1``` and ```App2```.
1. In the **Add Tag** section:

    - **Key:** ```Patch Group```
    - **Value:** ```App```

    ![](/media/ec2-tags-patch-group-app.png)

1. Select instances with **Name** ```Web1``` and ```Web2```.
1. Add Tag.

    - **Key:** ```Patch Group```
    - **Value:** ```Web```
    ![](/media/ec2-tags-patch-group-web.png)

1. Navigate back to [Systems Manager \> Patch Manager \> Patch Baselines](https://console.aws.amazon.com/systems-manager/patch-manager/baselines).
1. Select the second page of results and then select the Baseline you created in the previous part (```AmazonLinux2SecAndNonSecBaseline```).
1. Choose **Actions** and **Modify patch groups**.

    ![](/media/patch-modify-group.png)

1. For **Patch groups**, enter ```App```, choose **Add**, and choose **Close**.

    ![](/media/patch-add-group.png)

From here you can utilize the AWS provided Command document **AWS-RunPatchBaseline** to scan or patch your instances.

:information_source: For the purpose of this workshop, we are adding only one patch group (```App```) to the custom baseline. By doing this, our four Amazon Linux 2 instances will use two different baselines. The instances with the resource tag ```Patch Group : App``` will use the custom baseline created **AmazonLinux2SecAndNonSecBaseline**. The other two instances will use the default AWS provided baseline for Amazon Linux 2 **AWS-AmazonLinux2DefaultPatchBaseline** as there is not a corresponding baseline with the ```Patch Group : Web``` relationship. For more information about how patch groups work, see [About patch groups](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-patch-patchgroups.html).

Outside of this workshop, you can also select Configure Patching and link the Patch Baseline to the Maintenance Window (or create a new Maintenance Window), it will register the run task with the maintenance window and also register the Patch Group as a target. It utilizes the existing role AWSServiceRoleforAmazonSSM.

### Scan instances for missing updates

Now that we have created a patch baseline to define the criteria for the type of updates to approve, we will run a manual **Scan** operation to identify any missing updates on our managed instances. Before we initiate a scan operation, navigate to the [**Dashboard**](https://console.aws.amazon.com/systems-manager/patch-manager/dashboard) tab of **Patch Manager** where you can see that in the **Compliance Reporting Age** widget that the four test instances show as **Never reported**. This is a helpful way to identify managed instances that have never performed a scan or install operation using Patch Manager.

![](/media/patch-never-reported.png)

**To run a scan operation**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Patch Manager**](https://console.aws.amazon.com/systems-manager/patch-manager).
1. Choose **Patch now**.
1. For **Patch operation**, leave the default as **Scan**.
1. For **Instances to patch**, choose **Patch all instances**.
1. For **Patching log storage**, choose the S3 bucket created by the CloudFormation template. **Note**: The S3 bucket is named similar to ```ssm-command-logs-us-east-1-123456789012```.
1. Leave **Lifecycle hooks** disabled for the time being.
1. Choose **Patch now**.

    ![](/media/patch-scan-now.png)

    - **Note**: A [State Manager association](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-state-about.html) is then created to perform a **Scan** operation on your EC2 instances using the document ```AWS-RunPatchBaseline```. 

1. (Optional) To view the association, choose the **Association ID** link.

    ![](/media/patch-now-results.png)

1. (Optional) To view the command log details, choose the **Execution ID** link and then choose **Output** for one of the targeted managed instances. This will bring you to the corresponding Run Command output results for the **Scan** operation.
    
    - In **Step 2**, expand **Output** to view the command output details. You can then optionally choose **Amazon S3** to open the logs exported to the S3 bucket.

### Review patch compliance

After your instances have successfully completed a **Scan** or **Install** operation using Patch Manager, you can navigate back to the dashboard to review the patch compliance state of your managed instances, view recent patching operations, and view recurring patch tasks.

**To review patch compliance**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Patch Manager**](https://console.aws.amazon.com/systems-manager/patch-manager).
1. On the **Dashboard** tab you can review the compliance status of the managed EC2 instances created.

    ![](/media/patch-dashboard.png)

### Install missing updates

Depending on the release date of the AMI used, the test instances may not be missing updates. For hands-on experience, you can still perform an install operation to see the differences.

**To run an install operation**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Patch Manager**](https://console.aws.amazon.com/systems-manager/patch-manager).
1. Choose **Patch now**.
1. For **Patch operation**, choose **Scan and install**.
1. For **Reboot option**, leave the default as **Reboot if needed**.
    - :information_source: **Note**: The option **Reboot if needed** means that if there are any approved missing updates, then the instance will enforce a reboot. If no approved missing updates are installed, the instance does not reboot.
1. For **Instances to patch**, choose **Patch all instances**.
1. For **Patching log storage**, choose the S3 bucket created by the CloudFormation template. **Note**: The S3 bucket is named similar to ```ssm-command-logs-us-east-1-123456789012```.
1. Leave **Lifecycle hooks** disabled for the time being.
1. Choose **Patch now**.

    ![](/media/patch-install-now.png)

    - **Note**: A [State Manager association](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-state-about.html) is then created to perform a **Scan and install** operation on your EC2 instances using the document ```AWS-RunPatchBaseline```. 

1. (Optional) To view the association, choose the **Association ID** link.

    ![](/media/patch-now-results.png)

1. (Optional) To view the command log details, choose the **Execution ID** link and then choose **Output** for one of the targeted managed instances. This will bring you to the corresponding Run Command output results for the **Scan** operation.
    
    - In **Step 2**, expand **Output** to view the command output details. You can then optionally choose **Amazon S3** to open the logs exported to the S3 bucket.

Outside of the workshop, you can orchestrate multi-step custom patch processes using the Systems Manager document **AWS-RunPatchBaselineWithHooks**. Patch lifecycle hooks extend existing Patch Manager functionality to include new pre-patching and post-patching hooks that allow custom, customer-specified steps to be run at different phases of the patching workflow. For more information, see:

- [[AWS Management & Governance Blog] Orchestrating multi-step, custom patch processes using AWS Systems Manager Patch Manager](https://aws.amazon.com/blogs/mt/orchestrating-custom-patch-processes-aws-systems-manager-patch-manager/)
- [[AWS Systems Manager User Guide] About the AWS-RunPatchBaselineWithHooks SSM document](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-about-aws-runpatchbaselinewithhooks.html)

### Export patch results for all instances

Patch Manager supports the ability to generate patch compliance reports for your instances and save the report in an Amazon S3 bucket of your choice, in .csv format. Then, using a tool like [Amazon QuickSight](https://docs.aws.amazon.com/quicksight/latest/user/), you can analyze the patch compliance report data. You can generate a patch compliance report for a single instance, or for all instances in your account. You can generate a one-time report on demand, or set up a schedule for reports to be created automatically. You can also specify an Amazon Simple Notification Service topic to provide notifications when a report is generated. For reference after this workshop, see [Generating CSV patch compliance reports](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-compliance-reports-to-s3.html). 

**To export patch results for all instances**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Patch Manager**](https://console.aws.amazon.com/systems-manager/patch-manager).
1. Choose the [**Reporting**](https://console.aws.amazon.com/systems-manager/patch-manager/reporting) tab.
1. Choose **Export to S3**. Do not select an instance ID.
1. For **Report name**, enter ```ssm-workshop```.
1. For **Reporting frequency**, choose **On demand** to generate a one-time report.
    
    - Outside of the workshop, you may decide to choose **On a schedule** instead where you can specify a recurring schedule for automatically generating reports.

1. For **Bucket name**, choose the S3 bucket created by the CloudFormation template. **Note**: The S3 bucket is named similar to ```ssm-command-logs-us-east-1-123456789012```.
1. Choose **Submit**.

![](/media/patch-export-report.png)

The patch export process will then begin and you can view the status on the subsequent page. Once the status changes to **Success**, you can choose **View report** to view the CSV file generated.

1. On the resulting S3 page, choose **Object actions** and **Open** to download the CSV file locally.

![](/media/patch-s3-report.png)

## Next Section

Click the link below to go to the next section.

[![](media/codify-runbooks.png)](/episode-01-step-02-codify-runbooks.md)