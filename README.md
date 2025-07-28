<div align="center">

# 🧠 HASr: Hefei Aging Study Data Processing Tools
# 🧠 HASr：合肥老龄化研究数据处理工具包

<p align="center">
  <img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white" alt="R">
  <img src="https://img.shields.io/badge/Version-0.1.0-blue?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License">
</p>

<p align="center">
  <a href="https://github.com/Saintfoin/HASr/actions">
    <img src="https://github.com/Saintfoin/HASr/workflows/R-CMD-check/badge.svg" alt="R-CMD-check">
  </a>
  <a href="https://codecov.io/gh/Saintfoin/HASr">
    <img src="https://img.shields.io/codecov/c/github/Saintfoin/HASr?style=flat-square" alt="Codecov">
  </a>
  <a href="https://cran.r-project.org/package=HASr">
    <img src="https://www.r-pkg.org/badges/version/HASr" alt="CRAN status">
  </a>
  <a href="https://github.com/Saintfoin/HASr/issues">
    <img src="https://img.shields.io/github/issues/Saintfoin/HASr?style=flat-square" alt="GitHub issues">
  </a>
</p>

<p align="center">
  <strong>🏥 专业的老龄化研究数据处理工具包 | Professional Aging Research Data Processing Toolkit</strong>
</p>

<p align="center">
  <a href="#-installation--安装方法">安装</a> •
  <a href="#-usage--使用方法">使用</a> •
  <a href="#-documentation--文档">文档</a> •
  <a href="#-contributing--贡献">贡献</a> •
  <a href="https://saintfoin.github.io/HASr/">网站</a>
</p>

</div>

---

## ✨ Key Features / 核心功能

<div align="center">

| 🧬 **Data Processing** | 📊 **Analysis Tools** | 🔒 **Privacy Protection** | 🎨 **Visualization** | 🌐 **Variable Explorer** |
|:---:|:---:|:---:|:---:|:---:|
| 多维度数据解析 | 统计分析功能 | 差分隐私保护 | 专业图表生成 | Safari风格变量查询器 |
| Multi-dimensional parsing | Statistical analysis | Differential privacy | Professional plotting | Safari-style variable browser |

</div>

### 🔥 What's New in v0.1.0

- ✅ **8个专业数据解析函数** - 覆盖人口统计学、神经系统、心血管等多个领域
- ✅ **隐私保护机制** - 内置差分隐私算法保护敏感数据
- ✅ **完整测试覆盖** - 超过100个单元测试确保代码质量
- ✅ **双语文档** - 中英文完整文档支持
- ✅ **GitHub Pages** - 在线文档网站

---

## 🎯 Background & Purpose / 项目背景与目的

### 🌍 English

With rapid urbanization in China, rural elderly populations are transitioning into urban settings. Most domestic cohort studies still focus on rural populations, and there's a lack of systematic research into healthy aging in urban environments.

This project, based on the Hefei Aging Study (HAS), focuses on urban aging progression in a culturally distinct district (Luyang, Hefei), integrating clinical, cognitive, imaging, and biomarker data from adults 50 and older.

Our goal is to identify people in the "preclinical abnormal" state — with abnormal biomarkers but no clinical symptoms — and explore lifestyle and nutritional interventions that could slow or reverse cognitive decline in urban aging populations.

### 🇨🇳 中文

随着中国城市化进程的快速发展，农村老年人口正在向城市环境转移。目前国内队列研究仍主要关注农村人群，缺乏对城市环境中健康老龄化的系统性研究。

本项目基于合肥老龄化研究（HAS），聚焦于文化特色鲜明的城区（合肥庐阳区）的城市老龄化进程，整合了50岁及以上成年人的临床、认知、影像学和生物标志物数据。

我们的目标是识别处于"临床前异常"状态的人群——即生物标志物异常但无临床症状的个体，并探索可能延缓或逆转城市老龄化人群认知衰退的生活方式和营养干预措施。

## 📁 Project Structure / 项目结构

```
HASr/
├── .github/              # GitHub Actions workflows
├── docs/                 # GitHub Pages project site
│   └── index.md          # Bilingual homepage
├── data/                 # Sample/processed data for sharing
│   └── metadata.json     # Schema and descriptions
├── showcase/             # Shiny app or data viewer
├── R/                    # Cleaned and documented R functions
│   ├── parse_functions.R # Data parsing functions
│   └── utility_functions.R # Utility and plotting functions
├── man/                  # Auto-generated function documentation
├── DESCRIPTION           # R package metadata
├── NAMESPACE             # Generated from roxygen2
├── vignettes/            # Long-form R package usage guides
├── scripts/              # Research code outside of R package
├── tests/                # Unit tests
├── README.md             # This file
└── _config.yml           # GitHub Pages config
```

## 🌐 Variable Explorer / 变量查询器

