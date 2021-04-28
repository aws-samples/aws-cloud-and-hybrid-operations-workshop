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



### Create a custom application

### View the custom application in Application Manager


## Next Section

You have now completed the workshop **Episode 3: Create Actionable Visibility for Enterprise Cloud Applications and Resources**.

Click the link below to go to the next section to tear down the resources created during the workshop.

[![](media/tear-down.png)](/episode-03-step-04-tear-down.md)