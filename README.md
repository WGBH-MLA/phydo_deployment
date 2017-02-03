# Phydo Deployment

This project contains the deployment scripts and configuration for deploying
the Phydo website. The Phydo website code
repository is at http://github.com/WGBH/aapb2.

### Overview of tools used

  * Phydo is a Rails app.
  * Phydo is hosted on AWS EC2 instances.
  * Ansible is used for provisioning EC2 instances.
  * Capistrano is used for deploying website code.

### Why have a different repository for deployment code?

The two main reasons for having a separate repository are:

  * Provide a protected place for sensitive configuraiton data.
  * Separate deployment code and documentation from website code.
