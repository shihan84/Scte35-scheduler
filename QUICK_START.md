# SCTE-35 Scheduler - Quick Start Deployment Guide

This guide provides a quick and simple way to deploy the SCTE-35 Scheduler application.

## 🚀 Fastest Deployment (Docker)

### Step 1: Clone the Repository
```bash
git clone https://github.com/shihan84/Scte35-scheduler.git
cd scte35-scheduler
```

### Step 2: Configure Environment
```bash
cp .env.example .env
```

Edit `.env` file:
```env
# Flussonic Configuration (IMPORTANT: Update these!)
FLUSSONIC_URL="http://your-flussonic-server:8080"
FLUSSONIC_API_KEY="admin:your-api-key"

# You can keep other settings as defaults for now
DATABASE_URL="postgresql://postgres:password@postgres:5432/scte35_scheduler"
NEXTAUTH_SECRET="your-secret-key-here"
NEXTAUTH_URL="http://localhost:3000"
```

### Step 3: Start with Docker Compose
```bash
# Linux/macOS
docker-compose up -d

# Windows
docker-compose -f docker-compose.windows.yml up -d
```

### Step 4: Access the Application
Open your browser and go to: `http://localhost:3000`

**That's it! Your SCTE-35 Scheduler is now running!**

---

## 🏠 Local Development Setup

### Step 1: Clone and Install
```bash
git clone https://github.com/shihan84/Scte35-scheduler.git
cd scte35-scheduler
npm install
```

### Step 2: Configure Environment
```bash
cp .env.example .env.local
```

Edit `.env.local` with your Flussonic server details:
```env
FLUSSONIC_URL="http://localhost:8080"
FLUSSONIC_API_KEY="admin:password"
```

### Step 3: Setup Database
```bash
npm run db:push
npm run db:generate
```

### Step 4: Start the Application
```bash
# Terminal 1: Start the web application
npm run dev

# Terminal 2: Start the cron service (for automated injection)
npm run cron
```

### Step 5: Access the Application
Open your browser and go to: `http://localhost:3000`

---

## ☁️ Cloud Deployment (One-Click)

### AWS (Using ECS)
```bash
# 1. Install AWS CLI and configure credentials
aws configure

# 2. Build and push to ECR
aws ecr create-repository --repository-name scte35-scheduler
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
docker build -t scte35-scheduler .
docker tag scte35-scheduler:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/scte35-scheduler:latest
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/scte35-scheduler:latest

# 3. Deploy using AWS Console or CLI
# Use the provided task definition in DEPLOYMENT.md
```

### Google Cloud Run
```bash
# 1. Install Google Cloud SDK and authenticate
gcloud auth login
gcloud config set project your-project-id

# 2. Build and deploy
gcloud builds submit --tag gcr.io/your-project-id/scte35-scheduler
gcloud run deploy scte35-scheduler \
  --image gcr.io/your-project-id/scte35-scheduler \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars "FLUSSONIC_URL=http://your-flussonic-server:8080,FLUSSONIC_API_KEY=admin:your-api-key"
```

### Azure Container Instances
```bash
# 1. Install Azure CLI and login
az login

# 2. Create resource group and deploy
az group create --name scte35-scheduler-rg --location eastus
az container create \
  --resource-group scte35-scheduler-rg \
  --name scte35-scheduler \
  --image your-registry/scte35-scheduler:latest \
  --dns-name-label scte35-unique-name \
  --ports 3000 \
  --environment-variables \
    'FLUSSONIC_URL=http://your-flussonic-server:8080' \
    'FLUSSONIC_API_KEY=admin:your-api-key'
```

---

## ⚙️ Essential Configuration

### Flussonic Server Setup

1. **Edit Flussonic Configuration** (`/etc/flussonic/flussonic.conf`):
```nginx
stream your-stream-name {
  url udp://0.0.0.0:5000;
  scte35 true;
  scte35_out true;
}

http {
  api /api {
    auth "admin:password";
  }
}
```

