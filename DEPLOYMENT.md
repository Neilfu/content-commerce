# Deployment Guide - Content-to-Commerce Platform

## 📋 Overview

This guide will help you deploy the Content-to-Commerce platform to production using:
- **Frontend**: Vercel (Free tier available)
- **Backend**: Railway (Free $5/month credit)

## 🚀 Prerequisites

1. **Git Repository**
   - Code must be pushed to GitHub/GitLab
   - Repository should be public or accessible to deployment platforms

2. **Accounts**
   - Vercel account (sign up at https://vercel.com)
   - Railway account (sign up at https://railway.app)

## 📦 Step 1: Prepare Code for Deployment

### 1.1 Create .gitignore (if not exists)

```bash
# Add to root .gitignore
node_modules/
.next/
.env.local
*.db
dist/
build/
```

### 1.2 Push to GitHub

```bash
git init
git add .
git commit -m "Initial commit - Content-to-Commerce Platform"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/content-commerce.git
git push -u origin main
```

## 🔧 Step 2: Deploy Backend to Railway

### 2.1 Create New Project

1. Go to https://railway.app
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose your repository
5. Select "apps/backend/api-server" as root directory

### 2.2 Configure Service

In Railway dashboard:

1. **Settings** → **General**:
   - Name: `commerce-api`
   - Start Command: `npm start`

2. **Settings** → **Environment**:
   Add these variables:
   ```
   NODE_ENV=production
   PORT=9000
   ```

3. **Settings** → **Volumes** (IMPORTANT for SQLite):
   - Click "New Volume"
   - Mount Path: `/app/data`
   - This ensures database persists across deployments

4. **Settings** → **Networking**:
   - Generate Domain (e.g., `commerce-api.railway.app`)
   - Copy this URL for frontend configuration

### 2.3 Deploy

Railway will automatically deploy. Wait for deployment to complete (usually 2-3 minutes).

### 2.4 Verify Backend

Visit: `https://your-api.railway.app/health`

Should return:
```json
{
  "status": "ok",
  "timestamp": "2024-..."
}
```

## 🎨 Step 3: Deploy Frontend to Vercel

### 3.1 Import Project

1. Go to https://vercel.com
2. Click "Add New" → "Project"
3. Import your GitHub repository
4. Vercel will auto-detect Next.js

### 3.2 Configure Build Settings

- **Framework Preset**: Next.js
- **Root Directory**: `apps/web`
- **Build Command**: `npm run build` (auto-detected)
- **Output Directory**: `.next` (auto-detected)
- **Install Command**: `npm install` (auto-detected)

### 3.3 Environment Variables

Add in Vercel dashboard:

```
NEXT_PUBLIC_API_URL=https://your-api.railway.app
```

Replace `your-api.railway.app` with your actual Railway domain from Step 2.

### 3.4 Deploy

Click "Deploy". Vercel will build and deploy (usually 2-3 minutes).

### 3.5 Get Your URL

Vercel will provide a URL like: `https://your-project.vercel.app`

## ✅ Step 4: Verify Deployment

### 4.1 Test Frontend

1. Visit your Vercel URL
2. Navigate to Products page
3. Verify products load from API

### 4.2 Test Complete Flow

1. Select a product
2. Customize in editor
3. Add to cart
4. Complete checkout
5. Verify order is saved (check Railway logs)

### 4.3 Check Railway Logs

In Railway dashboard:
- Go to your service
- Click "Deployments" → "View Logs"
- Verify database initialization and API requests

## 🔄 Step 5: Continuous Deployment

Both platforms support automatic deployment:

- **Push to main branch** → Automatic deployment
- **Pull requests** → Preview deployments (Vercel)

## 🐛 Troubleshooting

### Frontend can't connect to API

**Problem**: CORS errors or 404 on API calls

**Solution**:
1. Verify `NEXT_PUBLIC_API_URL` in Vercel environment variables
2. Redeploy frontend after updating env vars
3. Check Railway service is running

### Backend database not persisting

**Problem**: Data lost after Railway redeploy

**Solution**:
1. Ensure Volume is mounted at `/app/data`
2. Verify `DATABASE_PATH` or `NODE_ENV=production` is set
3. Check db.js uses correct path in production

### Build fails on Vercel

**Problem**: Build errors during deployment

**Solution**:
1. Check build logs in Vercel dashboard
2. Verify all dependencies in package.json
3. Test build locally: `cd apps/web && npm run build`

### Railway service won't start

**Problem**: Service crashes on startup

**Solution**:
1. Check Railway logs for errors
2. Verify package.json has correct start script
3. Ensure all dependencies are installed

## 📊 Monitoring

### Railway
- View logs: Railway Dashboard → Service → Logs
- Monitor usage: Railway Dashboard → Usage

### Vercel
- View analytics: Vercel Dashboard → Analytics
- Monitor performance: Vercel Dashboard → Speed Insights

## 💰 Cost Estimate

### Free Tier Limits

**Vercel**:
- 100 GB bandwidth/month
- Unlimited deployments
- Free custom domain

**Railway**:
- $5 free credit/month
- ~500 hours of service uptime
- Sufficient for development/testing

### Scaling Up

If you exceed free tier:
- Vercel Pro: $20/month
- Railway: Pay-as-you-go ($0.000231/GB-hour)

## 🎉 Success!

Your Content-to-Commerce platform is now live!

- **Frontend**: https://your-project.vercel.app
- **Backend API**: https://your-api.railway.app
- **Database**: SQLite on Railway persistent volume

## 📝 Next Steps

1. **Custom Domain**: Add your domain in Vercel settings
2. **Analytics**: Enable Vercel Analytics
3. **Monitoring**: Set up error tracking (Sentry)
4. **Backups**: Export SQLite database regularly
5. **AI Integration**: Add千问/即梦 AI API keys

---

Need help? Check the logs or contact support on respective platforms.
