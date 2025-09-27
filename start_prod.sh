#!/bin/bash

# Gen UI Python - 生产环境启动脚本
# 优化性能，适合部署使用

echo "🚀 启动生产环境..."

# 检查是否存在 .env 文件
if [ ! -f ".env" ]; then
    echo "⚠️  未找到 .env 文件，正在创建..."
    if [ -f "env.template" ]; then
        cp env.template .env
        echo "✅ 已从 env.template 创建 .env 文件"
        echo "📝 请编辑 .env 文件，填入你的 API 密钥："
        echo "   - AZURE_OPENAI_API_KEY (推荐)"
        echo "   - OPENAI_API_KEY (如果使用OpenAI)"
        echo "   - GITHUB_TOKEN"
        echo "   - GEOCODE_API_KEY"
        echo "   - LANGCHAIN_API_KEY (可选)"
        echo ""
        echo "按任意键继续..."
        read -n 1
    else
        echo "❌ 未找到 env.template 文件"
        exit 1
    fi
fi

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请先启动 Docker"
    exit 1
fi

# 检查 docker compose 是否可用
if ! docker compose version > /dev/null 2>&1; then
    echo "❌ docker compose 不可用，请确保安装了 Docker Compose"
    exit 1
fi

echo "🔧 构建并启动生产服务..."
echo "📦 使用生产环境Dockerfile"
echo "⚡ 优化性能配置"
echo ""

# 使用生产环境配置启动
docker compose -f docker-compose.prod.yml up -d --build

echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo "📊 服务状态："
docker compose -f docker-compose.prod.yml ps

# 检查服务健康状态
echo ""
echo "🔍 检查服务健康状态..."
backend_health=$(docker compose -f docker-compose.prod.yml ps --format "table {{.Service}}\t{{.Status}}" | grep backend | awk '{print $2}')
frontend_health=$(docker compose -f docker-compose.prod.yml ps --format "table {{.Service}}\t{{.Status}}" | grep frontend | awk '{print $2}')

if [[ "$backend_health" == *"Up"* ]]; then
    echo "✅ 后端服务运行正常"
else
    echo "❌ 后端服务启动异常"
fi

if [[ "$frontend_health" == *"Up"* ]]; then
    echo "✅ 前端服务运行正常"
else
    echo "❌ 前端服务启动异常"
fi

echo ""
echo "🎉 生产环境已启动！"
echo "🌐 前端: http://localhost:3000"
echo "🔗 后端 API: http://localhost:8000"
echo ""
echo "📋 生产模式特性："
echo "   ✅ 优化性能"
echo "   ✅ 稳定运行"
echo "   ✅ 自动重启"
echo "   ✅ 健康检查"
echo ""
echo "📋 常用命令："
echo "   查看日志: docker compose -f docker-compose.prod.yml logs -f"
echo "   停止服务: docker compose -f docker-compose.prod.yml down"
echo "   重启服务: docker compose -f docker-compose.prod.yml restart"
echo "   查看状态: docker compose -f docker-compose.prod.yml ps"
echo ""
echo "🔧 管理命令："
echo "   更新服务: docker compose -f docker-compose.prod.yml up -d --build"
echo "   清理资源: docker system prune -f"
echo "   查看资源: docker system df"
