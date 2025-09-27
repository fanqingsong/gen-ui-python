#!/bin/bash
# 清理依赖文件，移除不必要的包

echo "🧹 清理依赖文件..."

# 删除poetry.lock文件，强制重新生成
if [ -f "backend/poetry.lock" ]; then
    echo "删除 poetry.lock 文件..."
    rm backend/poetry.lock
fi

# 删除uv.lock文件
if [ -f "backend/uv.lock" ]; then
    echo "删除 uv.lock 文件..."
    rm backend/uv.lock
fi

echo "✅ 依赖文件清理完成！"
echo "现在可以重新运行 ./start.sh 来构建项目"
