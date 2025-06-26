# lesson-7: Kubernetes + AWS + Helm + Terraform

## Project Structure

```
lesson-7/
├── main.tf
├── backend.tf
├── outputs.tf
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   └── eks/
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml
```

## Deployment Steps

### 1. Deploy Infrastructure (Terraform)

```sh
terraform init
terraform apply
```

### 2. Build and Push Django Docker Image to ECR

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

## Helm Chart Parameters (values.yaml)

- `image.repository`, `image.tag` — your ECR image path
- `service.type` — service type (LoadBalancer)
- `config` — environment variables
- `hpa` — autoscaler parameters

---

**Questions and suggestions — open an issue!**
