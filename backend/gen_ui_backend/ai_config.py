"""AI服务配置模块，支持OpenAI和Azure OpenAI"""

import os
from typing import Optional
from langchain_openai import ChatOpenAI


def get_ai_service_provider() -> str:
    """获取AI服务提供商配置"""
    return os.getenv("AI_SERVICE_PROVIDER", "azure").lower()


def create_chat_openai(
    model: str = "gpt-4o",
    temperature: float = 0,
    streaming: bool = True,
    **kwargs
) -> ChatOpenAI:
    """
    根据环境变量创建ChatOpenAI实例，支持OpenAI和Azure OpenAI
    
    Args:
        model: 模型名称
        temperature: 温度参数
        streaming: 是否启用流式输出
        **kwargs: 其他参数
    
    Returns:
        ChatOpenAI实例
    """
    provider = get_ai_service_provider()
    
    if provider == "azure":
        return _create_azure_openai(model, temperature, streaming, **kwargs)
    elif provider == "openai":
        return _create_openai(model, temperature, streaming, **kwargs)
    else:
        raise ValueError(f"不支持的AI服务提供商: {provider}")


def _create_azure_openai(
    model: str,
    temperature: float,
    streaming: bool,
    **kwargs
) -> ChatOpenAI:
    """创建Azure OpenAI实例"""
    azure_api_key = os.getenv("AZURE_OPENAI_API_KEY")
    azure_endpoint = os.getenv("AZURE_OPENAI_ENDPOINT")
    azure_api_version = os.getenv("AZURE_OPENAI_API_VERSION", "2024-02-15-preview")
    azure_deployment_name = os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME")
    
    if not all([azure_api_key, azure_endpoint, azure_deployment_name]):
        raise ValueError(
            "Azure OpenAI配置不完整。需要设置: "
            "AZURE_OPENAI_API_KEY, AZURE_OPENAI_ENDPOINT, AZURE_OPENAI_DEPLOYMENT_NAME"
        )
    
    return ChatOpenAI(
        model=azure_deployment_name,  # Azure使用部署名称而不是模型名称
        temperature=temperature,
        streaming=streaming,
        api_key=azure_api_key,
        base_url=f"{azure_endpoint}openai/deployments/{azure_deployment_name}/",
        default_query={"api-version": azure_api_version},
        **kwargs
    )


def _create_openai(
    model: str,
    temperature: float,
    streaming: bool,
    **kwargs
) -> ChatOpenAI:
    """创建OpenAI实例"""
    openai_api_key = os.getenv("OPENAI_API_KEY")
    
    if not openai_api_key:
        raise ValueError("OpenAI API Key未设置。请设置OPENAI_API_KEY环境变量。")
    
    return ChatOpenAI(
        model=model,
        temperature=temperature,
        streaming=streaming,
        openai_api_key=openai_api_key,
        **kwargs
    )
