# lesson-8-9: Kubernetes + AWS + Helm + Terraform

## Project Structure

```
lesson-8-9/
├── backend.tf
├── main.tf
├── outputs.tf
├── Jenkinsfile
├── README.md
├── modules/
│   ├── argo_cd/
│   │   ├── charts/
│   │   │   ├── Chart.yaml
│   │   │   ├── values.yaml
│   │   │   └── templates/
│   │   │       ├── application.yaml
│   │   │       └── repository.yaml
│   │   ├── values.yaml
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── jenkins.tf
│   ├── ecr/
│   ├── eks/
│   ├── jenkins/
│   │   ├── values.yaml
│   │   ├── outouts.tf
│   │   ├── variables.tf
│   │   ├── jenkins.tf
│   │   ├── values.tf
│   │   └── providers.tf
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

**Manual alternative:**

```sh
# Login to ECR
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

# Build and push
docker build -t <image-name> .
docker tag <image-name>:latest <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:latest
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:latest
```

### 3. Configure kubectl to Access the Cluster

```sh
aws eks --region <region> update-kubeconfig --name <eks-cluster-name>
```

### 4. Deploy Django App via Helm

```sh
cd charts/django-app
helm upgrade --install django-app .
```

## CI/CD with Jenkins, Helm, Terraform, and Argo CD

### Jenkins Pipeline

- Go to the Jenkins web UI (`/jenkins` in your cluster or via port-forward).
- Run the pipeline job (Jenkinsfile is preconfigured for build, push, and Helm chart update).
- Ensure the job completes successfully.

### Argo CD Sync

- Go to the Argo CD web UI (`/argocd` in your cluster or via port-forward).
- Find the `django-app` application.
- Ensure the status is `Synced` and `Healthy`.
- After a successful Jenkins pipeline, Argo CD will automatically sync changes and update the Django deployment.

## Helm Chart Parameters (values.yaml)

- `image.repository`, `image.tag` — your ECR image path
- `service.type` — service type (LoadBalancer)
- `config` — environment variables
- `hpa` — autoscaler parameters

## Notes

- Jenkins requires AWS credentials for ECR (secret `aws-ecr-creds`).
- For Argo CD Application, set the correct repository and path in `modules/argo_cd/values.yaml`.
- All parameters can be customized via the respective `values.yaml` files.

---

**Questions and suggestions — open an issue!**
