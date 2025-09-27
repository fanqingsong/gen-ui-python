#!/bin/bash

# Gen UI Python - 通用启动脚本
# 推荐使用专门的启动脚本：start_dev.sh 或 start_prod.sh

echo "🚀 Gen UI Python 启动脚本"
echo ""

# 检查是否存在 .env 文件
if [ ! -f ".env" ]; then
    echo "⚠️  未找到 .env 文件，正在创建..."
    if [ -f "env.template" ]; then
        cp env.template .env
        echo "✅ 已从 env.template 创建 .env 文件"
        echo "📝 请编辑 .env 文件，填入你的 API 密钥"
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

# 显示使用说明
echo "📋 请选择启动模式："
echo ""
echo "1. 开发模式 (推荐用于开发)"
echo "   - 支持热加载"
echo "   - 代码变更自动重载"
echo "   - 实时日志输出"
echo ""
echo "2. 生产模式 (推荐用于部署)"
echo "   - 优化性能"
echo "   - 稳定运行"
echo "   - 后台运行"
echo ""
echo "💡 提示："
echo "   开发模式: ./start_dev.sh"
echo "   生产模式: ./start_prod.sh"
echo ""

# 获取用户选择
read -p "请选择模式 (1=开发, 2=生产, q=退出): " choice

case $choice in
    1)
        echo "🔧 启动开发模式..."
        ./start_dev.sh
        ;;
    2)
        echo "🔧 启动生产模式..."
        ./start_prod.sh
        ;;
    q|Q)
        echo "👋 退出"
        exit 0
        ;;
    *)
        echo "❌ 无效选择，请重新运行脚本"
        exit 1
        ;;
esac
