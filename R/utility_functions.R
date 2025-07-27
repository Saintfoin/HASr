#' @title 解析出生日期 / Parse Birth Date
#' @description 
#' 清洗和标准化出生日期格式，支持多种输入格式。
#' Clean and standardize birth date formats, supporting multiple input formats.
#' 
#' @param x 字符向量，包含出生日期信息 / Character vector containing birth date information
#' 
#' @return Date向量 / Date vector
#' 
#' @examples
#' \dontrun{
#' dates <- c("1965年5月7日", "19650507", "1965.05.07", "1965/05/07")
#' parse_birth_date(dates)
#' }
#' 
#' @export
parse_birth_date <- function(x) {
  # 处理NULL输入
  if (is.null(x)) return(as.POSIXct(character(0)))
  
  x <- as.character(x)
  x <- stringr::str_trim(x)                     # 去除前后空格
  x <- stringr::str_replace_all(x, "年|\\.|/", "-")  # 替换中文"年"、"."、"/"为"-"
  x <- stringr::str_replace_all(x, "月", "-")
  x <- stringr::str_replace_all(x, "日", "")
  
  # 若为纯数字8位（如 19650507），加中间"-"
  x <- ifelse(stringr::str_detect(x, "^\\d{8}$"),
              stringr::str_c(substr(x, 1, 4), "-", substr(x, 5, 6), "-", substr(x, 7, 8)),
              x)
  
  # 若为纯数字6位（极少见如196505），处理成1965-05-01
  x <- ifelse(stringr::str_detect(x, "^\\d{6}$"),
              stringr::str_c(substr(x, 1, 4), "-", substr(x, 5, 6), "-01"),
              x)
  
  # 强制转换为 Date，使用多个解析格式
  lubridate::parse_date_time(x, orders = c("Ymd", "Y-m-d", "Y-m", "Y"))
}

#' @title 清洗数值型数据 / Clean Numeric Data
#' @description 
#' 从字符串中提取数字部分并转换为数值型。
#' Extract numeric parts from strings and convert to numeric.
#' 
#' @param x 字符向量 / Character vector
#' 
#' @return 数值向量 / Numeric vector
#' 
#' @examples
#' \dontrun{
#' values <- c("123.45kg", "67.8cm", "45mg/dl")
#' clean_numeric(values)
#' }
#' 
#' @export
clean_numeric <- function(x) {
  # 处理NULL输入
  if (is.null(x)) return(numeric(0))
  
  # 处理特殊值
  if (any(is.infinite(x))) {
    x[is.infinite(x)] <- NA
  }
  
  x_clean <- gsub("[^0-9\\.\\-]", "", as.character(x))
  # 如果清洗后为空字符串，返回NA
  x_clean[x_clean == ""] <- NA
  as.numeric(x_clean)
}

#' @title 清洗并转换数据 / Clean and Convert Data
#' @description 
#' 清洗数据并转换为数值型，处理逗号、空格等特殊字符。
#' Clean data and convert to numeric, handling commas, spaces and special characters.
#' 
#' @param x 字符向量 / Character vector
#' 
#' @return 数值向量 / Numeric vector
#' 
#' @examples
#' \dontrun{
#' values <- c("1,234.56", " 789.01 ", "2.5e-3")
#' clean_and_convert(values)
#' }
#' 
#' @export
clean_and_convert <- function(x) {
  # 处理NULL输入
  if (is.null(x)) return(numeric(0))
  
  x <- trimws(as.character(x))       # 去除首尾空格并转换为字符
  x <- gsub(",", "", x)             # 移除逗号（千位分隔符）
  
  # 保留数字、小数点、负号、科学计数法字母和加号
  x <- gsub("[^0-9\\.\\-eE+]", "", x)
  
  # 如果清洗后为空字符串，返回NA
  x[x == ""] <- NA
  
  as.numeric(x)                     # 转换为 numeric
}

#' @title 按性别绘制活动图 / Plot Activity by Sex
#' @description 
#' 根据性别绘制活动类型的分布图。
#' Plot activity type distribution by sex.
#' 
#' @param data 数据框，包含性别、年龄组和活动类型信息 / Data frame containing sex, age group and activity type information
#' @param sex_label 性别标签 / Sex label
#' 
#' @return ggplot对象 / ggplot object
#' 
#' @examples
#' \dontrun{
#' plot_activity_by_sex(activity_data, "Male")
#' }
#' 
#' @export
plot_activity_by_sex <- function(data, sex_label) {
  # 过滤性别并重新计算百分比
  data_sex <- data %>%
    dplyr::filter(sex == sex_label) %>%
    dplyr::group_by(age_group) %>%
    dplyr::mutate(percent = percent / sum(percent))  # 组内标准化
  
  # 绘图
  ggplot2::ggplot(data_sex, ggplot2::aes(x = age_group, y = percent, fill = activity_type)) +
    ggplot2::geom_bar(stat = "identity", position = "fill") +
    ggplot2::scale_y_continuous(labels = scales::percent_format(scale = 1)) +
    ggplot2::scale_fill_manual(values = c("#EC6E45", "#F2C363", "#C0C0C0", "#4E88B4")) +
    ggplot2::labs(
      title = paste("PA", sex_label),
      x = "Age Group",
      y = "Percentage"
    ) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, face = "bold"),
      axis.text.y = ggplot2::element_text(hjust = 1, face = "bold"),
      strip.background = ggplot2::element_blank(),
      strip.placement = "outside",
      plot.margin = ggplot2::unit(c(0.5, 0.5, 0.5, 0.5), "cm")
    )
}