# 使用华为云镜像加速
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/node:18-alpine AS base

# 安装依赖阶段
FROM base AS deps
WORKDIR /app

# 复制 package 文件
COPY package.json yarn.lock ./

# 配置 npm 和 yarn 使用国内镜像源
RUN npm config set registry https://registry.npmmirror.com && \
    yarn config set registry https://registry.npmmirror.com && \
    yarn config set network-timeout 300000

# 安装依赖
RUN yarn install --frozen-lockfile

# 构建阶段
FROM base AS builder
WORKDIR /app

# 复制依赖
COPY --from=deps /app/node_modules ./node_modules

# 复制源代码
COPY . .

# 构建应用
RUN yarn build

# 生产阶段
FROM base AS runner
WORKDIR /app

# 创建非 root 用户
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# 复制构建产物
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# 切换到非 root 用户
USER nextjs

# 暴露端口
EXPOSE 3000

# 设置环境变量
ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# 启动命令
CMD ["node", "server.js"]
