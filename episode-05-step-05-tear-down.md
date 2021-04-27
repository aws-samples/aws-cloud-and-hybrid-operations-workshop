# Tear down workshop

![](media/ssm-aws-logo.png)

**Congratulations!** You have completed the **Episode 5: Reactive ops and automation** workshop.

## Tear down instructions

**To disable AWS Config**

**To delete the Quick Setup Host Management**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Quick Setup**](https://console.aws.amazon.com/systems-manager/quick-setup).
1. Choose the **Host Management** configuration created previously, choose **Actions**, and choose **Delete Configuration**.

    1. Choose **Remove all OUs and Regions**.
    1. This process will take a few moments to complete, once complete proceed with the next step.

1. Choose **Actions** and choose **Delete configuration**.

    1. In the **Delete Configuration** window, type **delete**, and choose **Delete**

**To delete the resource data sync**

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

**To delete the Command document**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Documents**](https://console.aws.amazon.com/systems-manager/documents).
1. Choose the **Owned by me** tab.
1. Choose the document **org-install-app**, choose **Actions**, and choose **Delete document**.
1. In the **Delete document** window, choose **Delete**.

**To delete the Change calendar**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Change Calendar**](https://console.aws.amazon.com/systems-manager/change-calendar/).
1. Choose the calendar **YOURNAME-cal-open** and choose **Delete**.
1. In the **Delete calendar** window, choose **Delete**.

**To delete the Automation document**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Documents**](https://console.aws.amazon.com/systems-manager/documents).
1. Choose the **Owned by me** tab.
1. Choose the document **yourname-stop-instances-check-calendar**, choose **Actions**, and choose **Delete document**.
1. In the **Delete document** window, choose **Delete**.

**To delete the Parameter Store parameter**

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Parameter Store**](https://console.aws.amazon.com/systems-manager/parameters).
1. Choose the parameter **CloudWatchAgent-AmazonLinux** and choose **Delete**.
1. In the **Delete parameters** window, choose **Delete parameters**.

**To delete the State Manager associations**

1. Open the Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**State Manager**](https://console.aws.amazon.com/systems-manager/state-manager).
1. Choose the radio button next to the association named **CloudWatchAgent-Install** and choose **Delete**.
1. In the **Delete association** window, choose **Delete**.
1. Repeat this process for the association named **CloudWatchAgent-Configure**.

## Next Section

Click the link below to go to the next episode, **Episode 2:  Enable compliance and monitoring: through config rules and conformance packs**.

[![](media/.png)](/episode-02-step-01.md)