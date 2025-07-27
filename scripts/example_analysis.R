# HAS Cohort Analysis Example Script
# HAS队列分析示例脚本
#
# This script demonstrates how to use the HASr package for comprehensive
# analysis of the Hefei Aging Study cohort data.
# 此脚本演示如何使用HASr包对合肥老龄化研究队列数据进行综合分析。
#
# Author: HAS Research Team
# Date: 2024-12-19
# Contact: has@ustc.edu.cn

# Load required libraries ----
library(HASr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(corrplot)
library(tableone)

# Set up analysis environment ----
# 设置分析环境
options(stringsAsFactors = FALSE)
set.seed(12345)  # For reproducibility / 确保可重现性

# Define file paths ----
# 定义文件路径
data_path <- "data/raw/"  # Adjust to your data location / 调整为您的数据位置
output_path <- "results/" # Output directory / 输出目录

# Create output directory if it doesn't exist
if (!dir.exists(output_path)) {
  dir.create(output_path, recursive = TRUE)
}

# Data Loading and Processing ----
# 数据加载和处理

cat("Loading and processing HAS cohort data...\n")
cat("正在加载和处理HAS队列数据...\n")

# Load raw data (replace with actual file paths)
# 加载原始数据（替换为实际文件路径）
# raw_data <- read.csv(file.path(data_path, "has_cohort_data.csv"))

# For demonstration, create sample data
# 为演示目的，创建示例数据
n_participants <- 1000
sample_data <- data.frame(
  id = 1:n_participants,
  age = sample(55:85, n_participants, replace = TRUE),
  sex = sample(c("Male", "Female"), n_participants, replace = TRUE),
  education = sample(c("Primary", "Secondary", "Higher"), n_participants, replace = TRUE),
  height = rnorm(n_participants, 165, 10),
  weight = rnorm(n_participants, 65, 12),
  mmse_total = sample(15:30, n_participants, replace = TRUE),
  moca_total = sample(10:30, n_participants, replace = TRUE),
  stringsAsFactors = FALSE
)

# Process demographic data
# 处理人口统计学数据
cat("Processing demographic variables...\n")
demo_data <- parse_demo(
  df = sample_data,
  age = TRUE,
  sex = TRUE,
  education = TRUE,
  bmi = TRUE
)

# Process neurological data
# 处理神经系统数据
cat("Processing neurological variables...\n")
neuro_data <- parse_neuro(
  df = sample_data,
  cognition = TRUE
)

# Combine processed data
# 合并处理后的数据
analysis_data <- demo_data %>%
  left_join(neuro_data, by = "id")

cat(sprintf("Data processing complete. Final dataset: %d participants, %d variables\n", 
            nrow(analysis_data), ncol(analysis_data)))
cat(sprintf("数据处理完成。最终数据集：%d名参与者，%d个变量\n", 
            nrow(analysis_data), ncol(analysis_data)))

# Descriptive Analysis ----
# 描述性分析

cat("\nGenerating descriptive statistics...\n")
cat("\n生成描述性统计...\n")

# Create Table 1 - Baseline characteristics
# 创建表1 - 基线特征
vars_for_table1 <- c("age", "sex", "education", "bmi_category", 
                     "mmse_total", "moca_total")

# Generate overall summary
overall_summary <- analysis_data %>%
  select(all_of(vars_for_table1)) %>%
  summary()

print("Overall Summary / 总体摘要:")
print(overall_summary)

# Summary by sex
# 按性别汇总
sex_summary <- analysis_data %>%
  group_by(sex) %>%
  summarise(
    n = n(),
    age_mean = mean(age, na.rm = TRUE),
    age_sd = sd(age, na.rm = TRUE),
    bmi_mean = mean(bmi, na.rm = TRUE),
    bmi_sd = sd(bmi, na.rm = TRUE),
    mmse_mean = mean(mmse_total, na.rm = TRUE),
    mmse_sd = sd(mmse_total, na.rm = TRUE),
    moca_mean = mean(moca_total, na.rm = TRUE),
    moca_sd = sd(moca_total, na.rm = TRUE),
    .groups = 'drop'
  )

print("\nSummary by Sex / 按性别汇总:")
print(sex_summary)

# Age group analysis
# 年龄组分析
analysis_data <- analysis_data %>%
  mutate(
    age_group = case_when(
      age < 65 ~ "55-64",
      age < 75 ~ "65-74",
      TRUE ~ "75+"
    )
  )

age_group_summary <- analysis_data %>%
  group_by(age_group) %>%
  summarise(
    n = n(),
    percent = round(n() / nrow(analysis_data) * 100, 1),
    mmse_mean = round(mean(mmse_total, na.rm = TRUE), 1),
    moca_mean = round(mean(moca_total, na.rm = TRUE), 1),
    .groups = 'drop'
  )

print("\nAge Group Distribution / 年龄组分布:")
print(age_group_summary)

# Data Visualization ----
# 数据可视化

cat("\nGenerating visualizations...\n")
cat("\n生成可视化图表...\n")

# 1. Age distribution by sex
# 按性别的年龄分布
p1 <- ggplot(analysis_data, aes(x = age, fill = sex)) +
  geom_histogram(alpha = 0.7, position = "identity", bins = 20) +
  facet_wrap(~sex) +
  labs(
    title = "Age Distribution by Sex / 按性别的年龄分布",
    x = "Age (years) / 年龄（岁）",
    y = "Count / 计数"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave(file.path(output_path, "age_distribution_by_sex.png"), 
       p1, width = 10, height = 6, dpi = 300)

# 2. BMI distribution
# BMI分布
p2 <- ggplot(analysis_data, aes(x = bmi)) +
  geom_histogram(fill = "steelblue", alpha = 0.7, bins = 30) +
  geom_vline(xintercept = c(18.5, 24, 28), 
             linetype = "dashed", color = "red") +
  labs(
    title = "BMI Distribution / BMI分布",
    x = "BMI (kg/m²)",
    y = "Count / 计数",
    caption = "Dashed lines: BMI categories (18.5, 24, 28) / 虚线：BMI分类界值"
  ) +
  theme_minimal()

ggsave(file.path(output_path, "bmi_distribution.png"), 
       p2, width = 8, height = 6, dpi = 300)

# 3. Cognitive scores by age group
# 按年龄组的认知评分
cognitive_long <- analysis_data %>%
  select(id, age_group, mmse_total, moca_total) %>%
  pivot_longer(cols = c(mmse_total, moca_total),
               names_to = "test", values_to = "score") %>%
  mutate(test = case_when(
    test == "mmse_total" ~ "MMSE",
    test == "moca_total" ~ "MoCA"
  ))

p3 <- ggplot(cognitive_long, aes(x = age_group, y = score, fill = test)) +
  geom_boxplot(alpha = 0.7) +
  facet_wrap(~test, scales = "free_y") +
  labs(
    title = "Cognitive Test Scores by Age Group / 按年龄组的认知测试评分",
    x = "Age Group / 年龄组",
    y = "Test Score / 测试评分"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave(file.path(output_path, "cognitive_scores_by_age.png"), 
       p3, width = 10, height = 6, dpi = 300)

# 4. Correlation matrix
# 相关性矩阵
numeric_vars <- analysis_data %>%
  select_if(is.numeric) %>%
  select(-id) %>%
  cor(use = "complete.obs")

png(file.path(output_path, "correlation_matrix.png"), 
    width = 800, height = 800, res = 150)
corrplot(numeric_vars, method = "color", type = "upper", 
         order = "hclust", tl.cex = 0.8, tl.col = "black")
title("Correlation Matrix of Numeric Variables\n数值变量相关性矩阵")
dev.off()

# Statistical Analysis ----
# 统计分析

cat("\nPerforming statistical analyses...\n")
cat("\n进行统计分析...\n")

# 1. Sex differences in cognitive scores
# 认知评分的性别差异
mmse_ttest <- t.test(mmse_total ~ sex, data = analysis_data)
moca_ttest <- t.test(moca_total ~ sex, data = analysis_data)

cat("\nSex differences in cognitive scores / 认知评分的性别差异:\n")
cat(sprintf("MMSE: t = %.3f, p = %.3f\n", mmse_ttest$statistic, mmse_ttest$p.value))
cat(sprintf("MoCA: t = %.3f, p = %.3f\n", moca_ttest$statistic, moca_ttest$p.value))

# 2. Age correlation with cognitive scores
# 年龄与认知评分的相关性
age_mmse_cor <- cor.test(analysis_data$age, analysis_data$mmse_total)
age_moca_cor <- cor.test(analysis_data$age, analysis_data$moca_total)

cat("\nAge correlations with cognitive scores / 年龄与认知评分的相关性:\n")
cat(sprintf("Age-MMSE: r = %.3f, p = %.3f\n", 
            age_mmse_cor$estimate, age_mmse_cor$p.value))
cat(sprintf("Age-MoCA: r = %.3f, p = %.3f\n", 
            age_moca_cor$estimate, age_moca_cor$p.value))

# 3. Linear regression: Predictors of cognitive performance
# 线性回归：认知表现的预测因子
mmse_model <- lm(mmse_total ~ age + sex + education + bmi, data = analysis_data)
moca_model <- lm(moca_total ~ age + sex + education + bmi, data = analysis_data)

cat("\nLinear regression results / 线性回归结果:\n")
cat("\nMMSE Model:\n")
print(summary(mmse_model))
cat("\nMoCA Model:\n")
print(summary(moca_model))

# Save Results ----
# 保存结果

cat("\nSaving analysis results...\n")
cat("\n保存分析结果...\n")

# Save processed data
write.csv(analysis_data, file.path(output_path, "processed_has_data.csv"), 
          row.names = FALSE)

# Save summary statistics
sink(file.path(output_path, "summary_statistics.txt"))
cat("HAS Cohort Analysis Summary\n")
cat("HAS队列分析摘要\n")
cat("=========================\n\n")
cat("Dataset Overview:\n")
cat(sprintf("Total participants: %d\n", nrow(analysis_data)))
cat(sprintf("Age range: %d - %d years\n", min(analysis_data$age), max(analysis_data$age)))
cat(sprintf("Sex distribution: %s\n", 
            paste(table(analysis_data$sex), collapse = " Male, ", " Female")))
cat("\n")
print(sex_summary)
cat("\n")
print(age_group_summary)
sink()

# Generate analysis report
# 生成分析报告
report_content <- sprintf("
HAS Cohort Analysis Report
HAS队列分析报告
=======================

Analysis Date: %s
Analyst: HAS Research Team

Dataset Summary:
- Total Participants: %d
- Age Range: %d - %d years
- Male/Female: %d/%d

Key Findings:
1. Mean age: %.1f ± %.1f years
2. Mean BMI: %.1f ± %.1f kg/m²
3. Mean MMSE: %.1f ± %.1f
4. Mean MoCA: %.1f ± %.1f

Sex Differences:
- MMSE: p = %.3f
- MoCA: p = %.3f

Age Correlations:
- Age-MMSE: r = %.3f, p = %.3f
- Age-MoCA: r = %.3f, p = %.3f

Files Generated:
- processed_has_data.csv
- age_distribution_by_sex.png
- bmi_distribution.png
- cognitive_scores_by_age.png
- correlation_matrix.png
- summary_statistics.txt
",
Sys.Date(),
nrow(analysis_data),
min(analysis_data$age), max(analysis_data$age),
sum(analysis_data$sex == "Male"), sum(analysis_data$sex == "Female"),
mean(analysis_data$age), sd(analysis_data$age),
mean(analysis_data$bmi, na.rm = TRUE), sd(analysis_data$bmi, na.rm = TRUE),
mean(analysis_data$mmse_total), sd(analysis_data$mmse_total),
mean(analysis_data$moca_total), sd(analysis_data$moca_total),
mmse_ttest$p.value, moca_ttest$p.value,
age_mmse_cor$estimate, age_mmse_cor$p.value,
age_moca_cor$estimate, age_moca_cor$p.value
)

writeLines(report_content, file.path(output_path, "analysis_report.txt"))

cat("\nAnalysis complete! / 分析完成！\n")
cat(sprintf("Results saved to: %s\n", output_path))
cat(sprintf("结果已保存至：%s\n", output_path))

# Session info for reproducibility
# 会话信息以确保可重现性
sink(file.path(output_path, "session_info.txt"))
cat("R Session Information\n")
cat("R会话信息\n")
cat("====================\n\n")
print(sessionInfo())
sink()

cat("\nFor questions or support, contact: has@ustc.edu.cn\n")
cat("如有问题或需要支持，请联系：has@ustc.edu.cn\n")