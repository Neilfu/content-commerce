# Content-to-Commerce Platform

一个让每个人都能用内容创造商品的电商平台。

## 🌟 功能特性

- 🎨 **内容创作**: AI 生成、图片上传、在线编辑器
- 🛍️ **产品定制**: T恤、卫衣、海报、马克杯等多种产品
- 💳 **电商流程**: 购物车、结算、订单管理
- 📊 **创作者后台**: 销售数据、作品管理、收益中心
- 💾 **数据持久化**: SQLite 数据库

## 🚀 快速开始

### 本地开发

1. **克隆项目**
```bash
git clone https://github.com/YOUR_USERNAME/content-commerce.git
cd content-commerce
```

2. **安装依赖**
```bash
# 前端
cd apps/web
npm install

# 后端
cd ../backend/api-server
npm install
```

3. **启动服务**

终端 1 - 后端:
```bash
cd apps/backend/api-server
npm run dev
# 运行在 http://localhost:9000
```

终端 2 - 前端:
```bash
cd apps/web
npm run dev
# 运行在 http://localhost:3000
```

4. **访问应用**
- 前端: http://localhost:3000
- API: http://localhost:9000
- API 健康检查: http://localhost:9000/health

## 📦 技术栈

### 前端
- **框架**: Next.js 16 + React + TypeScript
- **样式**: Tailwind CSS v4
- **状态管理**: Zustand
- **画布编辑**: Fabric.js
- **图标**: Lucide React

### 后端
- **运行时**: Node.js + Express
- **数据库**: SQLite (better-sqlite3)
- **API**: RESTful

## 📁 项目结构

```
content-commerce/
├── apps/
│   ├── web/                 # Next.js 前端
│   │   ├── app/            # App Router 页面
│   │   ├── components/     # React 组件
│   │   ├── lib/           # 工具函数和服务
│   │   └── public/        # 静态资源
│   └── backend/
│       └── api-server/    # Express API 服务器
│           ├── index.js   # 主服务器文件
│           ├── db.js      # 数据库初始化
│           ├── seed.js    # 种子数据
│           └── commerce.db # SQLite 数据库
├── DEPLOYMENT.md          # 部署指南
└── README.md             # 本文件
```

## 🌐 部署

详细部署指南请查看 [DEPLOYMENT.md](./DEPLOYMENT.md)

### 快速部署

**前端 (Vercel)**:
1. 导入 GitHub 仓库到 Vercel
2. Root Directory: `apps/web`
3. 添加环境变量: `NEXT_PUBLIC_API_URL`

**后端 (Railway)**:
1. 导入 GitHub 仓库到 Railway
2. Root Directory: `apps/backend/api-server`
3. 添加持久化存储卷: `/app/data`

## 📖 API 文档

### 产品 API

- `GET /store/products` - 获取所有产品
- `GET /store/products/:id` - 获取单个产品

### 订单 API

- `POST /store/orders` - 创建订单
- `GET /store/orders` - 获取所有订单
- `GET /store/orders/:id` - 获取单个订单

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 🔗 相关链接

- [Next.js 文档](https://nextjs.org/docs)
- [Tailwind CSS 文档](https://tailwindcss.com/docs)
- [Fabric.js 文档](http://fabricjs.com/)
- [Vercel 部署](https://vercel.com)
- [Railway 部署](https://railway.app)

---

Made with ❤️ by Content-to-Commerce Team
