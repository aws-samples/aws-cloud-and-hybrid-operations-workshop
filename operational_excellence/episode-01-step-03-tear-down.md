# Tear down workshop

![](media/ssm-aws-logo.png)

**Congratulations!** You have completed the **Episode 1: Introduction and building a foundation for enterprise cloud operations** workshop.

## Tear down instructions

### Disable AWS Config

<details>
<summary><b>To disable AWS Config</b></summary><p>

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Quick Setup**](https://console.aws.amazon.com/systems-manager/quick-setup).
1. Choose the **Config Recording** configuration created previously, choose **Actions**, and choose **Delete Configuration**.

    1. Choose **Remove all OUs and Regions**.
    1. This process will take a few moments to complete, once complete proceed with the next step.

1. Choose the **Config Recording** configuration, choose **Actions**, and choose **Delete configuration**.

    1. In the **Delete Configuration** window, type **delete**, and choose **Delete**.
    
After the configuration has successfully been removed. Proceed with the next steps.

1. Open the AWS Config console at https://console.aws.amazon.com/config.
1. In the navigation pane, choose [**Settings**](https://console.aws.amazon.com/config/home#/settings).
1. Choose **Edit**.
1. Uncheck **Enable recording** and choose **Save**.

    ![](/media/config-disable-recording.png)
    
1. You will then be returned to the AWS Config settings page where you should see **Recording is off** under **Recorder**.

    ![](/media/config-recorder-off.png)
</p></details>

<details>
<summary><b>(Optional) To delete the Config recorder and Config delivery method</b></summary><p>

To delete the Config recorder and Config delivery channel, perform the following steps using AWS CloudShell:

From the AWS Management Console, you can launch AWS CloudShell by choosing the following options available on the navigation bar:

1. Choose the AWS CloudShell icon.
1. Start typing "cloudshell" in Search box and then choose the CloudShell option.

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
1. Choose the S3 bucket created by Quick Setup. The name will be similar to ```aws-quick-setup-config-recording-123456789012-z5ajl```.
1. Choose **Empty**.

    1. On the **Empty bucket** page, type **permanently delete** to confirm deletion of the objects in the S3 bucket.
    1. Choose **Empty**.

1. Choose the S3 bucket created by Quick Setup. The name will be similar to ```aws-quick-setup-config-recording-123456789012-z5ajl```.
1. Choose **Delete**.
    
    1. On the **Delete bucket** page, type the name of the S3 bucket to confirm deletion of the S3 bucket.
    1. Choose **Delete bucket**.

</p></details>



### Delete Quick Setup Host Management configuration

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

### Delete Resource Data Sync resources

<details>
<summary><b>To delete the resource data sync</b></summary><p>

1. Open the Resource Data Sync console at https://console.aws.amazon.com/systems-manager/managed-instances/resource-data-sync.
1. Choose the resource data sync **YOURNAME-inventory-s3-sync** and choose **Delete**.
1. In the **Delete resource data sync** window, choose **Delete resource data sync**. 

**To delete the S3 bucket created for the resource data sync**

1. Open the Amazon S3 console at https://s3.console.aws.amazon.com/s3.
1. Choose the S3 bucket **YOURFIRSTNAME-sm-workshop** and choose **Empty**.

    1. On the **Empty bucket** page, type **permanently delete** to confirm deletion of the objects in the S3 bucket.
    1. Choose **Empty**.

1. Choose the S3 bucket **YOURFIRSTNAME-sm-workshop** and choose **Delete**.
    
    1. On the **Delete bucket** page, type the name of the S3 bucket to confirm deletion of the S3 bucket.
    1. Choose **Delete bucket**.
    
</p></details>

### Delete Systems Manager resources

<details>
<summary><b>To delete the Command document</b></summary><p>

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Documents**](https://console.aws.amazon.com/systems-manager/documents).
1. Choose the **Owned by me** tab.
1. Choose the document **org-install-app**, choose **Actions**, and choose **Delete document**.
1. In the **Delete document** window, choose **Delete**.

</p></details>

<details>
<summary><b>To delete the Change Calendar</b></summary><p>

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Change Calendar**](https://console.aws.amazon.com/systems-manager/change-calendar/).
1. Choose the calendar **YOURNAME-cal-open** and choose **Delete**.
1. In the **Delete calendar** window, choose **Delete**.

</p></details>

<details>
<summary><b>To delete the Automation document</b></summary><p>

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Documents**](https://console.aws.amazon.com/systems-manager/documents).
1. Choose the **Owned by me** tab.
1. Choose the document **yourname-stop-instances-check-calendar**, choose **Actions**, and choose **Delete document**.
1. In the **Delete document** window, choose **Delete**.

</p></details>

<details>
<summary><b>To delete the Parameter Store parameter</b></summary><p>

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Parameter Store**](https://console.aws.amazon.com/systems-manager/parameters).
1. Choose the parameter **CloudWatchAgent-AmazonLinux** and choose **Delete**.
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

## Next Section

Click the link below to go to the next episode, **Episode 2:  Enable compliance and monitoring: through config rules and conformance packs**.

[![](media/.png)](/episode-02-step-01.md)