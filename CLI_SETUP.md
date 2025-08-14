# SCTE-35 Scheduler - CLI Setup Guide

This guide provides step-by-step CLI commands to create the entire SCTE-35 Scheduler project from scratch and push it to GitHub.

## Prerequisites

- Node.js (v18 or higher)
- npm or yarn
- Git
- GitHub account
- Windows PowerShell (for Windows) or Bash (for Linux/macOS)

## Step 1: Create Project Directory and Initialize Next.js

```bash
# Create project directory
mkdir scte35-scheduler
cd scte35-scheduler

# Initialize Next.js project with TypeScript
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"

# Install additional dependencies
npm install prisma @prisma/client zod socket.io socket.io-client lucide-react class-variance-authority clsx tailwind-merge @radix-ui/react-slot @radix-ui/react-dialog @radix-ui/react-dropdown-menu @radix-ui/react-toast @radix-ui/react-label @radix-ui/react-select @radix-ui/react-switch @radix-ui/react-tabs @radix-ui/react-alert-dialog @radix-ui/react-accordion @radix-ui/react-avatar @radix-ui/react-checkbox @radix-ui/react-collapsible @radix-ui/react-context-menu @radix-ui/react-hover-card @radix-ui/react-menubar @radix-ui/react-navigation-menu @radix-ui/react-popover @radix-ui/react-progress @radix-ui/react-radio-group @radix-ui/react-scroll-area @radix-ui/react-separator @radix-ui/react-slider @radix-ui/react-switch @radix-ui/react-table @radix-ui/react-tabs @radix-ui/react-toggle @radix-ui/react-toggle-group @radix-ui/react-tooltip recharts date-fns z-ai-web-dev-sdk

# Install development dependencies
npm install -D @types/node @types/react @types/react-dom typescript
```

## Step 2: Initialize Prisma

```bash
# Initialize Prisma
npx prisma init --datasource-provider sqlite

# Create database directory
mkdir -p db
```

## Step 3: Create Project Structure

```bash
# Create source directories
mkdir -p src/app/api/scte35 src/app/api/health src/components/ui src/hooks src/lib examples/websocket

# Create public directory
mkdir -p public
```

## Step 4: Create Configuration Files

### package.json
```bash
cat > package.json << 'EOF'
{
  "name": "scte35-scheduler",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "db:push": "prisma db push",
    "db:studio": "prisma studio",
    "db:generate": "prisma generate",
    "cron": "node src/lib/cron.js"
  },
  "dependencies": {
    "@prisma/client": "^5.6.0",
    "@radix-ui/react-accordion": "^1.1.2",
    "@radix-ui/react-alert-dialog": "^1.0.5",
    "@radix-ui/react-avatar": "^1.0.4",
    "@radix-ui/react-checkbox": "^1.0.4",
    "@radix-ui/react-collapsible": "^1.0.3",
    "@radix-ui/react-context-menu": "^2.1.5",
    "@radix-ui/react-dialog": "^1.0.5",
    "@radix-ui/react-dropdown-menu": "^2.0.6",
    "@radix-ui/react-hover-card": "^1.0.7",
    "@radix-ui/react-label": "^2.0.2",
    "@radix-ui/react-menubar": "^1.0.4",
    "@radix-ui/react-navigation-menu": "^1.1.4",
    "@radix-ui/react-popover": "^1.0.7",
    "@radix-ui/react-progress": "^1.0.3",
    "@radix-ui/react-radio-group": "^1.1.3",
    "@radix-ui/react-scroll-area": "^1.0.5",
    "@radix-ui/react-select": "^2.0.0",
    "@radix-ui/react-separator": "^1.0.3",
    "@radix-ui/react-slider": "^1.1.2",
    "@radix-ui/react-slot": "^1.0.2",
    "@radix-ui/react-switch": "^1.0.3",
    "@radix-ui/react-tabs": "^1.0.4",
    "@radix-ui/react-toast": "^1.1.5",
    "@radix-ui/react-toggle": "^1.0.3",
    "@radix-ui/react-toggle-group": "^1.0.4",
    "@radix-ui/react-tooltip": "^1.0.7",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "date-fns": "^2.30.0",
    "lucide-react": "^0.292.0",
    "next": "15.0.0",
    "react": "^18",
    "react-dom": "^18",
    "recharts": "^2.8.0",
    "socket.io": "^4.7.4",
    "socket.io-client": "^4.7.4",
    "tailwind-merge": "^2.0.0",
    "tailwindcss-animate": "^1.0.7",
    "z-ai-web-dev-sdk": "^1.0.0",
    "zod": "^3.22.4"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "autoprefixer": "^10.0.1",
    "eslint": "^8",
    "eslint-config-next": "15.0.0",
    "postcss": "^8",
    "prisma": "^5.6.0",
    "tailwindcss": "^3.3.0",
    "typescript": "^5"
  },
  "description": "SCTE-35 Scheduler for live streaming ad insertion",
  "keywords": ["scte35", "flussonic", "streaming", "ads", "scheduler"],
  "author": "Your Name",
  "license": "MIT"
}
EOF
```

