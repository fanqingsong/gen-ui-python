import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from langserve import add_routes

from gen_ui_backend.chain import create_graph
from gen_ui_backend.types import ChatInputType

# Load environment variables from .env file
load_dotenv()


def create_app() -> FastAPI:
    """创建FastAPI应用实例"""
    app = FastAPI(
        title="Gen UI Backend",
        version="1.0",
        description="A simple api server using Langchain's Runnable interfaces",
    )

    # Configure CORS
    origins = [
        "http://localhost",
        "http://localhost:3000",
    ]

    app.add_middleware(
        CORSMiddleware,
        allow_origins=origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    graph = create_graph()

    runnable = graph.with_types(input_type=ChatInputType, output_type=dict)

    add_routes(app, runnable, path="/chat", playground_type="chat")
    
    # 添加健康检查端点
    @app.get("/health")
    async def health_check():
        return {"status": "healthy", "service": "gen-ui-backend"}
    
    return app


def start() -> None:
    """启动服务器（用于生产环境）"""
    app = create_app()
    print("Starting server...")
    uvicorn.run(app, host="0.0.0.0", port=8000)


# 创建应用实例（用于开发环境）
app = create_app()
