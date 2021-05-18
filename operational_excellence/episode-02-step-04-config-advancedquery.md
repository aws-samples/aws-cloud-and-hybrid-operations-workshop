# Querying the Current Configuration State of AWS Resources using AWS Config Advanced Query

![](media/config-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
- [Next Section](#next-section)

## Summary

You can use AWS Config to query the current configuration state of AWS resources based on configuration properties for a single account and Region or across multiple accounts and Regions. You can perform ad hoc, property-based queries against current AWS resource state metadata across all resources that AWS Config supports. The advanced query feature provides a single query endpoint and a powerful query language to get current resource state metadata without performing service-specific describe API calls. You can use configuration aggregators to run the same queries from a central account across multiple accounts and AWS Regions.

In this section you will (1) run several queries against AWS resources to report on the current configuration state and (2) also use AWS CLI to run a query and output its information.

## Instructions

1.	Go to the [Config Console](https://console.aws.amazon.com/config), and then click on Advanced queries.
1. Click in the search box, and then click Name, and then select EC2 instances by type. Finally click on the Copy to editor button.

1. Change the instance type on the last line to t3.small. The complete, new query will look like this:

    ```
    SELECT
    resourceId,
    resourceName,
    resourceType,
    configuration.instanceType,
    tags,
    availabilityZone
    WHERE
    resourceType = 'AWS::EC2::Instance'
    AND configuration.instanceType = 't3.small'
    ```

1. These results are simple, but do not show the relationships between resources. Let’s run a more interesting query that reveals more about the environment that the instance has been created in. Copy the resourceId from the previous query and execute a new one with that as a parameter.

    ```
    SELECT
    *
    WHERE
    relationships.resourceId = 'your server id'
    ```

1. Scrolling-down to the output you can now see a more detailed list of resources that are related to this server, including its VPC, attached EBS volume, subnet, security group, elastic network interface, and the CloudFormation stack that created it.
You can create groupings and aggregations through Advanced Query as well:

    ```
    SELECT
        configuration.complianceType,
        COUNT(*)
    WHERE
        resourceType = 'AWS::Config::ResourceCompliance'
    GROUP BY
        configuration.complianceType
    ```
1. And unused EBS volumes:

    ```
    SELECT
    resourceId,
    accountId,
    awsRegion,
    resourceType,
    configuration.volumeType,
    configuration.size,
    resourceCreationTime,
    tags,
    configuration.encrypted,
    configuration.availabilityZone,
    configuration.state.value
    WHERE
    resourceType = 'AWS::EC2::Volume'
    AND configuration.state.value <> 'in-use'
    ```
1. The results from any and all of these queries can be exported to either CSV or JSON using the Export as button.

1. Finally, you can send queries to Config using the AWS Command Line Interface. This approach gives you a highly extensible method of scripting your data extraction. A simple example is this command:

    ```
    aws configservice select-resource-config --expression "SELECT resourceId WHERE resourceType='AWS::EC2::Instance'" --output yaml
    ```

## Next Section

Click the link below to go to the next section.

[![](/operational_excellence/media/tear-down.png)](/operational_excellence/episode-02-step-05-tear-down.md)