### tsconfig.json
```bash
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF
```

### tailwind.config.ts
```bash
cat > tailwind.config.ts << 'EOF'
import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  prefix: "",
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: "0" },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: "0" },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
} satisfies Config;

export default config;
EOF
```

### components.json
```bash
cat > components.json << 'EOF'
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.ts",
    "css": "src/app/globals.css",
    "baseColor": "neutral",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils"
  }
}
EOF
```

## Step 5: Create Database Schema

### prisma/schema.prisma
```bash
cat > prisma/schema.prisma << 'EOF'
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = "file:./db/custom.db"
}

model Scte35Schedule {
  id          String   @id @default(cuid())
  streamName  String
  startTime   DateTime
  endTime     DateTime
  cueId       String?
  duration    Int      // Duration in seconds
  description String?
  isActive    Boolean  @default(true)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  @@map("scte35_schedules")
}
EOF
```

## Step 6: Create Database Client

### src/lib/db.ts
```bash
cat > src/lib/db.ts << 'EOF'
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const db =
  globalForPrisma.prisma ??
  new PrismaClient({
    log: ['query'],
  })

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = db
EOF
```

## Step 7: Create Utility Functions

### src/lib/utils.ts
```bash
cat > src/lib/utils.ts << 'EOF'
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOF
```

