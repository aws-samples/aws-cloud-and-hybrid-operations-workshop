# Review CloudWatch alarms and enable alarm actions

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

To go back to the previous section, click here: [Using AWS Systems Manager to manage EC2 instances](/operational_excellence/episode-01-step-01-manage-ec2.md)

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [View metrics gathered by CloudWatch agent](#view-metrics-gathered-by-cloudwatch-agent)
    - [Create a CloudWatch alarm and add an alarm action](#create-a-cloudwatch-alarm-and-add-an-alarm-action)
    - [Trigger the CloudWatch alarm](#trigger-the-cloudwatch-alarm)
    - [Review the OpsItem](#review-the-opsitem)
    - [Resolve the OpsItem](#resolve-the-opsitem)
- [Next Section](#next-section)

## Summary

The following section discusses three primary topics:

- [Amazon CloudWatch Metric Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)
- [AWS Systems Manager OpsCenter](https://docs.aws.amazon.com/systems-manager/latest/userguide/OpsCenter.html)
- [AWS Systems Manager Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html)

----

A [metric alarm](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html) watches a single CloudWatch metric or the result of a math expression based on CloudWatch metrics. The alarm performs one or more actions based on the value of the metric or expression relative to a threshold over a number of time periods. The action can be sending a notification to an Amazon SNS topic, performing an Amazon EC2 action or an Auto Scaling action, or creating a Systems Manager OpsItem.

----

[OpsCenter](https://docs.aws.amazon.com/systems-manager/latest/userguide/OpsCenter.html), a capability of Systems Manager, provides a central location where operations engineers and IT professionals can view, investigate, and resolve operational work items (OpsItems) related to AWS resources. OpsCenter is designed to reduce mean time to resolution for issues impacting AWS resources. This Systems Manager capability aggregates and standardizes OpsItems across services while providing contextual investigation data about each OpsItem, related OpsItems, and related resources. OpsCenter also provides Systems Manager Automation documents (runbooks) that you can use to quickly resolve issues. You can specify searchable, custom data for each OpsItem. You can also view automatically-generated summary reports about OpsItems by status and source. 

----

[Systems Manager Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html) simplifies common maintenance and deployment tasks of Amazon EC2 instances and other AWS resources. Automation enables you to do the following:

- Build automations to configure and manage instances and AWS resources.
- Create custom runbooks or use pre-defined runbooks maintained by AWS.
- Receive notifications about Automation tasks and runbooks by using Amazon EventBridge.
- Monitor Automation progress and details by using the AWS Systems Manager console.

## Instructions

In this section you will (1) view the metrics in CloudWatch pushed by the CloudWatch agent, (2) create a CloudWatch alarm with OpsCenter integration, (3) use Run Command to trigger the alarm, (4) review the OpsItem created by the alarm in Systems Manager OpsCenter, and (5) resolve the OpsItem using Systems Manager Automation.

### View metrics gathered by CloudWatch agent

**To view the metrics pushed by CloudWatch agent**

1. Open the Amazon CloudWatch console at https://console.aws.amazon.com/cloudwatch.
1. In the navigation pane, choose **Metrics**.
1. Under **Custom Namespaces**, choose **CWAgent**.
1. Choose **CWAgent > ImageId, InstanceId, InstanceType, device, fstype, path**.
1. Choose a metric listed to display the disk used percentage metric on the graph. **Note**: You can select multiple metrics to be displayed at a single time.
    
    ![](/operational_excellence/media/cloudwatch-disk-used.png)

1. Return back to **CWAgent** and then choose **ImageId, InstanceId, InstanceType** to display the memeory used percentage metric.

    ![](/operational_excellence/media/cloudwatch-mem-used.png)
    
### Create a CloudWatch alarm and add an alarm action

1. Open the CloudWatch console at https://console.aws.amazon.com/cloudwatch.
1. In the navigation pane, choose **Alarms**.
1. Choose **Create alarm**.
1. For **Graph**, choose **Select metric**.
1. Under **Custom Namespaces**, choose **CWAgent**.
1. Choose **ImageId, InstanceId, InstanceType**.
1. Select **mem_used_percent** and choose **Select metric**.

    ![](/operational_excellence/media/alarm-memory-used.png)
    
1. Leave the defaults specified in the **Metric** section.
1. In the **Conditions** section, specify **Static**, **Greater**, and ```15```.

    ![](/operational_excellence/media/alarm-conditions.png)
    
    - **Note**: This configures the CloudWatch alarm to change to the ```Alarm``` state when memory usage exceeds 15%. For testing purposes in this workshop, 15% is being used. Outside of the workshop, you can specify a higher value.

1. Choose **Next**.
1. For **Notification**, choose **Remove**.
1. For **Systems Manager OpsCenter action**, choose **Add Systems Manager OpsCenter action**.
    1. Leave the default value for **Severity**.
    1. For **Category**, choose **Performance** from the drop-down list.

    ![](/operational_excellence/media/alarm-opsitem.png)

1. Choose **Next**.
1. For **Alarm name**, enter ```memory-used-alarm```.
1. For **Alarm description**, optionally enter a description such as ```This alarm is configured to trigger when memory usage exceeds 15%.```.

    ![](/operational_excellence/media/alarm-name.png)
    
1. Choose **Next**.
1. On the **Preview and create** page, reivew the inputs and choose **Create alarm**.

    ![](/operational_excellence/media/alarm-review.png)

### Trigger the CloudWatch alarm

To trigger the CloudWatch alarm for testing purposes we will use the ```stress``` Linux package via Run Command.

1. Open the Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Run Command**](https://console.aws.amazon.com/systems-manager/run-command).
1. Choose **Run Command**.
1. In the **Command document** section, search for **AWS-RunShellScript** and select the document **AWS-RunShellScript**.
1. In the **Command parameters** section, copy and paste the following commands:

    ```
    sudo amazon-linux-extras install epel -y
    sudo yum install stress -y
    stress -m 1 --vm-bytes 516M -t 1200s
    ```
    
1. For **Targets**, select **Choose instances manually** and choose the test Amazon Linux 2 EC2 instance.
1. Leave the remaining defaults and choose **Run** to begin the stress test.

In the command issued, the stress test will run for 1200s or 20 minutes. We can now navigate back to the CloudWatch alarm for [**memory-used-alarm**](https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#alarmsV2:alarm/memory-used-alarm?) and see the memory usage begin to spike in a few moments.

![](/operational_excellence/media/alarm-in-alarm-state.png)

### Review the OpsItem

Now that the CloudWatch alarm has been triggered, a corresponding OpsCenter OpsItem is created which we will now review.

1. Open the Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**OpsCenter**](https://console.aws.amazon.com/systems-manager/opsitems).
1. Choose the **OpsItems** tab and choose the OpsItem created by the CloudWatch Alarm.
1. Navigate through the various sections of the **Overview** tab to see details about the OpsItem and related resources.
    1. In the **Related resources** section, choose **Add**.
    1. In the **Add related resource** window, for **Resource type** choose  **AWS::EC2::Instance** from the drop-down menu and enter the EC2 instance ID.
    1. Choose **Add**.
1. Choose the **Related resource details** tab to see more information about the resource. Including details from **AWS Config** (if enabled) and **AWS CloudTrail**.
    
    - Expand the **Resource description** section to see the current CloudWatch alarm details.
    - Expand the **History** section to see the changes in the state of the alarm.
    
1. Choose **Next** for **Related resource** to see details about the EC2 instance which includes **CloudFormation stack resource** details.

### Resolve the OpsItem

In this workshop, we are aware that the stress test is causing the issue on the EC2 instance so we will initiate an Automation runbook to rebooot the instance to clear the stress test and resolve the issue.

1. Choose the **Overview** tab and perform the following steps:
    1. In the **Related resources** section, select the radio button for the EC2 instance.
    1. In the **Runbooks** section, enter ```AWS-RestartEC2Instance```, choose **AWS-RestartEC2Instance** from the list and choose **Execute**.
    
        ![](/operational_excellence/media/initiate-runbook.png)
    
    1. The EC2 instance ID will then be pre-populated since we previously selected it. Choose **Execute** to start the Automation runbook.
    
        ![](/operational_excellence/media/run-automation.png)
    
    1. You can view the direct results of the Automation runbook by choosing the **Execution ID** which will bring you to the Automation console.

1. Once the Automation runbook has completed, navigate back to the OpsItem to confirm the CloudWatch alarm status has returned to an **OK** state. You can then resolve the OpsItem by choosing **Set status** and choosing **Resolved**.

## Next Section

Click the link below to go to the next section.

[![](/operational_excellence/media/tear-down.png)](/operational_excellence/episode-01-step-03-tear-down.md)