**立即访问：[HASr 变量查询器](https://saintfoin.github.io/HASr/variable-explorer.html)**

- 🔍 搜索和浏览所有研究变量 / Search and browse all research variables
- 📊 查看数据分布和统计信息 / View data distribution and statistics
- 🏷️ 按类型和类别筛选变量 / Filter variables by type and category
- 📱 响应式设计，支持移动设备 / Responsive design for mobile devices

## 🚀 Installation / 安装方法

### 📦 From GitHub / 从GitHub安装

```r
# Install devtools if you haven't already
if (!require(devtools)) {
  install.packages("devtools")
}

# Install HASr from GitHub
devtools::install_github("USTC-HAS/HASr")
```

### 🔧 Dependencies / 依赖包

The package requires the following R packages:
本包需要以下R包：

```r
install.packages(c(
  "dplyr", "stringr", "lubridate", "ggplot2", 
  "scales", "readr", "tidyr"
))
```

## 💻 Usage / 使用方法

### 🔰 Basic Usage / 基本用法

```r
library(HASr)

# Parse demographic data / 解析人口统计学数据
demo_data <- parse_demo(
  df = your_dataframe,
  age = TRUE,
  sex = TRUE,
  education = TRUE,
  marriage = TRUE,
  bmi = TRUE
)

# Parse neurological data / 解析神经系统数据
neuro_data <- parse_neuro(
  df = your_dataframe,
  sensory = TRUE,
  fall_risk = TRUE,
  sleep = TRUE,
  adl = TRUE,
  cognition = TRUE
)

# Parse musculoskeletal data / 解析骨骼肌肉系统数据
msk_data <- parse_msk(
  df = your_dataframe,
  osteoporosis = TRUE,
  bone_metabolism = TRUE,
  frax = TRUE,
  sarcopenia = TRUE,
  arthritis = TRUE
)

# Parse cardiovascular data / 解析心血管系统数据
card_data <- parse_card(
  df = your_dataframe,
  lvef = TRUE,
  hypertension = TRUE,
  lipids = TRUE,
  carotid = TRUE
)

# Parse endocrine data / 解析内分泌系统数据
endo_data <- parse_endo(
  df = your_dataframe,
  diabetes = TRUE,
  glucose = TRUE,
  thyroid = TRUE,
  metabolic_syndrome = TRUE
)

# Parse immune/inflammatory data / 解析免疫炎症数据
immo_data <- parse_immo(
  df = your_dataframe,
  hscrp = TRUE,
  cytokines = TRUE,
  inflammatory_indices = TRUE
)

# Parse cerebrovascular disease data / 解析脑小血管病数据
scvd_data <- parse_scvd(
  df = your_dataframe,
  ptau217 = TRUE,
  apoe4 = TRUE,
  wmh = TRUE,
  lacunes = TRUE
)

# Apply differential privacy masking / 应用差分隐私掩码
masked_data <- mask_df(
  df = your_dataframe,
  columns = c("age", "bmi"),
  noise_level = 0.1
)

# Clean numeric data / 清洗数值型数据
clean_values <- clean_numeric(c("123.45kg", "67.8cm", "45mg/dl"))

# Parse birth dates / 解析出生日期
birth_dates <- parse_birth_date(c("1965年5月7日", "19650507", "1965.05.07"))
```

### 🚀 Advanced Usage / 高级用法

For detailed usage examples and tutorials, please refer to the package vignettes:
详细的使用示例和教程，请参考包的说明文档：

```r
# View available vignettes / 查看可用的说明文档
vignette(package = "HASr")

# Open specific vignette / 打开特定说明文档
vignette("data-processing", package = "HASr")
```

## 📚 Documentation / 文档

- **Variable Explorer**: [在线变量查询器](https://saintfoin.github.io/HASr/variable-explorer.html) - Safari-style variable browser
- **Function Reference**: Use `?function_name` or `help(function_name)` for detailed documentation
- **Vignettes**: Comprehensive guides available via `vignette(package = "HASr")`
- **Website**: Visit our [GitHub Pages site](https://ustc-has.github.io/HASr/) for online documentation
- **Deployment Guide**: [部署说明](DEPLOYMENT.md) - GitHub Pages deployment instructions

- **变量查询器**: [在线变量浏览工具](https://saintfoin.github.io/HASr/variable-explorer.html) - Safari风格的变量浏览器
- **函数参考**: 使用 `?function_name` 或 `help(function_name)` 查看详细文档
- **说明文档**: 通过 `vignette(package = "HASr")` 获取综合指南
- **网站**: 访问我们的 [GitHub Pages 网站](https://ustc-has.github.io/HASr/) 查看在线文档
- **部署指南**: [GitHub Pages 部署说明](DEPLOYMENT.md)

## 🤝 Contributing / 贡献

We welcome contributions to the HASr package! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

我们欢迎对HASr包的贡献！详情请参见我们的[贡献指南](CONTRIBUTING.md)。

## 👥 Contact & Contributors / 联系方式与贡献者

### 🔬 Research Team / 研究团队

- **Principal Investigator**: [Name] (University of Science and Technology of China)
- **Data Analysis Team**: HAS Research Group
- **Package Maintainer**: Zhang Xianzuo (zhangxianzuo@ustc.edu.cn)

### 🏛️ Institution / 机构

**University of Science and Technology of China (USTC)**  
**中国科学技术大学**

School of Life Sciences  
生命科学学院

Hefei, Anhui 230027, China  
中国安徽合肥 230027

### 📖 Citation / 引用

If you use this package in your research, please cite:
如果您在研究中使用了此包，请引用：

```
HAS Research Team (2024). HASr: Hefei Aging Study Data Processing Tools. 
R package version 0.1.0. https://github.com/USTC-HAS/HASr
```

## 📄 License / 许可证

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

本项目采用MIT许可证 - 详情请参见[LICENSE](LICENSE)文件。

---

**Hefei Aging Study (HAS) | 合肥老龄化研究**  
*University of Science and Technology of China | 中国科学技术大学*