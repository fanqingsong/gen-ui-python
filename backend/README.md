# Gen UI Backend

Gen UI Python 项目的后端服务，提供 AI 驱动的用户界面生成功能。

## 功能特性

- Azure OpenAI 支持
- 热加载开发环境
- FastAPI 框架
- LangChain 集成
- Docker 容器化

## 开发

```bash
# 启动开发环境
./start_dev.sh

# 查看日志
docker compose logs -f backend
```

## 生产部署

```bash
# 启动生产环境
./start_prod.sh
```

## API 文档

启动服务后访问：http://localhost:8000/docs