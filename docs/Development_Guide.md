# DAP 开发指南

## 项目概述

Digital Affiliate Portal (DAP) 是一个现代化的CPA业务支持系统，采用前后端分离架构，提供完整的CPA业务解决方案。

## 技术栈

### 前端技术栈
- **框架**: React 18 + TypeScript
- **UI库**: Ant Design 5.x
- **状态管理**: Zustand
- **路由**: React Router DOM 6.x
- **HTTP客户端**: Axios
- **表单处理**: React Hook Form + Yup
- **图表**: Recharts
- **构建工具**: Create React App

### 后端技术栈
- **运行时**: Node.js 18+
- **框架**: Express.js
- **数据库**: MySQL 8.0
- **ORM**: Sequelize
- **缓存**: Redis
- **消息队列**: RabbitMQ
- **认证**: JWT
- **日志**: Winston
- **验证**: Joi

### 基础设施
- **容器化**: Docker + Docker Compose
- **反向代理**: Nginx
- **负载均衡**: Nginx
- **监控**: Elasticsearch + Kibana
- **CI/CD**: GitHub Actions

## 开发环境搭建

### 前置要求
- Node.js 18+
- Docker & Docker Compose
- Git
- MySQL 8.0 (可选，Docker会自动安装)

### 快速开始

1. **克隆项目**
```bash
git clone https://github.com/michael0106/PM.git
cd PM
```

2. **安装依赖**
```bash
npm run setup
```

3. **启动开发环境**
```bash
# 使用Docker启动所有服务
npm run docker:up

# 或者分别启动前后端
npm run dev:frontend
npm run dev:backend
```

4. **访问应用**
- 前端: http://localhost:3000
- 后端API: http://localhost:8080
- 数据库: localhost:3306
- Redis: localhost:6379

## 项目结构

```
DAP/
├── frontend/                 # 前端应用
│   ├── public/              # 静态资源
│   ├── src/
│   │   ├── components/      # 通用组件
│   │   ├── pages/          # 页面组件
│   │   ├── hooks/          # 自定义Hooks
│   │   ├── services/       # API服务
│   │   ├── stores/         # 状态管理
│   │   ├── utils/          # 工具函数
│   │   ├── types/          # TypeScript类型定义
│   │   └── App.tsx         # 根组件
│   ├── package.json
│   └── tsconfig.json
├── backend/                 # 后端应用
│   ├── src/
│   │   ├── controllers/    # 控制器
│   │   ├── models/         # 数据模型
│   │   ├── routes/         # 路由
│   │   ├── middleware/     # 中间件
│   │   ├── services/       # 业务逻辑
│   │   ├── utils/          # 工具函数
│   │   ├── config/         # 配置文件
│   │   └── app.js          # 应用入口
│   ├── package.json
│   └── .env.example
├── database/               # 数据库脚本
│   ├── init.sql           # 初始化脚本
│   ├── migrations/        # 数据库迁移
│   └── seeds/             # 测试数据
├── docs/                  # 项目文档
├── docker/                # Docker配置
├── nginx/                 # Nginx配置
└── scripts/               # 部署脚本
```

## 开发规范

### 代码规范

#### 前端规范
- 使用TypeScript进行类型检查
- 遵循ESLint + Prettier配置
- 组件使用函数式组件 + Hooks
- 使用React.memo优化性能
- 遵循组件命名规范：PascalCase
- 文件命名规范：kebab-case

#### 后端规范
- 使用ESLint进行代码检查
- 遵循RESTful API设计规范
- 使用Joi进行数据验证
- 统一错误处理机制
- 使用Winston进行日志记录

### Git工作流

1. **分支策略**
   - `main`: 主分支，用于生产环境
   - `develop`: 开发分支，用于集成测试
   - `feature/*`: 功能分支
   - `hotfix/*`: 紧急修复分支

2. **提交规范**
```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 代码重构
test: 测试相关
chore: 构建过程或辅助工具的变动
```

3. **Pull Request流程**
   - 创建功能分支
   - 开发完成后创建PR
   - 代码审查
   - 合并到develop分支

### 数据库规范

- 表名使用snake_case
- 字段名使用snake_case
- 主键统一使用id
- 时间字段使用created_at, updated_at
- 状态字段使用status
- 软删除使用deleted_at

## API开发指南

### 控制器结构

```javascript
// controllers/userController.js
const UserService = require('../services/userService');
const { validateUser } = require('../validators/userValidator');

class UserController {
  async getUsers(req, res) {
    try {
      const { page = 1, limit = 20 } = req.query;
      const users = await UserService.getUsers({ page, limit });
      
      res.json({
        success: true,
        data: users
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: error.message
        }
      });
    }
  }
}

module.exports = new UserController();
```

### 路由定义

```javascript
// routes/userRoutes.js
const express = require('express');
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.get('/users', authMiddleware, userController.getUsers);
router.post('/users', authMiddleware, userController.createUser);
router.get('/users/:id', authMiddleware, userController.getUser);
router.put('/users/:id', authMiddleware, userController.updateUser);
router.delete('/users/:id', authMiddleware, userController.deleteUser);

module.exports = router;
```

### 数据验证

```javascript
// validators/userValidator.js
const Joi = require('joi');

const createUserSchema = Joi.object({
  username: Joi.string().email().required(),
  password: Joi.string().min(8).required(),
  phone: Joi.string().pattern(/^\+?[\d\s-]+$/),
  country: Joi.string().length(2).required()
});

const validateUser = (req, res, next) => {
  const { error } = createUserSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      error: {
        code: 'VALIDATION_ERROR',
        message: error.details[0].message
      }
    });
  }
  next();
};

module.exports = { validateUser };
```

