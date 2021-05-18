# AWS Config Deploy Conformance Pack 

![](media/config-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Deploy conformance pack](#deploy-conformance-pack)
    - [View compliance remediation](#view-compliance-remediation)
- [Next Section](#next-section)

## Summary

A conformance pack is a collection of AWS Config rules and remediation actions that can be easily deployed as a single entity in an account and a Region or across an organization in AWS Organizations. 

In this section you will (1) create an conformance pack with remediation to evaluate your S3 buckets accoriding to S3 Best Practices, and (2) use AWS Systems Manager Automation Documents to remediate non-compliant S3 Buckets.

## Instructions

### Deploy conformance pack 

Before we can deploy the conformance pack, we will need to edit it. Conformance packs that AWS provides represent collated best practices, however they are not “one size fits all” and need some tailoring before being leveraged.

1.	First, download the conformance pack template from this [link](cfntemplates/Operational-Best-Practices-for-Amazon-S3-with-Remediation.yml). - Operational-Best-Practices-for-Amazon-S3-with-Remediation
1.	Next edit this file so we can make it usable with your lab environment. You will need to replace the ```<Account-Id>``` entries with the proper account number for your account (without dashes). You will find this entry on these line numbers:
    -   43
    -   80
    -   139
    -   179
1.	Go to the [Config Console](https://console.aws.amazon.com/config), and then click on Conformance packs.
1.	Click on Deploy conformance pack on the top right of the page.

    ![](/media/config-conformancepack1-ep02.png)

1.	Under template details, select Upload template, and then select the Upload a template. Click Choose file, upload your modified template, and finally click Next.
1.	Give the conformance pack a name that is meaningful to you. - Workshop-Operational-S3-BestPractices-WithRemediation
1.	This conformance pack will require a parameter to function. Click Add parameter and then add a new key called ```S3TargetBucketNameForEnableLogging```.
    -   The value for this will be the name of the ```s3serversideloggingbucket``` created by the CloudFormation stack you deployed in the prerequisites. Copy the name of the bucket into the value field.
1.	Click Next, and finally click Deploy conformance pack.

    ![](/media/config-conformancepack2-ep02.png)

### View compliance remediation 

We will check compliance status for each rule in conformance pack and associated resources. Conformance Packs can also be deployed to an AWS Organization; however, this is out of scope for this lab.

1.	Once the conformance pack is deployed, click on conformance pack name to drill down into details. You can view list of rules and their compliance status.

    ![](/media/config-conformancepack3-ep02.png)

1.	Click on a rule name to see its details.
1.	Expand Resources in Scope section to see resources in scope and their compliance status. If there are any existing non-compliant resources, you can manually remediate them or wait for auto-remediation to complete.
1.	To see auto-remediation in action on a new resource, create a new S3 bucket using S3 Console. Config will discover the resource and mark it as non-compliant if it is not following S3 best practices.
1.	Go back to conformance pack details and select a rule with remediation action.
1.	Expand Resources in Scope section to see newly created resource with its compliance status. If the resource is non-compliant, the auto-remediation action will apply to resource within few minutes.
1.	Refresh the page to see updated resource compliance status.

## Next Section

Click the link below to go to the next section.

[![](media/config-advancedquery.png)](/episode-02-step-04-config-advancedquery.md)
