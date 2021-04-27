# Troubleshoot and resolve workload issues

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Create a CloudWatch alarm with OpsCenter integration](#create-a-cloudwatch-alarm-with-opscenter-integration)
    - [View the CloudWatch alarm in the CloudWatch console](#view-the-cloudwatch-alarm-in-the-cloudwatch-console)
    - [Reboot the test Windows EC2 instance](#reboot-the-test-windows-ec2-instance)
    - [Track OpsItem using Systems Manager OpsCenter](#track-opsitems-using-systems-manager-opscenter)
    - [Check performance counters](#check-performance-counters)
    - [Connect to the instance Using Session Manager](#connect-to-the-instance-using-session-manager)
    - [Use PowerShell to determine process CPU usage](#use-powershell-to-determine-process-cpu-usage)
    - [Fix the issue with Run Command](#fix-the-issue-with-run-command)  
- [Next Episode](#next-section)

### Summary

Now that you created the required test resources for this workshop, you are now going to create a CloudWatch alarm to monitor CPU usage on the test Windows EC2 instance. The alarm will trigger the creation of an OpsCenter OpsItem which can be used to effectively troubleshoot any issues. After the alarm has been created, you then reboot the test Windows instance to initiate the CPU stress test on the instance and consume CPU credits, if they are avaliable. You will then troubleshoot and resolve the problem without having to remotely connect to the instance using a combination of Fleet Manager, Session Manager, and Run Command. Additionally, you will explore other features of Fleet Manager, Application Manager, and Explorer to bring visibility in the context of an application.

## Instructions

### Create a CloudWatch alarm with OpsCenter integration

**To save the CloudWatch alarm configuration file locally**

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

**To create the CloudWatch alarm using CloudShell**

To create the CloudWatch alarm, we will use AWS CloudShell. From the AWS Management Console, you can launch AWS CloudShell by choosing the following options available on the navigation bar:

1. Choose the AWS CloudShell icon.
1. Start typing "cloudshell" in Search box and then choose the CloudShell option.

    ![](https://docs.aws.amazon.com/cloudshell/latest/userguide/images/launch_options.png)

1. Once the CloudShell session has been established, choose **Actions** and choose **Upload file**.

    ![](/media/episode-03-cloudshell-upload.png)

1. Choose **Select file**, navigate to the local ```put_metric_alarm.json``` file you created, choose **Open**, and choose **Upload**.
    - **Note**: The ```put_metric_alarm.json``` file will be uploaded to the directory ```/home/cloudshell-user```.

1. To create the CloudWatch alarm using the JSON configuration file, enter the following command:
    ```
    aws cloudwatch put-metric-alarm --cli-input-json file://put_metric_alarm.json
    ```

1. To verify the CloudWatch alarm has been created successfully, you can run the command:

    ```
    aws cloudwatch describe-alarms --alarm-name-prefix i-
    ```
    
    ![](/media/episode-03-cloudshell-describe.png)

To track CPU usage above the baseline, you may consider using the CPUUtilization metric. However, depending on the size of the instance the baseline utilization per vCPU varies between 5% and 40%. If you set an arbitrary threshold, you might wind up with too many or too few alerts.

### View the CloudWatch alarm in the CloudWatch console**

1. Open the **Amazon CloudWatch** console at https://console.aws.amazon.com/cloudwatch/home.
1. In the left navigation pane, choose **Alarms**.
1. Select the alarm created above ```[INSTANCE_ID]-BurstableInstanceCPUCreditBalanceLow``` to view details about the alarm.
1. Scroll down to the **Actions** section and confirm that the Systems Manager action is displayed.

    ![](/media/ep03-p16.png)

1. After a short period of time, the status of the alarm will change to ```OK``` as seen in the below screenshot.

    ![](/media/ep03-p17.png)
    
### Reboot the test Windows EC2 instance

Now that the CloudWatch alarm has been configured to monitor CPU credits, we will reboot the test Windows EC2 instance to initiate the CPU stress test which will consume CPU credits.

**To reboot the test Windows EC2 instance

1. Open the **Amazon EC2** console at https://console.aws.amazon.com/ec2/v2/home.
1. In the left navigation pane, choose **Instances**.
1. Select the ```TestWindowsInstance```, choose **Instance state**, and choose **Reboot instance**.
1. Choose **Reboot**.

After a brief amount of time, the CloudWatch alarm will change to the ```In alarm``` state as the stress test script is bursting CPU usage which is in turn consuming CPU credits for the test instance.

### Track OpsItem using Systems Manager OpsCenter

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**OpsCenter**](https://console.aws.amazon.com/systems-manager/opsitems).
1. Following the CloudWatch alarm changing to the ```In alarm``` state, you will then see an OpsItem created within OpsCenter.

    ![](/media/ep03-p18.png)
    
1. Choose the **OpsItem** tab.
1. Choose the **OpsItem** created by the **CloudWatch alarm** to view operational data details related to the alarm.
1. Expand the **OpsItem details** section to see details about the OpsItem.

    ![](/media/episode-03-opsitem-details.png)

1. Choose the **Related resource details** to view aggregated data from various AWS services.
1. For **Related resource**, leave the default resource of the CloudWatch alarm selected and expand the **Resource description** and **History** sections to see more details.
1. Once complete, change the **Related resource** to the EC2 instance ID.
    - You can then expand the sections **CloudWatch Metrics**, **Resource description**, **Tags**, **Current CloudWatch alarms**, **CloudTrail logs**, and **CloudFormation stack resources** to see more details about the EC2 instance from a single console.

### Check performance counters

To get additional insight into the current OS-level performance metrics of the EC2 instance, you can use **Fleet Manager**.

**To check performance metrics**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Fleet Manager**](https://console.aws.amazon.com/systems-manager/managed-instances).
1. Select the radio button next to the test instance created previously, choose **Instance actions**, and choose **View performance counters**.
    
    ![](/media/episode-03-view-counters.png)

1. After a moment, you will see that the **CPU utilization** by the instance is approximately 50%.

    ![](/media/episode-03-performance-counters.png)

### Connect to the instance using Session Manager

To continue troubleshooting, we will connect to the test Windows EC2 instance using Session Manager in order to determine which processes are consuming CPU resources.

**To connect to the instance using Session Manager**

1. In the top-right, choose **Instance actions** and then **Start session**.
    
    ![](/media/episode-03-start-session.png)

1. You will then be connected to the test Windows EC2 instance and a PowerShell session will be started.
    
    ![](/media/episode-03-powershell-session.png)

### Use PowerShell to determine process CPU usage

1. In the Session Manager session, enter the following command:

    ```
    Get-Process | Sort CPU -descending | Select -first 5 -Property ID,ProcessName,CPU, TotalProcessorTime | format-table -autosize
    ```

    - This command will return the top 5 processes using CPU and causing the CPU to above the 40% baseline. Take note of the first item returned with the **ProcessName** ```powershell```.
    
    ![](/media/episode-03-get-process.png)

1. Using the ```Id``` noted previously, replace ```pid``` in the below command to connect to the PowerShell process for additional review:

    ```
    Enter-PSHostProcess -Id pid
    ```
    
    - Example ```Enter-PSHostProcess``` where the Id value is ```3540```.
    
    ![](/media/episode-03-pid.png)

1. List the Runspaces and enter debugging mode using the Powershell Debugger by entering the following commands:

    ```
    Get-Runspace
    Debug-Runspace -Id 1
    ```
    
    ![](/media/episode-03-debug.png)

1. Once connected to the process, check the lines of code by entering the command:

    ```
    list 1
    ```

1. You can then see a message from the developer of the script. Where it is noted that the script should not be terminated, however, logging can be turned off which will reduce CPU consumption and resolve the issue.
    
    ![](/media/episode-03-message.png)

**Congratulations! You've found the issue!**

### Fix the issue with Run Command

In order to change the Windows registry key mentioned in the developer's message, you can use **Fleet Manager** or **Run Command**. In this case we will use **Run Command**.

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Run Command**](https://console.aws.amazon.com/systems-manager/run-command).
1. Choose **Run a Command**.
1. In the search field, add filters for ```Document name prefix: Equals: AWSFleetManager-Set``` to select the ```AWSFleetManager-SetWindowsRegistryValue```.

    ![](/media/episode-03-set-registry.png)

1. In the **Command parameters** section, perform the following steps:
    1. For **Path**, enter ```HKLM:\SOFTWARE\benfelip```.
    1. For **Name**, enter ```CrazyLogs```.
    1. For **Kind**, choose **DWord** from the drop-down list.
    1. For **Value**, enter ```0```.
    1. For **Perform Action**, choose **Yes** from the drop-down list.

    ![](/media/episode-03-command-parameters.png)

1. In the **Targets** section, select **Choose instances manually** and choose the test Windows EC2 instance.

    ![](/media/episode-03-target-instance.png)

1. Uncheck the option for **Enable an S3 bucket** in the **Output options** section.
1. Choose **Run**.
1. Once the execution is completed, go back to the performance counters in the [**Fleet Manager**](https://console.aws.amazon.com/systems-manager/managed-instances).
1. Choose the test Windows EC2 instance, choose **Instance actions**, and choose **View performance counters**.

Now that the Windows registry key has been changed and logging has been disabled, you should see your CPU return to below 40%.

**Congratulations!** The issue is resolved without having to remotely connect using Remote Desktop (RDP) to the instance.

Now that the issue is resolved, we can return to OpsCenter and resolve the OpsItem originally created. However, before the OpsItem is resolved we will navigate to the **Application Manager** and **Explorer** capabilities of **Systems Manager** to view the CloudWatch alarm and OpsItem in the context of our test Windows EC2 instance application.

## Next Section

You have now completed the workshop **Episode 3: Create Actionable Visibility for Enterprise Cloud Applications and Resources**.

Click the link below to go to the next section to tear down the resources created during the workshop.

[![](media/tear-down.png)](/episode-03-step-03-tear-down.md)
