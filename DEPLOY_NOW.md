# 🚀 立即部署清单

按照以下步骤完成部署，每完成一步请打勾 ✅

## 📋 第一步：准备 Git 仓库 (5分钟)

### 1.1 初始化 Git（如果还没有）
```bash
cd d:/gemini/content-commerce
git init
git add .
git commit -m "Initial commit: Content-to-Commerce Platform v1.0"
```

### 1.2 创建 GitHub 仓库
1. 访问 https://github.com/new
2. 仓库名称：`content-commerce`（或您喜欢的名称）
3. 选择 Public 或 Private
4. **不要**勾选 "Initialize with README"（我们已有代码）
5. 点击 "Create repository"

### 1.3 推送代码到 GitHub
```bash
git remote add origin https://github.com/YOUR_USERNAME/content-commerce.git
git branch -M main
git push -u origin main
```

**替换 `YOUR_USERNAME` 为您的 GitHub 用户名**

---

## 🔧 第二步：部署后端到 Railway (10分钟)

### 2.1 注册/登录 Railway
1. 访问 https://railway.app
2. 点击 "Login" → 使用 GitHub 登录
3. 授权 Railway 访问您的 GitHub

### 2.2 创建新项目
1. 点击 "New Project"
2. 选择 "Deploy from GitHub repo"
3. 选择 `content-commerce` 仓库
4. Railway 会自动检测到项目

### 2.3 配置服务
1. **Root Directory**:
   - 点击 Settings → General
   - Root Directory: `apps/backend/api-server`
   - 点击 Save

2. **Start Command**:
   - 在 Settings → Deploy
   - Start Command: `npm start`
   - 点击 Save

3. **环境变量**:
   - 点击 Variables
   - 添加以下变量：
     ```
     NODE_ENV=production
     PORT=9000
     ```

### 2.4 添加持久化存储（重要！）
1. 点击 "New" → "Volume"
2. Mount Path: `/app/data`
3. 点击 "Add"

**这一步确保 SQLite 数据库在重新部署后不会丢失！**

### 2.5 部署
1. 点击 "Deploy"
2. 等待构建完成（约2-3分钟）
3. 查看日志确认启动成功

### 2.6 获取 API URL
1. 点击 Settings → Networking
2. 点击 "Generate Domain"
3. **复制这个 URL**（例如：`https://content-commerce-production.up.railway.app`）
4. 测试：访问 `https://your-url.railway.app/health`
   - 应该返回：`{"status":"ok","timestamp":"..."}`

✅ **后端部署完成！记下您的 API URL**

---

## 🎨 第三步：部署前端到 Vercel (10分钟)

### 3.1 注册/登录 Vercel
1. 访问 https://vercel.com
2. 点击 "Sign Up" → 使用 GitHub 登录
3. 授权 Vercel 访问您的 GitHub

### 3.2 导入项目
1. 点击 "Add New..." → "Project"
2. 找到并选择 `content-commerce` 仓库
3. 点击 "Import"

### 3.3 配置构建设置
Vercel 会自动检测 Next.js，但需要设置 Root Directory：

1. **Framework Preset**: Next.js（自动检测）
2. **Root Directory**: `apps/web`
3. **Build Command**: `npm run build`（自动检测）
4. **Output Directory**: `.next`（自动检测）
5. **Install Command**: `npm install`（自动检测）

### 3.4 配置环境变量（关键步骤！）
1. 展开 "Environment Variables"
2. 添加：
   - Name: `NEXT_PUBLIC_API_URL`
   - Value: `https://your-api.railway.app`（使用第二步获取的 Railway URL）
   - Environment: Production
3. 点击 "Add"

### 3.5 部署
1. 点击 "Deploy"
2. 等待构建完成（约3-5分钟）
3. 构建成功后会显示 "Congratulations!"

### 3.6 访问您的网站
1. 点击 "Visit" 或复制提供的 URL
2. URL 格式：`https://content-commerce-xxx.vercel.app`

✅ **前端部署完成！**

---

## ✅ 第四步：验证部署 (5分钟)

### 4.1 测试前端
访问您的 Vercel URL，测试以下功能：

- [ ] 首页正常显示
- [ ] 导航到 "产品列表" 页面
- [ ] 产品能够正常加载（来自 Railway API）
- [ ] 点击产品进入编辑器
- [ ] 编辑器功能正常
- [ ] 添加文字/图形到设计
- [ ] 点击 "加入购物车"
- [ ] 购物车页面显示商品
- [ ] 点击 "去结算"
- [ ] 填写表单并提交订单
- [ ] 显示支付成功页面

### 4.2 测试后端
1. 访问 `https://your-api.railway.app/store/products`
   - 应该返回产品列表 JSON
2. 访问 `https://your-api.railway.app/store/orders`
   - 应该返回订单列表（可能为空或包含测试订单）

### 4.3 检查 Railway 日志
1. 在 Railway 控制台查看日志
2. 确认看到：
   ```
   ✅ Database initialized
   📦 Seeded 4 products
   🚀 API Server running on http://localhost:9000
   ```

---

## 🎉 部署成功！

您的应用现已上线：

- **前端**: https://your-project.vercel.app
- **后端**: https://your-api.railway.app
- **数据库**: SQLite（Railway 持久化存储）

---

## 🔧 后续操作（可选）

### 自定义域名
**Vercel**:
1. Settings → Domains
2. 添加您的域名
3. 配置 DNS（Vercel 会提供说明）

**Railway**:
1. Settings → Networking
2. Custom Domain
3. 添加域名并配置 DNS

### 监控和分析
- **Vercel Analytics**: 在项目设置中启用
- **Railway Logs**: 实时查看应用日志
- **错误追踪**: 考虑集成 Sentry

### 备份数据库
定期导出 SQLite 数据库：
1. 在 Railway 控制台使用 CLI
2. 或设置自动备份脚本

---

## ❓ 遇到问题？

### 前端无法连接后端
- 检查 Vercel 环境变量中的 `NEXT_PUBLIC_API_URL` 是否正确
- 确保 Railway 服务正在运行
- 检查 Railway 日志是否有错误

### 数据库数据丢失
- 确认 Railway Volume 已正确挂载到 `/app/data`
- 检查 `NODE_ENV=production` 环境变量已设置

### 构建失败
- 查看构建日志中的错误信息
- 确保所有依赖都在 package.json 中
- 尝试在本地运行 `npm run build` 测试

---

**需要帮助？** 查看 DEPLOYMENT.md 中的详细故障排查指南。
