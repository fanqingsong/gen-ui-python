# Docker 化改造说明

## 项目结构

```
gen-ui-python/
├── backend/
│   ├── Dockerfile              # 后端 Docker 镜像配置
│   ├── pyproject.toml          # Python 依赖配置
│   └── gen_ui_backend/         # 后端源代码
├── frontend/
│   ├── Dockerfile              # 前端 Docker 镜像配置
│   ├── next.config.mjs         # Next.js 配置（已更新支持 standalone）
│   ├── package.json            # Node.js 依赖配置
│   └── app/                    # 前端源代码
├── docker-compose.yml          # Docker Compose 服务编排
├── .dockerignore              # Docker 忽略文件
├── env.template               # 环境变量模板
├── start.sh                   # 一键启动脚本
└── README.md                  # 项目说明（已更新）
```

## 改造内容

### 1. 后端 Dockerfile
- 使用华为云镜像加速
- 基于 Python 3.11-slim
- 使用 Poetry 管理依赖
- 暴露 8000 端口

### 2. 前端 Dockerfile
- 使用华为云镜像加速
- 基于 Node.js 18-alpine
- 多阶段构建优化镜像大小
- 支持 Next.js standalone 模式
- 暴露 3000 端口

### 3. Docker Compose 配置
- 定义 backend 和 frontend 服务
- 配置服务间网络通信
- 环境变量管理
- 健康检查
- 自动重启策略

### 4. 环境变量管理
- 创建 `env.template` 模板文件
- 支持 Docker 和本地开发环境
- 包含所有必需的 API 密钥配置

### 5. 启动脚本
- 自动检查环境
- 创建环境变量文件
- 一键启动所有服务
- 提供常用命令说明

## 使用方法

### 快速启动
```bash
./start.sh
```

### 手动启动
```bash
# 1. 配置环境变量
cp env.template .env
nano .env

# 2. 启动服务
docker compose up -d

# 3. 访问应用
# 前端: http://localhost:3000
# 后端: http://localhost:8000
```

### 常用命令
```bash
# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f

# 停止服务
docker compose down

# 重新构建
docker compose build --no-cache
```

## 优势

1. **一键启动**: 无需手动安装依赖，一条命令启动整个应用
2. **环境隔离**: 使用容器隔离，避免环境冲突
3. **配置简单**: 统一的环境变量管理
4. **开发友好**: 支持热重载和调试
5. **生产就绪**: 优化的多阶段构建，适合生产部署
