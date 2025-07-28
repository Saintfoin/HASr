---
layout: default
title: Home
lang: en
---

<div align="center">

# 🧠 HASr: Hefei Aging Study Data Processing Tools
# 🧠 HASr：合肥老龄化研究数据处理工具包

<p align="center">
  <img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white" alt="R">
  <img src="https://img.shields.io/badge/Version-0.1.0-blue?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge" alt="Status">
</p>

<p align="center">
  <strong>🏥 专业的老龄化研究数据处理工具包</strong><br>
  <strong>Professional Aging Research Data Processing Toolkit</strong>
</p>

</div>

---

## 🌟 Highlights / 亮点功能

<div align="center">

| 🧬 **8+ Functions** | 📊 **Statistical Tools** | 🔒 **Privacy First** | 🎨 **Rich Visuals** |
|:---:|:---:|:---:|:---:|
| 专业数据解析函数 | 统计分析工具 | 隐私保护机制 | 丰富可视化 |
| Professional parsing | Analysis toolkit | Privacy protection | Rich visualization |

</div>

### 🔥 Latest Updates

- 🆕 **New in v0.1.0**: Complete data processing pipeline
- 🛡️ **Privacy Protection**: Built-in differential privacy algorithms
- 📈 **Performance**: Optimized for large-scale cohort data
- 🌐 **Bilingual**: Full Chinese and English documentation
- 🧪 **Tested**: 100+ unit tests for reliability

---

## 🎉 Welcome / 欢迎

### 🌍 English

Welcome to the HASr package documentation site. HASr is a comprehensive R package designed for processing and analyzing data from the Hefei Aging Study (HAS) cohort.

The Hefei Aging Study focuses on urban aging progression in Luyang District, Hefei, China, integrating clinical, cognitive, imaging, and biomarker data from adults aged 50 and older. Our research aims to identify individuals in the "preclinical abnormal" state and explore interventions that could slow or reverse cognitive decline in urban aging populations.

### 🇨🇳 中文

欢迎来到HASr包文档网站。HASr是一个专为处理和分析合肥老龄化研究（HAS）队列数据而设计的综合性R包。

合肥老龄化研究聚焦于中国合肥庐阳区的城市老龄化进程，整合了50岁及以上成年人的临床、认知、影像学和生物标志物数据。我们的研究旨在识别处于"临床前异常"状态的个体，并探索可能延缓或逆转城市老龄化人群认知衰退的干预措施。

## 🚀 Quick Start / 快速开始

### 📦 Installation / 安装

```r
# Install from GitHub
devtools::install_github("USTC-HAS/HASr")

# Load the package
library(HASr)
```

### 💻 Basic Usage / 基本用法

```r
# Parse demographic data
demo_data <- parse_demo(df, age = TRUE, sex = TRUE, education = TRUE)

# Parse neurological data
neuro_data <- parse_neuro(df, sensory = TRUE, cognition = TRUE)

# Clean numeric values
clean_values <- clean_numeric(c("123.45kg", "67.8cm"))
```

## ✨ Features / 功能特性

### 🔬 Data Processing Functions / 数据处理功能

- **Demographic Data Processing** / **人口统计学数据处理**
  - Age, sex, education, marriage status / 年龄、性别、教育、婚姻状况
  - BMI calculation and categorization / BMI计算和分类
  - Socioeconomic indicators / 社会经济指标

- **Neurological Assessment** / **神经系统评估**
  - Sensory function evaluation / 感觉功能评估
  - Fall risk assessment / 跌倒风险评估
  - Sleep structure analysis / 睡眠结构分析
  - Cognitive function testing / 认知功能测试

- **Musculoskeletal Health** / **骨骼肌肉健康**
  - Osteoporosis risk factors / 骨质疏松风险因素
  - Bone metabolism markers / 骨代谢标志物
  - FRAX and Garvan risk calculations / FRAX和Garvan风险计算
  - Sarcopenia assessment / 肌少症评估

### 🛠️ Utility Functions / 实用功能

- **Data Cleaning** / **数据清洗**
  - Birth date parsing / 出生日期解析
  - Numeric data extraction / 数值数据提取
  - String standardization / 字符串标准化

- **Visualization** / **可视化**
  - Activity distribution plots / 活动分布图
  - Age-stratified analyses / 年龄分层分析
  - Custom ggplot2 themes / 自定义ggplot2主题

## 📚 Documentation / 文档

- [Function Reference](reference/) - Complete function documentation / 完整函数文档
- [Vignettes](articles/) - Detailed usage guides / 详细使用指南
- [Examples](examples/) - Practical examples / 实用示例
- [GitHub Repository](https://github.com/USTC-HAS/HASr) - Source code and issues / 源代码和问题反馈

## 👥 Research Team / 研究团队

**University of Science and Technology of China (USTC)**  
**中国科学技术大学**

School of Life Sciences  
生命科学学院

For questions and collaboration inquiries, please contact: zhangxianzuo@ustc.edu.cn  
如有问题和合作咨询，请联系：zhangxianzuo@ustc.edu.cn

## 📖 Citation / 引用

If you use HASr in your research, please cite:  
如果您在研究中使用HASr，请引用：

```
HAS Research Team (2024). HASr: Hefei Aging Study Data Processing Tools. 
R package version 0.1.0. https://github.com/Saintfoin/HASr
```

---

*Last updated: July 2025 / 最后更新：2025年7月*