# 使用华为云镜像加速
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/python:3.11-slim

# 设置工作目录
WORKDIR /app

# 配置 apt 使用国内镜像源
RUN echo "deb https://mirrors.ustc.edu.cn/debian/ bookworm main" > /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/debian/ bookworm-updates main" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/debian-security bookworm-security main" >> /etc/apt/sources.list

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 配置 pip 使用国内镜像源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn

# 安装 uv
RUN pip install uv -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制应用代码
COPY . .

# 安装 Python 依赖 (uv 会自动使用 pip 的镜像源配置)
# 使用 --no-cache 避免缓存问题，--system 安装到系统目录
RUN uv pip install --system --no-cache -e . --index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 暴露端口
EXPOSE 8000

# 启动命令
CMD ["uv", "run", "start"]