### src/lib/scte35.ts
```bash
cat > src/lib/scte35.ts << 'EOF'
import { db } from './db'
import { z } from 'zod'

const Scte35ScheduleSchema = z.object({
  streamName: z.string().min(1, 'Stream name is required'),
  startTime: z.string().min(1, 'Start time is required'),
  endTime: z.string().min(1, 'End time is required'),
  cueId: z.string().optional(),
  duration: z.number().min(1, 'Duration must be at least 1 second'),
  description: z.string().optional(),
  isActive: z.boolean().default(true),
})

export type Scte35ScheduleInput = z.infer<typeof Scte35ScheduleSchema>

export interface Scte35Schedule {
  id: string
  streamName: string
  startTime: Date
  endTime: Date
  cueId?: string
  duration: number
  description?: string
  isActive: boolean
  createdAt: Date
  updatedAt: Date
}

export class Scte35Service {
  private flussonicUrl: string
  private flussonicApiKey: string

  constructor() {
    this.flussonicUrl = process.env.FLUSSONIC_URL || 'http://localhost:8080'
    this.flussonicApiKey = process.env.FLUSSONIC_API_KEY || 'admin:password'
  }

  async createSchedule(data: Scte35ScheduleInput): Promise<Scte35Schedule> {
    const validatedData = Scte35ScheduleSchema.parse(data)
    
    const schedule = await db.scte35Schedule.create({
      data: {
        ...validatedData,
        startTime: new Date(validatedData.startTime),
        endTime: new Date(validatedData.endTime),
      },
    })

    // Inject SCTE-35 marker into Flussonic
    await this.injectScte35Marker(schedule)

    return schedule
  }

  async getSchedules(): Promise<Scte35Schedule[]> {
    return await db.scte35Schedule.findMany({
      where: { isActive: true },
      orderBy: { startTime: 'asc' },
    })
  }

  async getSchedule(id: string): Promise<Scte35Schedule | null> {
    return await db.scte35Schedule.findUnique({
      where: { id },
    })
  }

  async updateSchedule(id: string, data: Partial<Scte35ScheduleInput>): Promise<Scte35Schedule> {
    const validatedData = Scte35ScheduleSchema.partial().parse(data)
    
    const updateData: any = { ...validatedData }
    if (validatedData.startTime) {
      updateData.startTime = new Date(validatedData.startTime)
    }
    if (validatedData.endTime) {
      updateData.endTime = new Date(validatedData.endTime)
    }

    const schedule = await db.scte35Schedule.update({
      where: { id },
      data: updateData,
    })

    // Update SCTE-35 marker in Flussonic
    await this.updateScte35Marker(schedule)

    return schedule
  }

  async deleteSchedule(id: string): Promise<void> {
    await db.scte35Schedule.delete({
      where: { id },
    })

    // Remove SCTE-35 marker from Flussonic
    await this.removeScte35Marker(id)
  }

  private async injectScte35Marker(schedule: Scte35Schedule): Promise<void> {
    try {
      const response = await fetch(`${this.flussonicUrl}/scte35/inject`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${Buffer.from(this.flussonicApiKey).toString('base64')}`,
        },
        body: JSON.stringify({
          stream: schedule.streamName,
          cueId: schedule.cueId || `cue_${schedule.id}`,
          startTime: schedule.startTime.toISOString(),
          duration: schedule.duration,
          description: schedule.description || 'Scheduled ad break',
        }),
      })

      if (!response.ok) {
        console.error('Failed to inject SCTE-35 marker:', await response.text())
      }
    } catch (error) {
      console.error('Error injecting SCTE-35 marker:', error)
    }
  }

  private async updateScte35Marker(schedule: Scte35Schedule): Promise<void> {
    try {
      const response = await fetch(`${this.flussonicUrl}/scte35/update`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${Buffer.from(this.flussonicApiKey).toString('base64')}`,
        },
        body: JSON.stringify({
          stream: schedule.streamName,
          cueId: schedule.cueId || `cue_${schedule.id}`,
          startTime: schedule.startTime.toISOString(),
          duration: schedule.duration,
          description: schedule.description || 'Scheduled ad break',
        }),
      })

      if (!response.ok) {
        console.error('Failed to update SCTE-35 marker:', await response.text())
      }
    } catch (error) {
      console.error('Error updating SCTE-35 marker:', error)
    }
  }

  private async removeScte35Marker(id: string): Promise<void> {
    try {
      const response = await fetch(`${this.flussonicUrl}/scte35/remove`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${Buffer.from(this.flussonicApiKey).toString('base64')}`,
        },
        body: JSON.stringify({
          cueId: `cue_${id}`,
        }),
      })

      if (!response.ok) {
        console.error('Failed to remove SCTE-35 marker:', await response.text())
      }
    } catch (error) {
      console.error('Error removing SCTE-35 marker:', error)
    }
  }

  async checkAndInjectMarkers(): Promise<void> {
    const now = new Date()
    const schedules = await db.scte35Schedule.findMany({
      where: {
        isActive: true,
        startTime: {
          lte: new Date(now.getTime() + 5 * 60 * 1000), // 5 minutes ahead
        },
      },
    })

    for (const schedule of schedules) {
      if (schedule.startTime <= now && schedule.endTime > now) {
        await this.injectScte35Marker(schedule)
      }
    }
  }
}

export const scte35Service = new Scte35Service()
EOF
```

### src/lib/cron.js
```bash
cat > src/lib/cron.js << 'EOF'
const { scte35Service } = require('./scte35.ts')

// Run every minute
const CRON_INTERVAL = 60 * 1000

async function runCronJob() {
  try {
    console.log('Running SCTE-35 injection check...')
    await scte35Service.checkAndInjectMarkers()
    console.log('SCTE-35 injection check completed')
  } catch (error) {
    console.error('Error in cron job:', error)
  }
}

// Start the cron job
console.log('Starting SCTE-35 injection cron service...')
runCronJob()

// Schedule to run every minute
setInterval(runCronJob, CRON_INTERVAL)

// Handle graceful shutdown
process.on('SIGTERM', () => {
  console.log('Received SIGTERM. Shutting down gracefully...')
  process.exit(0)
})

