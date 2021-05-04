# Enabling configuration management using parameters

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Add permissions to the EC2 IAM role](#add-permissions-to-the-ec2-iam-role)
    - [Create a Parameter Store parameter](#create-a-parameter-store-parameter)
    - [Create a State Manager Association to install CloudWatch agent](#create-a-state-manager-association-to-install-cloudwatch-agent)
    - [Create a State Manager Association to configure CloudWatch agent](#create-a-state-manager-association-to-configure-cloudwatch-agent)
    - [View metrics gathered by CloudWatch agent](#view-metrics-gathered-by-cloudwatch-agent)
- [Next Section](#next-section)

## Summary

The following section discusses three primary topics:

- [AWS Systems Manager State Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-state.html)
- [AWS Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)
- [Amazon CloudWatch agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)

[AWS Systems Manager State Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-state.html) is a secure and scalable configuration management service that automates the process of keeping your Amazon EC2 and hybrid infrastructure in a state that you define.

The following list describes the types of tasks you can perform with State Manager:

* Bootstrap instances with specific software at start-up.
* Download and update agents on a defined schedule, including SSM agent.
* Configure network settings.
* Join instances to a Windows domain (Windows Server instances only).
* Patch instances with software updates throughout their lifecycle.
* Run scripts on Linux and Windows managed instances throughout their lifecycle.

[AWS Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html) (Parameter Store) provides secure, hierarchical storage for configuration data management and secrets management. You can store data such as passwords, database strings, Amazon Machine Image (AMI) IDs, and license codes as parameter values. You can store values as plain text or encrypted data. You can reference Systems Manager parameters in your scripts, commands, SSM documents, and configuration and automation workflows by using the unique name that you specified when you created the parameter.

The unified [Amazon CloudWatch agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html) enables you to do the following:

- Collect internal system-level metrics from Amazon EC2 instances across operating systems. The metrics can include in-guest metrics, in addition to the metrics for EC2 instances. The additional metrics that can be collected are listed in [Metrics Collected by the CloudWatch agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html).
- Collect system-level metrics from on-premises servers. These can include servers in a hybrid environment as well as servers not managed by AWS.
- Retrieve custom metrics from your applications or services using the StatsD and collectd protocols. StatsD is supported on both Linux servers and servers running Windows Server. collectd is supported only on Linux servers.
- Collect logs from Amazon EC2 instances and on-premises servers, running either Linux or Windows Server. 

## Instructions

In this lab we will create a Parameter Store parameter which includes a basic configuration for the [Amazon CloudWatch agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html). The basic configuration collects disk usage and memory usage as percentages. We will then create **State Manager Associations** to install and configure the CloudWatch agent on a routine basis to ensure the configuration state is maintained.

### Add permissions to the EC2 IAM role

**To add CloudWatch agent permissions to the existing IAM role**

1. Open the AWS Identity and Access Management (IAM) console at https://console.aws.amazon.com/iam.
1. In the navigation pane, choose [**Roles**](https://console.aws.amazon.com/iam/home#/roles).
1. Select the **AmazonSSMRoleForInstancesQuickSetup** to bring up the **Summary** page for the IAM role created by **Quick Setup** in [Step 1: Enabling Inventory](/episode-01-step-01-enable-inventory.md).
1. Choose **Attach policies**.
1. In the list of policies, select the check box next to **CloudWatchAgentServerPolicy**. If necessary, use the search box to find the policy.
1. Choose **Attach policy**.

The IAM role attached to the test EC2 instances now have permissions to put metrics into CloudWatch using the CloudWatch agent.

![](/media/cloudwatch-iam-role.png)

### Create a Parameter Store parameter

Next, we will store the [basic CloudWatch agent configuration](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file-wizard.html#cloudwatch-agent-preset-metrics) as a parameter within Parameter Store which will then be used later on to configure the CloudWatch agent.

**To create a parameter in Parameter Store**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Parameter Store**](https://console.aws.amazon.com/systems-manager/parameters).
1. Choose **Create parameter**.
1. On the **Create parameter** page, perform the following steps:

    - For **Name**, enter: ```AmazonCloudWatch-TestInstances```.
        - **Important:** The name of the parameter is case-sensitive.
    - For **Description**, optionally enter a description for the parameter.
    - For **Type**, leave the default value **String**.
    - For **Data type**, leave the default value **text**.
    - For **Value**, enter the following text:
    
    ```
    {
        "agent": {
            "metrics_collection_interval": 60,
            "run_as_user": "root"
        },
        "metrics": {
            "append_dimensions": {
                "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
                "ImageId": "${aws:ImageId}",
                "InstanceId": "${aws:InstanceId}",
                "InstanceType": "${aws:InstanceType}"
            },
            "metrics_collected": {
                "disk": {
                    "measurement": [
                        "used_percent"
                    ],
                    "metrics_collection_interval": 60,
                    "resources": [
                        "*"
                    ]
                },
                "mem": {
                    "measurement": [
                        "mem_used_percent"
                    ],
                    "metrics_collection_interval": 60
                }
            }
        }
    }
    ```

    ![](/media/parameter-create.png)

### Create a State Manager Association to install CloudWatch agent

**To create a State Manager association to install the CloudWatch agent**

1. Open the Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**State Manager**](https://console.aws.amazon.com/systems-manager/state-manager).
1. Choose **Create association** and perform the following steps:

    - For **Name**, enter ```CloudWatchAgent-Install```.
    - For **Document**, search for the document and select the radio button for the document **AWS-ConfigureAWSPackage**.
    - In the **Parameters** section, perform the following steps:
        - Leave the default values for **Action** and **Installation Type**.
        - For **Name**, enter ```AmazonCloudWatchAgent```.
    - For **Targets**, choose **Choose instances manually**.
        - Choose the two instances created in [Step 1: Enabling Inventory](/episode-01-step-01-enable-inventory.md).
    - In the **Specify schedule** section, perform the following steps:
        - For **Specify with**, select **CRON/Rate expression**.
        - For **CRON/Rate expression**, enter ```rate(1 day)```.
    - Choose **Create Association**.
    
1. Once the create association request completes, choose the association name to view details about the association. After the status of the association changes to **Success**, continue with the next steps.

    ![](/media/state-association-details.png)

### Create a State Manager Association to configure CloudWatch agent

**To create a State Manager association to configure the CloudWatch agent**

1. Open the Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**State Manager**](https://console.aws.amazon.com/systems-manager/state-manager).
1. Choose **Create association** and perform the following steps:

    - For **Name**, enter ```CloudWatchAgent-Configure```.
    - For **Document**, search for the document **AmazonCloudWatch-ManageAgent** and select the radio button for the document **AmazonCloudWatch-ManageAgent**.
    - In the **Parameters** section, perform the following steps:
        - Leave the default values for **Action**, **Mode**, and **Optional Configuration Source**.
        - For **Optional Configuration Location**, enter the name of the Parameter Store parameter: ```AmazonCloudWatch-TestInstances```.
            - **Important:** The name of the parameter is case-sensitive.
        - Leave the default values for **Optional Open Telemetry Collector Configuration Source**, **Optional Open Telemetry Collector Configuration Location**, and **Optional Restart**.
        
    ![](/media/state-association-configure-parameters.png)
        
    - For **Targets**, choose **Choose instances manually**.
        - Choose the two instances created in [Step 1: Enabling Inventory](/episode-01-step-01-enable-inventory.md).
    - In the **Specify schedule** section, perform the following steps:
        - For **Specify with**, select **CRON/Rate expression**.
        - For **CRON/Rate expression**, enter ```rate(1 day)```.
    - Choose **Create Association**.

    ![](/media/state-association-configure-details.png)

1. Select radio button next to the **CloudWatchAgent-Configure** **Association ID** to review the **Association details**

    - Review the various tabs of the association to see different information about the association. After the status of the association changes to **Success**, continue with the next steps.

### View metrics gathered by CloudWatch agent

**To view the metrics pushed by CloudWatch agent**

1. Open the CloudWatch console at https://console.aws.amazon.com/cloudwatch.
1. In the navigation pane, choose **Metrics**.
1. Under **Custom Namespaces**, choose **CWAgent**.
1. Choose **CWAgent > ImageId, InstanceId, InstanceType, device, fstype, path**.
1. Choose a metric listed to display the disk used percentage metric on the graph. **Note**: You can select multiple metrics to be displayed at a single time.
    
    ![](/media/cloudwatch-disk-used.png)

1. Return back to **CWAgent** and then choose **ImageId, InstanceId, InstanceType** to display the memeory used percentage metric.

    ![](/media/cloudwatch-mem-used.png)

## Next Section

Click the link below to go to the next section.

[![](media/tear-down.png)](/episode-01-step-05-tear-down.md)