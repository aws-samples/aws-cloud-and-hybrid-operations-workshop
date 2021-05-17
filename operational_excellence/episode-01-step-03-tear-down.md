# Tear down workshop

![](media/ssm-aws-logo.png)

**Congratulations!** You have completed the **Episode 1: Using Amazon Systems Manager as a Foundation for Operationally Excellent Workloads** workshop.

## Tear down instructions

### Delete the CloudFormation stack

<details>
<summary><b>To delete the CloudFormation stack</b></summary><p>

1. Open the AWS CloudFormation console at https://console.aws.amazon.com/cloudformation/home.
1. In the navigation pane, choose **Stacks**.
1. Choose the stack **oe-workshop** and click **Delete**.
1. Choose **Delete stack**.

</p></details>

### Delete the CloudWatch alarm

<details>
<summary><b>To delete the CloudWatch alarm</b></summary><p>

1. Open the Amazon CloudWatch console at https://console.aws.amazon.com/cloudwatch/home.
1. In the navigation pane, choose **Alarms**.
1. Choose the alarm previously created **memory-used-alarm**, choose **Actions**, and choose **Delete**.

</p></details>

### Delete Systems Manager resources

<details>
<summary><b>To delete the Parameter Store parameter</b></summary><p>

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Parameter Store**](https://console.aws.amazon.com/systems-manager/parameters).
1. Choose the parameter **AmazonCloudWatch-linux** and choose **Delete**.
1. In the **Delete parameters** window, choose **Delete parameters**.

</p></details>

<details>
<summary><b>To delete the State Manager associations</b></summary><p>

1. Open the Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**State Manager**](https://console.aws.amazon.com/systems-manager/state-manager).
1. Choose the radio button next to the association named **CloudWatchAgent-Install** and choose **Delete**.
1. In the **Delete association** window, choose **Delete**.
1. Repeat this process for the association named **CloudWatchAgent-Configure**.

</p></details>