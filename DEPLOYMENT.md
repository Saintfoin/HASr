# 部署说明 - HASr 变量查询器

## 🚀 GitHub Pages 部署

### 自动部署（推荐）

1. **启用 GitHub Pages**
   - 访问你的 GitHub 仓库：https://github.com/Saintfoin/HASr
   - 点击 `Settings` 标签页
   - 在左侧菜单中找到 `Pages`
   - 在 `Source` 部分选择 `Deploy from a branch`
   - 选择 `gh-pages` 分支和 `/ (root)` 文件夹
   - 点击 `Save`

2. **等待部署完成**
   - GitHub Actions 会自动运行部署流程
   - 部署完成后，你的变量查询器将在以下地址可用：
   - **🌐 https://saintfoin.github.io/HASr/variable-explorer.html**

### 手动部署

如果自动部署失败，可以手动部署：

1. **生成数据文件**
   ```bash
   cd docs
   node generate-data.js
   ```

2. **提交并推送**
   ```bash
   git add .
   git commit -m "Update data files"
   git push origin main
   ```

## 📱 本地开发

### 启动本地服务器
```bash
cd docs
node server.js
```

然后访问：http://localhost:8080/variable-explorer.html

### 更新数据
当 CSV 文件更新时，重新运行：
```bash
node generate-data.js
```

## 🎯 功能特性

- **🔍 智能搜索**：支持变量名和描述搜索
- **📊 类型筛选**：按数据类型（字符型、数值型、逻辑型等）筛选
- **🏷️ 分类筛选**：按变量类别（基础信息、健康数据、社会信息等）筛选
- **📈 排序功能**：按变量名、类型或缺失值数量排序
- **📱 响应式设计**：适配桌面和移动设备
- **🎨 Safari 风格**：现代化的 macOS Safari 浏览器界面设计

## 📁 文件结构

```
docs/
├── variable-explorer.html    # 主页面
├── generate-data.js          # 数据处理脚本
├── server.js                 # 本地开发服务器
├── variables-data.json       # 变量数据（自动生成）
└── data-summary.json         # 数据摘要（自动生成）

data/
├── df_browse.csv            # 数据概览文件
└── codebook.csv             # 变量编码手册
```

## 🔧 技术栈

- **前端**：HTML5, CSS3, JavaScript (ES6+)
- **样式**：Safari 风格设计，响应式布局
- **数据处理**：Node.js, CSV 解析
- **部署**：GitHub Pages, GitHub Actions

## 📞 支持

如有问题，请查看：
- [GitHub Issues](https://github.com/Saintfoin/HASr/issues)
- [项目主页](https://saintfoin.github.io/HASr/)