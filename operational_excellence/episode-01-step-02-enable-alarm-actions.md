# Review CloudWatch alarms and enable alarm actions

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [View metrics gathered by CloudWatch agent](#view-metrics-gathered-by-cloudwatch-agent)
- [Next Section](#next-section)

## Summary

The following section discusses three primary topics:

- [Amazon CloudWatch Metric Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)
- [AWS Systems Manager OpsCenter](https://docs.aws.amazon.com/systems-manager/latest/userguide/OpsCenter.html)
- [AWS Systems Manager Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html)

A metric alarm watches a single CloudWatch metric or the result of a math expression based on CloudWatch metrics. The alarm performs one or more actions based on the value of the metric or expression relative to a threshold over a number of time periods. The action can be sending a notification to an Amazon SNS topic, performing an Amazon EC2 action or an Auto Scaling action, or creating a Systems Manager OpsItem.

OpsCenter, a capability of Systems Manager, provides a central location where operations engineers and IT professionals can view, investigate, and resolve operational work items (OpsItems) related to AWS resources. OpsCenter is designed to reduce mean time to resolution for issues impacting AWS resources. This Systems Manager capability aggregates and standardizes OpsItems across services while providing contextual investigation data about each OpsItem, related OpsItems, and related resources. OpsCenter also provides Systems Manager Automation documents (runbooks) that you can use to quickly resolve issues. You can specify searchable, custom data for each OpsItem. You can also view automatically-generated summary reports about OpsItems by status and source. 

Systems Manager Automation simplifies common maintenance and deployment tasks of Amazon EC2 instances and other AWS resources. Automation enables you to do the following:

- Build automations to configure and manage instances and AWS resources.
- Create custom runbooks or use pre-defined runbooks maintained by AWS.
- Receive notifications about Automation tasks and runbooks by using Amazon EventBridge.
- Monitor Automation progress and details by using the AWS Systems Manager console.

## Instructions

In this section you will (1) view the metrics in CloudWatch pushed by the CloudWatch agent, (2) create a CloudWatch alarm with OpsCenter integration, (3) use Run Command to trigger the alarm, (4) review the OpsItem created by the alarm in Systems Manager OpsCenter, and (5) resolve the OpsItem using Systems Manager Automation.

### View metrics gathered by CloudWatch agent

**To view the metrics pushed by CloudWatch agent**

1. Open the CloudWatch console at https://console.aws.amazon.com/cloudwatch.
1. In the navigation pane, choose **Metrics**.
1. Under **Custom Namespaces**, choose **CWAgent**.
1. Choose **CWAgent > ImageId, InstanceId, InstanceType, device, fstype, path**.
1. Choose a metric listed to display the disk used percentage metric on the graph. **Note**: You can select multiple metrics to be displayed at a single time.
    
    ![](/operational_excellence/media/cloudwatch-disk-used.png)

1. Return back to **CWAgent** and then choose **ImageId, InstanceId, InstanceType** to display the memeory used percentage metric.

    ![](/operational_excellence/media/cloudwatch-mem-used.png)
    
### Add an alarm action to create an OpsItem


### Review the OpsItem


### Resolve the OpsItem

## Next Section

Click the link below to go to the next section.

[![](media/define-freeze.png)](/episode-01-step-03-define-freeze.md)