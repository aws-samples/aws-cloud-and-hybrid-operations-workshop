# Tear down workshop

![](media/ssm-aws-logo.png)

To go back to the previous section, click here: [Perform a post-incident analysis](/episode-05-step-03-post-incident.md)

**Congratulations!** You have completed the **Episode 5: Reactive ops and automation** workshop.

## Tear down instructions

### Delete the CloudFormation stack

<details>
<summary><b>To delete the CloudFormation stack</b></summary><p>

1. Open the AWS CloudFormation console at https://console.aws.amazon.com/cloudformation/home.
1. In the navigation pane, choose **Stacks**.
1. Choose the stack **ssm-workshop-ep05** and click **Delete**.
1. Choose **Delete stack**.

</p></details>

### Delete Incident Manager resources

#### Delete the Incident Manager replication set

<details>
<summary><b>To delete the replication set</b></summary><p>

1. Navigate to the [**Incident Manager console**](https://console.aws.amazon.com/systems-manager/incidents/home) and choose **Settings** from the left navigation bar.
1. Select the region **US East (Ohio)** and choose **Delete**.
1. Enter ```delete``` into the text box and choose **Delete**.

</p></details>

#### Delete Incident Manager contacts

<details>
<summary><b>To delete contacts</b></summary><p>

1. Navigate to the [**Incident Manager console**](https://console.aws.amazon.com/systems-manager/incidents/home) and choose **Contacts** from the left navigation bar.
1. Select one of the two contacts created during the workshop (```yourname``` or ```yourname-escalated```), choose **Delete**.
1. Enter ```delete``` into the text box and choose **Delete**.
1. Repeat the process for the second contact.

</p></details>

#### Delete the response plan

<details>
<summary><b>To delete the reponse plan</b></summary><p>

1. Navigate to the [**Incident Manager console**](https://console.aws.amazon.com/systems-manager/incidents/home) and choose **Response plans** from the left navigation bar.
1. Select escalation plan created during the workshop (```sampleapp-performance-issues-response-plan```), choose **Delete**.
1. Enter ```sampleapp-performance-issues-response-plan``` into the text box and choose **Delete**.

</p></details>

#### Delete the escalation plan

<details>
<summary><b>To delete the escalation plan</b></summary><p>

1. Navigate to the [**Incident Manager console**](https://console.aws.amazon.com/systems-manager/incidents/home) and choose **Escalation plans** from the left navigation bar.
1. Select the escalation plan created during the workshop (```workshop-escalation```), choose **Delete**.
1. Enter ```delete``` into the text box and choose **Delete**.

</p></details>

### Delete the IAM role for Incident Manager

<details>
<summary><b>To delete the IAM role</b></summary><p>

1. Open the AWS IAM console at https://console.aws.amazon.com/iam/home.
1. In the navigation pane, choose **Roles**.
1. Choose the role **IncidentManager-Role**, choose **Delete role**, and choose **Yes, delete**.

</p></details>

## Next Section

Click the link below to go to the next episode, **Episode 2:  Enable compliance and monitoring: through config rules and conformance packs**.

[![](media/.png)](/episode-02-step-01.md)