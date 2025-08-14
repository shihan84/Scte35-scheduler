# GitHub Setup Script for SCTE-35 Scheduler
# This script will initialize the git repository, add the remote, and push all files to GitHub

# Configuration
$GITHUB_REPO = "git@github.com:shihan84/Scte35-scheduler.git"
# $PERSONAL_TOKEN = "YOUR_TOKEN_HERE" # Replace with your actual token

Write-Host "Setting up GitHub repository for SCTE-35 Scheduler..." -ForegroundColor Green

# Check if git is installed
try {
    git --version
    Write-Host "Git is installed." -ForegroundColor Green
} catch {
    Write-Host "Git is not installed. Please install Git first." -ForegroundColor Red
    exit 1
}

# Initialize git repository if not already initialized
if (-not (Test-Path -Path ".git")) {
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    git init
    Write-Host "Git repository initialized." -ForegroundColor Green
} else {
    Write-Host "Git repository already initialized." -ForegroundColor Green
}

# Add all files to staging
Write-Host "Adding files to staging area..." -ForegroundColor Yellow
git add .

# Commit the files
Write-Host "Committing files..." -ForegroundColor Yellow
git commit -m "Initial commit: SCTE-35 Scheduler application

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Add the remote repository
Write-Host "Adding remote repository..." -ForegroundColor Yellow
git remote add origin $GITHUB_REPO

# Configure Git with user details (if not already configured)
$gitUser = git config --global user.name
if ([string]::IsNullOrEmpty($gitUser)) {
    Write-Host "Git user not configured. Please configure your Git user details:" -ForegroundColor Yellow
    $userName = Read-Host "Enter your Git username"
    $userEmail = Read-Host "Enter your Git email"
    
    git config --global user.name $userName
    git config --global user.email $userEmail
    
    Write-Host "Git user configured." -ForegroundColor Green
}

# Create a .gitignore file if it doesn't exist
if (-not (Test-Path -Path ".gitignore")) {
    Write-Host "Creating .gitignore file..." -ForegroundColor Yellow
    @"
# Dependencies
node_modules/
/.pnp
.pnp.js

# Testing
/coverage

# Next.js
/.next/
/out/

# Production
/build

# Misc
.DS_Store
*.pem

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Local env files
.env*.local

# Vercel
.vercel

# TypeScript
*.tsbuildinfo
next-env.d.ts

# Database
*.db
*.sqlite
*.sqlite3

# Docker
.dockerignore

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage
*.lcov

# nyc test coverage
.nyc_output

# Dependency directories
node_modules/
jspm_packages/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.test
.env.production

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# Next.js build output
.next
out

# Nuxt.js build / generate output
.nuxt
dist

# Gatsby files
.cache/
public

# Storybook build outputs
.out
.storybook-out

# Temporary folders
tmp/
temp/

# Editor directories and files
.vscode/
.idea
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Prisma
migrations/
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8
    Write-Host ".gitignore file created." -ForegroundColor Green
}

# Push to GitHub
Write-Host "Pushing to GitHub repository..." -ForegroundColor Yellow
try {
    git push -u origin main
    Write-Host "Code successfully pushed to GitHub!" -ForegroundColor Green
} catch {
    Write-Host "Error pushing to GitHub. Trying to push to master branch instead..." -ForegroundColor Yellow
    try {
        git push -u origin master
        Write-Host "Code successfully pushed to GitHub!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to push to GitHub. Please check your credentials and repository URL." -ForegroundColor Red
        Write-Host "You may need to manually push using: git push -u origin main" -ForegroundColor Yellow
    }
}

Write-Host "GitHub setup completed!" -ForegroundColor Green
Write-Host "Repository URL: https://github.com/shihan84/Scte35-scheduler" -ForegroundColor Cyan
Write-Host "You can now clone this repository on any machine using:" -ForegroundColor Cyan
Write-Host "git clone $GITHUB_REPO" -ForegroundColor Cyan