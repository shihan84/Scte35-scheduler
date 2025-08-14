# GitHub Setup Guide for SCTE-35 Scheduler

This guide will help you manually set up your GitHub repository and push the SCTE-35 Scheduler code.

## Prerequisites

- Git installed on your system
- GitHub account
- Personal access token (provided): `YOUR_TOKEN_HERE`
- Repository URL: `git@github.com:shihan84/Scte35-scheduler.git`

## Step 1: Configure Git (if not already configured)

```bash
# Set your Git username
git config --global user.name "Your Name"

# Set your Git email
git config --global user.email "your.email@example.com"
```

## Step 2: Initialize Git Repository

```bash
# Navigate to your project directory
cd /path/to/your/scte35-scheduler

# Initialize Git repository (if not already initialized)
git init
```

## Step 3: Add All Files to Staging

```bash
# Add all files to the staging area
git add .
```

## Step 4: Commit the Files

```bash
# Commit with a descriptive message
git commit -m "Initial commit: SCTE-35 Scheduler application

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Step 5: Add Remote Repository

```bash
# Add the GitHub repository as remote
git remote add origin git@github.com:shihan84/Scte35-scheduler.git
```

## Step 6: Push to GitHub

### Option A: Using SSH (recommended)

```bash
# Push to GitHub using SSH
git push -u origin master
```

If you get SSH-related errors, make sure:
- You have SSH keys set up in your GitHub account
- Your SSH agent is running
- You can connect to GitHub via SSH

### Option B: Using HTTPS with Personal Access Token

```bash
# Change remote URL to HTTPS
git remote set-url origin https://github.com/shihan84/Scte35-scheduler.git

# Push to GitHub (will prompt for username and password)
git push -u origin master
```

When prompted:
- **Username**: Your GitHub username
- **Password**: Your personal access token (you have this token)

### Option C: Using HTTPS with Token in URL

```bash
# Set remote URL with token embedded
git remote set-url origin https://YOUR_TOKEN_HERE@github.com/shihan84/Scte35-scheduler.git

# Push to GitHub
git push -u origin master
```

## Step 7: Verify the Push

```bash
# Check remote repository
git remote -v

# Check branch status
git status
```

## Step 8: Access Your Repository

Your repository should now be available at:
https://github.com/shihan84/Scte35-scheduler

## Troubleshooting

### Common Issues

1. **SSH Authentication Failed**
   ```bash
   # Test SSH connection
   ssh -T git@github.com
   ```
   If this fails, you need to set up SSH keys.

2. **HTTPS Authentication Failed**
   - Make sure you're using your personal access token, not your GitHub password
   - Ensure the token has the necessary permissions (repo, write:packages)

3. **Branch Name Issues**
   ```bash
   # Check current branch
   git branch
   
   # If on 'main' instead of 'master'
   git push -u origin main
   ```

4. **Repository Already Exists**
   ```bash
   # If you get an error about repository existing, force push
   git push -u origin master --force
   ```

### Setting Up SSH Keys (if needed)

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard
cat ~/.ssh/id_ed25519.pub
```

Then add the public key to your GitHub account:
1. Go to GitHub → Settings → SSH and GPG keys
2. Click "New SSH key"
3. Paste your public key
4. Test connection: `ssh -T git@github.com`

## Next Steps

After successfully pushing to GitHub:

1. **Clone the repository on other machines**:
   ```bash
   git clone git@github.com:shihan84/Scte35-scheduler.git
   cd scte35-scheduler
   ```

2. **Set up the project**:
   ```bash
   npm install
   cp .env.example .env.local
   # Edit .env.local with your Flussonic server details
   npm run db:push
   npm run db:generate
   npm run dev
   ```

3. **Configure GitHub Actions** (if needed):
   - The repository includes CI/CD workflows
   - They will automatically run on push and pull requests

## Repository Structure

Your GitHub repository now contains:
- Complete SCTE-35 Scheduler application
- Docker configuration files
- GitHub Actions workflows
- CLI setup instructions
- Comprehensive documentation

You can now collaborate with others, track changes, and deploy your application from the GitHub repository.