## 前端开发指南

### 组件开发

```typescript
// components/UserList.tsx
import React from 'react';
import { Table, Button, Space } from 'antd';
import { useUsers } from '../hooks/useUsers';
import { User } from '../types/user';

interface UserListProps {
  onEdit?: (user: User) => void;
  onDelete?: (id: number) => void;
}

export const UserList: React.FC<UserListProps> = ({ onEdit, onDelete }) => {
  const { users, loading, error } = useUsers();

  const columns = [
    {
      title: '用户名',
      dataIndex: 'username',
      key: 'username',
    },
    {
      title: '邮箱',
      dataIndex: 'email',
      key: 'email',
    },
    {
      title: '状态',
      dataIndex: 'status',
      key: 'status',
    },
    {
      title: '操作',
      key: 'action',
      render: (_, record: User) => (
        <Space size="middle">
          <Button onClick={() => onEdit?.(record)}>编辑</Button>
          <Button danger onClick={() => onDelete?.(record.id)}>删除</Button>
        </Space>
      ),
    },
  ];

  if (error) return <div>加载失败: {error.message}</div>;

  return (
    <Table
      columns={columns}
      dataSource={users}
      loading={loading}
      rowKey="id"
    />
  );
};
```

### 自定义Hook

```typescript
// hooks/useUsers.ts
import { useState, useEffect } from 'react';
import { userService } from '../services/userService';
import { User } from '../types/user';

export const useUsers = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        setLoading(true);
        const data = await userService.getUsers();
        setUsers(data);
      } catch (err) {
        setError(err as Error);
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  return { users, loading, error };
};
```

### API服务

```typescript
// services/userService.ts
import axios from 'axios';
import { User, CreateUserRequest } from '../types/user';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080';

export const userService = {
  async getUsers(params?: { page?: number; limit?: number }) {
    const response = await axios.get(`${API_BASE_URL}/users`, { params });
    return response.data.data;
  },

  async getUser(id: number) {
    const response = await axios.get(`${API_BASE_URL}/users/${id}`);
    return response.data.data;
  },

  async createUser(user: CreateUserRequest) {
    const response = await axios.post(`${API_BASE_URL}/users`, user);
    return response.data.data;
  },

  async updateUser(id: number, user: Partial<CreateUserRequest>) {
    const response = await axios.put(`${API_BASE_URL}/users/${id}`, user);
    return response.data.data;
  },

  async deleteUser(id: number) {
    await axios.delete(`${API_BASE_URL}/users/${id}`);
  },
};
```

## 测试指南

### 单元测试

```javascript
// backend/tests/userController.test.js
const request = require('supertest');
const app = require('../src/app');
const UserService = require('../src/services/userService');

describe('User Controller', () => {
  describe('GET /users', () => {
    it('should return users list', async () => {
      const response = await request(app)
        .get('/users')
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });
});
```

### 前端测试

```typescript
// frontend/src/components/__tests__/UserList.test.tsx
import React from 'react';
import { render, screen } from '@testing-library/react';
import { UserList } from '../UserList';

const mockUsers = [
  { id: 1, username: 'test@example.com', email: 'test@example.com', status: 'active' }
];

describe('UserList', () => {
  it('renders user list', () => {
    render(<UserList />);
    expect(screen.getByText('test@example.com')).toBeInTheDocument();
  });
});
```

## 部署指南

### 开发环境部署

```bash
# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 生产环境部署

1. **构建镜像**
```bash
docker-compose -f docker-compose.prod.yml build
```

2. **部署到Kubernetes**
```bash
kubectl apply -f k8s/
```

3. **配置域名和SSL**
```bash
# 配置Nginx
sudo cp nginx/nginx.conf /etc/nginx/
sudo nginx -t
sudo systemctl reload nginx
```

## 监控和日志

### 日志配置

```javascript
// backend/src/config/logger.js
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
    new winston.transports.File({ filename: 'logs/combined.log' })
  ]
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple()
  }));
}

module.exports = logger;
```

### 健康检查

```javascript
// backend/src/routes/health.js
const express = require('express');
const router = express.Router();

router.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

module.exports = router;
```

## 性能优化

### 前端优化
- 使用React.memo减少不必要的重渲染
- 实现虚拟滚动处理大量数据
- 使用懒加载减少初始包大小
- 启用Gzip压缩

### 后端优化
- 使用Redis缓存热点数据
- 实现数据库连接池
- 使用索引优化查询性能
- 实现API限流

## 安全指南

### 认证和授权
- 使用JWT进行身份认证
- 实现基于角色的访问控制(RBAC)
- 使用HTTPS传输敏感数据
- 实现密码强度验证

### 数据安全
- 使用参数化查询防止SQL注入
- 实现输入验证和过滤
- 使用HTTPS加密传输
- 定期备份数据

## 常见问题

### 开发环境问题

1. **端口冲突**
```bash
# 查看端口占用
lsof -i :3000
# 杀死进程
kill -9 <PID>
```

2. **数据库连接失败**
```bash
# 检查MySQL服务状态
docker-compose ps mysql
# 查看MySQL日志
docker-compose logs mysql
```

3. **前端热重载不工作**
```bash
# 清除缓存
npm run build
# 重启开发服务器
npm run dev:frontend
```

## 贡献指南

1. Fork项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建Pull Request

## 联系方式

- 项目负责人: @Leon Li
- 技术支持: @Michael Duan
- 产品经理: @Nora Ye