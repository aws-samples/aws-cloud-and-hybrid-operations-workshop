# Create Managed Instances

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Prerequisites](episode-03-step-00.md)
- [Instructions](#instructions)
    - [Enable System Manager](#)
    - [Configure System Manager Fleet Manager](#)
    - [Create a CloudWatch Alarm and track OpsItem](#)
    - [Check performance counters](#)
    - [Connect to the instance Using Session Manager](#)
    - [Troubleshoot the issue](#) 
    - [Fix the issue with Run Command](#)      
- [Next Episode](#next-section)

### Summary

You are going to launch an regular Windows instance and enable a script that will stress the instance CPU and consume CPU credits, if they are avaliable. Based on the alarm this action triggers, I will guide you how to troubleshoot that problem without RDPing into the instance. Additionally, we will explore some features such as the performance counters and registry explorer. If you ran the CloudFormation, skip to step 

In this section you will configure System Manager to manage (1) the instance you created in setup [setup](episode-03-step-00.md) step. I will guide you through configuring Fleet Manager with a custom KMS Key (2) and you will create an OpsItem and a CloudWatch Alarm (3) and explore the performance counters via Fleet Manager (4) then connect to dig a little deeper using Session Manager(5) and once the issue is identified you will fix it using Run Command(6). This is totally inspired in the following Blog post: https://aws.amazon.com/blogs/mt/troubleshoot-and-resolve-windows-workload-issues-using-aws-systems-manager-fleet-manager/ 

# Instructions

I will guide you through the Steps assuming you have all the required IAM permissions and have deployed the AMI provided in the previous [step](episode-03-step-00.md).



## Create a CloudWatch Alarm and OpsItem.


1. Download the helper json file from [here](../misc/put_metric_alarm.json).
1. Edit the downloaded file with you [ACCOUNT_ID] and [INSTANCE_ID] with your values
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

1. From an AWS CLI session, configure your cli with the credentials you created on the setup step.

1. Issue the following command.
```

aws cloudwatch put-metric-alarm --cli-input-json file://put_metric_alarm.json

```

Verify that the alarm was created successfully. 

To track CPU usage above the baseline, you might consider using the CPUUtilization metric. But depending on the size of the instance, the baseline utilization per vCPU varies from 5% to 40%. If you set an arbitrary threshold, you might wind up with too many or too few alerts.


1. Open the Amazon CloudWatch console, and from the left navigation pane, choose Alarms.

1. Locate and select the alarm named [INSTANCE_ID]-BurstableInstanceCPUCreditBalanceLow.

1. In Actions, confirm that a Systems Manager action is displayed.
    ![](/media/ep03-p16.png)

1. After a short period of time, the status of the alarm is OK, as shown.
    ![](/media/ep03-p17.png)

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
