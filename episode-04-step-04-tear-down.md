# Tear down workshop

![](media/ssm-aws-logo.png)

To go back to the previous section, click here: [Enable Change Management](/episode-04-step-03-enable-change-management.md)

**Congratulations!** You have completed the **Episode 4: Proactive ops and automation / preventative maintenance** workshop.

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

## Next Section

Click the link below to go to the next episode, **Episode 2:  Enable compliance and monitoring: through config rules and conformance packs**.

[![](media/.png)](/episode-02-step-01.md)