2. **Restart Flussonic**:
```bash
sudo systemctl restart flussonic
```

3. **Test SCTE-35 Injection**:
```bash
curl -X POST http://your-flussonic-server:8080/scte35/inject \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n admin:password | base64)" \
  -d '{"stream": "your-stream-name", "cueId": "test", "startTime": "2024-01-01T10:00:00Z", "duration": 30}'
```

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `FLUSSONIC_URL` | Your Flussonic server URL | `http://192.168.1.100:8080` |
| `FLUSSONIC_API_KEY` | Flussonic API credentials | `admin:your-password` |
| `DATABASE_URL` | Database connection string | `postgresql://user:pass@localhost:5432/db` |
| `NEXTAUTH_SECRET` | Next.js secret key | `your-secret-key-here` |
| `NEXTAUTH_URL` | Application URL | `http://localhost:3000` |

---

## 🔍 First Steps After Deployment

### 1. Create Your First Schedule
1. Open the web application (`http://localhost:3000`)
2. Click "New Schedule"
3. Fill in the details:
   - **Stream Name**: Your Flussonic stream name
   - **Start Time**: When the ad break should begin
   - **End Time**: When the ad break should end
   - **Duration**: Length in seconds (e.g., 30)
4. Click "Create Schedule"

### 2. Test the Integration
1. Check if the schedule appears in the list
2. Verify that SCTE-35 markers are being injected into your stream
3. Monitor the application logs for any errors

### 3. Monitor the Application
```bash
# Docker logs
docker-compose logs -f app

# PM2 logs (if using manual deployment)
pm2 logs scte35-scheduler

# Health check
curl http://localhost:3000/api/health
```

---

## 🛠️ Common Commands

### Docker Management
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f app

# Restart services
docker-compose restart

# Update and rebuild
docker-compose up -d --build
```

### Manual Deployment (PM2)
```bash
# Start application
pm2 start ecosystem.config.js

# Stop application
pm2 stop scte35-scheduler

# Restart application
pm2 restart scte35-scheduler

# Monitor application
pm2 monit

# View logs
pm2 logs scte35-scheduler
```

### Database Management
```bash
# Open Prisma Studio (database GUI)
npm run db:studio

# Reset database
npm run db:push

# Generate Prisma client
npm run db:generate
```

---

## 🚨 Troubleshooting

### Application Won't Start
```bash
# Check logs
docker-compose logs app

# Check port availability
netstat -tulpn | grep :3000

# Verify environment variables
docker-compose config
```

### Flussonic Connection Issues
```bash
# Test Flussonic connectivity
curl http://your-flussonic-server:8080/api/health

# Test SCTE-35 injection
curl -X POST http://your-flussonic-server:8080/scte35/inject \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n admin:password | base64)" \
  -d '{"stream": "test", "startTime": "2024-01-01T10:00:00Z", "duration": 30}'
```

### Database Issues
```bash
# Check database connection
npm run db:studio

# Reset database
rm -f db/custom.db
npm run db:push
```

---

## 📚 Next Steps

1. **Configure Your Streams**: Update your Flussonic configuration to enable SCTE-35 for all your live streams
2. **Set Up Monitoring**: Configure logging and monitoring for production use
3. **Configure SSL**: Set up SSL certificates for production deployments
4. **Set Up Backups**: Configure database and configuration backups
5. **Test End-to-End**: Verify that SCTE-35 markers are being injected correctly into your streams

---

## 🆘 Need Help?

- **Check the full deployment guide**: `DEPLOYMENT.md`
- **Review the troubleshooting section**: Common issues and solutions
- **Check the logs**: Application logs provide detailed error information
- **Test Flussonic connectivity**: Ensure your Flussonic server is accessible
- **Create an issue**: Report bugs or request features on GitHub

**Your SCTE-35 Scheduler is now ready to schedule ad breaks for your live streams!** 🎉