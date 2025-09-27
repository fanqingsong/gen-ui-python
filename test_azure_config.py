#!/usr/bin/env python3
"""
测试Azure OpenAI配置的脚本
运行此脚本来验证您的Azure OpenAI配置是否正确
"""

import os
import sys
from dotenv import load_dotenv

# 添加backend目录到Python路径
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'backend'))

# 加载环境变量
load_dotenv()

def test_azure_config():
    """测试Azure OpenAI配置"""
    try:
        from gen_ui_backend.ai_config import create_chat_openai, get_ai_service_provider
        
        print("=== Azure OpenAI 配置测试 ===")
        print(f"AI服务提供商: {get_ai_service_provider()}")
        
        # 检查环境变量
        required_vars = [
            "AZURE_OPENAI_API_KEY",
            "AZURE_OPENAI_ENDPOINT", 
            "AZURE_OPENAI_DEPLOYMENT_NAME"
        ]
        
        missing_vars = []
        for var in required_vars:
            if not os.getenv(var):
                missing_vars.append(var)
        
        if missing_vars:
            print(f"❌ 缺少必需的环境变量: {', '.join(missing_vars)}")
            return False
        
        print("✅ 所有必需的环境变量都已设置")
        
        # 尝试创建ChatOpenAI实例
        try:
            model = create_chat_openai(model="gpt-4o", temperature=0, streaming=False)
            print("✅ ChatOpenAI实例创建成功")
            
            # 尝试一个简单的API调用
            print("🔄 测试API调用...")
            response = model.invoke("Hello, this is a test message.")
            print(f"✅ API调用成功: {response.content[:100]}...")
            
            return True
            
        except Exception as e:
            print(f"❌ API调用失败: {str(e)}")
            return False
            
    except ImportError as e:
        print(f"❌ 导入错误: {str(e)}")
        print("请确保在backend目录中安装了依赖")
        return False
    except Exception as e:
        print(f"❌ 配置错误: {str(e)}")
        return False

if __name__ == "__main__":
    success = test_azure_config()
    if success:
        print("\n🎉 Azure OpenAI配置测试通过！")
        sys.exit(0)
    else:
        print("\n💥 Azure OpenAI配置测试失败！")
        sys.exit(1)
