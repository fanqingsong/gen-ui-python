#!/bin/bash

# Docker 镜像优化脚本

echo "🚀 优化 Docker 镜像配置..."

# 创建 Docker daemon 配置文件
echo "📝 配置 Docker daemon 使用国内镜像..."

# 创建 Docker daemon 配置目录
sudo mkdir -p /etc/docker

# 备份现有配置
if [ -f /etc/docker/daemon.json ]; then
    echo "📋 备份现有 Docker daemon 配置..."
    sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.backup.$(date +%Y%m%d_%H%M%S)
fi

# 创建优化的 Docker daemon 配置
sudo tee /etc/docker/daemon.json > /dev/null << 'EOF'
{
  "registry-mirrors": [
    "https://swr.cn-north-4.myhuaweicloud.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ],
  "insecure-registries": [],
  "debug": false,
  "experimental": false,
  "features": {
    "buildkit": true
  },
  "builder": {
    "gc": {
      "enabled": true,
      "defaultKeepStorage": "20GB"
    }
  }
}
EOF

echo "✅ Docker daemon 配置已更新"

# 重启 Docker 服务
echo "🔄 重启 Docker 服务..."
sudo systemctl restart docker

# 等待 Docker 启动
echo "⏳ 等待 Docker 服务启动..."
sleep 5

# 验证 Docker 状态
if docker info > /dev/null 2>&1; then
    echo "✅ Docker 服务运行正常"
else
    echo "❌ Docker 服务启动失败，请检查配置"
    exit 1
fi

# 显示当前镜像源配置
echo "📊 当前 Docker 镜像源配置："
docker info | grep -A 10 "Registry Mirrors"

echo ""
echo "🎉 Docker 镜像优化完成！"
echo ""
echo "📋 优化内容："
echo "   ✅ 配置了多个国内镜像源"
echo "   ✅ 启用了 BuildKit 构建加速"
echo "   ✅ 配置了构建缓存清理"
echo "   ✅ 重启了 Docker 服务"
echo ""
echo "🔍 验证命令："
echo "   docker info | grep -A 10 'Registry Mirrors'"
echo "   docker system df"
echo ""
echo "💡 提示：如果遇到问题，可以恢复备份配置："
echo "   sudo cp /etc/docker/daemon.json.backup.* /etc/docker/daemon.json"