process.on('SIGINT', () => {
  console.log('Received SIGINT. Shutting down gracefully...')
  process.exit(0)
})
EOF
```

## Step 8: Create API Routes

### src/app/api/scte35/route.ts
```bash
cat > src/app/api/scte35/route.ts << 'EOF'
import { NextRequest, NextResponse } from 'next/server'
import { scte35Service } from '@/lib/scte35'

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (id) {
      const schedule = await scte35Service.getSchedule(id)
      if (!schedule) {
        return NextResponse.json({ error: 'Schedule not found' }, { status: 404 })
      }
      return NextResponse.json(schedule)
    }

    const schedules = await scte35Service.getSchedules()
    return NextResponse.json(schedules)
  } catch (error) {
    console.error('Error fetching SCTE-35 schedules:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const schedule = await scte35Service.createSchedule(body)
    return NextResponse.json(schedule, { status: 201 })
  } catch (error) {
    console.error('Error creating SCTE-35 schedule:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function PUT(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return NextResponse.json({ error: 'Schedule ID is required' }, { status: 400 })
    }

    const body = await request.json()
    const schedule = await scte35Service.updateSchedule(id, body)
    return NextResponse.json(schedule)
  } catch (error) {
    console.error('Error updating SCTE-35 schedule:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return NextResponse.json({ error: 'Schedule ID is required' }, { status: 400 })
    }

    await scte35Service.deleteSchedule(id)
    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('Error deleting SCTE-35 schedule:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
EOF
```

### src/app/api/health/route.ts
```bash
cat > src/app/api/health/route.ts << 'EOF'
import { NextResponse } from 'next/server'

export async function GET() {
  try {
    return NextResponse.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      service: 'scte35-scheduler',
    })
  } catch (error) {
    return NextResponse.json(
      { status: 'unhealthy', error: error.message },
      { status: 500 }
    )
  }
}
EOF
```

## Step 9: Create Web Application

### src/app/layout.tsx
```bash
cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'SCTE-35 Scheduler',
  description: 'Schedule SCTE-35 markers for live streaming ad insertion',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
EOF
```

### src/app/globals.css
```bash
cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96%;
    --secondary-foreground: 222.2 84% 4.9%;
    --muted: 210 40% 96%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96%;
    --accent-foreground: 222.2 84% 4.9%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.75rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 84% 4.9%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 94.1%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
EOF
```

### src/app/page.tsx
```bash
cat > src/app/page.tsx << 'EOF'
'use client'

import { useState, useEffect } from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Switch } from '@/components/ui/switch'
import { Badge } from '@/components/ui/badge'
import { Calendar, Clock, Plus, Trash2, Edit } from 'lucide-react'

interface Scte35Schedule {
  id: string
  streamName: string
  startTime: string
  endTime: string
  cueId?: string
  duration: number
  description?: string
  isActive: boolean
  createdAt: string
  updatedAt: string
}

