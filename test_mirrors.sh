#!/bin/bash

# 镜像源测试脚本

echo "🧪 测试国内镜像源配置..."

# 检查 Docker 服务状态
echo "1. 检查 Docker 服务状态..."
if docker info > /dev/null 2>&1; then
    echo "   ✅ Docker 服务运行正常"
else
    echo "   ❌ Docker 服务未运行"
    exit 1
fi

# 检查 Docker 镜像源配置
echo ""
echo "2. 检查 Docker 镜像源配置..."
echo "   当前配置的镜像源："
docker info | grep -A 10 "Registry Mirrors" | grep -E "https?://" || echo "   未找到镜像源配置"

# 测试 Docker 镜像拉取速度
echo ""
echo "3. 测试 Docker 镜像拉取速度..."
echo "   拉取测试镜像 alpine:latest..."

start_time=$(date +%s)
if docker pull alpine:latest > /dev/null 2>&1; then
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "   ✅ 镜像拉取成功，耗时: ${duration}秒"
else
    echo "   ❌ 镜像拉取失败"
fi

# 检查项目构建
echo ""
echo "4. 检查项目构建配置..."
if [ -f "docker-compose.yml" ]; then
    echo "   ✅ docker-compose.yml 存在"
    
    # 检查是否使用国内镜像
    if grep -q "swr.cn-north-4.myhuaweicloud.com" docker-compose.yml; then
        echo "   ✅ 已配置华为云镜像"
    else
        echo "   ⚠️  未检测到华为云镜像配置"
    fi
else
    echo "   ❌ docker-compose.yml 不存在"
fi

# 检查后端配置
echo ""
echo "5. 检查后端镜像配置..."
if [ -f "backend/Dockerfile" ]; then
    if grep -q "pypi.tuna.tsinghua.edu.cn" backend/Dockerfile; then
        echo "   ✅ 后端已配置清华镜像源"
    else
        echo "   ⚠️  后端未配置清华镜像源"
    fi
else
    echo "   ❌ 后端 Dockerfile 不存在"
fi

# 检查前端配置
echo ""
echo "6. 检查前端镜像配置..."
if [ -f "frontend/Dockerfile" ]; then
    if grep -q "registry.npmmirror.com" frontend/Dockerfile; then
        echo "   ✅ 前端已配置淘宝镜像源"
    else
        echo "   ⚠️  前端未配置淘宝镜像源"
    fi
else
    echo "   ❌ 前端 Dockerfile 不存在"
fi

# 测试网络连接
echo ""
echo "7. 测试网络连接..."
echo "   测试 Python 镜像源连接..."
if ping -c 1 pypi.tuna.tsinghua.edu.cn > /dev/null 2>&1; then
    echo "   ✅ Python 镜像源连接正常"
else
    echo "   ❌ Python 镜像源连接失败"
fi

echo "   测试 Node.js 镜像源连接..."
if ping -c 1 registry.npmmirror.com > /dev/null 2>&1; then
    echo "   ✅ Node.js 镜像源连接正常"
else
    echo "   ❌ Node.js 镜像源连接失败"
fi

# 显示优化建议
echo ""
echo "📋 优化建议："
echo "   1. 运行 ./optimize_mirrors.sh 自动优化 Docker 配置"
echo "   2. 使用 ./start_dev.sh 启动开发环境测试构建速度"
echo "   3. 定期检查镜像源状态，必要时更新配置"

echo ""
echo "🎉 镜像源测试完成！"
