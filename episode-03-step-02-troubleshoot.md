# Troubleshoot and resolve workload issues

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Create a CloudWatch Alarm and track OpsItem](#)
    - [Check performance counters](#)
    - [Connect to the instance Using Session Manager](#)
    - [Troubleshoot the issue](#) 
    - [Fix the issue with Run Command](#)      
- [Next Episode](#next-section)

### Summary

Now that you created the required test resources for this workshop, you are now going to create a CloudWatch alarm to monitor CPU usage on the test Windows EC2 instance. The alarm will trigger the creation of an OpsCenter OpsItem which can be used to effectively troubleshoot any issues. After the alarm has been created, you then reboot the test Windows instance to initiate the CPU stress test on the instance and consume CPU credits, if they are avaliable. You will then troubleshoot and resolve the problem without having to remotely connect to the instance using a combination of Fleet Manager, Session Manager, and Run Command. Additionally, you will explore other features of Fleet Manager, Application Manager, and Explorer to bring visibility in the context of an application.

## Instructions

### Create a CloudWatch Alarm with OpsCenter Integration

1. Open the CloudWatch Alarm configuration JSON at [put_metric_alarm.json](misc/put_metric_alarm.json).
1. Choose **Raw**.

    ![](/media/github-raw.png)

1. Open Notepad and copy the entire text.
1. In the copied text, perform the following steps:
    - Replace ```[INSTANCE_ID]``` with the EC2 instance ID created in [Step 01: Set up the workshop environment](/episode-03-step-01-initial-setup.md).
    - Replace ```[ACCOUNT_ID]``` with the AWS account ID that you are using. **Note**: You can click your IAM user name or role in the upper-right corner to see your AWS account ID.

    ![](/media/episode-03-account-id.png)

    ```
    {
        "AlarmName": "[INSTANCE_ID]-BurstableInstanceCPUCreditBalanceLow",
        "AlarmDescription": "Burstable instance type cpu credit balance approaching zero",
        "ActionsEnabled": true,
        "AlarmActions": [
            "arn:aws:ssm:us-east-1:[ACCOUNT_ID]:opsitem:2#CATEGORY=Cost"
        ],
        "MetricName": "CPUCreditBalance",
        "Namespace": "AWS/EC2",
        "Statistic": "Average",
        "Dimensions": [
            {
                "Name": "InstanceId",
                "Value": "[INSTANCE_ID]"
            }
        ],
        "Period": 300,
        "EvaluationPeriods": 1,
        "Threshold": 5,
        "ComparisonOperator": "LessThanThreshold"
    }
    ```

1. Save the file to your local machine as ```put_metric_alarm.json```.

To create the CloudWatch alarm, we will use AWS CloudShell. From the AWS Management Console, you can launch AWS CloudShell by choosing the following options available on the navigation bar:

1. Choose the AWS CloudShell icon.
1. Start typing "cloudshell" in Search box and then choose the CloudShell option.

    ![](https://docs.aws.amazon.com/cloudshell/latest/userguide/images/launch_options.png)

1. Once the CloudShell session has been established, choose **Actions** and choose **Upload file**.
1. Choose **Select file**, navigate to the local ```put_metric_alarm.json``` file you created, choose **Open**, and choose **Upload**.
    - **Note**: The ```put_metric_alarm.json``` file will be uploaded to the directory ```/home/cloudshell-user```.

1. To create the CloudWatch alarm using the JSON configuration file, enter the following command:
    ```
    aws cloudwatch put-metric-alarm --cli-input-json file://put_metric_alarm.json
    ```

1. To verify the CloudWatch alarm has been created successfully, you can run the command:

    ```
    aws cloudwatch describe-alarms --alarm-prefix-name i-
    ```
    
    ![](/media/episode-03-cloudshell-describe.png)

To track CPU usage above the baseline, you might consider using the CPUUtilization metric. But depending on the size of the instance, the baseline utilization per vCPU varies from 5% to 40%. If you set an arbitrary threshold, you might wind up with too many or too few alerts.


1. Open the Amazon CloudWatch console, and from the left navigation pane, choose Alarms.

1. Locate and select the alarm named [INSTANCE_ID]-BurstableInstanceCPUCreditBalanceLow.

1. In Actions, confirm that a Systems Manager action is displayed.
    ![](/media/ep03-p16.png)

1. After a short period of time, the status of the alarm is OK, as shown.
    ![](/media/ep03-p17.png)
    
### Reboot the test Windows EC2 instance

1. Reboot the instance so the script you installed through user data can be triggered and proceed to the next session.

### Track OpsItem using Systems Manager OpsCenter

1. Go to System Manager console and Choose OpsCenter, you should see the following
    ![](/media/ep03-p18.png)

### Check performance counters
1. Navigate back to Fleet Manager and check instance's Performance Counters
    ![](/media/ep03-p20.png)

1. If you followed this guide throughly, you will see the instance with consistent 50% CPU Utilization.
    ![](/media/ep03-p21.png)

### Connect to the instance Using Session Manager

1. On the top right, click **Instance actions** and then **Start session**
    ![](/media/ep03-p22.png)

1. This will open a Powershell session into the instance.
    ![](/media/ep03-p23.png)

### Troubleshoot the issue

1. Type the following commands 

```

Get-Process | Sort CPU -descending | Select -first 5 -Property ID,ProcessName,CPU, TotalProcessorTime | format-table -autosize

```
It will show you the top 5 processes using CPU and causing the CPU to above the 40% baseline.

1. Connect to the process to check it by typing:

```
Enter-PSHostProcess -Id pid
```

1. List the Runspaces and debug it using the Powershell Debugger by issuing

```
Get-Runspace
Debug-Runspace -Id 1
```
1. Once attached to the process, check the lines of code by typing:

```
list 1
```
1. You are going to see a little message from our Developer.
    
    ![](/media/ep03-p24.png)

**Congratulations! You've found the issue!**

### Fix the issue with Run Command
In order to change the above-mentioned Registry key, you can both use Fleet Manager or a simple **Run Command** which is the approach we are going to take.

1. Go the back to Systems Manager console.
1. Scroll down the left menu until you find **Run Command**, click it.
1. Click the orange button **Run Command**.
1. In the search field, add filters for Document type: Command and Search: **SetWindows**
    ![](/media/ep03-p25.png)

1. Set the values according to the screenshot.
    ![](/media/ep03-p26.png)

1. Select your managed instance as target
    ![](/media/ep03-p27.png)
1. Uncheck both Output options.
1. Click **Run**.
1. Once the execution is completed, go back to the performance counters in the fleet manager.
1. You should see your CPU Back to below 40%.
1. **Congratulations!!!** The issue is resolved without the need to log into the instance.

## Next Section

You have now completed the workshop **Episode 3: Create Actionable Visibility for Enterprise Cloud Applications and Resources**.

Click the link below to go to the next section to tear down the resources created during the workshop.

[![](media/tear-down.png)](/episode-03-step-03-tear-down.md)
