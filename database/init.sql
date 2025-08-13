-- DAP系统数据库初始化脚本
-- 创建数据库
CREATE DATABASE IF NOT EXISTS dap_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dap_db;

-- 用户表
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    dap_user_id VARCHAR(50) UNIQUE NOT NULL COMMENT 'DAP用户ID',
    username VARCHAR(100) UNIQUE NOT NULL COMMENT '用户名',
    email VARCHAR(255) UNIQUE NOT NULL COMMENT '邮箱',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    phone VARCHAR(20) COMMENT '手机号',
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active' COMMENT '用户状态',
    kyc_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending' COMMENT 'KYC状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_dap_user_id (dap_user_id),
    INDEX idx_email (email),
    INDEX idx_status (status)
) COMMENT '用户表';

-- CPA账户表
CREATE TABLE cpa_accounts (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    account_number VARCHAR(50) UNIQUE NOT NULL COMMENT 'CPA账户号',
    account_name VARCHAR(255) NOT NULL COMMENT '账户名称',
    country VARCHAR(10) NOT NULL COMMENT '国家代码',
    currency VARCHAR(3) DEFAULT 'USD' COMMENT '货币',
    status ENUM('pending', 'active', 'suspended', 'closed') DEFAULT 'pending' COMMENT '账户状态',
    sales_rep_id BIGINT COMMENT '销售代表ID',
    parent_account_id BIGINT COMMENT '父账户ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_account_number (account_number),
    INDEX idx_user_id (user_id),
    INDEX idx_country (country),
    INDEX idx_status (status)
) COMMENT 'CPA账户表';

-- 佣金计划表
CREATE TABLE commission_plans (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(255) NOT NULL COMMENT '计划名称',
    plan_type ENUM('standard', 'bonus', 'multi_trigger') NOT NULL COMMENT '计划类型',
    description TEXT COMMENT '计划描述',
    commission_rate DECIMAL(10,4) NOT NULL COMMENT '佣金比例',
    min_deposit DECIMAL(15,2) DEFAULT 0 COMMENT '最小入金',
    max_commission DECIMAL(15,2) COMMENT '最大佣金',
    qualification_conditions JSON COMMENT '合格条件',
    status ENUM('active', 'inactive') DEFAULT 'active' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plan_name (plan_name),
    INDEX idx_status (status)
) COMMENT '佣金计划表';

-- 账户佣金计划关联表
CREATE TABLE account_commission_plans (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    account_id BIGINT NOT NULL COMMENT '账户ID',
    plan_id BIGINT NOT NULL COMMENT '计划ID',
    start_date DATE NOT NULL COMMENT '开始日期',
    end_date DATE COMMENT '结束日期',
    status ENUM('active', 'inactive') DEFAULT 'active' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES cpa_accounts(id),
    FOREIGN KEY (plan_id) REFERENCES commission_plans(id),
    INDEX idx_account_id (account_id),
    INDEX idx_plan_id (plan_id),
    INDEX idx_status (status)
) COMMENT '账户佣金计划关联表';

-- 客户表
CREATE TABLE clients (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    account_id BIGINT NOT NULL COMMENT 'CPA账户ID',
    client_id VARCHAR(50) UNIQUE NOT NULL COMMENT '客户ID',
    first_name VARCHAR(100) NOT NULL COMMENT '名',
    last_name VARCHAR(100) NOT NULL COMMENT '姓',
    email VARCHAR(255) NOT NULL COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    country VARCHAR(10) NOT NULL COMMENT '国家',
    status ENUM('registered', 'kyc_pending', 'kyc_approved', 'deposited', 'trading') DEFAULT 'registered' COMMENT '客户状态',
    first_deposit_amount DECIMAL(15,2) COMMENT '首次入金金额',
    first_deposit_date TIMESTAMP NULL COMMENT '首次入金日期',
    total_deposit DECIMAL(15,2) DEFAULT 0 COMMENT '总入金',
    total_withdrawal DECIMAL(15,2) DEFAULT 0 COMMENT '总出金',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES cpa_accounts(id),
    INDEX idx_client_id (client_id),
    INDEX idx_account_id (account_id),
    INDEX idx_status (status),
    INDEX idx_country (country)
) COMMENT '客户表';

