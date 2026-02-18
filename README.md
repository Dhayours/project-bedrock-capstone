Project Bedrock

Barakat Third Semester Capstone – InnovateMart EKS Deployment

Cloud DevOps Engineer: Amoto David Yusuf
AWS Region: us-east-1

📌 Overview

Project Bedrock provisions a production-grade Kubernetes environment on AWS using Infrastructure as Code and deploys the AWS Retail Store Sample Application.

The solution includes:

Amazon EKS (v1.34+)

Custom VPC across multiple AZs

Secure IAM & Kubernetes RBAC

CloudWatch logging (control plane + containers)

Event-driven S3 → Lambda integration

CI/CD automation via GitHub Actions

Remote Terraform state (S3 + DynamoDB)

🏗 Architecture

High-level components:

VPC: project-bedrock-vpc

EKS Cluster: project-bedrock-cluster

Namespace: retail-app

S3 Bucket: bedrock-assets-0960

Lambda: bedrock-asset-processor

IAM Developer User: bedrock-dev-view

Tag applied to all resources:
Project: barakat-2025-capstone

⚙️ Infrastructure as Code

Provisioned entirely using Terraform.

Remote State Configuration

Terraform backend:

S3 bucket: bedrock-tfstate-0960

DynamoDB table: Used for state locking

Local .tfstate files are not used.

☸️ EKS Cluster Details

Cluster Name:

project-bedrock-cluster


Region:

us-east-1


Control plane logging enabled:

API

Audit

Authenticator

ControllerManager

Scheduler

🛍 Application Deployment

The AWS Retail Store Sample App is deployed via Helm into:

Namespace: retail-app


All microservices are running with in-cluster dependencies (MySQL, PostgreSQL, Redis, etc.) as required.

Verify:

kubectl get pods -n retail-app


All pods should be Running and READY 1/1.

🔐 Secure Developer Access

IAM User:

bedrock-dev-view

AWS Console Access

Attached policy:

ReadOnlyAccess


Plus scoped permission:

s3:PutObject


on:

bedrock-assets-0960

Kubernetes RBAC

Mapped to:

ClusterRole/view


Verification:

kubectl auth can-i get pods -n retail-app      # yes
kubectl auth can-i delete pods -n retail-app   # no


This ensures read-only cluster access.

📊 Observability
Control Plane Logs

Enabled and available in CloudWatch Log Groups.

Container Logs

Amazon CloudWatch Observability Add-on installed.

Application logs available under:

/aws/containerinsights/project-bedrock-cluster/application

⚡ Event-Driven Serverless Extension

S3 Bucket:

bedrock-assets-0960


Lambda Function:

bedrock-asset-processor


Trigger:

S3 ObjectCreated event

When a file is uploaded:

Image received: <filename>


is logged in:

/aws/lambda/bedrock-asset-processor


Test:

echo "test" > test.txt
aws s3 cp test.txt s3://bedrock-assets-0960/test.txt

🔄 CI/CD Automation

Implemented using GitHub Actions.

Workflow
Pull Request → terraform plan

Triggers:

terraform-plan.yml

Merge to main → terraform apply

Triggers:

terraform-apply.yml


AWS credentials stored securely in repository secrets.

No credentials are hardcoded.

🌐 Application Access

Retail Store is exposed via AWS Load Balancer Controller (ALB Ingress).

Public URL:

[Insert your ALB or domain URL here]

🏷 Resource Tagging

All AWS resources include:

Project: barakat-2025-capstone


Verified using:

aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=Project,Values=barakat-2025-capstone

📦 Terraform Outputs (grading.json)

Generated via:

terraform output -json > grading.json


Root outputs include:

cluster_endpoint

cluster_name

region

vpc_id

assets_bucket_name

🛠 Deployment Guide
1️⃣ Clone repository
git clone <repo-url>
cd project-bedrock-capstone/terraform

2️⃣ Initialize Terraform
terraform init

3️⃣ Apply infrastructure
terraform apply

4️⃣ Configure kubeconfig
aws eks update-kubeconfig \
  --region us-east-1 \
  --name project-bedrock-cluster

5️⃣ Verify deployment
kubectl get pods -n retail-app

🎯 Grading Credentials

IAM User:

bedrock-dev-view


Access Key and Secret Key are provided separately as required.

✅ Compliance Summary
Requirement	Status
Naming Conventions	✅
us-east-1 Region	✅
Remote State	✅
EKS ≥ 1.34	✅
Retail App Running	✅
RBAC Read-Only	✅
Control Plane Logs	✅
Container Logs	✅
S3 → Lambda Trigger	✅
CI/CD Plan & Apply	✅
Resource Tagging	✅
📌 Final Notes

This project demonstrates:

Production-grade Kubernetes provisioning

Secure IAM + RBAC implementation

Observability best practices

Event-driven architecture

Automated infrastructure delivery
Automated infrastructure delivery# test
