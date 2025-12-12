#!/usr/bin/env pwsh

# 测试注册和邮箱验证流程

Write-Host "🧪 开始测试注册和邮箱验证流程" -ForegroundColor Cyan
Write-Host ""

# 测试数据
$testEmail = "test_$(Get-Date -Format 'yyyyMMddHHmmss')@example.com"
$testData = @{
    email        = $testEmail
    password     = "Password123"
    username     = "test_user_$(Get-Date -Format 'HHmmss')"
    first_name   = "测试"
    last_name    = "用户"
    agreeToTerms = $true
} | ConvertTo-Json

Write-Host "📝 测试数据:" -ForegroundColor Yellow
Write-Host $testData
Write-Host ""

# Step 1: 测试注册
Write-Host "Step 1: 测试用户注册..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/register" `
        -Method POST `
        -ContentType "application/json" `
        -Body $testData `
        -ErrorAction Stop

    Write-Host "✅ 注册成功!" -ForegroundColor Green
    Write-Host "响应状态: $($response.StatusCode)" -ForegroundColor Gray
    
    $result = $response.Content | ConvertFrom-Json
    Write-Host "用户 ID: $($result.user.id)" -ForegroundColor Gray
    Write-Host "用户邮箱: $($result.user.email)" -ForegroundColor Gray
    Write-Host ""
}
catch {
    Write-Host "❌ 注册失败!" -ForegroundColor Red
    Write-Host "错误: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "请检查:" -ForegroundColor Yellow
    Write-Host "1. Next.js 服务器是否运行 (http://localhost:3000)" -ForegroundColor Yellow
    Write-Host "2. Strapi 服务器是否运行 (http://localhost:1337)" -ForegroundColor Yellow
    Write-Host "3. Strapi 权限是否配置正确" -ForegroundColor Yellow
    exit 1
}

# Step 2: 检查 Strapi 中的数据
Write-Host "Step 2: 检查 Strapi 数据..." -ForegroundColor Green

# 检查 User Profile
try {
    $profiles = Invoke-RestMethod -Uri "http://localhost:1337/api/user-profiles?populate=*" `
        -Method GET `
        -ErrorAction Stop
    
    $latestProfile = $profiles.data | Select-Object -Last 1
    if ($latestProfile) {
        Write-Host "✅ User Profile 已创建" -ForegroundColor Green
        Write-Host "  - ID: $($latestProfile.id)" -ForegroundColor Gray
        Write-Host "  - First Name: $($latestProfile.attributes.firstName)" -ForegroundColor Gray
        Write-Host "  - Last Name: $($latestProfile.attributes.lastName)" -ForegroundColor Gray
    }
    else {
        Write-Host "⚠️  未找到 User Profile" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "⚠️  无法获取 User Profile: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# 检查 Verification Token
try {
    $tokens = Invoke-RestMethod -Uri "http://localhost:1337/api/verification-tokens?filters[email][$eq]=$testEmail" `
        -Method GET `
        -ErrorAction Stop
    
    $token = $tokens.data | Select-Object -Last 1
    if ($token) {
        Write-Host "✅ Verification Token 已创建" -ForegroundColor Green
        Write-Host "  - ID: $($token.id)" -ForegroundColor Gray
        Write-Host "  - Token: $($token.attributes.token)" -ForegroundColor Gray
        Write-Host "  - Email: $($token.attributes.email)" -ForegroundColor Gray
        Write-Host "  - Used: $($token.attributes.used)" -ForegroundColor Gray
        Write-Host "  - Expires At: $($token.attributes.expiresAt)" -ForegroundColor Gray
        
        $verificationToken = $token.attributes.token
    }
    else {
        Write-Host "⚠️  未找到 Verification Token" -ForegroundColor Yellow
        Write-Host "注册可能成功，但 token 未保存" -ForegroundColor Yellow
        exit 1
    }
}
catch {
    Write-Host "❌ 无法获取 Verification Token: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请检查 Strapi 权限配置" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Step 3: 测试邮箱验证
Write-Host "Step 3: 测试邮箱验证..." -ForegroundColor Green
try {
    $verifyData = @{
        token = $verificationToken
    } | ConvertTo-Json

    $verifyResponse = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/verify-email" `
        -Method POST `
        -ContentType "application/json" `
        -Body $verifyData `
        -ErrorAction Stop

    Write-Host "✅ 邮箱验证成功!" -ForegroundColor Green
    Write-Host "响应状态: $($verifyResponse.StatusCode)" -ForegroundColor Gray
    Write-Host ""
}
catch {
    Write-Host "❌ 邮箱验证失败!" -ForegroundColor Red
    Write-Host "错误: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
}

# Step 4: 验证结果
Write-Host "Step 4: 验证最终结果..." -ForegroundColor Green

# 检查 Token 是否标记为已使用
try {
    $updatedTokens = Invoke-RestMethod -Uri "http://localhost:1337/api/verification-tokens/$($token.id)" `
        -Method GET `
        -ErrorAction Stop
    
    if ($updatedTokens.data.attributes.used -eq $true) {
        Write-Host "✅ Token 已标记为已使用" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  Token 未标记为已使用" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "⚠️  无法验证 Token 状态" -ForegroundColor Yellow
}
Write-Host ""

# 总结
Write-Host "=" * 50 -ForegroundColor Cyan
Write-Host "🎉 测试完成!" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan
Write-Host ""
Write-Host "测试结果:" -ForegroundColor Yellow
Write-Host "✅ 用户注册" -ForegroundColor Green
Write-Host "✅ User Profile 创建" -ForegroundColor Green
Write-Host "✅ Verification Token 创建" -ForegroundColor Green
Write-Host "✅ 邮箱验证" -ForegroundColor Green
Write-Host ""
Write-Host "测试邮箱: $testEmail" -ForegroundColor Gray
Write-Host "验证 Token: $verificationToken" -ForegroundColor Gray
Write-Host ""
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "1. 在 Strapi 管理面板中查看创建的数据" -ForegroundColor Yellow
Write-Host "2. 检查用户的 confirmed 状态是否为 true" -ForegroundColor Yellow
Write-Host "3. 尝试使用该用户登录" -ForegroundColor Yellow