export default function Home() {
  const [schedules, setSchedules] = useState<Scte35Schedule[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [formData, setFormData] = useState({
    streamName: '',
    startTime: '',
    endTime: '',
    cueId: '',
    duration: 30,
    description: '',
    isActive: true,
  })

  useEffect(() => {
    fetchSchedules()
  }, [])

  const fetchSchedules = async () => {
    try {
      const response = await fetch('/api/scte35')
      if (response.ok) {
        const data = await response.json()
        setSchedules(data)
      }
    } catch (error) {
      console.error('Error fetching schedules:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    
    try {
      const url = editingId ? `/api/scte35?id=${editingId}` : '/api/scte35'
      const method = editingId ? 'PUT' : 'POST'
      
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      })

      if (response.ok) {
        await fetchSchedules()
        setShowForm(false)
        setEditingId(null)
        setFormData({
          streamName: '',
          startTime: '',
          endTime: '',
          cueId: '',
          duration: 30,
          description: '',
          isActive: true,
        })
      }
    } catch (error) {
      console.error('Error saving schedule:', error)
    }
  }

  const handleEdit = (schedule: Scte35Schedule) => {
    setFormData({
      streamName: schedule.streamName,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
      cueId: schedule.cueId || '',
      duration: schedule.duration,
      description: schedule.description || '',
      isActive: schedule.isActive,
    })
    setEditingId(schedule.id)
    setShowForm(true)
  }

  const handleDelete = async (id: string) => {
    if (confirm('Are you sure you want to delete this schedule?')) {
      try {
        const response = await fetch(`/api/scte35?id=${id}`, {
          method: 'DELETE',
        })

        if (response.ok) {
          await fetchSchedules()
        }
      } catch (error) {
        console.error('Error deleting schedule:', error)
      }
    }
  }

  const formatDateTime = (dateString: string) => {
    return new Date(dateString).toLocaleString()
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading SCTE-35 schedules...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="container mx-auto px-4 py-8">
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">SCTE-35 Scheduler</h1>
            <p className="text-gray-600 mt-2">Schedule SCTE-35 markers for live streaming ad insertion</p>
          </div>
          <Button
            onClick={() => setShowForm(true)}
            className="flex items-center gap-2"
          >
            <Plus className="h-4 w-4" />
            New Schedule
          </Button>
        </div>

        {showForm && (
          <Card className="mb-8">
            <CardHeader>
              <CardTitle>{editingId ? 'Edit Schedule' : 'Create New Schedule'}</CardTitle>
              <CardDescription>
                Configure SCTE-35 marker injection for your live stream
              </CardDescription>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleSubmit} className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <Label htmlFor="streamName">Stream Name</Label>
                    <Input
                      id="streamName"
                      value={formData.streamName}
                      onChange={(e) => setFormData({ ...formData, streamName: e.target.value })}
                      placeholder="e.g., live-channel-1"
                      required
                    />
                  </div>
                  <div>
                    <Label htmlFor="cueId">Cue ID (Optional)</Label>
                    <Input
                      id="cueId"
                      value={formData.cueId}
                      onChange={(e) => setFormData({ ...formData, cueId: e.target.value })}
                      placeholder="e.g., AD_BREAK_001"
                    />
                  </div>
                  <div>
                    <Label htmlFor="startTime">Start Time</Label>
                    <Input
                      id="startTime"
                      type="datetime-local"
                      value={formData.startTime}
                      onChange={(e) => setFormData({ ...formData, startTime: e.target.value })}
                      required
                    />
                  </div>
                  <div>
                    <Label htmlFor="endTime">End Time</Label>
                    <Input
                      id="endTime"
                      type="datetime-local"
                      value={formData.endTime}
                      onChange={(e) => setFormData({ ...formData, endTime: e.target.value })}
                      required
                    />
                  </div>
                  <div>
                    <Label htmlFor="duration">Duration (seconds)</Label>
                    <Input
                      id="duration"
                      type="number"
                      value={formData.duration}
                      onChange={(e) => setFormData({ ...formData, duration: parseInt(e.target.value) })}
                      min="1"
                      required
                    />
                  </div>
                  <div className="flex items-center space-x-2">
                    <Switch
                      id="isActive"
                      checked={formData.isActive}
                      onCheckedChange={(checked) => setFormData({ ...formData, isActive: checked })}
                    />
                    <Label htmlFor="isActive">Active</Label>
                  </div>
                </div>
                <div>
                  <Label htmlFor="description">Description</Label>
                  <Textarea
                    id="description"
                    value={formData.description}
                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                    placeholder="e.g., Prime time ad break"
                    rows={3}
                  />
                </div>
                <div className="flex justify-end space-x-2">
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => {
                      setShowForm(false)
                      setEditingId(null)
                      setFormData({
                        streamName: '',
                        startTime: '',
                        endTime: '',
                        cueId: '',
                        duration: 30,
                        description: '',
                        isActive: true,
                      })
                    }}
                  >
                    Cancel
                  </Button>
                  <Button type="submit">
                    {editingId ? 'Update Schedule' : 'Create Schedule'}
                  </Button>
                </div>
              </form>
            </CardContent>
          </Card>
        )}

        <div className="grid gap-6">
          {schedules.length === 0 ? (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <Calendar className="h-12 w-12 text-gray-400 mb-4" />
                <h3 className="text-lg font-semibold text-gray-900 mb-2">No schedules found</h3>
                <p className="text-gray-600 text-center mb-4">
                  Create your first SCTE-35 schedule to start managing ad breaks
                </p>
                <Button onClick={() => setShowForm(true)}>
                  <Plus className="h-4 w-4 mr-2" />
                  Create Schedule
                </Button>
              </CardContent>
            </Card>
          ) : (
            schedules.map((schedule) => (
              <Card key={schedule.id}>
                <CardHeader>
                  <div className="flex justify-between items-start">
                    <div>
                      <CardTitle className="flex items-center gap-2">
                        <Clock className="h-5 w-5" />
                        {schedule.streamName}
                        <Badge variant={schedule.isActive ? 'default' : 'secondary'}>
                          {schedule.isActive ? 'Active' : 'Inactive'}
                        </Badge>
                      </CardTitle>
                      <CardDescription>
                        {schedule.description || 'No description provided'}
                      </CardDescription>
                    </div>
                    <div className="flex space-x-2">
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => handleEdit(schedule)}
                      >
                        <Edit className="h-4 w-4" />
                      </Button>
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => handleDelete(schedule.id)}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                    <div>
                      <p className="font-medium text-gray-900">Start Time</p>
                      <p className="text-gray-600">{formatDateTime(schedule.startTime)}</p>
                    </div>
                    <div>
                      <p className="font-medium text-gray-900">End Time</p>
                      <p className="text-gray-600">{formatDateTime(schedule.endTime)}</p>
                    </div>
                    <div>
                      <p className="font-medium text-gray-900">Duration</p>
                      <p className="text-gray-600">{schedule.duration} seconds</p>
                    </div>
                    {schedule.cueId && (
                      <div>
                        <p className="font-medium text-gray-900">Cue ID</p>
                        <p className="text-gray-600">{schedule.cueId}</p>
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            ))
          )}
        </div>
      </div>
    </div>
  )
}
EOF
```

## Step 10: Create UI Components

Create all the necessary UI components in the src/components/ui/ directory. Here are a few examples:

### src/components/ui/button.tsx
```bash
cat > src/components/ui/button.tsx << 'EOF'
import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive:
          "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline:
          "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        secondary:
          "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button"
    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = "Button"

