# Bee Temporal Helm Chart

This repository contains a customized Helm chart for deploying [Temporal](https://temporal.io/) in Kubernetes, specifically adapted for Bee's infrastructure requirements.

## Overview

This fork of Temporal's official Helm charts has been customized to:

- Use PostgreSQL as the default persistence layer
- Configure Elasticsearch for visibility storage
- Set up AWS Network Load Balancer for the frontend service
- Configure ingress resources with ALB annotations
- Enable Prometheus monitoring
- Add Bee-specific environment variables and configurations

The chart is configured through the `bee-config.yaml` file and through environment variables.

The chart is meant to be used through the deployment pipelines configured for Jenkins at:
```
https://bruno.getbee.io/job/BEE%20Temporal/job/deploy-bee-temporal/
```

## Usage

The project contains some shell scripts designed to update database schemas and create indexes on Elasticsearch. When upgrading to a new version, database schema should be updated first. 
These scripts use `temporal-sql-tool` to perform the operations. This tool is part of the temporal source repository.

## Steps to update to a new version

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/bee-temporal-helm.git
   ```

2. Clone the original Temporal repository in the same parent directory:
   ```
   git clone https://github.com/temporalio/temporal.git
   ```
   The goal is to have this directory structure:

   ```
   your-local-directory/
   ├── bee-temporal-helm/         # This repository
   ├── temporal/                  # Original temporal repository
   ```

3. Build the `temporal-sql-tool` utility with:
   ```
   make temporal-sql-tool
   ```

4. Update or check the required environment variables in the `.env` file 
5. Run the schema update scripts for the target environment:
   ```
   ./db-scripts/update_main_postgresql_schema.sh pre|qa|pro
   ```
6. Deploy the changes with:
   ```
   bee deploy pre|qa|pro
   ```
   Or by running the corresponding Jenkins Job from the web interface:
   https://bruno.getbee.io/job/BEE%20Temporal/job/deploy-bee-temporal/