# Strapi 权限配置指南

## 目标

为新创建的 Content Types 配置适当的权限,确保 API 端点可被前端访问。

---

## 配置步骤

### 1. 访问 Strapi 管理面板

1. 启动 Strapi: `cd apps/backend/strapi-cms && npm run develop`
2. 访问: `http://localhost:1337/admin`
3. 登录管理员账号

### 2. 配置 Public 角色权限

路径: **Settings** → **Users & Permissions Plugin** → **Roles** → **Public**

#### Design-asset
- ✅ `find` - 允许列表查询
- ✅ `findOne` - 允许单个查询
- ❌ `create` - 禁止创建
- ❌ `update` - 禁止更新
- ❌ `delete` - 禁止删除

#### Product-template
- ✅ `find` - 允许列表查询 (仅 isPublic=true)
- ✅ `findOne` - 允许单个查询 (仅 isPublic=true)
- ❌ `create` - 禁止创建
- ❌ `update` - 禁止更新
- ❌ `delete` - 禁止删除

#### Design
- ❌ 所有权限禁止 (设计是私有的)

### 3. 配置 Authenticated 角色权限

路径: **Settings** → **Users & Permissions Plugin** → **Roles** → **Authenticated**

#### Design-asset
- ✅ `find` - 允许列表查询
- ✅ `findOne` - 允许单个查询
- ✅ `create` - 允许创建
- ❌ `update` - 禁止更新 (素材不可修改)
- ✅ `delete` - 允许删除 (仅自己的)

#### Product-template
- ✅ `find` - 允许列表查询
- ✅ `findOne` - 允许单个查询
- ✅ `create` - 允许创建
- ✅ `update` - 允许更新 (仅自己的)
- ✅ `delete` - 允许删除 (仅自己的)

#### Design
- ✅ `find` - 允许列表查询 (仅自己的)
- ✅ `findOne` - 允许单个查询 (仅自己的)
- ✅ `create` - 允许创建
- ✅ `update` - 允许更新 (仅自己的)
- ✅ `delete` - 允许删除 (仅自己的)

#### Upload (Media Library)
- ✅ `upload` - 允许上传文件
- ✅ `destroy` - 允许删除文件 (仅自己的)

---

## 高级配置: 基于所有者的权限控制

为了确保用户只能访问自己的资源,需要在 Strapi 中配置策略。

### 方法 1: 使用 Strapi 的内置所有者策略

在 Content Type 的 `schema.json` 中,确保有 `user` 或 `creator` 字段关联到用户。

### 方法 2: 自定义策略

创建自定义策略文件:

**文件**: `apps/backend/strapi-cms/src/policies/isOwner.ts`

```typescript
export default (policyContext, config, { strapi }) => {
    const { user } = policyContext.state;
    const { id } = policyContext.params;

    if (!user) {
        return false;
    }

    // 检查资源是否属于当前用户
    const entity = await strapi.entityService.findOne(
        config.contentType,
        id
    );

    return entity && entity.user === user.id;
};
```

然后在路由中应用策略。

---

## 验证配置

### 测试 Public 访问

```bash
# 应该成功 - 获取公开的产品模板
curl http://localhost:1337/api/product-templates?filters[isPublic][$eq]=true

# 应该成功 - 获取设计素材
curl http://localhost:1337/api/design-assets

# 应该失败 - 获取设计 (需要认证)
curl http://localhost:1337/api/designs
```

### 测试 Authenticated 访问

```bash
# 首先获取 JWT token (需要先注册/登录)
TOKEN="your-jwt-token"

# 应该成功 - 创建设计
curl -X POST http://localhost:1337/api/designs \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"data": {"name": "Test Design", "user": "user-id"}}'

# 应该成功 - 上传图片
curl -X POST http://localhost:1337/api/upload \
  -H "Authorization: Bearer $TOKEN" \
  -F "files=@image.png"
```

---

## 常见问题

### Q: 为什么 API 返回 403 Forbidden?
A: 检查权限配置,确保对应的角色有相应的权限。

### Q: 如何限制用户只能访问自己的资源?
A: 使用自定义策略或在查询时添加过滤器 `filters[user][$eq]=userId`。

### Q: Upload API 不工作?
A: 确保 Authenticated 角色有 `upload.upload` 权限。

---

## 下一步

配置完成后,重启 Strapi 服务以应用更改:

```bash
cd apps/backend/strapi-cms
npm run develop
```

然后测试前端应用是否能正常访问 API。
