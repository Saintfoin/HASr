# HASr 0.1.0

## Initial Release / 初始版本

### New Features / 新功能

* **Data Processing Functions / 数据处理功能**
  - `parse_demo()`: Extract and process demographic variables / 提取和处理人口统计学变量
  - `parse_neuro()`: Extract and process neurological assessment data / 提取和处理神经系统评估数据
  - `parse_msk()`: Extract and process musculoskeletal health data / 提取和处理肌肉骨骼健康数据

* **Utility Functions / 实用功能**
  - `parse_birth_date()`: Clean and standardize birth date formats / 清洗和标准化出生日期格式
  - `clean_numeric()`: Extract numeric values from character strings / 从字符串中提取数值
  - `clean_and_convert()`: Clean and convert data with comma and space handling / 清洗和转换数据，处理逗号和空格
  - `plot_activity_by_sex()`: Create activity distribution plots by gender / 按性别创建活动分布图

* **Documentation / 文档**
  - Comprehensive bilingual documentation (English + Chinese) / 全面的双语文档（英文+中文）
  - Data processing vignette with examples / 包含示例的数据处理指南
  - Metadata schema for HAS cohort variables / HAS队列变量的元数据模式

* **Package Infrastructure / 包基础设施**
  - Standard R package structure / 标准R包结构
  - Unit tests with testthat framework / 使用testthat框架的单元测试
  - GitHub Actions CI/CD pipeline / GitHub Actions CI/CD流水线
  - pkgdown website configuration / pkgdown网站配置

### Data Coverage / 数据覆盖范围

The package supports processing of the following HAS cohort data modules:
该包支持处理以下HAS队列数据模块：

* **Demographics (d_demo)** / 人口统计学数据
  - Age, gender, education, marital status / 年龄、性别、教育、婚姻状况
  - BMI, socioeconomic indicators / BMI、社会经济指标
  - Smoking and alcohol consumption / 吸烟和饮酒

* **Neurological Assessment (d_neuro)** / 神经系统评估
  - Sensory function and fall risk / 感觉功能和跌倒风险
  - Sleep structure and quality / 睡眠结构和质量
  - Activities of Daily Living (ADL/IADL) / 日常生活活动能力
  - Cognitive function (MMSE, MoCA) / 认知功能

* **Musculoskeletal Health (d_msk)** / 肌肉骨骼健康
  - Osteoporosis risk factors / 骨质疏松风险因素
  - Bone metabolism markers / 骨代谢标志物
  - FRAX and Garvan risk scores / FRAX和Garvan风险评分
  - Sarcopenia assessment / 肌少症评估
  - Arthritis diagnosis and scoring / 关节炎诊断和评分

### Technical Details / 技术细节

* **Dependencies / 依赖包**
  - Core: dplyr, stringr, lubridate / 核心：dplyr、stringr、lubridate
  - Visualization: ggplot2, scales / 可视化：ggplot2、scales
  - Documentation: roxygen2 / 文档：roxygen2

* **R Version Support / R版本支持**
  - Requires R >= 4.0.0 / 需要R >= 4.0.0
  - Tested on Windows, macOS, and Ubuntu / 在Windows、macOS和Ubuntu上测试

* **Quality Assurance / 质量保证**
  - Comprehensive unit tests / 全面的单元测试
  - Continuous integration with GitHub Actions / 使用GitHub Actions的持续集成
  - Code coverage monitoring / 代码覆盖率监控

### Project Structure / 项目结构

* **GitHub Pages Integration / GitHub Pages集成**
  - Bilingual project homepage / 双语项目主页
  - Automated documentation website / 自动化文档网站

* **Research Workflow Support / 研究工作流支持**
  - Example analysis scripts / 示例分析脚本
  - Data showcase interface (placeholder) / 数据展示界面（占位符）
  - Reproducible research templates / 可重现研究模板

### Acknowledgments / 致谢

This initial release represents the collaborative effort of the HAS research team at the University of Science and Technology of China (USTC). Special thanks to all contributors who helped transform individual R scripts into a comprehensive, well-documented package.

此初始版本代表了中国科学技术大学（USTC）HAS研究团队的协作努力。特别感谢所有帮助将单独的R脚本转换为全面、文档完善的包的贡献者。

### Future Development / 未来发展

Planned features for upcoming releases:
即将发布的版本计划功能：

* Additional data modules (cardiovascular, endocrine, immune, cerebrovascular) / 其他数据模块（心血管、内分泌、免疫、脑血管）
* Interactive Shiny dashboard / 交互式Shiny仪表板
* Advanced statistical analysis functions / 高级统计分析功能
* Machine learning integration / 机器学习集成
* Enhanced visualization capabilities / 增强的可视化功能

---

*For detailed information about changes and new features, see the package documentation and vignettes.*  
*有关更改和新功能的详细信息，请参阅包文档和指南。*