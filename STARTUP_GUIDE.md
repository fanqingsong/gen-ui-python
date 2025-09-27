# 启动脚本使用指南

本项目提供了多个启动脚本，针对不同的使用场景进行了优化。

## 📋 启动脚本概览

| 脚本名称 | 用途 | 特点 | 推荐场景 |
|---------|------|------|----------|
| `start_dev.sh` | 开发环境 | 热加载、实时日志 | 日常开发 |
| `start_prod.sh` | 生产环境 | 优化性能、稳定运行 | 部署使用 |
| `start.sh` | 通用启动 | 交互式选择 | 不确定环境时 |

## 🚀 快速启动

### 开发模式（推荐）
```bash
# 直接启动开发环境
./start_dev.sh
```

**特点：**
- ✅ 支持热加载
- ✅ 代码变更自动重载
- ✅ 实时日志输出
- ✅ 文件自动同步

### 生产模式
```bash
# 直接启动生产环境
./start_prod.sh
```

**特点：**
- ✅ 优化性能
- ✅ 稳定运行
- ✅ 后台运行
- ✅ 健康检查

### 交互式启动
```bash
# 交互式选择模式
./start.sh
```

**特点：**
- ✅ 引导式选择
- ✅ 自动环境检查
- ✅ 详细说明信息

## 🔧 脚本功能对比

### start_dev.sh
```bash
./start_dev.sh
```
- 使用 `docker-compose.yml` 配置
- 使用 `Dockerfile.dev` 构建镜像
- 支持 Docker Compose Watch
- 实时显示日志
- 代码变更自动同步

### start_prod.sh
```bash
./start_prod.sh
```
- 使用 `docker-compose.prod.yml` 配置
- 使用 `Dockerfile` 构建镜像
- 后台运行服务
- 自动健康检查
- 优化性能配置

### start.sh
```bash
./start.sh
```
- 交互式选择模式
- 自动环境检查
- 引导用户选择
- 调用对应的专门脚本

## 📝 使用示例

### 开发工作流
```bash
# 1. 启动开发环境
./start_dev.sh

# 2. 修改代码（自动重载）
# 编辑 backend/ 或 frontend/ 目录下的文件

# 3. 查看日志
docker compose logs -f

# 4. 停止服务
docker compose down
```

### 生产部署
```bash
# 1. 启动生产环境
./start_prod.sh

# 2. 检查服务状态
docker compose -f docker-compose.prod.yml ps

# 3. 查看日志
docker compose -f docker-compose.prod.yml logs -f

# 4. 停止服务
docker compose -f docker-compose.prod.yml down
```

## 🛠️ 环境配置

### 环境变量
所有脚本都会自动检查并创建 `.env` 文件：

```bash
# 如果不存在 .env 文件，会自动从 env.template 创建
cp env.template .env
```

### 必需配置
```env
# Azure OpenAI 配置（推荐）
AZURE_OPENAI_API_KEY=your_azure_openai_api_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com/
AZURE_OPENAI_API_VERSION=2024-02-15-preview
AZURE_OPENAI_DEPLOYMENT_NAME=your_deployment_name
AI_SERVICE_PROVIDER=azure

# 其他必需配置
GITHUB_TOKEN=your_github_token_here
GEOCODE_API_KEY=your_geocode_api_key_here
```

## 🔍 故障排除

### 常见问题

1. **权限问题**
   ```bash
   chmod +x start_dev.sh start_prod.sh start.sh
   ```

2. **Docker未运行**
   ```bash
   # 启动Docker服务
   sudo systemctl start docker
   ```

3. **端口占用**
   ```bash
   # 检查端口占用
   netstat -tlnp | grep :3000
   netstat -tlnp | grep :8000
   ```

4. **环境变量未设置**
   ```bash
   # 检查环境变量
   cat .env
   ```

### 日志查看

```bash
# 开发环境日志
docker compose logs -f

# 生产环境日志
docker compose -f docker-compose.prod.yml logs -f

# 特定服务日志
docker compose logs -f backend
docker compose logs -f frontend
```

## 📊 性能对比

| 特性 | 开发模式 | 生产模式 |
|------|----------|----------|
| 启动速度 | 快 | 中等 |
| 内存使用 | 高 | 低 |
| CPU使用 | 高 | 低 |
| 热加载 | ✅ | ❌ |
| 稳定性 | 中等 | 高 |
| 调试友好 | ✅ | ❌ |

## 💡 最佳实践

1. **开发时**：使用 `./start_dev.sh`
2. **部署时**：使用 `./start_prod.sh`
3. **不确定时**：使用 `./start.sh`
4. **定期清理**：`docker system prune -f`
5. **监控资源**：`docker system df`

## 🎯 总结

- **开发模式**：适合日常开发，支持热加载
- **生产模式**：适合部署使用，优化性能
- **通用脚本**：适合不确定环境时使用

选择适合您需求的启动脚本，享受高效的开发体验！🚀
