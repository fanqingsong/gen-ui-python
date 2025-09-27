#!/bin/bash

# Gen UI Python - 开发环境启动脚本
# 支持热加载功能

echo "🔥 启动开发环境 (支持热加载)..."

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

echo "🔧 启动开发模式..."
echo "📁 代码变更将自动同步到容器中"
echo "🔄 后端: uvicorn --reload (Python文件变更自动重载)"
echo "🔄 前端: Next.js dev server (前端文件变更自动重载)"
echo "📦 依赖文件变更将自动重建镜像"
echo ""

# 使用开发环境配置启动
docker compose up --build

echo ""
echo "🎉 开发环境已启动！"
echo "🌐 前端: http://localhost:3000"
echo "🔗 后端 API: http://localhost:8000"
echo ""
echo "📋 开发模式特性："
echo "   ✅ 代码热重载"
echo "   ✅ 文件自动同步"
echo "   ✅ 依赖自动重建"
echo "   ✅ 实时日志输出"
echo ""
echo "📋 常用命令："
echo "   查看日志: docker compose logs -f"
echo "   停止服务: docker compose down"
echo "   重启服务: docker compose restart"
echo "   进入容器: docker compose exec backend bash"
