#!/bin/bash

# DAP 部署脚本
# 使用方法: ./scripts/deploy.sh [environment]
# environment: dev, staging, prod (默认: dev)

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查依赖
check_dependencies() {
    log_info "检查部署依赖..."
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker 未安装"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose 未安装"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        log_error "Git 未安装"
        exit 1
    fi
    
    log_success "依赖检查完成"
}

# 获取环境变量
get_environment() {
    local env=${1:-dev}
    
    case $env in
        dev|development)
            echo "development"
            ;;
        staging)
            echo "staging"
            ;;
        prod|production)
            echo "production"
            ;;
        *)
            log_error "无效的环境: $env"
            log_info "支持的环境: dev, staging, prod"
            exit 1
            ;;
    esac
}

# 备份数据库
backup_database() {
    local env=$1
    
    if [ "$env" = "production" ]; then
        log_info "备份生产数据库..."
        
        local backup_dir="backups/$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        
        docker-compose exec -T mysql mysqldump -u root -proot_password dap_db > "$backup_dir/dap_db.sql"
        
        log_success "数据库备份完成: $backup_dir/dap_db.sql"
    fi
}

# 停止服务
stop_services() {
    log_info "停止现有服务..."
    docker-compose down
    log_success "服务已停止"
}

# 拉取最新代码
pull_latest_code() {
    log_info "拉取最新代码..."
    git pull origin main
    log_success "代码更新完成"
}

# 构建镜像
build_images() {
    local env=$1
    
    log_info "构建 Docker 镜像..."
    
    if [ "$env" = "production" ]; then
        docker-compose -f docker-compose.yml -f docker-compose.prod.yml build --no-cache
    else
        docker-compose build
    fi
    
    log_success "镜像构建完成"
}

# 启动服务
start_services() {
    local env=$1
    
    log_info "启动服务..."
    
    if [ "$env" = "production" ]; then
        docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
    else
        docker-compose up -d
    fi
    
    log_success "服务启动完成"
}

# 等待服务就绪
wait_for_services() {
    log_info "等待服务就绪..."
    
    # 等待数据库
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if docker-compose exec -T mysql mysqladmin ping -h localhost -u root -proot_password --silent; then
            log_success "数据库就绪"
            break
        fi
        
        log_info "等待数据库就绪... (尝试 $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    if [ $attempt -gt $max_attempts ]; then
        log_error "数据库启动超时"
        exit 1
    fi
    
    # 等待后端API
    attempt=1
    while [ $attempt -le $max_attempts ]; do
        if curl -f http://localhost:8080/health > /dev/null 2>&1; then
            log_success "后端API就绪"
            break
        fi
        
        log_info "等待后端API就绪... (尝试 $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    if [ $attempt -gt $max_attempts ]; then
        log_error "后端API启动超时"
        exit 1
    fi
    
    # 等待前端
    attempt=1
    while [ $attempt -le $max_attempts ]; do
        if curl -f http://localhost:3000 > /dev/null 2>&1; then
            log_success "前端就绪"
            break
        fi
        
        log_info "等待前端就绪... (尝试 $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    if [ $attempt -gt $max_attempts ]; then
        log_error "前端启动超时"
        exit 1
    fi
}

# 运行数据库迁移
run_migrations() {
    log_info "运行数据库迁移..."
    docker-compose exec backend npm run migrate
    log_success "数据库迁移完成"
}

# 运行测试
run_tests() {
    local env=$1
    
    if [ "$env" != "production" ]; then
        log_info "运行测试..."
        docker-compose exec backend npm test
        log_success "测试完成"
    fi
}

# 健康检查
health_check() {
    log_info "执行健康检查..."
    
    # 检查前端
    if curl -f http://localhost:3000 > /dev/null 2>&1; then
        log_success "前端健康检查通过"
    else
        log_error "前端健康检查失败"
        return 1
    fi
    
    # 检查后端API
    if curl -f http://localhost:8080/health > /dev/null 2>&1; then
        log_success "后端API健康检查通过"
    else
        log_error "后端API健康检查失败"
        return 1
    fi
    
    # 检查数据库
    if docker-compose exec -T mysql mysqladmin ping -h localhost -u root -proot_password --silent; then
        log_success "数据库健康检查通过"
    else
        log_error "数据库健康检查失败"
        return 1
    fi
    
    log_success "所有服务健康检查通过"
}

# 清理旧镜像
cleanup_images() {
    log_info "清理未使用的 Docker 镜像..."
    docker image prune -f
    log_success "镜像清理完成"
}

# 显示部署信息
show_deployment_info() {
    local env=$1
    
    log_success "部署完成!"
    echo ""
    echo "=== 部署信息 ==="
    echo "环境: $env"
    echo "前端地址: http://localhost:3000"
    echo "后端API: http://localhost:8080"
    echo "数据库: localhost:3306"
    echo "Redis: localhost:6379"
    echo ""
    echo "=== 服务状态 ==="
    docker-compose ps
    echo ""
    echo "=== 日志查看 ==="
    echo "查看所有服务日志: docker-compose logs -f"
    echo "查看前端日志: docker-compose logs -f frontend"
    echo "查看后端日志: docker-compose logs -f backend"
    echo "查看数据库日志: docker-compose logs -f mysql"
}

# 主函数
main() {
    local env=$(get_environment "$1")
    
    log_info "开始部署 DAP 系统到 $env 环境"
    
    # 检查依赖
    check_dependencies
    
    # 备份数据库（生产环境）
    backup_database "$env"
    
    # 停止现有服务
    stop_services
    
    # 拉取最新代码
    pull_latest_code
    
    # 构建镜像
    build_images "$env"
    
    # 启动服务
    start_services "$env"
    
    # 等待服务就绪
    wait_for_services
    
    # 运行数据库迁移
    run_migrations
    
    # 运行测试（非生产环境）
    run_tests "$env"
    
    # 健康检查
    if health_check; then
        # 清理旧镜像
        cleanup_images
        
        # 显示部署信息
        show_deployment_info "$env"
    else
        log_error "健康检查失败，部署可能有问题"
        exit 1
    fi
}

# 错误处理
trap 'log_error "部署过程中发生错误，正在回滚..."; docker-compose down; exit 1' ERR

# 执行主函数
main "$@"