export { Button, buttonVariants }
EOF
```

### src/components/ui/card.tsx
```bash
cat > src/components/ui/card.tsx << 'EOF'
import * as React from "react"

import { cn } from "@/lib/utils"

const Card = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn(
      "rounded-lg border bg-card text-card-foreground shadow-sm",
      className
    )}
    {...props}
  />
))
Card.displayName = "Card"

const CardHeader = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn("flex flex-col space-y-1.5 p-6", className)}
    {...props}
  />
))
CardHeader.displayName = "CardHeader"

const CardTitle = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLHeadingElement>
>(({ className, ...props }, ref) => (
  <h3
    ref={ref}
    className={cn(
      "text-2xl font-semibold leading-none tracking-tight",
      className
    )}
    {...props}
  />
))
CardTitle.displayName = "CardTitle"

const CardDescription = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLParagraphElement>
>(({ className, ...props }, ref) => (
  <p
    ref={ref}
    className={cn("text-sm text-muted-foreground", className)}
    {...props}
  />
))
CardDescription.displayName = "CardDescription"

const CardContent = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div ref={ref} className={cn("p-6 pt-0", className)} {...props} />
))
CardContent.displayName = "CardContent"

const CardFooter = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn("flex items-center p-6 pt-0", className)}
    {...props}
  />
))
CardFooter.displayName = "CardFooter"

export { Card, CardHeader, CardFooter, CardTitle, CardDescription, CardContent }
EOF
```

### src/components/ui/input.tsx
```bash
cat > src/components/ui/input.tsx << 'EOF'
import * as React from "react"

import { cn } from "@/lib/utils"

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {}

