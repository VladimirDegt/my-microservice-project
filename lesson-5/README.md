# AWS Infrastructure with Terraform

## Project Structure Description

- **main.tf** — connects all infrastructure modules.
- **backend.tf** — configures Terraform state storage in S3 with locking via DynamoDB.
- **outputs.tf** — common outputs from all modules.
- **modules/**
  - **s3-backend/** — module for creating an S3 bucket and DynamoDB table for state storage and locking.
  - **vpc/** — module for creating a VPC, public and private subnets, Internet Gateway, NAT Gateway, and routing.
  - **ecr/** — module for creating an ECR repository with image scanning and access policy.

---

## Quick Start

1. **Initialize Terraform:**

   ```sh
   terraform init
   ```

2. **Plan changes:**

   ```sh
   terraform plan
   ```

3. **Apply changes:**

   ```sh
   terraform apply
   ```

4. **Destroy infrastructure:**
   ```sh
   terraform destroy
   ```

---

## Module Descriptions

### Module `s3-backend`

- **Purpose:** Creates an S3 bucket for storing Terraform state files and a DynamoDB table for state locking.
- **Parameters:**
  - `bucket_name` — S3 bucket name.
  - `table_name` — DynamoDB table name.
- **Outputs:**
  - `s3_bucket_name` — created S3 bucket name.
  - `dynamodb_table_name` — DynamoDB table name.

### Module `vpc`

- **Purpose:** Creates a VPC with 3 public and 3 private subnets, Internet Gateway, NAT Gateway, and configures routing.
- **Parameters:**
  - `vpc_cidr_block` — CIDR block for the VPC.
  - `public_subnets` — list of CIDR blocks for public subnets.
  - `private_subnets` — list of CIDR blocks for private subnets.
  - `availability_zones` — list of availability zones.
  - `vpc_name` — VPC name.
- **Outputs:**
  - `vpc_id` — created VPC ID.
  - `public_subnets` — list of public subnet IDs.
  - `private_subnets` — list of private subnet IDs.
  - `internet_gateway_id` — Internet Gateway ID.

### Module `ecr`

- **Purpose:** Creates an ECR repository with automatic image scanning and access policy.
- **Parameters:**
  - `repository_name` — ECR repository name.
- **Outputs:**
  - `repository_url` — created ECR repository URL.

---

## Terraform Backend Configuration

The `backend.tf` file configures Terraform state storage in S3 and locking via DynamoDB:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-Volodymyr"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

---

## Notes

- All resources are created in the `us-west-2` region.
- You need permissions to create AWS resources (S3, DynamoDB, VPC, ECR, etc.).
- Make sure your AWS credentials are configured before running (`aws configure`).

---
