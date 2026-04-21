# Three-Tier Application on Amazon EKS

A production-ready, three-tier web application deployed on **Amazon EKS** with Infrastructure as Code using **Terraform**.

## Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Web Tier   │────▶│   API Tier   │────▶│  Data Tier   │
│   (React)    │     │  (Express)   │     │  (MongoDB)   │
│   Nginx:80   │     │   Node:8080  │     │    :27017    │
└──────────────┘     └──────────────┘     └──────────────┘
       ▲                                         │
       │              AWS ALB Ingress             │
       └──────────── (path-based routing) ────────┘
```

## Project Structure

```
three-tier-eks-iac/
├── application/                    # Application source code
│   ├── api/                        #   Backend — Express.js REST API
│   │   ├── Dockerfile              #     Multi-stage build (Node 18 Alpine)
│   │   ├── server.js               #     Entry point
│   │   ├── database.js             #     MongoDB connection handler
│   │   ├── models/                 #     Mongoose schemas
│   │   │   └── task.model.js
│   │   └── routes/                 #     REST route handlers
│   │       └── task.routes.js
│   └── web/                        #   Frontend — React SPA
│       ├── Dockerfile              #     Multi-stage build (Nginx)
│       ├── src/
│       │   ├── App.js              #     Root UI component
│       │   ├── TaskManager.js      #     State management
│       │   └── services/
│       │       └── task.service.js  #     Axios HTTP client
│       └── public/
├── kubernetes/                     # Kubernetes manifests
│   ├── api/                        #   Backend deployment & service
│   ├── web/                        #   Frontend deployment & service
│   ├── database/                   #   MongoDB deployment, service & secret
│   ├── networking/                 #   ALB Ingress routing rules
│   └── helm-values/                #   Helm chart value overrides
└── infrastructure/                 # Terraform IaC
    ├── provider.tf                 #   AWS & Terraform config
    ├── backend.tf                  #   S3 remote state
    ├── variables.tf                #   Input variables
    ├── outputs.tf                  #   Post-apply outputs
    ├── vpc.tf                      #   VPC with public/private subnets
    ├── eks-cluster.tf              #   EKS cluster & node groups
    ├── iam.tf                      #   IAM roles, users & policies
    ├── helm-providers.tf           #   Helm provider config
    ├── alb-controller.tf           #   AWS ALB Ingress Controller
    ├── cluster-autoscaler-iam.tf   #   Autoscaler IAM (IRSA)
    ├── cluster-autoscaler-manifest.tf  # Autoscaler K8s resources
    ├── eks-addons.tf               #   Managed EKS add-ons
    └── monitoring.tf               #   Prometheus & Grafana (optional)
```

## Getting Started

### Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate permissions
- [Terraform](https://www.terraform.io/downloads) >= 1.3
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://www.docker.com/) for building container images

### 1. Provision Infrastructure

```bash
cd infrastructure/

# Update backend.tf with your S3 bucket name
# Update variables.tf defaults or create a terraform.tfvars file

terraform init
terraform plan
terraform apply
```

### 2. Configure kubectl

```bash
# The exact command is shown in Terraform outputs after apply
aws eks update-kubeconfig --region us-west-2 --name three-tier-eks-cluster
```

### 3. Deploy the Application

```bash
# Create the namespace
kubectl create namespace three-tier

# Deploy the database tier
kubectl apply -f kubernetes/database/

# Deploy the API tier
kubectl apply -f kubernetes/api/

# Deploy the web tier
kubectl apply -f kubernetes/web/

# Set up ingress routing
kubectl apply -f kubernetes/networking/
```

### 4. Build & Push Container Images

```bash
# API image
cd application/api/
docker build -t <your-ecr-repo>/three-tier-api:latest .
docker push <your-ecr-repo>/three-tier-api:latest

# Web image
cd application/web/
docker build -t <your-ecr-repo>/three-tier-web:latest .
docker push <your-ecr-repo>/three-tier-web:latest
```

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| **Multi-stage Dockerfiles** | Smaller images (~40MB for web, ~120MB for API) |
| **Nginx for frontend** | Static file serving is faster and lighter than Node |
| **IRSA for pod IAM** | Fine-grained permissions without sharing node credentials |
| **Single NAT Gateway** | Cost savings for dev; switch to per-AZ for production |
| **Spot node group** | Up to 90% cost savings for fault-tolerant workloads |
| **Path-based ALB routing** | Single load balancer serves both frontend and API |

## TODO

- [ ] Replace placeholder ECR image URIs in deployment manifests
- [ ] Replace placeholder S3 bucket name in `backend.tf`
- [ ] Replace placeholder domain in `ingress.yaml`
- [ ] Change default MongoDB credentials in `secret.yaml`
- [ ] Enable persistent volume for MongoDB in production
- [ ] Uncomment monitoring stack when observability is needed
