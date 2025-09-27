# 热加载开发指南

本项目现在支持开发阶段的热加载功能，使用Docker Compose的watch配置实现代码变更自动重新加载。

## 🚀 快速开始

### 开发模式（推荐）
```bash
# 直接启动开发模式（支持热加载）
./start_dev.sh
```

### 生产模式
```bash
# 直接启动生产模式
./start_prod.sh
```

### 通用启动脚本
```bash
# 交互式选择模式
./start.sh
```

## 🔧 热加载功能

### 后端热加载
- **技术**: uvicorn --reload
- **触发**: Python文件变更时自动重新加载
- **支持文件**: `.py` 文件
- **配置**: `backend/Dockerfile.dev`

### 前端热加载
- **技术**: Next.js 开发服务器
- **触发**: 前端文件变更时自动重新加载
- **支持文件**: `.js`, `.jsx`, `.ts`, `.tsx`, `.css` 等
- **配置**: `frontend/Dockerfile.dev`

### Docker Compose Watch
- **同步**: 代码变更自动同步到容器
- **重建**: 依赖文件变更时自动重建镜像
- **配置**: `docker-compose.yml` 中的 `develop.watch` 部分

## 📁 文件结构

```
├── docker-compose.yml          # 开发环境配置（支持热加载）
├── docker-compose.prod.yml     # 生产环境配置
├── start.sh                    # 通用启动脚本（交互式选择）
├── start_dev.sh                # 开发环境启动脚本
├── start_prod.sh               # 生产环境启动脚本
├── backend/
│   ├── Dockerfile              # 生产环境Dockerfile
│   └── Dockerfile.dev          # 开发环境Dockerfile
└── frontend/
    ├── Dockerfile              # 生产环境Dockerfile
    └── Dockerfile.dev          # 开发环境Dockerfile
```

## 🔄 热加载配置详解

### 后端配置
```yaml
develop:
  watch:
    - action: sync              # 同步代码变更
      path: ./backend
      target: /app
    - action: rebuild           # 重建镜像
      path: ./backend/pyproject.toml
    - action: rebuild
      path: ./backend/gen_ui_backend/requirements.txt
```

### 前端配置
```yaml
develop:
  watch:
    - action: sync              # 同步代码变更
      path: ./frontend
      target: /app
    - action: rebuild           # 重建镜像
      path: ./frontend/package.json
    - action: rebuild
      path: ./frontend/yarn.lock
```

## 🛠️ 开发工作流

1. **启动开发环境**:
   ```bash
   ./start_dev.sh
   ```

2. **修改代码**:
   - 后端: 修改 `backend/` 目录下的 `.py` 文件
   - 前端: 修改 `frontend/` 目录下的文件

3. **自动重载**:
   - 代码变更会自动同步到容器
   - 后端使用 uvicorn --reload 自动重启
   - 前端使用 Next.js 开发服务器自动重载

4. **查看日志**:
   ```bash
   docker compose logs -f
   ```

## 🐛 故障排除

### 热加载不工作
1. 检查Docker Compose版本是否支持watch功能
2. 确保文件权限正确
3. 检查容器是否正常运行

### 后端不重载
1. 检查 `backend/Dockerfile.dev` 中的启动命令
2. 确保使用 `uvicorn --reload` 参数
3. 检查Python文件语法是否正确

### 前端不重载
1. 检查 `frontend/Dockerfile.dev` 中的启动命令
2. 确保使用 `yarn dev` 命令
3. 检查Next.js配置是否正确

## 📝 注意事项

1. **开发模式**: 使用 `docker-compose.yml` 和 `Dockerfile.dev`
2. **生产模式**: 使用 `docker-compose.prod.yml` 和 `Dockerfile`
3. **依赖变更**: 修改 `pyproject.toml` 或 `package.json` 会触发镜像重建
4. **性能**: 开发模式会保持容器运行，便于调试

## 🎯 最佳实践

1. **开发时**: 始终使用开发模式 (`./dev.sh`)
2. **部署时**: 使用生产模式 (`./start.sh prod`)
3. **调试**: 使用 `docker compose logs -f` 查看实时日志
4. **清理**: 定期运行 `docker system prune` 清理未使用的镜像

## 🔍 监控和调试

### 查看服务状态
```bash
docker compose ps
```

### 查看实时日志
```bash
# 所有服务
docker compose logs -f

# 特定服务
docker compose logs -f backend
docker compose logs -f frontend
```

### 进入容器调试
```bash
# 后端容器
docker compose exec backend bash

# 前端容器
docker compose exec frontend sh
```

现在您可以享受高效的开发体验了！🎉
