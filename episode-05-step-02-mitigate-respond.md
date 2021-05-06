# Mitigate and respond to incidents

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

To go back to the previous section, click here: [Prepare for incidents using Incident Manager](/episode-05-step-01-enable-incident.md).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Simulate an incident](#simulate-an-incident)
    - [Review the incident](#review-the-incident)
    - [Remediate the issue](#remediate-the-issue)
    - [Add a custom timeline event](#add-a-custom-timeline-event)
- [Next Section](#next-section)

## Summary

In this section you will (1)

## Instructions

### Simulate an incident

To simulate an incident, you will use the ```stress-ng``` Linux package via Session Manager which will cause the Amazon CloudWatch alarm to go into an ```ALARM``` state, creating an incident. 

1. Open the Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Session Manager**](https://console.aws.amazon.com/systems-manager/session-manager/sessions).
1. Choose **Start session**.
1. In the **Target instances** section, choose the **SampleApp** instance
1. Choose **Start session** to establish a session and remotely connect.
1. Once the session has established, run the following commands to begin the stress test. These commands will install the ```stress-ng``` package to the SampleApp instance and simulate 70% CPU usage.

    ```
    sudo amazon-linux-extras install epel -y
    sudo yum install stress-ng -y
    sleep 10
    stress-ng -c 0 -l 70
    ```
    
    ![](media/begin-stress-test.png)

We can now navigate back to the [CloudWatch alarm console](https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#alarmsV2:alarm/?), choose the CPU spike alarm, and momentairly see the CPU usage begin to spike.

![](/media/alarm-in-alarm-state.png)

### Review the incident in Incident Manager

When the CloudWatch alarm changes to the ```Alarm``` state, an incident will automatically be created in Incident Manager using the response plan created in the first section [Prepare for incidents using Incident Manager](/episode-05-step-01-enable-incident.md)

1. Open the Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Incident Manager**](https://console.aws.amazon.com/systems-manager/incidents/home).
1. Open the incident created, ```[SampleApp] Performance Issues Detected [i-123456789012-CPU-Spike]```.
1. Review the **Summary** details which contains the description provided when creating the response plan and data provided by Amazon EventBridge with details about the event.

    - Optionally choose **Edit** to modify the summary details.

1. Review the **Recent timeline events**, to see when the event started and the cause.
1. The **Current runbook step** shows where you are in the overall procedure of the defined runbook.

### Review the runbook

1. Choose the **Runbook** tab to see the appropriate steps defined by the response plan.
1. The first step is to **Triage** the incident by using the **Metrics** tab.

### Triage and diagnose the issue

1. Choose the **Metrics** tab to review the metrics of the CloudWatch alarm which started the incident.

    - You can optionally modify the timeframe.

1. Choose **Add**.
1. In the **Add metrics** window, choose **From CloudWatch metrics**.
1. Copy and paste the following JSON metric source code to display the network IN/OUT on the SampleApp instance.

    - :exclamation: **Important** Replace ```[INSTANCE-ID]``` with the EC2 instance ID created by CloudFormation.

    ```
    {
        "view": "timeSeries",
        "stacked": false,
        "region": "us-east-1",
        "metrics": [
            [ "AWS/EC2", "NetworkIn", "InstanceId", "[INSTANCE-ID]" ],
            [ ".", "NetworkOut", ".", "." ]
        ]
    }
    ```

1. Navigate back to the **Runbook** tab and choose **Resume** to proceed to step 2: **Diagnosis**.
1. Choose the **Related items** tab to see the ARN of the CloudWatch alarm.
1. Choose **Add**.
1. In the **Add related item** windowm, enter the following details:
    
    - For **Title**, enter ```SampleApp Instance ID```
    - For **Type**, choose **Other**.
    - For **Detail**, 


1. Review the steps specified within the **Diagnosis** step and when prepared, choose **Resume** to move to step 3: **Mitigation**.

### Review the timeline

1. Choose the **Timeline** 

### Resolve the incident



## Next Section

Click the link below to go to the next section.

[![](media/episode-05-step-03-post-incident.png)](/episode-05-step-03-post-incident.md)