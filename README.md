# Generative UI with LangChain Python 🦜🔗

![Generative UI with LangChain Python](./frontend/public/gen_ui_diagram.png)

## Overview

This application aims to provide a template for building generative UI applications with LangChain Python.
It comes pre-built with a few UI features which you can use to play about with gen ui. The UI components are built using [Shadcn](https://ui.shadcn.com/).

## Getting Started

### 使用 Docker Compose (推荐)

这是最简单的一键启动方式：

1. 克隆仓库：
```bash
git clone https://github.com/bracesproul/gen-ui-python.git
cd gen-ui-python
```

2. 配置环境变量：
```bash
# 复制环境变量模板
cp env.template .env

# 编辑 .env 文件，填入你的 API 密钥
nano .env
```

3. 一键启动：
```bash
# 方式一：使用启动脚本（推荐）
./start.sh

# 方式二：直接使用 docker compose
docker compose up -d
```

4. 访问应用：
- 前端：http://localhost:3000
- 后端 API：http://localhost:8000

5. 停止应用：
```bash
docker compose down
```

### 手动安装 (开发环境)

如果你需要在本地开发环境中运行：

First, clone the repository and install dependencies:

```bash
git clone https://github.com/bracesproul/gen-ui-python.git

cd gen-ui-python
```

Install dependencies in the `frontend` and `backend` directories:

```bash
cd ./frontend

yarn install
```

```bash
cd ../backend

poetry install
```

### Secrets

Next, if you plan on using the existing pre-built UI components, you'll need to set a few environment variables:

#### Docker 环境
如果你使用 Docker Compose，请编辑项目根目录的 `.env` 文件：

```bash
# 复制环境变量模板
cp env.template .env

# 编辑 .env 文件
nano .env
```

#### 本地开发环境
如果你使用本地开发环境，请复制环境变量文件到后端目录：

```bash
cp env.template backend/.env
```

#### 必需的 API 密钥

LangSmith keys are optional, but highly recommended if you plan on developing this application further.

The `OPENAI_API_KEY` is required. Get your OpenAI API key from the [OpenAI dashboard](https://platform.openai.com/login?launch).

[Sign up/in to LangSmith](https://smith.langchain.com/) and get your API key.

Create a new [GitHub PAT (Personal Access Token)](https://github.com/settings/tokens/new) with the `repo` scope.

[Create a free Geocode account](https://geocode.xyz/api).

```bash
# ------------------LangSmith tracing------------------
LANGCHAIN_API_KEY=...
LANGCHAIN_CALLBACKS_BACKGROUND=true
LANGCHAIN_TRACING_V2=true
# -----------------------------------------------------

GITHUB_TOKEN=...
OPENAI_API_KEY=...
GEOCODE_API_KEY=...
```

### Running the Application

#### 使用 Docker Compose (推荐)
```bash
# 一键启动所有服务
docker compose up -d

# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f

# 停止服务
docker compose down
```

访问应用：
- 前端：http://localhost:3000
- 后端 API：http://localhost:8000

#### 本地开发环境
```bash
# 启动前端
cd ./frontend
yarn dev
```

This will start a development server on [`http://localhost:3000`](http://localhost:3000).

Then, in a new terminal window:

```bash
# 启动后端
cd ../backend
poetry run start
```

### Docker 故障排除

如果遇到 Docker 相关问题，可以尝试以下解决方案：

```bash
# 清理并重新构建
docker compose down
docker compose build --no-cache
docker compose up -d

# 查看详细日志
docker compose logs backend
docker compose logs frontend

# 进入容器调试
docker compose exec backend bash
docker compose exec frontend sh

# 检查容器状态
docker compose ps
```

### Go further

If you're interested in ways to take this demo application further, I'd consider the following:

- Generating entire React components to be rendered, instead of relying on pre-built components.
- Using the LLM to build custom components using a UI library like [Shadcn](https://ui.shadcn.com/).
- Multi-tool and component usage.
- Update the LangGraph agent to call multiple tools, and appending multiple different UI components to the client rendered UI.
- Generative UI outside of the chatbot window: Have the UI dynamically render in different areas on the screen. E.g a dashboard, where the components are dynamically rendered based on the LLMs output.
