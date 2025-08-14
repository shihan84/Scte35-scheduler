# SCTE-35 Scheduler - Deployment Guide

This guide provides step-by-step instructions for deploying the SCTE-35 Scheduler application in various environments.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development Deployment](#local-development-deployment)
3. [Production Deployment with Docker](#production-deployment-with-docker)
4. [Manual Server Deployment](#manual-server-deployment)
5. [Cloud Deployment](#cloud-deployment)
6. [Environment Configuration](#environment-configuration)
7. [Flussonic Integration](#flussonic-integration)
8. [Monitoring and Maintenance](#monitoring-and-maintenance)
9. [Troubleshooting](#troubleshooting)

## Prerequisites

Before deploying, ensure you have:

- **Flussonic Media Server** running and accessible
- **Database** (SQLite for development, PostgreSQL for production)
- **Node.js** (v18 or higher) for manual deployment
- **Docker** and **Docker Compose** for containerized deployment
- **Domain name** (optional, for production)
- **SSL certificate** (recommended for production)

## Local Development Deployment

### Step 1: Clone the Repository

```bash
git clone https://github.com/shihan84/Scte35-scheduler.git
cd scte35-scheduler
```

### Step 2: Install Dependencies

```bash
npm install
```

### Step 3: Configure Environment

```bash
cp .env.example .env.local
```

Edit `.env.local` with your configuration:
```env
# Database
DATABASE_URL="file:./db/custom.db"

# Flussonic Configuration
FLUSSONIC_URL="http://localhost:8080"
FLUSSONIC_API_KEY="admin:password"

# Next.js
NEXTAUTH_SECRET="your-secret-key-here"
NEXTAUTH_URL="http://localhost:3000"
```

### Step 4: Initialize Database

```bash
npm run db:push
npm run db:generate
```

### Step 5: Start Development Server

```bash
# Start the main application
npm run dev

# In a separate terminal, start the cron service
npm run cron
```

### Step 6: Access the Application

Open your browser and navigate to `http://localhost:3000`

## Production Deployment with Docker

### Option A: Using Docker Compose (Recommended)

#### Step 1: Clone the Repository

```bash
git clone https://github.com/shihan84/Scte35-scheduler.git
cd scte35-scheduler
```

#### Step 2: Configure Environment

```bash
cp .env.example .env.production
```

Edit `.env.production`:
```env
# Database
DATABASE_URL="postgresql://username:password@postgres:5432/scte35_scheduler"

# Flussonic Configuration
FLUSSONIC_URL="http://your-flussonic-server:8080"
FLUSSONIC_API_KEY="admin:your-api-key"

# Next.js
NEXTAUTH_SECRET="your-production-secret-key"
NEXTAUTH_URL="https://your-domain.com"

# Docker
NODE_ENV="production"
```

#### Step 3: Start Docker Compose

```bash
# For Linux/macOS
docker-compose up -d

# For Windows
docker-compose -f docker-compose.windows.yml up -d
```

#### Step 4: Verify Deployment

```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs -f app
```

#### Step 5: Access the Application

The application will be available at `http://localhost:3000`

### Option B: Manual Docker Build

#### Step 1: Build the Docker Image

```bash
docker build -t scte35-scheduler .
```

#### Step 2: Run the Container

```bash
docker run -d \
  --name scte35-scheduler \
  -p 3000:3000 \
  -e DATABASE_URL="file:./db/custom.db" \
  -e FLUSSONIC_URL="http://your-flussonic-server:8080" \
  -e FLUSSONIC_API_KEY="admin:your-api-key" \
  -e NEXTAUTH_SECRET="your-secret-key" \
  -e NEXTAUTH_URL="http://localhost:3000" \
  scte35-scheduler
```

#### Step 3: Start the Cron Service

```bash
docker run -d \
  --name scte35-cron \
  -e DATABASE_URL="file:./db/custom.db" \
  -e FLUSSONIC_URL="http://your-flussonic-server:8080" \
  -e FLUSSONIC_API_KEY="admin:your-api-key" \
  scte35-scheduler \
  npm run cron
```

## Manual Server Deployment

### Step 1: Prepare the Server

#### Update System Packages

```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y

# CentOS/RHEL
sudo yum update -y
```

#### Install Node.js

```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# CentOS/RHEL
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs
```

#### Install PM2 (Process Manager)

```bash
sudo npm install -g pm2
```

### Step 2: Deploy the Application

#### Clone the Repository

```bash
git clone https://github.com/shihan84/Scte35-scheduler.git
cd scte35-scheduler
```

#### Install Dependencies

```bash
npm install --production
```

#### Configure Environment

```bash
cp .env.example .env.production
```

Edit `.env.production`:
```env
# Database
DATABASE_URL="postgresql://username:password@localhost:5432/scte35_scheduler"

# Flussonic Configuration
FLUSSONIC_URL="http://your-flussonic-server:8080"
FLUSSONIC_API_KEY="admin:your-api-key"

# Next.js
NEXTAUTH_SECRET="your-production-secret-key"
NEXTAUTH_URL="https://your-domain.com"

# Production
NODE_ENV="production"
```

#### Build the Application

```bash
npm run build
```

#### Initialize Database

```bash
npm run db:push
npm run db:generate
```

### Step 3: Set Up PM2

#### Create PM2 Configuration File

```bash
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [
    {
      name: 'scte35-scheduler',
      script: 'npm',
      args: 'start',
      cwd: './',
      instances: 'max',
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      error_file: './logs/err.log',
      out_file: './logs/out.log',
      log_file: './logs/combined.log',
      time: true
    },
    {
      name: 'scte35-cron',
      script: 'npm',
      args: 'run cron',
      cwd: './',
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/cron-err.log',
      out_file: './logs/cron-out.log',
      log_file: './logs/cron-combined.log',
      time: true
    }
  ]
}
EOF
```

#### Create Logs Directory

```bash
mkdir -p logs
```

#### Start Applications with PM2

```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

### Step 4: Set Up Reverse Proxy (Nginx)

#### Install Nginx

```bash
# Ubuntu/Debian
sudo apt install nginx -y

# CentOS/RHEL
sudo yum install nginx -y
```

#### Configure Nginx

```bash
sudo tee /etc/nginx/sites-available/scte35-scheduler << 'EOF'
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF
```

#### Enable the Site

```bash
sudo ln -s /etc/nginx/sites-available/scte35-scheduler /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Step 5: Set Up SSL (Let's Encrypt)

#### Install Certbot

```bash
# Ubuntu/Debian
sudo apt install certbot python3-certbot-nginx -y

# CentOS/RHEL
sudo yum install certbot python3-certbot-nginx -y
```

#### Obtain SSL Certificate

```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

#### Auto-renewal

```bash
sudo systemctl status certbot.timer
sudo certbot renew --dry-run
```

## Cloud Deployment

### AWS Deployment

#### Using AWS EC2

1. **Launch EC2 Instance**
   - Choose Ubuntu 20.04 LTS or Amazon Linux 2
   - Configure security groups (ports 22, 80, 443)
   - Attach IAM role with necessary permissions

2. **Connect to Instance**
   ```bash
   ssh -i your-key.pem ec2-user@your-ec2-public-ip
   ```

3. **Follow Manual Server Deployment** steps above

#### Using AWS ECS (Fargate)

1. **Create ECR Repository**
   ```bash
   aws ecr create-repository --repository-name scte35-scheduler
   ```

2. **Build and Push Docker Image**
   ```bash
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
   docker build -t scte35-scheduler .
   docker tag scte35-scheduler:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/scte35-scheduler:latest
   docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/scte35-scheduler:latest
   ```

3. **Create ECS Task Definition**
   ```json
   {
     "family": "scte35-scheduler",
     "networkMode": "awsvpc",
     "requiresCompatibilities": ["FARGATE"],
     "cpu": "256",
     "memory": "512",
     "executionRoleArn": "arn:aws:iam::123456789012:role/ecsTaskExecutionRole",
     "containerDefinitions": [
       {
         "name": "scte35-scheduler",
         "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/scte35-scheduler:latest",
         "portMappings": [
           {
             "containerPort": 3000,
             "protocol": "tcp"
           }
         ],
         "environment": [
           {
             "name": "NODE_ENV",
             "value": "production"
           },
           {
             "name": "DATABASE_URL",
             "value": "postgresql://user:pass@db:5432/scte35"
           },
           {
             "name": "FLUSSONIC_URL",
             "value": "http://your-flussonic-server:8080"
           },
           {
             "name": "FLUSSONIC_API_KEY",
             "value": "admin:your-api-key"
           }
         ],
         "logConfiguration": {
           "logDriver": "awslogs",
           "options": {
             "awslogs-group": "/ecs/scte35-scheduler",
             "awslogs-region": "us-east-1",
             "awslogs-stream-prefix": "ecs"
           }
         }
       }
     ]
   }
   ```

### Google Cloud Platform

#### Using Google Cloud Run

1. **Build and Push Docker Image**
   ```bash
   gcloud auth configure-docker
   gcloud builds submit --tag gcr.io/your-project-id/scte35-scheduler
   docker push gcr.io/your-project-id/scte35-scheduler
   ```

2. **Deploy to Cloud Run**
   ```bash
   gcloud run deploy scte35-scheduler \
     --image gcr.io/your-project-id/scte35-scheduler \
     --platform managed \
     --region us-central1 \
     --allow-unauthenticated \
     --set-env-vars "NODE_ENV=production,DATABASE_URL=your-db-url,FLUSSONIC_URL=http://your-flussonic-server:8080,FLUSSONIC_API_KEY=admin:your-api-key"
   ```

### Azure Deployment

#### Using Azure Container Instances

1. **Create Resource Group**
   ```bash
   az group create --name scte35-scheduler-rg --location eastus
   ```

2. **Build and Push to ACR**
   ```bash
   az acr create --resource-group scte35-scheduler-rg --name scte35acr --sku Basic
   az acr login --name scte35acr
   docker build -t scte35acr.azurecr.io/scte35-scheduler:v1 .
   docker push scte35acr.azurecr.io/scte35-scheduler:v1
   ```

3. **Deploy Container**
   ```bash
   az container create \
     --resource-group scte35-scheduler-rg \
     --name scte35-scheduler \
     --image scte35acr.azurecr.io/scte35-scheduler:v1 \
     --dns-name-label scte35-scheduler-unique \
     --ports 3000 \
     --environment-variables \
       'NODE_ENV=production' \
       'DATABASE_URL=your-db-url' \
       'FLUSSONIC_URL=http://your-flussonic-server:8080' \
       'FLUSSONIC_API_KEY=admin:your-api-key'
   ```

## Environment Configuration

### Development Environment (.env.local)

```env
# Database
DATABASE_URL="file:./db/custom.db"

# Flussonic Configuration
FLUSSONIC_URL="http://localhost:8080"
FLUSSONIC_API_KEY="admin:password"

# Next.js
NEXTAUTH_SECRET="dev-secret-key"
NEXTAUTH_URL="http://localhost:3000"
```

### Production Environment (.env.production)

```env
# Database (PostgreSQL recommended for production)
DATABASE_URL="postgresql://username:password@localhost:5432/scte35_scheduler"

# Flussonic Configuration
FLUSSONIC_URL="http://your-flussonic-server:8080"
FLUSSONIC_API_KEY="admin:your-secure-api-key"

# Next.js
NEXTAUTH_SECRET="your-very-secure-production-secret-key"
NEXTAUTH_URL="https://your-domain.com"

# Production Settings
NODE_ENV="production"
```

### Docker Environment (.env.docker)

```env
# Database
DATABASE_URL="postgresql://postgres:password@postgres:5432/scte35_scheduler"

# Flussonic Configuration
FLUSSONIC_URL="http://host.docker.internal:8080"
FLUSSONIC_API_KEY="admin:your-api-key"

# Next.js
NEXTAUTH_SECRET="docker-secret-key"
NEXTAUTH_URL="http://localhost:3000"

# Docker
NODE_ENV="production"
```

## Flussonic Integration

### Step 1: Configure Flussonic for SCTE-35

Edit your Flussonic configuration file (`/etc/flussonic/flussonic.conf`):

```nginx
# Enable SCTE-35 for your stream
stream live {
  url udp://0.0.0.0:5000;
  scte35 true;
  scte35_out true;
}

# API endpoint for SCTE-35 injection
http {
  api /api {
    auth "admin:password";
  }
}
```

### Step 2: Test SCTE-35 Injection

```bash
# Test injection via curl
curl -X POST http://your-flussonic-server:8080/scte35/inject \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n admin:password | base64)" \
  -d '{
    "stream": "live",
    "cueId": "test_cue_001",
    "startTime": "2024-01-01T10:00:00Z",
    "duration": 30,
    "description": "Test ad break"
  }'
```

### Step 3: Verify SCTE-35 in Stream

Use a SCTE-35 analyzer or monitoring tool to verify that markers are being injected correctly into your stream.

## Monitoring and Maintenance

### Application Monitoring

#### Using PM2 Monitoring

```bash
# Monitor application status
pm2 monit

# View logs
pm2 logs scte35-scheduler
pm2 logs scte35-cron

# Restart applications
pm2 restart scte35-scheduler
pm2 restart scte35-cron

# Update applications
pm2 reload scte35-scheduler
```

#### Health Checks

```bash
# Application health
curl http://localhost:3000/api/health

# Database connectivity
npm run db:studio
```

### Log Management

#### Configure Log Rotation

```bash
# Install logrotate
sudo apt install logrotate -y

# Create logrotate configuration
sudo tee /etc/logrotate.d/scte35-scheduler << 'EOF'
/path/to/scte35-scheduler/logs/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 nodejs nodejs
}
EOF
```

### Backup and Recovery

#### Database Backup

```bash
# SQLite backup
sqlite3 db/custom.db ".backup db/custom_backup_$(date +%Y%m%d).db"

# PostgreSQL backup
pg_dump scte35_scheduler > scte35_backup_$(date +%Y%m%d).sql
```

#### Configuration Backup

```bash
# Backup environment files
tar -czf config_backup_$(date +%Y%m%d).tar.gz .env* .env.*

# Backup PM2 configuration
pm2 save
tar -czf pm2_backup_$(date +%Y%m%d).tar.gz ~/.pm2
```

### Updates and Upgrades

#### Application Updates

```bash
# Pull latest changes
git pull origin master

# Install updated dependencies
npm install

# Rebuild application
npm run build

# Update database schema if needed
npm run db:push
npm run db:generate

# Restart application
pm2 restart scte35-scheduler
pm2 restart scte35-cron
```

#### System Updates

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Update Node.js
sudo npm install -g n
sudo n stable

# Update PM2
sudo npm update -g pm2
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Application Won't Start

**Symptoms**: Application fails to start, error messages in logs

**Solutions**:
```bash
# Check PM2 status
pm2 status

# View error logs
pm2 logs scte35-scheduler --err

# Check port availability
netstat -tulpn | grep :3000

# Verify environment variables
pm2 env scte35-scheduler
```

#### 2. Database Connection Issues

**Symptoms**: Database connection errors, application crashes

**Solutions**:
```bash
# Test database connection
npm run db:studio

# Check database file permissions
ls -la db/

# Verify DATABASE_URL
echo $DATABASE_URL
```

#### 3. Flussonic Integration Issues

**Symptoms**: SCTE-35 markers not being injected, connection errors

**Solutions**:
```bash
# Test Flussonic connectivity
curl http://your-flussonic-server:8080/api/health

# Test SCTE-35 injection
curl -X POST http://your-flussonic-server:8080/scte35/inject \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n admin:password | base64)" \
  -d '{"stream": "live", "cueId": "test", "startTime": "2024-01-01T10:00:00Z", "duration": 30}'

# Check Flussonic logs
tail -f /var/log/flussonic/flussonic.log
```

#### 4. Cron Service Issues

**Symptoms**: Scheduled markers not being injected, cron service not running

**Solutions**:
```bash
# Check cron service status
pm2 status scte35-cron

# View cron logs
pm2 logs scte35-cron

# Manually test cron functionality
node src/lib/cron.js
```

#### 5. Performance Issues

**Symptoms**: Slow response times, high CPU/memory usage

**Solutions**:
```bash
# Monitor resource usage
pm2 monit

# Check application metrics
pm2 info scte35-scheduler

# Optimize database queries
npm run db:studio

# Increase PM2 instances if needed
pm2 scale scte35-scheduler 2
```

### Debug Mode

#### Enable Debug Logging

```bash
# Set debug environment variable
export DEBUG="scte35:*"

# Restart application with debug mode
pm2 restart scte35-scheduler --update-env
```

#### Database Debug

```bash
# Enable Prisma query logging
export DEBUG="prisma:query"

# View database operations
npm run dev
```

### Performance Optimization

#### Database Optimization

```bash
# Create database indexes
npm run db:push

# Analyze query performance
npm run db:studio
```

#### Application Optimization

```bash
# Enable Next.js production optimizations
npm run build

# Configure PM2 for optimal performance
pm2 describe scte35-scheduler
```

### Security Hardening

#### Firewall Configuration

```bash
# Configure UFW (Ubuntu)
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# Configure firewall rules
sudo iptables -A INPUT -p tcp --dport 3000 -j DROP
sudo iptables -A INPUT -s 127.0.0.1 -p tcp --dport 3000 -j ACCEPT
```

#### SSL/TLS Configuration

```bash
# Verify SSL configuration
sudo certbot certificates

# Test SSL security
openssl s_client -connect your-domain.com:443
```

## Support

For additional support:

1. **Check the logs** for detailed error messages
2. **Review the troubleshooting section** for common issues
3. **Consult the Flussonic documentation** for SCTE-35 configuration
4. **Create an issue** on GitHub for bug reports or feature requests

## Conclusion

This deployment guide provides comprehensive instructions for deploying the SCTE-35 Scheduler in various environments. Choose the deployment method that best fits your infrastructure and requirements.

For production deployments, we recommend using Docker with Docker Compose or a cloud provider's managed container service for better scalability and maintainability.

Remember to:
- Always use environment variables for sensitive configuration
- Implement proper backup strategies
- Monitor application performance and logs
- Keep dependencies and system packages updated
- Follow security best practices

Your SCTE-35 Scheduler is now ready for production use!