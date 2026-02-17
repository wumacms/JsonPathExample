# 🚀 JsonPathExplorer

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20iOS-blue.svg?style=flat)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](LICENSE)

**JsonPathExplorer** 是一款基于 SwiftUI 构建的强大 JSONPath 实验与调试工具。它旨在为开发者提供一个直观、高效的界面，用于测试 JSONPath 查询、验证语法、分析性能以及自动生成路径模板。

---

## ✨ 核心特性

- **🔍 实时 Playground**: 输入 JSON 数据和 JSONPath 表达式，立即查看查询结果。支持代码高亮与格式化输出。
- **✅ 语法验证**: 实时检测 JSONPath 语法的正确性，并提供详细的错误提示。
- **⚡ 性能基准测试**: 提供多种复杂场景下的查询性能测试，直观展示解析延迟。
- **🛠️ 路径生成器**: 自动扫描并提取 JSON 中的所有潜在路径，帮助你快速定位深层嵌套的数据。
- **🎨 现代 UI 设计**: 采用 GitHub 风格的主题设计，支持原生暗黑模式，极致的视觉体验。
- **🧬 跨平台支持**: 适配 macOS 与 iOS，随时随地开启调试。

---

## 🛠️ 技术栈

- **语言**: Swift 5.9+
- **框架**: SwiftUI
- **核心库**: [Sextant](https://github.com/KittyMac/Sextant.git) — 灵活且高性能的 Swift JSONPath 库。
- **样式**: 自定义 GitHub 风格的主题系统。

---

## 📸 功能预览

> *提示：以下功能可通过侧边栏进行切换*

1.  **Playground**: 核心工作区，用于日常 JSONPath 调试。
2.  **Validation**: 专门用于测试复杂表达式的有效性。
3.  **Performance**: 运行内置的压力测试，评估在大规模数据下的表现。
4.  **Generator**: 一键生成所有可用路径，无需手动推导。

---

## 🚀 快速开始

### 运行环境
- macOS 14.0+ / iOS 17.0+
- Xcode 15.0+

### 安装步骤
1.  **克隆仓库**:
    ```bash
    git clone https://github.com/wumacms/JsonPathExample.git
    ```
2.  **打开项目**:
    在 Finder 中双击 `JsonPathExample.xcodeproj`。
3.  **自动配置依赖**:
    Xcode 会自动拉取 Swift Package Manager 依赖（特别是 `Sextant` 库）。
4.  **运行**:
    选择目标设备（Mac 或 iPhone 模拟器），点击 **Run (Cmd + R)**。

---

## 📜 许可证

本项目采用 [MIT 许可证](LICENSE)。

---

## 🤝 贡献与反馈

欢迎提交 Issue 或 Pull Request 来改进这个工具！如果你觉得好用，请给个 ⭐️ 鼓励一下。

---

<p align="center">Made with ❤️ using SwiftUI</p>
