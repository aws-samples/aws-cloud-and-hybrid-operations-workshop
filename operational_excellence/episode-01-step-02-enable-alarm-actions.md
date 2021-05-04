# Review CloudWatch alarms and enable alarm actions

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)

- [Next Section](#next-section)

## Summary

create a CloudWatch alarm, (7) review the Systems Manager OpsCenter OpsItem created by the alarm, and (8) resolve the OpsItem using Systems Manager Automation.

## Instructions

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