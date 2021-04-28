# View and take action on operational data in the context of an application

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [View operational data using the Explorer dashboard](#view-operational-data-using-the-explorer-dashboard)
    - [Create a custom application](#create-a-custom-application)
    - [View the custom application in Application Manager](#view-the-custom-application-in-application-manager)
- [Next Episode](#next-section)

## Summary

In this section of the workshop, we will review the AWS Systems Manager capabilities: **Explorer** and **Application Manager**.

**AWS Systems Manager Explorer** is a customizable operations dashboard that reports information about your AWS resources. Explorer displays an aggregated view of operations data (OpsData) for your AWS accounts and across Regions. Explorer retrieves OpsData from the following sources:

- **Amazon Elastic Compute Cloud (Amazon EC2)**: Data displayed in Explorer includes: total number of instances, total number of managed and unmanaged instances, and a count of instances using a specific Amazon Machine Image (AMI).
- **Systems Manager OpsCenter**: Data displayed in Explorer includes: a count of OpsItems by status, a count of OpsItems by severity, a count of open OpsItems across groups and across 30-day time periods, and historical data of OpsItems over time.
- **Systems Manager Patch Manager**: Data displayed in Explorer includes a count of instances that aren't patch compliant.
- **AWS Trusted Advisor**: Data displayed in Explorer includes: status of best practice checks for EC2 reserved instances in the areas of cost optimization, security, fault tolerance, performance, and service limits.
- **AWS Compute Optimizer**: Data displayed in Explorer includes: a count of Under provisioned and Over provisioned EC2 instances, optimization findings, on-demand pricing details, and recommendations for instance type and price.
- **AWS Support Center cases**: Data displayed in Explorer includes: case ID, severity, status, created time, subject, service, and category.
- **AWS Config**: Data displayed in Explorer includes: overall summary of compliant and non-compliant AWS Config rules, the number of compliant and non-compliant resources, and specific details about each (when you drill down into a non-compliant rule or resource).
- **AWS Security Hub**: Data displayed in Explorer includes: overall summary of Security Hub findings, the number of each finding grouped by severity, and specific details about finding.
    
**AWS Systems Manager Application Manager** helps DevOps engineers investigate and remediate issues with their AWS resources in the context of their applications. Application Manager aggregates operations information from multiple AWS services and Systems Manager capabilities to a single AWS Management Console.

In Application Manager, an application is a logical group of AWS resources that you want to operate as a unit. This logical group can represent different versions of an application, ownership boundaries for operators, or developer environments, to name a few.

## Instructions

### View operational data using the Explorer dashboard

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Explorer**](https://console.aws.amazon.com/systems-manager/explorers).
1. Choose **Dashboard actions** and choose **Configure dashboard**.
    - On the resulting page, you can see the various OpsData sources and widgets for Explorer.
    - Choose the radio button for each OpsData source to see the corresponding widgets available. Depending on the services you have enabled within your account, you may choose to enable additional sources.
    
    ![](/media/episode-03-explorer-configure.png)

1. Choose the **Explorer settings** tab.
    - In the **Explorer settings** tab, you can review the default rules for OpsItems and custom rules created. You can also configure data export as a CSV file for Explorer OpsData to an Amazon Simple Storage Service (S3) bucket.
    - You can also create a **Resource Data Sync** for Explorer which will aggregate OpsData from other accounts/Regions within your AWS Organization. For the purpose of this workshop, we will not create a resource data sync. However, for more information on setting up Explorer to aggregate data see, [Setting up Systems Manager Explorer to display data from multiple accounts and Regions ](https://docs.aws.amazon.com/systems-manager/latest/userguide/Explorer-resource-data-sync.html).

1. Navigate back to the **Explorer** dashboard at https://console.aws.amazon.com/systems-manager/explorer.
    - Scroll through the dashboard to see the various widgets available.
    - Each widget can be customized to modify the shape and size of the widget as well as the location of each widget. Take time to move around the widgets to bring the most relevant widgets to the top.
    - **Note**: Widgets that are not enabled or the corresponding service is not enabled, will show the status message **No data to display**. To troubleshoot in a real-world environment, see [Troubleshooting Explorer](https://docs.aws.amazon.com/console/systems-manager/Explorer-troubleshooting).
    
To see an example of a real-world Explorer dashboard with all OpsData widgets enabled, expand the following section.

<details>
<summary><b>Example Explorer Dashboard</b></summary><p>

![](/media/episode-03-example-explorer.png)

</p></details>

### Create a custom application

To view the CloudWatch alarm, OpsCenter OpsItem, and our CloudFormation stack resources within Application Manager, we will create a Resource Group which in turn can be viewed as a custom application in Application Manager.

**To create a Resource Group**

1. Open the AWS Resource Groups console at https://console.aws.amazon.com/resource-groups/home.
1. In the navigation pane, choose [**Create Resource Group**](https://console.aws.amazon.com/resource-groups/groups/new) or choose **Create resource group**.
1. For **Group type** choose **Tag based**.
1. In the **Grouping criteria** section, perform the following steps:
    - For **Resource types**, ensure **All supported resource types** is selected.
    - For **Tag key**, enter ```SSMWorkshop```.
    - For **Tag value**, enter ```true```.
    - Choose **Add**.
    - Choose **Preview group resources**. You should see seven (7) resources listed.
    
    ![](/media/episode-03-resource-group.png)
    
1. In the **Group details** section, perform the following steps:
    - For **Group name**, enter ```SSMWorkshop```.
    - For **Group description**, optionally enter a description such as ```Resources created during the Systems Manager workshop```.
1. Choose **Create group**.

You will be brought to the saved resource group page for the new custom resource group and can continue with the next steps.

### View the custom application in Application Manager

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/home.
1. In the navigation pane, choose [**Application Manager**](https://console.aws.amazon.com/systems-manager/appmanager).
1. Choose the **Applications** tab.
1. Choose **Custom applications** and then choose the **SSMWorkshop** custom application.

    ![](/media/episode-03-custom-application.png)

1. You will be brought to the **Overview** screen for your custom application **SSMWorkshop** where you can view the current CloudWatch alarms, OpsItems, and runbooks pertaining to the resources in the group.

    ![](/media/episode-03-app-overview.png)
    
1. Navigate between the various tabs, **Resources**, **Compliance**, **Monitoring**, **OpsItems**, **Logs**, and **Runbooks** to see information that is aggregated about the resources in the custom application.

    - **Note**: The **Compliance** tab will show ```Insufficient data``` for AWS Config resource compliance if you have not enabled AWS Config previously. Additionally, if you did not use **Quick Setup** then you may not have data for **Associations compliance**.

<details>
<summary><b>Resources tab</b></summary><p>

![](/media/episode-03-resources-tab.png)

</p></details>

<details>
<summary><b>Compliance tab</b></summary><p>

![](/media/episode-03-compliance-tab.png)

</p></details>

<details>
<summary><b>Monitoring tab</b></summary><p>

![](/media/episode-03-monitoring-tab.png)

</p></details>

<details>
<summary><b>OpsItem tab</b></summary><p>

![](/media/episode-03-opsitems-tab.png)

</p></details>



## Next Section

You have now completed the workshop **Episode 3: Create Actionable Visibility for Enterprise Cloud Applications and Resources**.

Click the link below to go to the next section to tear down the resources created during the workshop.

[![](media/tear-down.png)](/episode-03-step-04-tear-down.md)