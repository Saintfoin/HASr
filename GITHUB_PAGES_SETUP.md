# GitHub Pages 设置指南

## 问题描述
如果您看到 "There isn't a GitHub Pages site here" 的错误信息，这意味着 GitHub Pages 还没有为您的仓库启用。

## 解决步骤

### 1. 访问仓库设置
1. 打开您的 GitHub 仓库：https://github.com/Saintfoin/HASr
2. 点击仓库页面顶部的 **Settings** 标签
3. 在左侧菜单中找到并点击 **Pages**

### 2. 配置 Pages 设置
在 Pages 设置页面中：

#### 方法一：使用 GitHub Actions（推荐）
1. 在 "Source" 部分，选择 **GitHub Actions**
2. 系统会自动检测到我们的 `.github/workflows/deploy.yml` 工作流
3. 点击 **Save** 保存设置

#### 方法二：使用分支部署
1. 在 "Source" 部分，选择 **Deploy from a branch**
2. 在 "Branch" 下拉菜单中选择 **main**
3. 在文件夹选择中选择 **/ (root)** 或 **/docs**
4. 点击 **Save** 保存设置

### 3. 等待部署
- 设置完成后，GitHub 会开始构建和部署您的网站
- 这个过程通常需要几分钟时间
- 您可以在 **Actions** 标签页中查看部署进度

### 4. 访问网站
部署完成后，您的变量查询器将可以通过以下地址访问：
- **主页面**：https://saintfoin.github.io/HASr/
- **变量查询器**：https://saintfoin.github.io/HASr/docs/variable-explorer.html

## 常见问题

### Q: 为什么我看不到 Pages 选项？
A: 确保您的仓库是公开的（public），或者您有 GitHub Pro/Team/Enterprise 账户。

### Q: 部署失败怎么办？
A: 检查 Actions 标签页中的错误日志，确保所有文件都已正确提交。

### Q: 网站显示 404 错误？
A: 检查文件路径是否正确，确保 `docs/variable-explorer.html` 文件存在。

### Q: 更改没有生效？
A: GitHub Pages 可能有缓存延迟，等待几分钟或清除浏览器缓存。

## 技术说明

我们的项目包含：
- `.nojekyll` 文件：绕过 Jekyll 处理
- GitHub Actions 工作流：自动部署静态文件
- 响应式设计：支持移动设备访问

## 联系支持

如果您仍然遇到问题，可以：
1. 检查 GitHub Status 页面：https://www.githubstatus.com/
2. 查看 GitHub Pages 文档：https://docs.github.com/en/pages
3. 在仓库中创建 Issue 寻求帮助