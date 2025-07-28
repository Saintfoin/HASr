install.packages('diffpriv')
library(diffpriv)
library(dplyr)
#隐私差分自定义函数写在0_functions_v4.r里调用

#测试自定函数
df_masked <- mask_df(d_demo, noise_level = 0.15)

#处理真实变量
library(progress)
library(readr)
library(dplyr)

# 创建输出文件夹（如不存在）
if (!dir.exists("csv_mask")) {
  dir.create("csv_mask")
}

# 获取文件列表
csv_files <- list.files("csv", pattern = "\\.csv$", full.names = TRUE)
n_files <- length(csv_files)

# 创建进度条
pb <- progress_bar$new(
  format = "  处理中 [:bar] :current/:total (:percent) in :elapsed",
  total = n_files, clear = FALSE, width = 60
)

# 主循环：处理每个文件
for (file in csv_files) {
  pb$tick()
  
  # 读取数据
  df <- read_csv(file, show_col_types = FALSE)
  
  # 掩码处理
  df_masked <- mask_df(df)
  
  # 修改主键列（支持 id 或 UserID）
  key_col <- intersect(c("id", "UserID"), names(df_masked))
  if (length(key_col) == 1) {
    df_masked[[key_col]] <- paste0("s", df_masked[[key_col]])
  }
  
  # 写入新文件
  out_name <- basename(file)
  write_csv(df_masked, file.path("csv_mask", out_name))
}




