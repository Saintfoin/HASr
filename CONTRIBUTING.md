# Contributing to HASr / 为HASr贡献

## Welcome / 欢迎

### English

We welcome contributions to the HASr package! This document outlines how to propose changes, report bugs, and contribute code to the project.

### 中文

我们欢迎对HASr包的贡献！本文档概述了如何提出更改建议、报告错误以及为项目贡献代码。

## Types of Contributions / 贡献类型

### Bug Reports / 错误报告

If you find a bug, please create an issue on GitHub with:
如果您发现错误，请在GitHub上创建问题，包含：

- A clear description of the problem / 问题的清晰描述
- Steps to reproduce the issue / 重现问题的步骤
- Expected vs. actual behavior / 预期与实际行为
- Your R version and system information / 您的R版本和系统信息
- A minimal reproducible example / 最小可重现示例

### Feature Requests / 功能请求

For new features, please:
对于新功能，请：

- Check if the feature already exists / 检查功能是否已存在
- Describe the use case and benefits / 描述用例和好处
- Provide examples of how it would work / 提供工作示例

### Code Contributions / 代码贡献

We welcome code contributions including:
我们欢迎代码贡献，包括：

- Bug fixes / 错误修复
- New functions / 新功能
- Documentation improvements / 文档改进
- Test additions / 测试添加
- Performance improvements / 性能改进

## Development Workflow / 开发工作流程

### 1. Fork and Clone / 分叉和克隆

```bash
# Fork the repository on GitHub
# 在GitHub上分叉仓库

# Clone your fork
# 克隆您的分叉
git clone https://github.com/YOUR-USERNAME/HASr.git
cd HASr

# Add upstream remote
# 添加上游远程
git remote add upstream https://github.com/USTC-HAS/HASr.git
```

### 2. Create a Branch / 创建分支

```bash
# Create and switch to a new branch
# 创建并切换到新分支
git checkout -b feature/your-feature-name

# Or for bug fixes
# 或者对于错误修复
git checkout -b fix/issue-description
```

### 3. Development Setup / 开发设置

```r
# Install development dependencies
# 安装开发依赖
install.packages(c("devtools", "roxygen2", "testthat", "pkgdown"))

# Load the package for development
# 加载包进行开发
devtools::load_all()

# Check package
# 检查包
devtools::check()
```

### 4. Make Changes / 进行更改

#### Code Style / 代码风格

- Use meaningful variable and function names / 使用有意义的变量和函数名
- Follow R coding conventions / 遵循R编码约定
- Use `<-` for assignment, not `=` / 使用`<-`进行赋值，而不是`=`
- Limit lines to 80 characters when possible / 尽可能将行限制为80个字符
- Use spaces around operators / 在操作符周围使用空格

#### Documentation / 文档

- All exported functions must have roxygen2 documentation / 所有导出的函数必须有roxygen2文档
- Include `@title`, `@description`, `@param`, `@return`, and `@examples` / 包含`@title`、`@description`、`@param`、`@return`和`@examples`
- Provide bilingual descriptions (English + Chinese) / 提供双语描述（英文+中文）
- Update NEWS.md for significant changes / 为重大更改更新NEWS.md

#### Testing / 测试

- Write tests for new functions / 为新函数编写测试
- Ensure all tests pass / 确保所有测试通过
- Aim for good test coverage / 争取良好的测试覆盖率

```r
# Run tests
# 运行测试
devtools::test()

# Check test coverage
# 检查测试覆盖率
covr::package_coverage()
```

### 5. Commit Changes / 提交更改

```bash
# Stage your changes
# 暂存您的更改
git add .

# Commit with a descriptive message
# 使用描述性消息提交
git commit -m "Add function for parsing cardiovascular data

- Implement parse_card() function
- Add comprehensive documentation
- Include unit tests
- Update NAMESPACE"
```

#### Commit Message Guidelines / 提交消息指南

- Use present tense ("Add feature" not "Added feature") / 使用现在时
- Keep the first line under 50 characters / 保持第一行少于50个字符
- Reference issues and pull requests when applicable / 在适用时引用问题和拉取请求
- Use conventional commit format when possible / 尽可能使用常规提交格式

### 6. Push and Create Pull Request / 推送并创建拉取请求

```bash
# Push to your fork
# 推送到您的分叉
git push origin feature/your-feature-name

# Create a pull request on GitHub
# 在GitHub上创建拉取请求
```

## Pull Request Guidelines / 拉取请求指南

### Before Submitting / 提交前

- [ ] Code follows the style guidelines / 代码遵循风格指南
- [ ] All tests pass / 所有测试通过
- [ ] Documentation is updated / 文档已更新
- [ ] NEWS.md is updated (for significant changes) / NEWS.md已更新（对于重大更改）
- [ ] No merge conflicts / 无合并冲突

### Pull Request Description / 拉取请求描述

Include:
包含：

- Clear description of changes / 更改的清晰描述
- Motivation for the changes / 更改的动机
- Any breaking changes / 任何破坏性更改
- Related issues / 相关问题

## Code Review Process / 代码审查过程

### English

1. All pull requests require review by at least one maintainer
2. Reviews focus on code quality, documentation, and testing
3. Feedback should be addressed before merging
4. Maintainers may request changes or provide suggestions
5. Once approved, maintainers will merge the pull request

### 中文

1. 所有拉取请求都需要至少一名维护者的审查
2. 审查重点关注代码质量、文档和测试
3. 合并前应解决反馈意见
4. 维护者可能会要求更改或提供建议
5. 一旦批准，维护者将合并拉取请求

## Development Environment / 开发环境

### Required Software / 必需软件

- R (>= 4.0.0)
- RStudio (recommended) / RStudio（推荐）
- Git
- Pandoc (for documentation) / Pandoc（用于文档）

### Recommended Packages / 推荐包

```r
install.packages(c(
  "devtools",    # Development tools
  "roxygen2",    # Documentation
  "testthat",    # Testing
  "pkgdown",     # Website generation
  "covr",        # Test coverage
  "lintr",       # Code linting
  "styler"       # Code formatting
))
```

## Getting Help / 获取帮助

### English

If you need help with contributing:

- Check existing issues and discussions
- Read the package documentation
- Contact the maintainers: has@ustc.edu.cn
- Join our development discussions on GitHub

### 中文

如果您需要贡献方面的帮助：

- 查看现有问题和讨论
- 阅读包文档
- 联系维护者：has@ustc.edu.cn
- 在GitHub上加入我们的开发讨论

## Recognition / 认可

All contributors will be acknowledged in:
所有贡献者将在以下位置得到认可：

- Package DESCRIPTION file / 包DESCRIPTION文件
- Package documentation / 包文档
- Release notes / 发布说明
- Project website / 项目网站

## Code of Conduct / 行为准则

### English

By participating in this project, you agree to abide by our code of conduct:

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different viewpoints and experiences
- Show empathy towards other community members

### 中文

通过参与此项目，您同意遵守我们的行为准则：

- 保持尊重和包容
- 欢迎新人并帮助他们学习
- 专注于建设性反馈
- 尊重不同的观点和经验
- 对其他社区成员表现出同理心

## License / 许可证

By contributing to HASr, you agree that your contributions will be licensed under the MIT License.

通过为HASr做出贡献，您同意您的贡献将在MIT许可证下获得许可。

---

**Thank you for contributing to HASr! / 感谢您为HASr做出贡献！**

*For questions about contributing, please contact: has@ustc.edu.cn*  
*有关贡献的问题，请联系：has@ustc.edu.cn*