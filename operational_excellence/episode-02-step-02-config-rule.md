# AWS Config Rule with Remdiation

![](media/config-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Creating a Config rule to restrict incoming TCP traffic to specified ports as non-compliance](#creating-a-config-rule-to-alert-on-systems-manager-agent-non-compliance )
    - [Deploy an EC2 instance](#deploy-an-ec2-instance)
    - [Add Remediation to your AWS Config Rule](#add-remediation-to-your-aws-config-rule)
- [Next Section](#next-section)

## Summary

AWS Config provides AWS managed rules, which are predefined, customizable rules that AWS Config uses to evaluate whether your AWS resources comply with common best practices. For example, you could use a managed rule to quickly start assessing whether your Amazon Elastic Block Store (Amazon EBS) volumes are encrypted or whether specific tags are applied to your resources. You can set up and activate these rules without writing the code to create an AWS Lambda function, which is required if you want to create custom rules.

In this section you will (1) create an AWS Config Rule to evaluate if security groupd that are in use disallow unrestricted incoming TCP traffic to the specified ports, and (2) use AWS Systems Manager Automation Documents to remediate non-compliant secuirty groups. 

## Instructions

### Creating a Config rule to restrict incoming TCP traffic to specified ports as non-compliance 

You can create config Rules to monitor a number of items within your infrastructure. Beside utilizing AWS managed Config rules you can also create custom rules using AWS Lambda functions. Located here in [Github](https://github.com/awslabs/aws-config-rules) are same sample config rules you can create and implement in Lambda.

In this step we will create a Config rule that will evaluate if EC2 security groups that are in use disallow unrestricted incoming TCP traffic to the specified ports.

1.	Go to the AWS Config console, and then click on Rules on the left side of the console.
1.	Click on Add Rule
1.	In the Add Rule screen in the Filter section type ```restricted-common-ports```, click on the restricted-common-ports rule.
1.	Under the Trigger Section take notice of the trigger type. Leave the remaining settings as-is.
1.	Click Next and then Add rule

### Deploy an EC2 instance

Next, let’s deploy a EC2 instance with a security group that allows TCP port 22 from the internet to test our Config rule. 

1.	Open the Amazon EC2 console by choosing EC2 under Compute.
1.	From the Amazon EC2 dashboard, choose Launch Instance. 
1.	The Choose an Amazon Machine Image (AMI) page displays a list of basic configurations called Amazon Machine Images (AMIs) that serve as templates for your instance. Select the HVM edition of the Amazon Linux 2 AMI.
1.	On the Choose an Instance Type page, choose t3.small as the hardware configuration of your instance and Review and Launch. 
1.	On the Configure Instance Details page, select the ```WorkshopEC2SSMRole``` as the IAM role and then choose Next: Add Storage: 
1.	On the Add Storage page, leave the defaults and then choose Next: Add Tags. 
1.	On the Add Tags page, leave the defaults and then choose Next: Configure Security Group 
1.	On the Configure Security Group page, Create a new security group called ```workshop-securitygroup```
1.	On the Review Instance Launch page, choose the Proceed without key pair option.
1.	To launch your instance, select the acknowledgment check box, then choose Launch Instances. 
1.	The instance should be up and running in around a minute.

### Add Remediation to your AWS Config Rule

AWS Config provides a set of managed automation documents with remediation actions. You can also create and associate custom automation documents with AWS Config rules.

Now return to the Config rule you created, click into the rule, and click Re-evaluate after the instance is up and running. You will have wait a minute or two for the result, and then refresh the web page. After a few moments the security group with the instance we deployed should be flagged as non-compliant.

***Adding Remeditaion to the Config rule to alert on Systems Manager agent non-compliance***

1.	In the AWS Config console, click on the restricted-common-ports rule you created.

1.	Click Actions | Re-evaluate after the instance is up and running

    ![](/media/config-reevaluatessmrule-ep02.png)

1.	You will have wait a minute or two for the result, and then refresh the web page. After a few moments the security group that was creted should be flagged as non-compliant.

1.  Next you will fix this non-compliant resource by adding a remediation action to the Config rule.

1.  Click Actions | Manage remediation

1. Under the Edit: remediation action do the following:
    -   Remediation method: Manual remediation
    -   Remediation action: AWS-DisablePublicAccessForSecurityGroup
    -   Resource ID parameter: GroupId 
        -   This passes the non-compliant security group ID to the remediation action

    ![](/media/config-ssmremediation1-ep02.png)
    ![](/media/config-ssmremediation2-ep02.png)

1.	Click Save

1.	Go back into the Config rule and look at non-compliant resources. Select the security group we deployed and then click on Remediate.

1.	Once completed, click on the security group resource and click Manage Resource button.

1.  Click on the Inbound rules tab for the security group and the public access rule for port 22 should be deleted.

1.	Return to AWS Config, and click on the restricted-common-ports rule and re-evaluate the rule once more. You will see that the security group is now compliant.


## Next Section

Click the link below to go to the next section.

[![](media/config-conformancepack.png)](/operational_excellence/episode-02-step-03-config-conformancepack.md)
