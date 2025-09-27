# NVIDIA依赖问题解决方案

## 问题描述

在构建Docker镜像时，发现安装过程非常缓慢，主要原因是下载了大量的NVIDIA相关包：
- nvidia-cuda-cu12
- nvidia-cublas-cu12
- nvidia-cusolver-cu12
- nvidia-cusparselt-cu12
- nvidia-cusparse-cu12
- nvidia-nccl-cu12

## 问题原因

经过分析发现，这些NVIDIA包是由 `unstructured[all-docs]` 包引入的：

1. `unstructured[all-docs]` 包含了大量的文档处理依赖
2. 其中包括 `unstructured-inference` 包
3. `unstructured-inference` 依赖 PyTorch
4. PyTorch 默认安装CUDA版本，引入了NVIDIA相关包

## 解决方案

### 1. 移除不必要的依赖

从 `backend/pyproject.toml` 中移除了 `unstructured` 包：
```toml
# 移除了这行
# unstructured = {extras = ["all-docs"], version = "^0.13.4"}
```

**原因**：项目中并没有实际使用 `unstructured` 包，这是一个不必要的依赖。

### 2. 清理锁文件

运行清理脚本删除锁文件，强制重新生成依赖：
```bash
./clean_deps.sh
```

### 3. 优化Dockerfile

在Dockerfile中添加了 `--no-cache` 参数，避免缓存问题：
```dockerfile
RUN uv pip install --system --no-cache -e . --index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

## 验证修复

重新构建项目：
```bash
./start.sh
```

现在构建过程应该会快很多，不再下载NVIDIA相关的包。

## 如果将来需要文档处理功能

如果将来确实需要文档处理功能，可以考虑：

1. **使用更轻量的依赖**：
   ```toml
   unstructured = {extras = ["pdf"], version = "^0.13.4"}
   ```

2. **使用CPU版本的PyTorch**：
   ```bash
   pip install torch --index-url https://download.pytorch.org/whl/cpu
   ```

3. **按需安装**：只在需要时安装特定的文档处理包

## 总结

通过移除不必要的 `unstructured[all-docs]` 依赖，我们：
- 大幅减少了构建时间
- 避免了下载大型NVIDIA包
- 保持了项目的核心功能不变
- 减少了Docker镜像大小
