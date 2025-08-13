# DAP API 文档

## 概述

Digital Affiliate Portal (DAP) API 提供了完整的CPA业务支持功能，包括用户管理、账户管理、佣金计算、营销推广等核心功能。

## 基础信息

- **Base URL**: `https://api.dap.com`
- **API Version**: v1
- **Content-Type**: `application/json`
- **认证方式**: JWT Bearer Token

## 认证

### 获取访问令牌

```http
POST /auth/login
```

**请求体:**
```json
{
  "username": "user@example.com",
  "password": "password123"
}
```

**响应:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "dap_user_id": "DAP001",
      "username": "user@example.com",
      "status": "active"
    }
  }
}
```

## 用户管理 API

### 用户注册

```http
POST /auth/register
```

**请求体:**
```json
{
  "username": "newuser@example.com",
  "email": "newuser@example.com",
  "password": "password123",
  "phone": "+1234567890",
  "country": "US"
}
```

### 获取用户信息

```http
GET /users/profile
Authorization: Bearer {token}
```

### 更新用户信息

```http
PUT /users/profile
Authorization: Bearer {token}
```

## CPA账户管理 API

### 获取账户列表

```http
GET /accounts
Authorization: Bearer {token}
```

**查询参数:**
- `status`: 账户状态 (pending, active, suspended, closed)
- `country`: 国家代码
- `page`: 页码
- `limit`: 每页数量

### 创建CPA账户

```http
POST /accounts
Authorization: Bearer {token}
```

**请求体:**
```json
{
  "account_name": "My CPA Account",
  "country": "US",
  "currency": "USD"
}
```

### 获取账户详情

```http
GET /accounts/{account_id}
Authorization: Bearer {token}
```

## KYC认证 API

### 提交KYC资料

```http
POST /kyc/submit
Authorization: Bearer {token}
```

**请求体:**
```json
{
  "account_id": 1,
  "identity_document": "base64_encoded_file",
  "address_proof": "base64_encoded_file",
  "selfie": "base64_encoded_file"
}
```

### 获取KYC状态

```http
GET /kyc/status/{account_id}
Authorization: Bearer {token}
```

## 佣金计划 API

### 获取佣金计划列表

```http
GET /commission-plans
Authorization: Bearer {token}
```

### 为账户配置佣金计划

```http
POST /accounts/{account_id}/commission-plans
Authorization: Bearer {token}
```

**请求体:**
```json
{
  "plan_id": 1,
  "start_date": "2024-01-01",
  "end_date": "2024-12-31"
}
```

### 获取账户佣金计划

```http
GET /accounts/{account_id}/commission-plans
Authorization: Bearer {token}
```

## 客户管理 API

### 获取客户列表

```http
GET /clients
Authorization: Bearer {token}
```

**查询参数:**
- `account_id`: CPA账户ID
- `status`: 客户状态
- `country`: 国家代码
- `date_from`: 开始日期
- `date_to`: 结束日期

### 获取客户详情

```http
GET /clients/{client_id}
Authorization: Bearer {token}
```

### 获取客户统计数据

```http
GET /clients/statistics
Authorization: Bearer {token}
```

## 佣金记录 API

### 获取佣金记录

```http
GET /commissions
Authorization: Bearer {token}
```

**查询参数:**
- `account_id`: CPA账户ID
- `status`: 佣金状态
- `date_from`: 开始日期
- `date_to`: 结束日期

### 获取佣金统计

```http
GET /commissions/statistics
Authorization: Bearer {token}
```

## 营销素材 API

### 获取营销素材列表

```http
GET /marketing-materials
Authorization: Bearer {token}
```

### 创建营销素材

```http
POST /marketing-materials
Authorization: Bearer {token}
```

**请求体:**
```json
{
  "account_id": 1,
  "material_type": "link",
  "material_name": "My Landing Page",
  "material_url": "https://example.com/landing"
}
```

### 生成邀请链接

```http
POST /marketing-materials/invite-links
Authorization: Bearer {token}
```

**请求体:**
```json
{
  "account_id": 1,
  "campaign_name": "Summer Campaign",
  "tracking_params": {
    "utm_source": "dap",
    "utm_medium": "email"
  }
}
```

## 线索追踪 API

### 获取线索追踪数据

```http
GET /lead-tracking
Authorization: Bearer {token}
```

**查询参数:**
- `material_id`: 营销素材ID
- `date_from`: 开始日期
- `date_to`: 结束日期
- `conversion_status`: 转化状态

### 获取转化漏斗数据

```http
GET /lead-tracking/funnel
Authorization: Bearer {token}
```

## 系统配置 API

### 获取系统配置

```http
GET /system/configs
Authorization: Bearer {token}
```

### 更新系统配置

```http
PUT /system/configs/{config_key}
Authorization: Bearer {token}
```

## 错误处理

### 错误响应格式

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Email is required"
      }
    ]
  }
}
```

### 常见错误代码

| 错误代码 | 描述 |
|---------|------|
| `UNAUTHORIZED` | 未授权访问 |
| `FORBIDDEN` | 禁止访问 |
| `NOT_FOUND` | 资源不存在 |
| `VALIDATION_ERROR` | 数据验证错误 |
| `INTERNAL_ERROR` | 服务器内部错误 |
| `RATE_LIMIT_EXCEEDED` | 请求频率超限 |

## 速率限制

- **认证接口**: 5次/分钟
- **普通接口**: 100次/分钟
- **文件上传**: 10次/分钟

## 分页

支持分页的接口使用以下查询参数：

- `page`: 页码 (默认: 1)
- `limit`: 每页数量 (默认: 20, 最大: 100)

**响应格式:**
```json
{
  "success": true,
  "data": {
    "items": [...],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "total_pages": 5
    }
  }
}
```

## Webhook

### 配置Webhook

```http
POST /webhooks
Authorization: Bearer {token}
```

**请求体:**
```json
{
  "url": "https://your-domain.com/webhook",
  "events": ["client.registered", "commission.earned"],
  "secret": "your_webhook_secret"
}
```

### Webhook事件类型

- `client.registered`: 客户注册
- `client.kyc_approved`: KYC认证通过
- `client.deposited`: 客户入金
- `commission.earned`: 佣金获得
- `commission.paid`: 佣金支付

## 测试环境

- **测试Base URL**: `https://test-api.dap.com`
- **测试数据**: 使用测试账户进行API测试

## SDK支持

- JavaScript/TypeScript SDK
- Python SDK
- PHP SDK
- Java SDK

## 更新日志

### v1.0.0 (2024-01-01)
- 初始版本发布
- 支持基础用户管理和CPA账户功能
- 支持KYC认证流程
- 支持佣金计划配置