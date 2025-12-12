# Strapi 重启和配置指南

## Step 1: 重启 Strapi 服务器

**重要**: Strapi 需要重启以识别新的 Content Types

### 操作步骤

1. **停止当前 Strapi 服务器**
   - 找到运行 Strapi 的终端窗口
   - 按 `Ctrl+C` 停止服务器

2. **重新启动 Strapi**
   ```bash
   cd d:\gemini\content-commerce\apps\backend\strapi-cms
   npm run develop
   ```

3. **等待启动完成**
   - 看到 "Strapi started successfully" 消息
   - 访问 http://localhost:1337/admin

### 验证 Content Types

启动后，在 Strapi 管理面板中：

1. 进入 **Content-Type Builder**
2. 应该看到新的 Collection Types:
   - ✅ Verification Token
   - ✅ User Profile

如果看不到，请检查：
- Schema 文件是否在正确位置
- 文件格式是否正确
- Strapi 日志是否有错误

---

## Step 2: 配置权限

### 2.1 配置 Public Role

1. 访问 http://localhost:1337/admin
2. 进入 **Settings** > **Users & Permissions** > **Roles**
3. 点击 **Public** role
4. 找到 **Verification-token** 部分
   - ✅ 勾选 `create`
   - ✅ 勾选 `findOne`
5. 找到 **User-profile** 部分
   - ✅ 勾选 `findOne`
6. 点击 **Save** 保存

### 2.2 配置 Authenticated Role

1. 在同一页面，点击 **Authenticated** role
2. 找到 **Verification-token** 部分
   - ✅ 勾选 `find`
   - ✅ 勾选 `findOne`
3. 找到 **User-profile** 部分
   - ✅ 勾选 `find`
   - ✅ 勾选 `findOne`
   - ✅ 勾选 `update`
4. 点击 **Save** 保存

---

## Step 3: 测试注册流程

### 3.1 准备测试数据

```json
{
  "first_name": "测试",
  "last_name": "用户",
  "email": "test123@example.com",
  "username": "test123",
  "password": "Password123",
  "confirmPassword": "Password123",
  "agreeToTerms": true
}
```

### 3.2 执行注册

1. 访问 http://localhost:3000/register
2. 填写表单
3. 点击注册按钮

### 3.3 检查日志

**Next.js 服务器日志** 应该显示:
```
📝 Registering user: test123@example.com
🔵 Creating Strapi user: test123@example.com
✅ Strapi user created successfully: 1
🔵 Creating user profile for user: 1
✅ User profile created: 1
🔵 Saving verification token for: test123@example.com
✅ Verification token saved
📧 邮件内容...
```

### 3.4 验证数据

在 Strapi 管理面板中：

1. **Content Manager** > **User** (from users-permissions)
   - 应该看到新用户
   - `confirmed` 应该是 `false`

2. **Content Manager** > **User Profile**
   - 应该看到新的 profile
   - `firstName` 和 `lastName` 应该正确

3. **Content Manager** > **Verification Token**
   - 应该看到新的 token
   - `used` 应该是 `false`
   - `expiresAt` 应该是 24 小时后

---

## Step 4: 测试邮箱验证

### 4.1 获取验证链接

从 Next.js 服务器日志中复制验证链接:
```
http://localhost:3000/verify-email?token=xxxxx
```

### 4.2 访问验证链接

1. 在浏览器中打开链接
2. 应该看到验证页面

### 4.3 检查日志

**Next.js 服务器日志** 应该显示:
```
🔵 Verifying email with token: xxxxx
Found token: 1
Updating user: 1
✅ Email verified successfully
```

### 4.4 验证结果

在 Strapi 管理面板中：

1. **Content Manager** > **User**
   - 用户的 `confirmed` 应该变成 `true` ✅

2. **Content Manager** > **Verification Token**
   - Token 的 `used` 应该变成 `true` ✅

---

## 故障排除

### 问题 1: Content Types 未出现

**症状**: 重启后看不到新的 Content Types

**解决方案**:
1. 检查文件路径是否正确
2. 检查 JSON 格式是否正确
3. 查看 Strapi 启动日志
4. 尝试删除 `.cache` 文件夹并重启

### 问题 2: 权限配置无效

**症状**: API 返回 403 错误

**解决方案**:
1. 确认权限已保存
2. 刷新浏览器
3. 清除浏览器缓存
4. 重启 Strapi

### 问题 3: Profile 创建失败

**症状**: 日志显示 "Error creating user profile"

**解决方案**:
1. 检查 User Profile Content Type 是否存在
2. 检查权限配置
3. 查看详细错误日志
4. 检查 user relation 配置

### 问题 4: Token 验证失败

**症状**: "验证令牌无效或已使用"

**解决方案**:
1. 检查 token 是否正确复制
2. 检查 token 是否过期
3. 检查 Verification Token 表中的数据
4. 确认权限配置正确

---

## 成功标准

✅ Strapi 成功重启  
✅ 看到新的 Content Types  
✅ 权限配置完成  
✅ 用户注册成功  
✅ User Profile 创建成功  
✅ Verification Token 保存成功  
✅ 邮箱验证成功  
✅ 用户状态更新为 confirmed  
✅ Token 标记为已使用

---

**准备好了吗？让我们开始吧！**