-- 佣金记录表
CREATE TABLE commission_records (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    account_id BIGINT NOT NULL COMMENT 'CPA账户ID',
    client_id BIGINT NOT NULL COMMENT '客户ID',
    plan_id BIGINT NOT NULL COMMENT '佣金计划ID',
    commission_amount DECIMAL(15,2) NOT NULL COMMENT '佣金金额',
    commission_type ENUM('ftd', 'trading', 'bonus') NOT NULL COMMENT '佣金类型',
    status ENUM('pending', 'approved', 'paid', 'rejected') DEFAULT 'pending' COMMENT '状态',
    qualification_date TIMESTAMP NOT NULL COMMENT '合格日期',
    payment_date TIMESTAMP NULL COMMENT '支付日期',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES cpa_accounts(id),
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (plan_id) REFERENCES commission_plans(id),
    INDEX idx_account_id (account_id),
    INDEX idx_client_id (client_id),
    INDEX idx_status (status),
    INDEX idx_qualification_date (qualification_date)
) COMMENT '佣金记录表';

-- 营销素材表
CREATE TABLE marketing_materials (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    account_id BIGINT NOT NULL COMMENT 'CPA账户ID',
    material_type ENUM('link', 'qr_code', 'banner', 'video', 'landing_page') NOT NULL COMMENT '素材类型',
    material_name VARCHAR(255) NOT NULL COMMENT '素材名称',
    material_url TEXT COMMENT '素材链接',
    material_content LONGTEXT COMMENT '素材内容',
    tracking_code VARCHAR(100) UNIQUE COMMENT '追踪代码',
    status ENUM('active', 'inactive') DEFAULT 'active' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES cpa_accounts(id),
    INDEX idx_account_id (account_id),
    INDEX idx_tracking_code (tracking_code),
    INDEX idx_status (status)
) COMMENT '营销素材表';

-- 线索追踪表
CREATE TABLE lead_tracking (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    material_id BIGINT NOT NULL COMMENT '营销素材ID',
    visitor_ip VARCHAR(45) COMMENT '访问者IP',
    user_agent TEXT COMMENT '用户代理',
    referrer VARCHAR(500) COMMENT '来源页面',
    country VARCHAR(10) COMMENT '国家',
    city VARCHAR(100) COMMENT '城市',
    device_type ENUM('desktop', 'mobile', 'tablet') COMMENT '设备类型',
    browser VARCHAR(100) COMMENT '浏览器',
    os VARCHAR(100) COMMENT '操作系统',
    visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '访问时间',
    conversion_status ENUM('visit', 'register', 'kyc', 'deposit') DEFAULT 'visit' COMMENT '转化状态',
    client_id BIGINT COMMENT '客户ID',
    FOREIGN KEY (material_id) REFERENCES marketing_materials(id),
    FOREIGN KEY (client_id) REFERENCES clients(id),
    INDEX idx_material_id (material_id),
    INDEX idx_visit_time (visit_time),
    INDEX idx_conversion_status (conversion_status)
) COMMENT '线索追踪表';

-- 系统配置表
CREATE TABLE system_configs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    config_key VARCHAR(100) UNIQUE NOT NULL COMMENT '配置键',
    config_value TEXT COMMENT '配置值',
    config_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string' COMMENT '配置类型',
    description VARCHAR(500) COMMENT '配置描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_config_key (config_key)
) COMMENT '系统配置表';

-- 操作日志表
CREATE TABLE operation_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT COMMENT '用户ID',
    operation_type VARCHAR(100) NOT NULL COMMENT '操作类型',
    operation_desc TEXT COMMENT '操作描述',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    request_data JSON COMMENT '请求数据',
    response_data JSON COMMENT '响应数据',
    status ENUM('success', 'failed') DEFAULT 'success' COMMENT '操作状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_operation_type (operation_type),
    INDEX idx_created_at (created_at)
) COMMENT '操作日志表';

-- 插入初始数据
INSERT INTO system_configs (config_key, config_value, config_type, description) VALUES
('kyc_required', 'true', 'boolean', '是否要求KYC认证'),
('min_deposit_amount', '100', 'number', '最小入金金额'),
('commission_payment_delay', '30', 'number', '佣金支付延迟天数'),
('blacklist_countries', '["CN", "US"]', 'json', '黑名单国家'),
('allowed_currencies', '["USD", "EUR", "GBP"]', 'json', '允许的货币');

-- 插入示例佣金计划
INSERT INTO commission_plans (plan_name, plan_type, description, commission_rate, min_deposit, qualification_conditions) VALUES
('标准计划', 'standard', '标准CPA佣金计划', 0.0500, 100.00, '{"min_deposit": 100, "min_trades": 1}'),
('奖金计划', 'bonus', '高额奖金计划', 0.0800, 500.00, '{"min_deposit": 500, "min_trades": 5}'),
('多次触发计划', 'multi_trigger', '多次触发佣金计划', 0.0300, 200.00, '{"min_deposit": 200, "triggers": ["ftd", "trading"]}');