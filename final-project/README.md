# Final Project: DevOps Infrastructure on AWS with Terraform

## Project Structure

```
final-project/
├── backend.tf
├── main.tf
├── outputs.tf
├── Jenkinsfile
├── README.md
├── modules/
│   ├── argo_cd/
│   ├── ecr/
│   ├── eks/
│   ├── jenkins/
│   ├── monitoring/
│   ├── rds/
│   ├── s3-backend/
│   └── vpc/
├── charts/
│   └── django-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           └── hpa.yaml
```

## Deployment Steps

### 1. Deploy Infrastructure (Terraform)

```sh
terraform init
terraform plan
terraform apply
```

### 2. Build and Push Django Docker Image to ECR (via Jenkins)

- Jenkins is installed via Helm and managed by Terraform.
- The pipeline (see Jenkinsfile) will:
  - Build the Docker image using Kaniko agent
  - Push the image to ECR
  - Update the image tag in the Helm chart repository
  - Push changes to the main branch

### 3. Configure kubectl to Access the Cluster

```sh
aws eks --region <region> update-kubeconfig --name <eks-cluster-name>
```

### 4. Deploy Django App via Helm

```sh
cd charts/django-app
helm upgrade --install django-app .
```

### 5. Access Monitoring (Prometheus & Grafana)

- Prometheus and Grafana are deployed in the `monitoring` namespace.
- To access Grafana:
  ```sh
  kubectl port-forward svc/grafana -n monitoring 3000:80
  # Then open http://localhost:3000
  # Default login: admin / prom-operator
  ```
- To access Prometheus:
  ```sh
  kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090
  # Then open http://localhost:9090
  ```

## Modules Overview

- **VPC**: Creates VPC, public/private subnets, routing.
- **EKS**: Creates Kubernetes cluster and node group.
- **ECR**: Creates container registry for Docker images.
- **Jenkins**: Installs Jenkins via Helm for CI/CD.
- **Argo CD**: Installs Argo CD for GitOps deployment.
- **RDS**: Creates PostgreSQL database in private subnets.
- **Monitoring**: Installs Prometheus and Grafana via Helm.
- **S3/DynamoDB**: Backend for Terraform state and locking.

## Outputs

- `eks_cluster_name`, `eks_cluster_endpoint` — EKS cluster info
- `rds_endpoint`, `rds_db_name`, `rds_db_user` — RDS info
- `prometheus_release`, `grafana_release`, `monitoring_namespace` — Monitoring info
- `jenkins_release`, `jenkins_namespace` — Jenkins info
- `s3_bucket_name`, `dynamodb_table_name` — Terraform backend info

## Notes

- All resources are created in the `us-west-2` region.
- You need permissions to create AWS resources (EKS, RDS, VPC, ECR, etc.).
- Make sure your AWS credentials are configured before running (`aws configure`).
- Jenkins requires AWS credentials for ECR (secret `aws-ecr-creds`).
- For Argo CD Application, set the correct repository and path in `modules/argo_cd/values.yaml`.
- All parameters can be customized via the respective `values.yaml` files.

---

**Questions and suggestions — open an issue!**
