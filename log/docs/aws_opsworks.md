# Amazon Web Services and OpsWorks

Most of AAPB operates using various products from Amazon Web Services. We use
EC2 instances for hosting the Rails web application. The Solr search index is
also hosted on an EC2 instance with a detachable EBS volume for the data
itself.

OpsWorks is a DevOps tool that is part of the AWS suite of products. We chose to use it because:

  * it appeared to be more user friendly than CloudFormation.
  * it is more flexible than ElasticBeanstalk.
  * it uses Chef, which has a robust community of its own, and if all our
  	config is expressed in Chef recipes, we can use them outside of OpsWorks
  	if we want to.

## Accessing the WGBH-MLA account on AWS

You should log in using an IAM user. If you need one creaeted, contact someone
with administrative privileges. With your IAM account, you log in thorugh a specially designated login screen.

[__Log in to the WGBH-MLA AWS account__](https://signin.aws.amazon.com/oauth?SignatureVersion=4&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJMOATPLHVSJ563XQ&X-Amz-Date=2015-07-02T20%3A18%3A36.356Z&X-Amz-Signature=8ed9859a4cdb42e5ba968705189da0f51a4520a55ee46abf0ecdfd77c7a06443&X-Amz-SignedHeaders=host&client_id=arn%3Aaws%3Aiam%3A%3A015428540659%3Auser%2Fhomepage&redirect_uri=https%3A%2F%2Fconsole.aws.amazon.com%2Fconsole%2Fhome%3Fstate%3DhashArgs%2523%26isauthcode%3Dtrue&response_type=code&state=hashArgs%23).

## Accessing the OpsWorks console

The [OpsWorks console](https://console.aws.amazon.com/opsworks/home?region=us-east-1)
is linked from the [AWS console home](https://console.aws.amazon.com/console/home?region=us-east-1#)
under the "Deployment and Management" section.

The default screen is the OpsWorks Dashboard, which lists all of your stacks.

## the AAPB Stack

The highest level of organization in OpsWorks is called a "stack". The one for
AAPB is cleverly named __AAPB__.

We created the AAPB with the following values:

Field|Value|
---|-----|-----
Name|AAPB||
Region|US East (N. Virginia)|Default
VPC|No VPC|Default
Default Availability Zone|`us-east-1a`|Default
Default Operating System|`Amazon Linux 2014.09`|Default
Default root device type|EBS Backed|Default
IAM Role|`aws-opsworks-service-role`|Default
Default SSH key|`aapb`|This is from a key-pair we created in AWS prior to creating the stack.
Default IAM instance profile|`aws-opsworks-ec2-role`|Default
Hostname theme|Layer Dependent|Default
Stack color|greenish|Who doesn't love greenish things?
Chef version|`11.10`|
Use custom Chef cookbooks|No|Default
Custom JSON|None|Default
Use OpsWorks security groups|Yes|Default


After creating the stack, OpsWorks expands the values for **IAM Role** and
**Default IAM instance profile**, and adds an **OpsWorksID**...

Field|Value
---|-----
IAM Role|arn:aws:iam::127946490116:role/aws-opsworks-service-role
Default IAM instance profile|arn:aws:iam::127946490116:instance-profile/aws-opsworks-ec2-role
OpsWorksID|5c18a7b8-3a8c-4f85-b530-934c9fc1c8a5 _(This will be different for different stacks)_

## Layers

Each stack is composed of one or more "layers". A layer is a blueprint for a
set of EC2 instances. It specifies the instance's settings, resources,
installed packages, profiles, and security groups.

Each OpsWorks layer has a lifecycle consisting of 5 phases: **Setup**,
**Configure**, **Deploy**, **Undeploy**, and **Shutdown**. During these
phases, various chef recipes are run for configuring the EC2 instance.

OpsWorks provides several pre-built layers for common use cases. You may also
create a custom layer and define your own chef recipes to run during lifecycle
phases.

### The AAPB Rails layer

We have created a custom layer called __AAPB Rails__ for provisioning EC2
instances that serve the Rails application.

OpsWorks defines several built-in Chef recipes for our layer that are
apparently required for running on AWS, because we cannot remove them. They
are (ordered by lifecycle phase):

  - **Setup:** `opsworks_initial_setup`, `ssh_host_keys`, `ssh_users`, `mysql::client`, `dependencies`, `ebs`, `opsworks_ganglia::client`
  - **Configure:** `opsworks_ganglglia::configure-client`, `ssh_users`, `mysql::client`, `agent_version`
  - **Deploy:** `deploy::default`
  - **Undeploy:** _none_
  - **Shutdown:** `opsworks_shutdown::default`

In addition to these, since it is a custom layer, we can specify other recipes to run during the lifecycle. For the AAPB Rails layer, these are:

  - **Setup:** `apache2`, `apache2::mod_deflate`, `passenger_apache2`, `passenger_apache2::mod_rails`, `passenger_apache2::rails`
  - **Configure:** `rails::configure`
  - **Deploy:** _none_
  - **Undeploy:** `deploy::rails-undeploy`
  - **Shutdown:** `apache2::stop`


### Custom chef recipes

We don't have any yet, but OpsWorks requires a repository URL in order to
customize which pre-built recipes a layer uses, which is what we are doing for
the AAPB Rails layer.

Our (empty) repo for custom recipes is here: https://github.com/WGBH/aapb-cookbooks.
Any Chef recipes we wish to maintain should be done in this repository.

I believe OpsWorks requires that your custom recipe repo be public, which is
why it's in Github instead of this repo (aapb_deployment) in Stash. If/when
OpsWorks allows you to use a private repo for custom Chef recipes, it would
make sense to move them to this repository.


## Other OpsWorks notes

#### Using both OpsWorks and the EC2 Console

The EC2 console is a place to manage _all_ EC2 instances in your AWS account.
However, for managing EC2 instances that were provisioned using OpsWorks, it's
recommended to stick with using the OpsWorks interface.

While both interfaces allow you to manage your instances, they do so in slightly
different ways, and I've found at least one bug in the way the status of EC2
instances are reported if you launch the instance from
OpsWorks, and then stop it in the EC2 console.

  1. If the OpsWorks layer has auto healing _**enabled**_, and you stop the
  instance from the EC2 console, then the status in OpsWorks will report
  "online" for a little while it then appears to re-launch the instance, so
  the status changes to "booting",and then "setting up".

  The surprising thing to me here is that the auto healing feature says it
  will reboot the instance in case of failure. So OpsWorks must think your
  instance failed if you deliberately stopped it from the EC2 console.

  1. If the OpsWorks layer has auto healing _**disabled**_, and you stop the
  instance from the EC2 console, then the status in OpsWorks will report
  "online" indefinitely (or at least I wasn't patient enough to find out when
  it switches to "stopped"), but the instance will not be reachable. In order
  for it to show up as "stopped" in OpsWorks, you have to deliberately stop it
  from the OpsWorks console.
