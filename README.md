# SCTE-35 Scheduler

A comprehensive web-based application for scheduling SCTE-35 markers for live streaming ad insertion, designed specifically for broadcasters using OBS and Flussonic Media Server.

## 🎯 Overview

The SCTE-35 Scheduler provides broadcasters with an intuitive interface to schedule SCTE-35 markers that trigger ad breaks in live streams. Perfect for broadcasters pushing SRT streams to distributors like JioTV and TataPlay.

## ✨ Key Features

- **🖥️ Web Interface**: Intuitive scheduling system with real-time management
- **🔌 SCTE-35 Integration**: Automatic injection of markers into Flussonic streams
- **⏰ Automated Injection**: Cron-based service for timely marker delivery
- **🗄️ Database Storage**: Persistent storage using Prisma ORM with SQLite/PostgreSQL
- **📱 Responsive Design**: Works seamlessly on desktop and mobile devices
- **🐳 Docker Support**: Containerized deployment for easy scaling
- **🔄 Real-time Updates**: Live status monitoring and schedule management

## 🚀 Quick Start

### Fastest Deployment (Docker)

```bash
# Clone the repository
git clone https://github.com/shihan84/Scte35-scheduler.git
cd scte35-scheduler

# Configure environment
cp .env.example .env
# Edit .env with your Flussonic server details

# Start with Docker
docker-compose up -d

# Access the application
open http://localhost:3000
```

### Local Development

```bash
# Clone and install
git clone https://github.com/shihan84/Scte35-scheduler.git
cd scte35-scheduler
npm install

# Configure environment
cp .env.example .env.local
# Edit with your Flussonic server details

# Setup database
npm run db:push
npm run db:generate

# Start the application
npm run dev
# In another terminal: npm run cron
```

## 🛠️ Technology Stack

### Core Framework
- **Next.js 15** - React framework with App Router
- **TypeScript 5** - Type-safe development
- **Tailwind CSS 4** - Utility-first styling

### Backend & Database
- **Prisma ORM** - Modern database toolkit
- **SQLite/PostgreSQL** - Database options
- **Node.js** - Runtime environment

### UI Components
- **shadcn/ui** - High-quality accessible components
- **Lucide React** - Beautiful icon library
- **Radix UI** - Low-level component primitives

### Deployment
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **PM2** - Process manager for production

## 📋 Prerequisites

- Node.js (v18 or higher)
- Flussonic Media Server
- Git
- Docker (optional, for containerized deployment)

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `FLUSSONIC_URL` | Flussonic server URL | ✅ | `http://localhost:8080` |
| `FLUSSONIC_API_KEY` | Flussonic API credentials | ✅ | `admin:password` |
| `DATABASE_URL` | Database connection string | ✅ | `file:./db/custom.db` |
| `NEXTAUTH_SECRET` | Next.js secret key | ✅ | `your-secret-key` |
| `NEXTAUTH_URL` | Application URL | ✅ | `http://localhost:3000` |

### Flussonic Server Setup

Configure your Flussonic server to accept SCTE-35 injection:

```nginx
# /etc/flussonic/flussonic.conf
stream live-channel {
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

## 📖 Documentation

- **[Quick Start Guide](QUICK_START.md)** - Fastest way to get running
- **[Deployment Guide](DEPLOYMENT.md)** - Comprehensive deployment instructions
- **[CLI Setup Guide](CLI_SETUP.md)** - Complete CLI commands for project creation
- **[GitHub Setup Guide](GITHUB_SETUP.md)** - GitHub repository setup instructions

## 🎮 Usage

### Creating a Schedule

1. **Open the web interface** at `http://localhost:3000`
2. **Click "New Schedule"** to create a new SCTE-35 marker schedule
3. **Fill in the required fields**:
   - **Stream Name**: Your Flussonic stream identifier
   - **Start Time**: When the ad break should begin
   - **End Time**: When the ad break should end
   - **Duration**: Length of the ad break in seconds
