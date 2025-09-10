#!/bin/bash

# ProjectEye Build Script
# 项目编译脚本 - 支持跨平台构建

set -e

echo "=== ProjectEye 编译脚本 ==="
echo "正在检测编译环境..."

# 检测操作系统
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    PLATFORM="windows"
    echo "检测到Windows环境"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
    echo "检测到Linux环境"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
    echo "检测到macOS环境"
else
    PLATFORM="unknown"
    echo "未知操作系统: $OSTYPE"
fi

# 切换到项目目录
PROJECT_DIR="src/Local/ProjectEye"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "错误：未找到项目目录 $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"

echo "当前工作目录: $(pwd)"

# 检测可用的构建工具
BUILD_TOOL=""
if command -v msbuild &> /dev/null; then
    BUILD_TOOL="msbuild"
    echo "检测到MSBuild"
elif command -v dotnet &> /dev/null; then
    BUILD_TOOL="dotnet"
    echo "检测到.NET SDK"
elif command -v mono &> /dev/null && command -v xbuild &> /dev/null; then
    BUILD_TOOL="mono"
    echo "检测到Mono"
else
    echo "错误：未找到可用的构建工具"
    echo "请安装以下工具之一："
    echo "  - Visual Studio (Windows)"
    echo "  - .NET SDK"
    echo "  - Mono (Linux/macOS)"
    exit 1
fi

# 恢复NuGet包
echo "正在恢复NuGet包..."
if command -v nuget &> /dev/null; then
    nuget restore ProjectEye.Local.sln
elif [ "$BUILD_TOOL" = "dotnet" ]; then
    dotnet restore ProjectEye.Local.sln
else
    echo "警告：无法恢复NuGet包，可能会导致编译失败"
fi

# 开始编译
echo "开始编译项目..."
case $BUILD_TOOL in
    "msbuild")
        msbuild ProjectEye.Local.sln /p:Configuration=Release /p:Platform="Any CPU"
        ;;
    "dotnet")
        dotnet build ProjectEye.Local.sln -c Release
        ;;
    "mono")
        xbuild ProjectEye.Local.sln /p:Configuration=Release
        ;;
esac

if [ $? -eq 0 ]; then
    echo "=== 编译成功 ==="
    echo "输出目录: bin/Release/"
    ls -la bin/Release/ 2>/dev/null || echo "注意：无法列出输出文件"
    
    # 创建发布包
    if [ -d "bin/Release" ]; then
        echo "正在创建发布包..."
        mkdir -p ../../../release
        cp -r bin/Release/* ../../../release/ 2>/dev/null || true
        echo "发布包已创建在: release/"
    fi
else
    echo "=== 编译失败 ==="
    exit 1
fi