const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, type, ...props }, ref) => {
    return (
      <input
        type={type}
        className={cn(
          "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)
Input.displayName = "Input"

export { Input }
EOF
```

### src/components/ui/label.tsx
```bash
cat > src/components/ui/label.tsx << 'EOF'
import * as React from "react"
import * as LabelPrimitive from "@radix-ui/react-label"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const labelVariants = cva(
  "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
)

const Label = React.forwardRef<
  React.ElementRef<typeof LabelPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof LabelPrimitive.Root> &
    VariantProps<typeof labelVariants>
>(({ className, ...props }, ref) => (
  <LabelPrimitive.Root
    ref={ref}
    className={cn(labelVariants(), className)}
    {...props}
  />
))
Label.displayName = LabelPrimitive.Root.displayName

export { Label }
EOF
```

### src/components/ui/switch.tsx
```bash
cat > src/components/ui/switch.tsx << 'EOF'
import * as React from "react"
import * as SwitchPrimitives from "@radix-ui/react-switch"

import { cn } from "@/lib/utils"

const Switch = React.forwardRef<
  React.ElementRef<typeof SwitchPrimitives.Root>,
  React.ComponentPropsWithoutRef<typeof SwitchPrimitives.Root>
>(({ className, ...props }, ref) => (
  <SwitchPrimitives.Root
    className={cn(
      "peer inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=unchecked]:bg-input",
      className
    )}
    {...props}
    ref={ref}
  >
    <SwitchPrimitives.Thumb
      className={cn(
        "pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-5 data-[state=unchecked]:translate-x-0"
      )}
    />
  </SwitchPrimitives.Root>
))
Switch.displayName = SwitchPrimitives.Root.displayName

export { Switch }
EOF
```

### src/components/ui/badge.tsx
```bash
cat > src/components/ui/badge.tsx << 'EOF'
import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const badgeVariants = cva(
  "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
  {
    variants: {
      variant: {
        default:
          "border-transparent bg-primary text-primary-foreground hover:bg-primary/80",
        secondary:
          "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
        destructive:
          "border-transparent bg-destructive text-destructive-foreground hover:bg-destructive/80",
        outline: "text-foreground",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
)

export interface BadgeProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof badgeVariants> {}

function Badge({ className, variant, ...props }: BadgeProps) {
  return (
    <div className={cn(badgeVariants({ variant }), className)} {...props} />
  )
}

export { Badge, badgeVariants }
EOF
```

### src/components/ui/textarea.tsx
```bash
cat > src/components/ui/textarea.tsx << 'EOF'
import * as React from "react"

import { cn } from "@/lib/utils"

export interface TextareaProps
  extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {}

const Textarea = React.forwardRef<HTMLTextAreaElement, TextareaProps>(
  ({ className, ...props }, ref) => {
    return (
      <textarea
        className={cn(
          "flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)
Textarea.displayName = "Textarea"

export { Textarea }
EOF
```

## Step 11: Create Environment Configuration

### .env.example
```bash
cat > .env.example << 'EOF'
# Database
DATABASE_URL="file:./db/custom.db"

# Flussonic Configuration
FLUSSONIC_URL="http://localhost:8080"
FLUSSONIC_API_KEY="admin:password"

# Next.js
NEXTAUTH_SECRET="your-secret-key"
NEXTAUTH_URL="http://localhost:3000"
EOF
```

### .env.local
```bash
cat > .env.local << 'EOF'
# Database
DATABASE_URL="file:./db/custom.db"

# Flussonic Configuration
FLUSSONIC_URL="http://localhost:8080"
FLUSSONIC_API_KEY="admin:password"

# Next.js
NEXTAUTH_SECRET="your-secret-key"
NEXTAUTH_URL="http://localhost:3000"
EOF
```

## Step 12: Initialize Database and Generate Prisma Client

```bash
# Generate Prisma client
npm run db:generate

# Push database schema
npm run db:push
```

## Step 13: Create Additional Files

### .gitignore
```bash
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
```

### README.md
```bash
cat > README.md << 'EOF'
# SCTE-35 Scheduler

A web-based application for scheduling SCTE-35 markers for live streaming ad insertion, designed for broadcasters using OBS and Flussonic Media Server.

## Features

- **Web Interface**: Intuitive web-based scheduling system
- **SCTE-35 Integration**: Automatic injection of SCTE-35 markers into Flussonic streams
- **Real-time Management**: Create, edit, and delete schedules on the fly
- **Automated Injection**: Cron-based service for timely marker injection
- **Database Storage**: Persistent storage of all schedules using Prisma ORM
- **Responsive Design**: Works seamlessly on desktop and mobile devices

## Technology Stack

- **Frontend**: Next.js 15 with TypeScript and Tailwind CSS
- **Backend**: Next.js API routes with Prisma ORM
- **Database**: SQLite (easily configurable for PostgreSQL)
- **UI Components**: shadcn/ui with Radix UI primitives
- **Styling**: Tailwind CSS with custom design system
- **Real-time**: Socket.IO for real-time updates (optional)

## Prerequisites

- Node.js (v18 or higher)
- npm or yarn
- Flussonic Media Server
- Git

## Installation

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/shihan84/Scte35-scheduler.git
   cd scte35-scheduler
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env.local
   ```
   Edit `.env.local` with your Flussonic server details:
   ```env
   FLUSSONIC_URL="http://your-flussonic-server:8080"
   FLUSSONIC_API_KEY="admin:your-api-key"
   ```

4. **Initialize database**
   ```bash
   npm run db:push
   npm run db:generate
   ```

5. **Start development server**
   ```bash
   npm run dev
   ```

6. **Start the cron service** (in a separate terminal)
   ```bash
   npm run cron
   ```

The application will be available at `http://localhost:3000`.

### Docker Deployment

1. **Build and run with Docker Compose**
   ```bash
   docker-compose up -d
   ```

2. **For Windows users**
   ```bash
   docker-compose -f docker-compose.windows.yml up -d
   ```

## Configuration

### Flussonic Media Server Setup

1. **Configure your Flussonic server** to accept SCTE-35 injection requests
2. **Ensure your streams are properly configured** for SCTE-35 support
3. **Set up authentication** for the API endpoints

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | Database connection string | `file:./db/custom.db` |
| `FLUSSONIC_URL` | Flussonic server URL | `http://localhost:8080` |
| `FLUSSONIC_API_KEY` | Flussonic API credentials | `admin:password` |
| `NEXTAUTH_SECRET` | NextAuth secret key | `your-secret-key` |
| `NEXTAUTH_URL` | NextAuth URL | `http://localhost:3000` |

## Usage

### Creating a Schedule

1. **Open the web interface** at `http://localhost:3000`
2. **Click "New Schedule"** to create a new SCTE-35 marker schedule
3. **Fill in the required fields**:
   - Stream Name: The name of your Flussonic stream
   - Start Time: When the ad break should begin
   - End Time: When the ad break should end
   - Duration: Length of the ad break in seconds
4. **Optional fields**:
   - Cue ID: Custom identifier for the SCTE-35 marker
   - Description: Notes about the ad break
   - Active: Enable/disable the schedule
5. **Click "Create Schedule"** to save

### Managing Schedules

- **Edit**: Click the edit icon to modify existing schedules
- **Delete**: Click the trash icon to remove schedules
- **View Status**: Active/Inactive badges show schedule status

### Automated Injection

The cron service runs every minute to:
- Check for upcoming schedules
- Inject SCTE-35 markers into Flussonic streams
- Update marker information for modified schedules
- Clean up expired markers

## API Endpoints

### SCTE-35 Schedules

- `GET /api/scte35` - Get all schedules
- `GET /api/scte35?id={id}` - Get specific schedule
- `POST /api/scte35` - Create new schedule
- `PUT /api/scte35?id={id}` - Update schedule
- `DELETE /api/scte35?id={id}` - Delete schedule

### Health Check

- `GET /api/health` - Application health status

## Database Schema

### Scte35Schedule

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

## Troubleshooting

### Common Issues

1. **Database connection errors**
   - Ensure SQLite is installed
   - Check database file permissions
   - Verify `DATABASE_URL` in `.env.local`

2. **Flussonic integration issues**
   - Verify Flussonic server is running
   - Check API credentials in `FLUSSONIC_API_KEY`
   - Ensure network connectivity to Flussonic server

3. **Cron service not working**
   - Check if the cron service is running
   - Verify Node.js is installed
   - Check logs for error messages

### Logs

- Application logs: Check console output
- Database queries: Enable Prisma query logging
- Cron service: Monitor terminal output

## Development

### Project Structure

```
src/
├── app/
│   ├── api/
│   │   ├── scte35/      # SCTE-35 API routes
│   │   └── health/      # Health check endpoint
│   ├── globals.css      # Global styles
│   ├── layout.tsx       # Root layout
│   └── page.tsx         # Main application page
├── components/
│   └── ui/              # shadcn/ui components
├── hooks/               # Custom React hooks
└── lib/
    ├── db.ts           # Database client
    ├── scte35.ts       # SCTE-35 service
    ├── socket.ts       # Socket.IO configuration
    ├── utils.ts        # Utility functions
    └── cron.js         # Cron service
```

### Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint
- `npm run db:push` - Push database schema
- `npm run db:generate` - Generate Prisma client
- `npm run db:studio` - Open Prisma Studio
- `npm run cron` - Start cron service

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue on GitHub
- Check the troubleshooting section
- Review the Flussonic documentation

## Acknowledgments

- Next.js team for the excellent framework
- Prisma team for the modern ORM
- shadcn/ui for the beautiful components
- Flussonic team for the streaming platform
EOF
```

## Step 14: GitHub Setup

Now, let's set up the GitHub repository. Run the appropriate script for your operating system:

### For Windows (PowerShell):
```powershell
.\github-setup.ps1
```

### For Linux/macOS (Bash):
```bash
./github-setup.sh
```

## Step 15: Final Setup

After pushing to GitHub, you can:

1. **Clone the repository on any machine**:
   ```bash
   git clone git@github.com:shihan84/Scte35-scheduler.git
   cd scte35-scheduler
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure environment**:
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your Flussonic server details
   ```

4. **Initialize database**:
   ```bash
   npm run db:push
   npm run db:generate
   ```

5. **Start the application**:
   ```bash
   npm run dev
   ```

## Next Steps

1. **Configure your Flussonic server** to accept SCTE-35 injection requests
2. **Test the application** with your live streams
3. **Set up the cron service** for automated injection
4. **Deploy to production** using Docker or your preferred method

Your SCTE-35 Scheduler is now ready for use! The application provides a complete solution for scheduling SCTE-35 markers for ad insertion in your live streams.