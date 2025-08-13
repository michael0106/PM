# Digital Affiliate Portal (DAP)

## 项目概述

Digital Affiliate Portal (DAP) 是一个自建的CPA业务支持系统，用于替代现有的Cellxpert (CX) 平台，解决业务限制并提升运营效率。

## 核心目标

- 实现自建CPA系统替代Cellxpert平台
- 打通数据，解决多流程同时操作的问题
- 优化CPA核心流程，解耦注册开户与计划配置
- 为业务赋能，加速Sales业务运转
- 建立数据白皮书，推进数据治理
- 引入预警机制，加强业务监控

## 主要功能模块

### 1. 注册开户模块
- 快速注册申请
- 用户协议管理
- 登录系统（账号密码 + 忘记密码）
- DAP User ID生成
- CPA Account管理
- 邀请链接生成

### 2. 开户审核模块
- KYC认证资料提交
- 自动校验能力
- 禁开国配置
- 黑名单配置
- 系统内工单OA
- 流程引擎
- 一键过审功能

### 3. 佣金计划配置模块
- 首次计划配置
- 计划调整
- 多账户计划配置
- 佣金模式配置
- 佣金规则配置
- 子代理佣金规则配置
- 协议模板管理
- 应用控制（全量/存量/增量）

### 4. 营销推广模块
- 邀请链接
- 活码系统
- 营销素材中心
- 线索追踪
- 精准跳转
- 客户管理
- 代理管理
- API数据回传

### 5. 佣金支付管理模块
- 佣金计算
- 支付流程
- 结算管理

### 6. 客户管理模块
- 客户清单
- 客户明细
- 漏斗分析
- 数据报表

### 7. 代理管理模块
- 代理清单
- 代理明细
- 层级管理
- 业绩统计

### 8. 系统设置模块
- 基础配置
- 权限管理
- 系统参数

## 技术架构

### 前端技术栈
- React/Vue.js
- TypeScript
- Ant Design/Element UI
- Redux/Vuex

### 后端技术栈
- Node.js/Java Spring Boot
- Express/Spring MVC
- MySQL/PostgreSQL
- Redis
- RabbitMQ/Kafka

### 部署架构
- Docker容器化
- Kubernetes编排
- Nginx负载均衡
- AWS/Azure云服务

## 开发环境搭建

```bash
# 克隆项目
git clone https://github.com/michael0106/PM.git
cd PM

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

## 项目结构

```
DAP/
├── frontend/          # 前端应用
├── backend/           # 后端服务
├── database/          # 数据库脚本
├── docs/             # 项目文档
├── docker/           # Docker配置
└── scripts/          # 部署脚本
```

## 开发规范

### 代码规范
- 使用ESLint + Prettier
- 遵循TypeScript规范
- 组件化开发
- 单元测试覆盖率 > 80%

### Git工作流
- 主分支：main
- 开发分支：develop
- 功能分支：feature/*
- 修复分支：hotfix/*

### 提交规范
```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 代码重构
test: 测试相关
chore: 构建过程或辅助工具的变动
```

## 部署说明

### 开发环境
```bash
docker-compose up -d
```

### 生产环境
```bash
kubectl apply -f k8s/
```

## 联系方式

- 项目负责人：@Leon Li
- 技术支持：@Michael Duan
- 产品经理：@Nora Ye

## 版本历史

- v1.0.0 (2025.06.23) - 创建项目基础架构