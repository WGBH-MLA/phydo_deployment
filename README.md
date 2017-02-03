# AAPB Deployment

This project contains the deployment scripts and configuration for deploying
the [AAPB website](http://americanarchive.org). The AAPB website code
repository is at http://github.com/WGBH/aapb2.

### Overview of tools used

  * AAPB is a Rails app.
  * AAPB is hosted on AWS EC2 instances.
  * AWS OpsWorks is used for provisioning EC2 instances.
  * Capistrano is used for deploying website code.

### Why have a different repository for deployment code?

The two main reasons for having a separate repository are:

  * Provide a protected place for sensitive configuraiton data.
  * Separate deployment code and documentation from website code.

### Documentation

AAPB deployment documentation is stored in the [`docs`](./docs) directory of
this repository. This way, we ensure that our deployment policies and
conventiones get versioned along with any working code or configuration.

#### Table of Contents

[**Production/Demo Environment Setup Guide**](./docs/production_env_setup_guide.md)
- a step-by-step guide for setting up a production (or demo) environment for
AAPB.

[**AWS OpsWorks**](./docs/aws_opsworks.md) - Details of how AAPB uses OpsWorks.
