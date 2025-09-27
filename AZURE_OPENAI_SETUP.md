# Azure OpenAI 配置指南

本项目现在支持使用Azure OpenAI服务。以下是配置步骤：

## 1. 获取Azure OpenAI配置信息

在Azure门户中创建OpenAI资源后，您需要获取以下信息：

- **API Key**: 在Azure门户的"密钥和终结点"部分找到
- **Endpoint**: 您的Azure OpenAI资源的终结点URL
- **Deployment Name**: 您部署的模型名称（例如：gpt-4, gpt-35-turbo等）
- **API Version**: 建议使用 `2024-02-15-preview`

## 2. 配置环境变量

复制 `env.template` 文件为 `.env` 并填入您的配置：

```bash
cp env.template .env
```

然后编辑 `.env` 文件，填入您的Azure OpenAI配置：

```env
# Azure OpenAI 配置
AZURE_OPENAI_API_KEY=your_azure_openai_api_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com/
AZURE_OPENAI_API_VERSION=2024-02-15-preview
AZURE_OPENAI_DEPLOYMENT_NAME=your_deployment_name

# 选择使用Azure OpenAI
AI_SERVICE_PROVIDER=azure
```

## 3. 启动服务

使用Docker Compose启动服务：

```bash
docker compose up --build
```

## 4. 验证配置

服务启动后，您可以通过以下方式验证配置：

1. 访问前端界面：http://localhost:3000
2. 访问后端API：http://localhost:8000
3. 检查Docker日志确认没有配置错误

## 故障排除

### 常见错误

1. **"Azure OpenAI配置不完整"**
   - 确保所有必需的环境变量都已设置
   - 检查环境变量名称是否正确

2. **"API Key无效"**
   - 验证Azure OpenAI API Key是否正确
   - 确保API Key有足够的权限

3. **"部署名称不存在"**
   - 确保在Azure门户中已创建模型部署
   - 检查部署名称是否与配置中的一致

### 调试模式

如果需要调试，可以查看Docker日志：

```bash
docker compose logs backend
```

## 切换回OpenAI

如果您想切换回使用OpenAI API，只需修改环境变量：

```env
AI_SERVICE_PROVIDER=openai
OPENAI_API_KEY=your_openai_api_key_here
```

## 注意事项

- Azure OpenAI的模型名称使用部署名称而不是原始模型名称
- 确保您的Azure订阅有足够的配额
- API版本建议使用最新的稳定版本