4. **Optional fields**:
   - **Cue ID**: Custom identifier for the SCTE-35 marker
   - **Description**: Notes about the ad break
   - **Active**: Enable/disable the schedule
5. **Click "Create Schedule"** to save

### Managing Schedules

- **View**: All schedules displayed in an organized list
- **Edit**: Click the edit icon to modify existing schedules
- **Delete**: Click the trash icon to remove schedules
- **Status**: Active/Inactive badges show current status

### Automated Injection

The cron service runs every minute to:
- Check for upcoming schedules
- Inject SCTE-35 markers into Flussonic streams
- Update marker information for modified schedules
- Clean up expired markers

## 🚢 Deployment Options

### Docker Deployment (Recommended)

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Manual Server Deployment

```bash
# Using PM2 process manager
npm install -g pm2
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

### Cloud Deployment

- **AWS ECS**: See deployment guide for detailed instructions
- **Google Cloud Run**: One-click deployment with Docker
- **Azure Container Instances**: Quick Azure deployment
- **Heroku**: Platform-as-a-Service deployment

## 🔧 API Endpoints

### SCTE-35 Schedules

- `GET /api/scte35` - Get all schedules
- `GET /api/scte35?id={id}` - Get specific schedule
- `POST /api/scte35` - Create new schedule
- `PUT /api/scte35?id={id}` - Update schedule
- `DELETE /api/scte35?id={id}` - Delete schedule

### Health Check

- `GET /api/health` - Application health status

## 🗄️ Database Schema

### Scte35Schedule Model

| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Primary key |
| `streamName` | String | Flussonic stream name |
| `startTime` | DateTime | When the marker should be injected |
| `endTime` | DateTime | When the marker should expire |
| `cueId` | String? | Optional custom cue identifier |
| `duration` | Int | Duration in seconds |
| `description` | String? | Optional description |
| `isActive` | Boolean | Schedule status |
| `createdAt` | DateTime | Creation timestamp |
| `updatedAt` | DateTime | Last update timestamp |

## 🐛 Troubleshooting

### Common Issues

1. **Application won't start**
   ```bash
   # Check logs
   docker-compose logs app
   # or
   pm2 logs scte35-scheduler
   ```

2. **Flussonic connection issues**
   ```bash
   # Test connectivity
   curl http://your-flussonic-server:8080/api/health
   ```

3. **Database connection problems**
   ```bash
   # Reset database
   npm run db:push
   npm run db:generate
   ```

### Debug Mode

```bash
# Enable debug logging
export DEBUG="scte35:*"
pm2 restart scte35-scheduler --update-env
```

## 📊 Monitoring

### Application Health

```bash
# Health check
curl http://localhost:3000/api/health

# PM2 monitoring
pm2 monit

# View logs
pm2 logs scte35-scheduler
```

### Database Management

```bash
# Open Prisma Studio
npm run db:studio

# Check database status
npm run db:push
```

## 🔒 Security

### Best Practices

- Use environment variables for sensitive configuration
- Implement proper authentication for Flussonic API
- Use HTTPS in production
- Regularly update dependencies
- Monitor application logs for suspicious activity

### Environment Security

```bash
# Secure environment files
chmod 600 .env.local
chmod 600 .env.production

# Use secrets management in production
# Consider using AWS Secrets Manager, Azure Key Vault, or similar
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:

- **Documentation**: Check the comprehensive guides in this repository
- **Issues**: Create an issue on GitHub for bug reports or feature requests
- **Flussonic Docs**: Refer to Flussonic documentation for SCTE-35 configuration
- **Community**: Join discussions in the GitHub Issues section

## 🙏 Acknowledgments

- **Next.js Team** - For the excellent React framework
- **Prisma Team** - For the modern ORM
- **shadcn/ui** - For the beautiful component library
- **Flussonic Team** - For the robust streaming platform
- **Broadcast Community** - For inspiring this solution

---

**Built with ❤️ for live broadcasters everywhere.**

Perfect for OBS users streaming to Flussonic and distributing to platforms like JioTV and TataPlay! 🎥📺