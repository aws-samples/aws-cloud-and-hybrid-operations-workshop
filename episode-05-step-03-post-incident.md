# Enabling Inventory

![](media/ssm-aws-logo.png)

NOTE: You will incur charges as you go through either of these workshops, as they will exceed the [limits of AWS free tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html).

## Table of Contents

- [Summary](#summary)
- [Instructions](#instructions)
    - [Create analysis for the incident](#create-analysis-for-the-incident)
- [Next Section](#next-section)

## Summary

In this section you will (1) 

## Instructions

### Create the analysis

1. Open the AWS Systems Manager console at https://console.aws.amazon.com/systems-manager/.
1. In the navigation pane, choose [**Incident Manager**](https://console.aws.amazon.com/systems-manager/incidents).
1. In the **Resolved incidents** section, choose the incident created during this workshop and choose **View details**.
    
    - **Note**: The name should be similar to ```[SampleApp] CPU Issue [i-123456789012-CPU-Spike]```.

1. Choose **Create analysis**.

    [![](media/tear-down.png)](/incident-create-analysis.md)

1. In the **Create analysis** window, leave the default value for **Title**, choose **AWSIncidents-PostIncidentAnalysisTemplate**, and choose **Create**.


#### Add metrics

1. Choose the **Metrics** tab and choose **Add metrics**.
1. In the search bar, filter for ```Name: CPUUtiliziation```, choose the instance created by the CloudFormation stack, and choose **Next**.
1. On the **Describe, annotate, and review** page, enter a title and description for the event such as:

    - **Title**: ```Stress test command performed spiking CPU```.
    - **Description**: ```A stress test command to simulate 70% CPU usage was performed to simulate an incident.```
    
1. Choose **Add Annotation** to add an annotation to the metric graph. You can add annotations to identify key timepoints during the incident.
    
    - For **Annotation**, enter ```Incident begins``` and modify the time to match the beginning of the graph.
    - Choose **Add Annotation**.
    - For **Annotation**, enter ```Stress command interrupted``` and modify the time to match the peak of the graph.
    - Choose **Add Annotation**.
    - For **Annotation**, enter ```Incident resolved``` and modify the time to match the ending of the graph.

1. Choose **Done**.

#### Answer incident questions

1. Choose the **Incident questions** tab to review the questions provided by the **AWSIncidents-PostIncidentAnalysisTemplate** analysis template.

## Next Section

You have now completed the workshop **Episode 5: Problem and Incident Management with Scale and Automation in an Enterprise Cloud Environment**!

Click the link below to go to the next section to tear down the resources created during the workshop.

[![](media/tear-down.png)](/episode-05-step-04-tear-down.md)