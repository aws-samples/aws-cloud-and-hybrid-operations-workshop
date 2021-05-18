# Tear down workshop

![](media/config-aws-logo.png)

**Congratulations!**You have completed the **Episode 2: Manage and Track Application and Infrastructure Configuration Changes using AWS Config** workshop.

## Tear down instructions

### Delete EC2 Instance and Security Group

<details>
<summary><b>To delete the EC2 Instance and Security Group</b></summary><p>

1. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
1. In the navigation pane, choose **Instances**.
1. Select on the EC2 Instance that was created and Click **Instance state | Terminate Instance**.
1. Click the **Terminate** Button.
1. In the navigation pane, choose **Security Groups**.
1. Select the **workshop-securitygroup** Security Group and Click **Actions | Delete security groups**.
1. Click **Delete** Button
</p></details>

### Delete AWS Config Resources

<details>
<summary><b>Delete AWS Config Conformance Pack</b></summary><p>

1. Open the AWS Config console at https://console.aws.amazon.com/config/.
1. In the navigation pane, choose **Conformance packs**.
1. Select the Conformance pack and click **Actions | delete**.
1. Enter the phrase ```Delete``` to confirm this action and click **Delete**.
</p></details>
<details>
<summary><b>To delete the AWS Config rule</b></summary><p>

1. In the navigation pane, choose **Rules**.
1. Click on the **Rule**.
1. Under the **Remediation action section** click **Delete**.
1. Enter the phrase ```Delete``` to confirm this action and click **Delete**.
1. Click Actions | Delete rule.
1. Enter the phrase ```Delete``` to confirm this action and click **Delete**.
</p></details>

<details>
<summary><b>To disable AWS Config</b></summary><p>

1. In the navigation pane, choose **Settings**.
1. Click **Edit**.
1. Uncheck the **Enable recording** check box.
1. Click **Save**.
</p></details>

<details>
<summary><b>(Optional) To delete the Config recorder and Config delivery method</b></summary><p>

To delete the Config recorder and Config delivery channel, perform the following steps using AWS CloudShell:

From the AWS Management Console, you can launch AWS CloudShell by choosing the following options available on the navigation bar:

1. Choose the AWS CloudShell icon.
2. Start typing "cloudshell" in Search box and then choose the CloudShell option.

![](https://docs.aws.amazon.com/cloudshell/latest/userguide/images/launch_options.png)

1. To delete the Config recorder, enter the following command:
    
    ```aws configservice delete-configuration-recorder --configuration-recorder-name default```

1. To delete the Config delivery channel, enter the following command:

    ```aws configservice delete-delivery-channel --delivery-channel-name default```
    
1. Return to the AWS Config console to confirm Config is no longer enabled. If you see the **Set up AWS Config** page, then Config has successfully been disabled.

</p></details>

<details>
<summary><b>To delete configuration items stored by AWS Config</b></summary><p>

1. Open the Amazon S3 console at https://s3.console.aws.amazon.com/s3.
1. Choose the S3 bucket created by AWS Config Setup. The name will be similar to ```config-bucket-123456789012```.
1. Choose **Empty**.

    1. On the **Empty bucket** page, type **permanently delete** to confirm deletion of the objects in the S3 bucket.
    1. Choose **Empty**.

1. Choose the S3 bucket created by AWS Config Setup. The name will be similar to ```config-bucket-123456789012``.
1. Choose **Delete**.
    
    1. On the **Delete bucket** page, type the name of the S3 bucket to confirm deletion of the S3 bucket.
    1. Choose **Delete bucket**.

</p></details>

### Delete Cloudformation Stack for AWS Config Prerequisites

<details>
<summary><b>To delete the CloudFormation Stack</b></summary><p>

1. Open the AWS CloudFormation console at https://console.aws.amazon.com/cloudformation/.
1. Choose the stack created and click **Delete**.
1. Click **Delete Stack**.
</p></details>

## Next Section

Click the link below to go to the next episode, **Episode 3:  Implementing Observability with Amazon CloudWatch**.

[![](media/.png)](/episode-03-step-00.md)