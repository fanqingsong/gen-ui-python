#!/bin/bash

# 热加载功能测试脚本

echo "🔥 测试热加载功能..."

# 检查服务是否运行
echo "📊 检查服务状态..."
docker compose ps

echo ""
echo "🧪 开始热加载测试..."

# 测试后端热加载
echo "1. 测试后端热加载..."
echo "   修改 backend/gen_ui_backend/server.py 文件..."
echo "   添加注释: # Hot reload test - $(date)"

# 在server.py文件末尾添加测试注释
echo "" >> backend/gen_ui_backend/server.py
echo "# Hot reload test - $(date)" >> backend/gen_ui_backend/server.py

echo "   ✅ 后端文件已修改，请观察后端日志是否显示重载..."

# 等待一下让用户观察
sleep 3

# 测试前端热加载
echo ""
echo "2. 测试前端热加载..."
echo "   修改 frontend/app/page.tsx 文件..."

# 备份原文件
cp frontend/app/page.tsx frontend/app/page.tsx.backup

# 在page.tsx中添加测试内容
cat > frontend/app/page.tsx << 'EOF'
import { Agent } from "./agent";

export default function Home() {
  return (
    <div className="flex h-screen bg-gray-50">
      <div className="flex-1 flex flex-col">
        <header className="bg-white shadow-sm border-b">
          <div className="px-6 py-4">
            <h1 className="text-2xl font-bold text-gray-900">
              Gen UI - Hot Reload Test
            </h1>
            <p className="text-gray-600">
              This page was modified at: {new Date().toLocaleString()}
            </p>
          </div>
        </header>
        <main className="flex-1 overflow-hidden">
          <Agent />
        </main>
      </div>
    </div>
  );
}
EOF

echo "   ✅ 前端文件已修改，请观察前端页面是否自动刷新..."

echo ""
echo "📋 测试说明："
echo "   1. 后端热加载：观察 docker compose logs backend 是否显示重载信息"
echo "   2. 前端热加载：观察浏览器页面是否自动刷新显示新内容"
echo "   3. 文件同步：修改文件后应该立即在容器中生效"

echo ""
echo "🔍 查看日志命令："
echo "   docker compose logs -f backend"
echo "   docker compose logs -f frontend"

echo ""
echo "🔄 恢复原文件命令："
echo "   mv frontend/app/page.tsx.backup frontend/app/page.tsx"
echo "   sed -i '/# Hot reload test/d' backend/gen_ui_backend/server.py"

echo ""
echo "✅ 热加载测试完成！"
