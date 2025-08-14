#!/bin/bash

# GitHub Setup Script for SCTE-35 Scheduler
# This script will initialize the git repository, add the remote, and push all files to GitHub

# Configuration
GITHUB_REPO="git@github.com:shihan84/Scte35-scheduler.git"
# PERSONAL_TOKEN="YOUR_TOKEN_HERE" # Replace with your actual token

echo "Setting up GitHub repository for SCTE-35 Scheduler..."

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Please install Git first."
    exit 1
fi

echo "Git is installed."

# Initialize git repository if not already initialized
if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
    echo "Git repository initialized."
else
    echo "Git repository already initialized."
fi

# Add all files to staging
echo "Adding files to staging area..."
git add .

# Commit the files
echo "Committing files..."
git commit -m "Initial commit: SCTE-35 Scheduler application

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Add the remote repository
echo "Adding remote repository..."
git remote add origin "$GITHUB_REPO"

# Configure Git with user details (if not already configured)
GIT_USER=$(git config --global user.name)
if [ -z "$GIT_USER" ]; then
    echo "Git user not configured. Please configure your Git user details:"
    read -p "Enter your Git username: " userName
    read -p "Enter your Git email: " userEmail
    
    git config --global user.name "$userName"
    git config --global user.email "$userEmail"
    
    echo "Git user configured."
fi

# Create a .gitignore file if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "Creating .gitignore file..."
    cat > .gitignore << 'EOF'
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
EOF
    echo ".gitignore file created."
fi

# Push to GitHub
echo "Pushing to GitHub repository..."
if git push -u origin main 2>/dev/null; then
    echo "Code successfully pushed to GitHub!"
else
    echo "Error pushing to GitHub. Trying to push to master branch instead..."
    if git push -u origin master 2>/dev/null; then
        echo "Code successfully pushed to GitHub!"
    else
        echo "Failed to push to GitHub. Please check your credentials and repository URL."
        echo "You may need to manually push using: git push -u origin main"
    fi
fi

echo "GitHub setup completed!"
echo "Repository URL: https://github.com/shihan84/Scte35-scheduler"
echo "You can now clone this repository on any machine using:"
echo "git clone $GITHUB_REPO"