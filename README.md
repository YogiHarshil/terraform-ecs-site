# Next.js ECS Terraform

Production-ready Next.js deployment on AWS ECS using Terraform and GitHub Actions.

## 🏗️ Architecture

```
GitHub → GitHub Actions → ECR → ECS Fargate → ALB → Users
```

- **Next.js 14** with App Router and TypeScript
- **AWS ECS Fargate** for serverless containers
- **Application Load Balancer** for high availability
- **ECR** for container registry
- **Terraform** for infrastructure as code
- **GitHub Actions** for CI/CD

## 🚀 Quick Deploy

### Prerequisites
- AWS CLI configured
- Docker installed
- Terraform installed

### One-Command Deployment
```bash
chmod +x deploy.sh
./deploy.sh
```

### Manual Deployment
```bash
# 1. Deploy infrastructure
cd terraform
terraform init
terraform apply

# 2. Build and push image
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $(terraform output -raw ecr_repository_url)
docker build -t nextjs-ecs .
docker tag nextjs-ecs:latest $(terraform output -raw ecr_repository_url):latest
docker push $(terraform output -raw ecr_repository_url):latest

# 3. Update ECS service
aws ecs update-service --cluster nextjs-ecs --service nextjs-ecs --force-new-deployment
```

## 🔧 Configuration

### Environment Variables (GitHub Secrets)
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Terraform Variables (optional)
Create `terraform/terraform.tfvars`:
```hcl
aws_region    = "us-west-2"
project_name  = "nextjs-ecs"
environment   = "prod"
desired_count = 3
cpu          = "512"
memory       = "1024"
```

## 📊 Features

✅ **Optimized Docker** - Multi-stage builds, minimal image size  
✅ **Secure Networking** - VPC with public/private subnets  
✅ **Health Monitoring** - Built-in health checks and CloudWatch logs  
✅ **Auto Scaling** - ECS service scaling based on demand  
✅ **CI/CD Pipeline** - Automated testing and deployment  
✅ **Cost Optimized** - Fargate with minimal resource allocation  

## 🛠️ Development

```bash
npm install
npm run dev     # Development server
npm run build   # Production build
npm run lint    # Code linting
```

## 🧪 Testing

After deployment:
```bash
# Get application URL
cd terraform && terraform output application_url

# Test health endpoint
curl http://your-alb-dns/api/health
```

## 🧹 Cleanup

```bash
cd terraform
terraform destroy
```

## 📚 Learn More

This project demonstrates:
- Infrastructure as Code with Terraform
- Container orchestration with ECS
- CI/CD with GitHub Actions  
- AWS networking and security best practices
- Next.js production optimization

---
**Total deployment time: ~10 minutes** ⚡ 