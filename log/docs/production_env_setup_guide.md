# Production/Demo Environment Setup Guide

This is meant to be a step-by-step guide for setting up a production (or demo)
environment for AAPB on Amazon Web Services (AWS) using thier OpsWorks product.

We link to the official AWS docs where applicable, and supply the AAPB-specific
values you'll need to complete the steps.

## Prerequisites

There are a couple of things you need before starting the setup process. You
should only have to do these once, so skip them if you've already done them.

### Get an IAM account;

This must be done by an MLA web administrator. You'll be given an IAM username
and password with which will allow you to log in to the
[AWS Management Console](https://signin.aws.amazon.com/oauth?SignatureVersion=4&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJMOATPLHVSJ563XQ&X-Amz-Date=2015-07-27T21%3A50%3A36.685Z&X-Amz-Signature=f3382793d30d28390bc9b7193b3688f925b49c142b31090735e31666cd0dfef6&X-Amz-SignedHeaders=host&client_id=arn%3Aaws%3Aiam%3A%3A015428540659%3Auser%2Fhomepage&redirect_uri=https%3A%2F%2Fconsole.aws.amazon.com%2Fconsole%2Fhome%3Fstate%3DhashArgs%2523%26isauthcode%3Dtrue&response_type=code&state=hashArgs%23).

### Acquire SSH key for logging in to EC2 instances

You must get this directly from an MLA web administrator. It's top secret, so it comes with responsibility -- i.e. don't make copies, don't share, etc.

After you get the SSH key

  1. Move the file to `~/.ssh/aapb.pem`
  1. Change permissions on the file with `chmod 600 ~/.ssh/aapb.pem`

## Step 1: Log in to AWS

_**ALWAYS**_ sign using this [this AWS ManagementConsole login screen](https://signin.aws.amazon.com/oauth?SignatureVersion=4&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJMOATPLHVSJ563XQ&X-Amz-Date=2015-07-27T21%3A50%3A36.685Z&X-Amz-Signature=f3382793d30d28390bc9b7193b3688f925b49c142b31090735e31666cd0dfef6&X-Amz-SignedHeaders=host&client_id=arn%3Aaws%3Aiam%3A%3A015428540659%3Auser%2Fhomepage&redirect_uri=https%3A%2F%2Fconsole.aws.amazon.com%2Fconsole%2Fhome%3Fstate%3DhashArgs%2523%26isauthcode%3Dtrue&response_type=code&state=hashArgs%23)
with the following values:

  - **Account:** `wgbh-mla`
  - **User Name:** _your IAM username_
  - **Password:** _your IAM password_

_**NEVER**_ sign in from [the standard this AWS login screen](https://www.amazon.com/ap/signin?openid.assoc_handle=aws&openid.return_to=https%3A%2F%2Fsignin.aws.amazon.com%2Foauth%3Fresponse_type%3Dcode%26client_id%3Darn%253Aaws%253Aiam%253A%253A015428540659%253Auser%252Fhomepage%26redirect_uri%3Dhttps%253A%252F%252Fconsole.aws.amazon.com%252Fconsole%252Fhome%253Fstate%253DhashArgs%252523%2526isauthcode%253Dtrue%26noAuthCookie%3Dtrue&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&action=&disableCorpSignUp=&clientContext=&marketPlaceId=&poolName=&authCookies=&pageId=aws.ssop&siteState=unregistered%2Cen_US&accountStatusPolicy=P1&sso=&openid.pape.preferred_auth_policies=MultifactorPhysical&openid.pape.max_auth_age=120&openid.ns.pape=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Fpape%2F1.0&server=%2Fap%2Fsignin%3Fie%3DUTF8&accountPoolAlias=&forceMobileApp=0&language=en_US&forceMobileLayout=0).
This is for logging in as the root user for AWS accounts.

## Step 2: Find the AAPB stack in the OpsWorks console

Click the orange cube in the upper left corner of the page to open the [home menu](https://console.aws.amazon.com/console/home?region=us-east-1#).
The home menu lists all the AWS products grouped into categories.

Click on the link for ["OpsWorks"](https://console.aws.amazon.com/opsworks/home?region=us-east-1#) under the "Deployment and Management" section. This will show the [OpsWorks Dashboard](https://console.aws.amazon.com/opsworks/home?region=us-east-1) that lists all of your stacks.

Click on the [AAPB stack](https://console.aws.amazon.com/opsworks/home?region=us-east-1#/stack/beb7faaf-ff53-4d04-87b3-6a17dbbc150f/stack) to show the AAPB stack overview page.

## Step 3: Create a new EC2 instance to host the web app

Follow these instruction for [**Adding an Instance to a Layer**](http://docs.aws.amazon.com/opsworks/latest/userguide/workinginstances-add.html)
using the following values:

  - **Hostname:** `aapb-rails1` (or whatever the default value is)
  - **Size:** `m3-medium`
  - **Availability Zone:** `us-east-1a`
  - **Scaling Type:** `24/7`
  - **SSH Key:** `aapb`
  - **Operating System:** `Amazon Linux 2015.03`
  - **Root Device Type:** `EBS backed`
  - **Volume Type:** `General Purpose (SSD)`

## Step 4: Associate Elastic IP

If you don't want your EC2 instance to use an existing Elastic IP (EIP) you
can skip this step.

EIP addresses are static IP addresses you can associate to (and dissociate
from) EC2 instances. The settings for the AAPB Rails layer are set to create a
new EIP for any new EC2 by default. However, you can associate your new EC2
instance with a previously registered EIP.

Follow these instruction for [**Associating Elastic IP Addresses with an Instance**](http://docs.aws.amazon.com/opsworks/latest/userguide/resources-attach.html#resources-attach-eip)

## Step 5: Set up an EBS volume for storing Solr data

1. Follow these instructions for [**Creating an Amazon EBS Volume**](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-creating-volume.html),
using the following values:
  - **Type:** General Purpose SSD
  - **Size:** 10 GiB
  - **Availability Zone:** `us-east-1a`
  - **Snapshot ID:** _Empty_
  - **Encryption:** _Unchecked_

1. Name the new EBS volume by hovering over the "name" field, and
clicking on the pencil icon. Type `aapb-solr-data` and click the checkbox.

> **TIP:** Always try to give an EBS volume a name that describes its
> purpose. This will help avoid situations where there are a lot of mystery
> volumes that are cryptically named, or not named at all.

1. Follow these instructions for [**Registering Amazon EBS Volumes with a Stack**](http://docs.aws.amazon.com/opsworks/latest/userguide/resources-reg.html#resources-reg-ebs)

1. Follow these instructions for [**Assigning Amazon EBS Volumes to an Instance**](http://docs.aws.amazon.com/opsworks/latest/userguide/resources-attach.html#resources-attach-ebs) using the following values:

  - **Name:** `aapb-solr-data`
  - **Mount point:** `/mnt/aapb-solr-data` _**NOTE:** The mount point **must** be named this in order for capistrano tasks to properly create symlinks._
  - **Instance:** _Select the EC2 instance that will host the website._


## Step 6: Start the EC2 instance and log in with SSH

1. Follow these instructions on [**Starting 24/7 Instances**](http://docs.aws.amazon.com/opsworks/latest/userguide/workinginstances-starting.html).

1. After the instance is started, open a terminal and SSH in to the instance with:

```
# Replace X.X.X.X with the IP address of the EC2 instance.
ssh -i ~/.ssh/aapb.pem ec2-user@X.X.X.X
```


## Step 8: Configure virtual host

Configuring the Apache virtual host is not yet automated, so there are a few
steps that need to be completed manually.

1. SSH into the newly created EC2 instance and, using `sudo`, copy the
contents of [virtual host config](../config/aapb.conf) to a file named
`/etc/httpd/sites-available/aapb.conf`.

1. Symlink the vhost config into the `sites-enabled` directory like so:
  ```
  sudo ln -s /etc/httpd/sites-available/aapb.conf /etc/httpd/sites-enabled/aapb.conf
  ```

1. Restart apache with `sudo service httpd restart`

Now visiting the public IP of your EC2 should display the AAPB home page. But
you may still get HTTP 500 errors when trying to do searches because Solr has
not been configured yet.

## Clone the aapb_deployment repository to your local machine

**TODO**

## Deploy the web application

**TODO**
