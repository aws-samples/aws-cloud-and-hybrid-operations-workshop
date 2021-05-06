# Mitigate and respond to incidents

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

To go back to the previous section, click here: [Prepare for incidents using Incident Manager](/episode-05-step-01-enable-incident.md).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)

- [Next Section](#next-section)

## Summary

In this section you will (1)

## Instructions

### Trigger the incident

To trigger the CloudWatch alarm for testing purposes we will use the ```stress-ng``` Linux package via Session Manager.

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

![](/operational_excellence/media/alarm-in-alarm-state.png)

### Review the incident in Incident Manager

When the CloudWatch alarm changes to the ```Alarm``` state, an incident will automatically be created in Incident Manager using the response plan created in the first section [Prepare for incidents using Incident Manager](/episode-05-step-01-enable-incident.md)

### Resolve the incident



## Next Section

Click the link below to go to the next section.

[![](media/episode-05-step-03-post-incident.png)](/episode-05-step-03-post-incident.md)