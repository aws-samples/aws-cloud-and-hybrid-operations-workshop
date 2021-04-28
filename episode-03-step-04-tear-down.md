# Tear down workshop

![](media/ssm-aws-logo.png)

**Congratulations!** You have completed the **Episode 3: Create Actionable Visibility for Enterprise Cloud Applications and Resources** workshop.

## Tear down instructions

### Delete the Quick Setup Host Management configuration

<details>
<summary><b>To delete the Quick Setup Host Management</b></summary><p>

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Quick Setup**](https://console.aws.amazon.com/systems-manager/quick-setup).
1. Choose the **Host Management** configuration created previously, choose **Actions**, and choose **Delete Configuration**.

    1. Choose **Remove all OUs and Regions**.
    1. This process will take a few moments to complete, once complete proceed with the next step.

1. Choose the **Host Management** configuration, choose **Actions**, and choose **Delete configuration**.

    1. In the **Delete Configuration** window, type **delete**, and choose **Delete**.

</p></details>

### Delete the CloudWatch alarm

<details>
<summary><b>To delete the CloudWatch alarm</b></summary><p>

1. Open the Amazon CloudWatch console at https://console.aws.amazon.com/cloudwatch/home.
1. In the navigation pane, choose **Alarms**.
1. Choose the alarm previously created **i-123456789012-BurstableInstanceCPUCreditBalanceLow**, choose **Actions**, and choose **Delete**.

</p></details>

### Delete the CloudFormation stack

<details>
<summary><b>To delete the CloudFormation stack</b></summary><p>

1. Open the AWS CloudFormation console at https://console.aws.amazon.com/cloudformation/home.
1. In the navigation pane, choose **Stacks**.
1. Choose the stack **ssm-workshop-ep03** and click **Delete**.
1. Choose **Delete stack**.

</p></details>

### Manually terminate the EC2 instances

<details>
<summary><b>To delete the CloudFormation stack</b></summary><p>

**To manually terminate the EC2 Instance**

1. Open the AWS CloudFormation console at https://console.aws.amazon.com/ec2/v2/home.
1. In the navigation pane, choose **Instances**.
1. Choose the **TestWindowsInstance**, choose **Instance state**, and choose **Terminate instance**.

</p></details>

### Delete the Resource Group

<details>
<summary><b>To delete the Resource Group</b></summary><p>

**To manually terminate the EC2 Instance**

1. Open the AWS Resource Group console at https://console.aws.amazon.com/resource-groups/home.
1. In the navigation pane, choose **Saved Resource Groups**.
1. Choose the **SSMWorkshop** and choose **View details**.
1. Choose **Delete**.

</p></details>


## Next Section

Click the link below to go to the next episode, **Episode 4: Automating Changes and Preventative Maintenance in an Enterprise / Cloud Environment**.

[![](media/.png)](/episode-04-step-01.md)

## Special Thanks

This workshop is inspired in part by the following AWS Management & Governance blog post: 
[Troubleshoot and resolve Windows workload issues using AWS Systems Manager Fleet Manager](https://aws.amazon.com/blogs/mt/troubleshoot-and-resolve-windows-workload-issues-using-aws-systems-manager-fleet-manager/)