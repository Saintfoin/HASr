# v4 增加隐私差分功能
# v3 更新 parse_msk() parse_card() parse_endo() parse_immo() parse_scvd()
# v2 更新 parse_demo() 增加身高、体重

#* 自定义出生日期清洗函数----
parse_birth_date <- function(x) {
  x <- as.character(x)
  x <- str_trim(x)                     # 去除前后空格
  x <- str_replace_all(x, "年|\\.|/", "-")  # 替换中文"年"、“.”、“/”为"-"
  x <- str_replace_all(x, "月", "-")
  x <- str_replace_all(x, "日", "")
  
  # 若为纯数字8位（如 19650507），加中间"-"
  x <- ifelse(str_detect(x, "^\\d{8}$"),
              str_c(substr(x, 1, 4), "-", substr(x, 5, 6), "-", substr(x, 7, 8)),
              x)
  
  # 若为纯数字6位（极少见如196505），处理成1965-05-01
  x <- ifelse(str_detect(x, "^\\d{6}$"),
              str_c(substr(x, 1, 4), "-", substr(x, 5, 6), "-01"),
              x)
  
  # 强制转换为 Date，使用多个解析格式
  parse_date_time(x, orders = c("Ymd", "Y-m-d", "Y-m", "Y"))
}

parse_demo <- function(x,
                       age = TRUE,
                       age_group = FALSE,
                       sex = TRUE,
                       education = FALSE,
                       marital_status = FALSE,
                       current_job = FALSE,
                       previous_job = FALSE,
                       personal_income = FALSE,
                       self_rated_income = FALSE,
                       household_income = FALSE,
                       medical_insurance = FALSE,
                       smoking = FALSE,
                       drinking = FALSE,
                       bmi = FALSE,
                       bmi_group = FALSE,
                       ses_index = FALSE,
                       height_cm = FALSE,
                       weight_kg = FALSE) {
  
  # 检查 d_demo 是否存在；如不存在，则读取 CSV
  if (!exists("d_demo")) {
    if (file.exists("d_demo.csv")) {
      message("读取 d_demo.csv 文件...")
      d_demo <- read.csv("d_demo.csv")
    } else {
      stop("找不到 d_demo 数据框，也未找到 d_demo.csv 文件。")
    }
  }
  
  # 确保 id 存在于两个数据中
  if (!"id" %in% names(x) | !"id" %in% names(d_demo)) {
    stop("x 和 d_demo 都必须包含 'id' 变量。")
  }
  
  # 构建要提取的变量列表
  vars <- c("id")  # 主键一定要保留
  
  if (age) vars <- c(vars, "age")
  if (age_group) vars <- c(vars, "age_group")
  if (sex) vars <- c(vars, "sex")
  if (education) vars <- c(vars, "education")
  if (marital_status) vars <- c(vars, "marital_status")
  if (current_job) vars <- c(vars, "current_job")
  if (previous_job) vars <- c(vars, "previous_job")
  if (personal_income) vars <- c(vars, "personal_income")
  if (self_rated_income) vars <- c(vars, "self_rated_income")
  if (household_income) vars <- c(vars, "household_income")
  if (medical_insurance) vars <- c(vars, "medical_insurance")
  if (smoking) vars <- c(vars, "smoking")
  if (drinking) vars <- c(vars, "drinking")
  if (bmi) vars <- c(vars, "bmi")
  if (bmi_group) vars <- c(vars, "bmi_group")
  if (ses_index) vars <- c(vars, "ses_index")
  if (height_cm) vars <- c(vars, "height_cm")
  if (weight_kg) vars <- c(vars, "weight_kg")
  
  # 判断所选变量哪些在 d_demo 中存在
  vars_exist <- vars[vars %in% names(d_demo)]
  
  # 提取子集
  d_sub <- d_demo[, vars_exist]
  
  # left join 到 x，覆盖已有变量
  x <- x %>%
    dplyr::select(-any_of(setdiff(vars_exist, "id"))) %>%  # 移除要覆盖的列（除了 id）
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}


#* 提取神经系统变量 ----
parse_neuro <- function(x,
                        memory = TRUE,
                        fom = TRUE,
                        fluency = TRUE,
                        mmse_moca = TRUE,
                        vision_hearing = TRUE,
                        sleepiness = TRUE,
                        adl = TRUE,
                        iadl = TRUE,
                        falls = TRUE,
                        diagnostics = TRUE) {
  
  # 检查 d_neuro 是否存在；如不存在，尝试读取 csv
  if (!exists("d_neuro")) {
    if (file.exists("d_neuro.csv")) {
      message("读取 d_neuro.csv 文件...")
      d_neuro <- read.csv("d_neuro.csv")
    } else {
      stop("找不到 d_neuro 数据框，也未找到 d_neuro.csv 文件。")
    }
  }
  
  # 检查 id 是否存在
  if (!"id" %in% names(x) | !"id" %in% names(d_neuro)) {
    stop("x 和 d_neuro 都必须包含 'id' 变量。")
  }
  
  # 初始化变量列表
  vars <- c("id")
  
  if (memory) {
    vars <- c(vars, "memory_forward", "memory_backward")
  }
  
  if (fom) {
    vars <- c(vars, "fom_total", "fom_item16")
  }
  
  if (fluency) {
    vars <- c(vars, "fluency_animal", "fluency_vegetable", "fluency_fruit")
  }
  
  if (mmse_moca) {
    vars <- c(vars, "mmse_score", "moca_score")
  }
  
  if (vision_hearing) {
    vars <- c(vars, "vision_problem", "hearing_problem")
  }
  
  if (sleepiness) {
    vars <- c(vars, paste0("sleepiness_", 1:8), "sleepiness_total", "ess_score", "ess_category", "ess_diagnosis")
  }
  
  if (adl) {
    vars <- c(vars, paste0("adl_", c("bathing", "dressing", "toileting", "transfer", "continence", "feeding")),
              "adl_total", "adl_impairment")
  }
  
  if (iadl) {
    vars <- c(vars, paste0("iadl_", c("telephone", "shopping", "foodprep", "housework", "laundry", "transport", "meds", "finance")),
              "iadl_total", "iadl_impairment")
  }
  
  if (falls) {
    vars <- c(vars, "falls_count", "falls_fracture")
  }
  
  if (diagnostics) {
    vars <- c(vars, "functional_status")
  }
  
  # 保留在 d_neuro 中真实存在的变量
  vars_exist <- unique(vars[vars %in% names(d_neuro)])
  
  # 给出警告：哪些变量缺失
  missing_vars <- setdiff(vars, names(d_neuro))
  if (length(missing_vars) > 0) {
    warning("以下变量在 d_neuro 中未找到，将被忽略：\n", paste(missing_vars, collapse = ", "))
  }
  
  # 提取子集
  neuro_sub <- d_neuro[, vars_exist]
  
  # 移除 x 中已有同名变量（除 id），避免重复覆盖
  x <- x %>%
    dplyr::select(-any_of(setdiff(vars_exist, "id"))) %>%
    dplyr::left_join(neuro_sub, by = "id")
  
  return(x)
}


# 通用清洗函数：提取数字部分
clean_numeric <- function(x) {
  x_clean <- gsub("[^0-9\\.]", "", x)
  as.numeric(x_clean)
}

#*提取骨骼肌肉系统----
parse_msk <- function(x,
                      prior_hip_fracture = FALSE,
                      parental_hip_fracture = FALSE,
                      current_smoking = FALSE,
                      alcohol_3units_per_day = FALSE,
                      glucocorticoids = FALSE,
                      rheumatoid_arthritis = FALSE,
                      secondary_osteoporosis = FALSE,
                      fracture_number = FALSE,
                      falls_last12mo = FALSE,
                      fall_count = FALSE,
                      falls_count = FALSE,
                      falls_fracture = FALSE,
                      functional_status = FALSE,
                      CR = FALSE,
                      T = FALSE,
                      GDX1 = FALSE,
                      calc = FALSE,
                      phosp = FALSE,
                      vitd = FALSE,
                      oc = FALSE,
                      tp1np = FALSE,
                      bctx = FALSE,
                      major_fracture_risk = FALSE,
                      hip_fracture_risk = FALSE,
                      any_fracture_5yr = FALSE,
                      any_fracture_10yr = FALSE,
                      hip_fracture_5yr = FALSE,
                      hip_fracture_10yr = FALSE,
                      sarcopenia_status = FALSE,
                      acr_score = FALSE,
                      acr_suspected_knee_oa = FALSE,
                      koos_score_std = FALSE,
                      koos_category = FALSE,
                      womac_score_std = FALSE,
                      womac_category = FALSE,
                      vigorous_activity = FALSE,
                      moderate_activity = FALSE,
                      light_activity = FALSE,
                      sedentary_time = FALSE,
                      total_activity_time = FALSE,
                      met_total = FALSE,
                      fall_binary = FALSE) {
  
  if (!exists("db")) {
    if (file.exists("db.csv")) {
      message("读取 db.csv 文件...")
      db <- read.csv("db.csv")
    } else {
      stop("找不到 db 数据框，也未找到 db.csv 文件。")
    }
  }
  
  if (!"id" %in% names(x)) {
    stop("x 必须包含 'id' 变量。")
  }
  if (!"UserID" %in% names(db)) {
    stop("db 必须包含 'UserID' 变量。")
  }
  
  var_map <- c(
    prior_hip_fracture = "prior_hip_fracture",
    parental_hip_fracture = "parental_hip_fracture",
    current_smoking = "current_smoking",
    alcohol_3units_per_day = "alcohol_3units_per_day",
    glucocorticoids = "glucocorticoids",
    rheumatoid_arthritis = "rheumatoid_arthritis",
    secondary_osteoporosis = "secondary_osteoporosis",
    fracture_number = "fracture_number",
    falls_last12mo = "falls_last12mo",
    fall_count = "K1",
    falls_count = "falls_count",
    falls_fracture = "falls_fracture",
    functional_status = "functional_status",
    CR = "CR",
    T = "T",
    GDX1 = "GDX1",
    calc = "calc",
    phosp = "phosp",
    vitd = "vitd",
    oc = "oc",
    tp1np = "tp1np",
    bctx = "bctx",
    major_fracture_risk = "major_fracture_risk",
    hip_fracture_risk = "hip_fracture_risk",
    any_fracture_5yr = "any_fracture_5yr",
    any_fracture_10yr = "any_fracture_10yr",
    hip_fracture_5yr = "hip_fracture_5yr",
    hip_fracture_10yr = "hip_fracture_10yr",
    sarcopenia_status = "sarcopenia_status",
    acr_score = "acr_score",
    acr_suspected_knee_oa = "acr_suspected_knee_oa",
    koos_score_std = "koos_score_std",
    koos_category = "koos_category",
    womac_score_std = "womac_score_std",
    womac_category = "womac_category",
    vigorous_activity = "vigorous_activity",
    moderate_activity = "moderate_activity",
    light_activity = "light_activity",
    sedentary_time = "sedentary_time",
    total_activity_time = "total_activity_time",
    met_total = "met_total",
    fall_binary = "fall_binary"
  )
  
  # 选择被设置为 TRUE 的变量
  user_flags <- mget(names(var_map), envir = parent.frame(), ifnotfound = FALSE)
  selected_vars <- names(var_map)[unlist(user_flags)]
  db_vars <- unname(var_map[selected_vars])
  db_vars <- c("UserID", db_vars)
  
  d_sub <- db[, intersect(db_vars, names(db)), drop = FALSE]
  names(d_sub)[names(d_sub) == "UserID"] <- "id"
  names(d_sub) <- gsub("^K1$", "fall_count", names(d_sub))
  
  x <- x %>%
    dplyr::select(-any_of(setdiff(names(d_sub), "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}


library(ggplot2)
library(dplyr)
library(scales)

plot_activity_by_sex <- function(data, sex_label) {
  # 过滤性别并重新计算百分比
  data_sex <- data %>%
    filter(sex == sex_label) %>%
    group_by(age_group) %>%
    mutate(percent = percent / sum(percent))  # 组内标准化
  
  # 绘图
  ggplot(data_sex, aes(x = age_group, y = percent, fill = activity_type)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_y_continuous(labels = percent_format(scale = 1)) +
    scale_fill_manual(values = c("#EC6E45", "#F2C363", "#C0C0C0", "#4E88B4")) +
    labs(
      title = paste("PA", sex_label),
      x = "Age Group",
      y = "Percentage"
    ) +
    theme_classic()+
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.title = element_text(hjust = 0.5, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
      axis.text.y = element_text(hjust = 1, face = "bold"),
      strip.background = element_blank(),
      strip.placement = "outside",
      plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")
    )
}

#清洗变量----
# 清洗并转换函数
clean_and_convert <- function(x) {
  x <- trimws(x)                     # 去除首尾空格
  x <- gsub(",", ".", x)            # 替换逗号为小数点
  x <- gsub("[^0-9\\.\\-eE]", "", x) # 移除除数字、小数点、负号、科学计数法字母以外的字符
  as.numeric(x)                     # 转换为 numeric
}

parse_msk <- function(x,
                      sarcopenia_status = TRUE,
                      low_strength = FALSE,
                      low_mass = FALSE,
                      low_function = FALSE,
                      
                      functional_status = TRUE,
                      adl_total = FALSE,
                      adl_impairment = FALSE,
                      iadl_total = FALSE,
                      iadl_impairment = TRUE,
                      
                      falls_last12mo = FALSE,
                      falls_count = FALSE,
                      falls_fracture = FALSE,
                      fall = FALSE,
                      fall_count = FALSE,
                      fall_binary = FALSE,
                      
                      acr_suspected_knee_oa = TRUE,
                      acr_score = FALSE,
                      koos_score = FALSE,
                      womac_score = FALSE,
                      
                      met_total = TRUE,
                      vigorous_activity = FALSE,
                      moderate_activity = FALSE,
                      light_activity = FALSE,
                      sedentary_time = FALSE,
                      
                      prior_hip_fracture = FALSE,
                      parental_hip_fracture = FALSE,
                      current_smoking = FALSE,
                      alcohol_3units_per_day = FALSE,
                      glucocorticoids = FALSE,
                      rheumatoid_arthritis = FALSE,
                      secondary_osteoporosis = FALSE,
                      fracture_number = FALSE,
                      calc = FALSE,
                      phosp = FALSE,
                      vitd = FALSE,
                      oc = FALSE,
                      tp1np = FALSE,
                      bctx = FALSE) {
  
  # 检查 d_msk 是否存在；如不存在，则尝试读取 CSV
  if (!exists("d_msk")) {
    if (file.exists("d_msk.csv")) {
      message("读取 d_msk.csv 文件...")
      d_msk <- read.csv("d_msk.csv")
    } else {
      stop("找不到 d_msk 数据框，也未找到 d_msk.csv 文件。")
    }
  }
  
  # 确保 id 存在于两个数据中
  if (!"id" %in% names(x) | !"id" %in% names(d_msk)) {
    stop("x 和 d_msk 都必须包含 'id' 变量。")
  }
  
  # 构建要提取的变量列表
  vars <- c("id")
  
  if (sarcopenia_status) vars <- c(vars, "sarcopenia_status")
  if (low_strength) vars <- c(vars, "low_strength")
  if (low_mass) vars <- c(vars, "low_mass")
  if (low_function) vars <- c(vars, "low_function")
  
  if (functional_status) vars <- c(vars, "functional_status")
  if (adl_total) vars <- c(vars, "adl_total")
  if (adl_impairment) vars <- c(vars, "adl_impairment")
  if (iadl_total) vars <- c(vars, "iadl_total")
  if (iadl_impairment) vars <- c(vars, "iadl_impairment")
  
  if (falls_last12mo) vars <- c(vars, "falls_last12mo")
  if (falls_count) vars <- c(vars, "falls_count")
  if (falls_fracture) vars <- c(vars, "falls_fracture")
  if (fall) vars <- c(vars, "fall")
  if (fall_count) vars <- c(vars, "fall_count")
  if (fall_binary) vars <- c(vars, "fall_binary")
  
  if (acr_suspected_knee_oa) vars <- c(vars, "acr_suspected_knee_oa")
  if (acr_score) vars <- c(vars, "acr_score")
  if (koos_score) vars <- c(vars, "koos_score")
  if (womac_score) vars <- c(vars, "womac_score")
  
  if (met_total) vars <- c(vars, "met_total")
  if (vigorous_activity) vars <- c(vars, "vigorous_activity")
  if (moderate_activity) vars <- c(vars, "moderate_activity")
  if (light_activity) vars <- c(vars, "light_activity")
  if (sedentary_time) vars <- c(vars, "sedentary_time")
  
  if (prior_hip_fracture) vars <- c(vars, "prior_hip_fracture")
  if (parental_hip_fracture) vars <- c(vars, "parental_hip_fracture")
  if (current_smoking) vars <- c(vars, "current_smoking")
  if (alcohol_3units_per_day) vars <- c(vars, "alcohol_3units_per_day")
  if (glucocorticoids) vars <- c(vars, "glucocorticoids")
  if (rheumatoid_arthritis) vars <- c(vars, "rheumatoid_arthritis")
  if (secondary_osteoporosis) vars <- c(vars, "secondary_osteoporosis")
  if (fracture_number) vars <- c(vars, "fracture_number")
  
  if (calc) vars <- c(vars, "calc")
  if (phosp) vars <- c(vars, "phosp")
  if (vitd) vars <- c(vars, "vitd")
  if (oc) vars <- c(vars, "oc")
  if (tp1np) vars <- c(vars, "tp1np")
  if (bctx) vars <- c(vars, "bctx")
  
  # 提取存在的变量
  vars_exist <- vars[vars %in% names(d_msk)]
  
  d_sub <- d_msk[, vars_exist]
  
  # Left join 到 x，覆盖已有变量（除 id）
  x <- x %>%
    dplyr::select(-any_of(setdiff(vars_exist, "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

parse_card <- function(x,
                       lv_diastolic_dysfunction = FALSE,
                       left_heart_enlargement = FALSE,
                       aortic_valve_disease = FALSE,
                       mitral_valve_disease = FALSE,
                       pulmonary_hypertension = FALSE,
                       pericardial_effusion = FALSE,
                       normal_echo = FALSE,
                       
                       echo_measurements = FALSE,  # LA/LVD/LVS 等结构指标打包
                       lvef = FALSE,
                       
                       diagnosis_hypertension = TRUE,
                       sbp = TRUE,
                       dbp = TRUE,
                       resting_hr = FALSE,
                       
                       lipid = TRUE,  # 包含 tc 和 hdl_c
                       index_ai = FALSE,
                       
                       carotid_imt = TRUE,
                       carotid_plaque = TRUE,
                       carotid_stenosis = TRUE) {
  
  # 检查 d_card 是否存在；如不存在则尝试读取
  if (!exists("d_card")) {
    if (file.exists("d_card.csv")) {
      message("读取 d_card.csv 文件...")
      d_card <- read.csv("d_card.csv")
    } else {
      stop("找不到 d_card 数据框，也未找到 d_card.csv 文件。")
    }
  }
  
  # 确保 id 存在于两个数据框中
  if (!"id" %in% names(x) | !"id" %in% names(d_card)) {
    stop("x 和 d_card 都必须包含 'id' 变量。")
  }
  
  # 构建变量列表
  vars <- c("id")
  
  if (lv_diastolic_dysfunction) vars <- c(vars, "lv_diastolic_dysfunction")
  if (left_heart_enlargement) vars <- c(vars, "left_heart_enlargement")
  if (aortic_valve_disease) vars <- c(vars, "aortic_valve_disease")
  if (mitral_valve_disease) vars <- c(vars, "mitral_valve_disease")
  if (pulmonary_hypertension) vars <- c(vars, "pulmonary_hypertension_or_tricuspid_regurgitation")
  if (pericardial_effusion) vars <- c(vars, "pericardial_effusion")
  if (normal_echo) vars <- c(vars, "normal_echo")
  
  if (echo_measurements) vars <- c(vars, "AO", "LA", "LVD", "LVS", "IVS", "LVPW", "PA", "sPAP")
  if (lvef) vars <- c(vars, "LVEF")
  
  if (diagnosis_hypertension) vars <- c(vars, "diagnosis_hypertension")
  if (sbp) vars <- c(vars, "sbp")
  if (dbp) vars <- c(vars, "dbp")
  if (resting_hr) vars <- c(vars, "resting_hr")
  
  if (lipid) vars <- c(vars, "tc", "hdl_c")
  if (index_ai) vars <- c(vars, "index_ai")
  
  if (carotid_imt) vars <- c(vars, "imt_left", "imt_right")
  if (carotid_plaque) vars <- c(vars,
                                "plaque_present_left", "plaque_present_right",
                                "plaque_count_left", "plaque_count_right",
                                "plaque_site_left", "plaque_site_right",
                                "plaque_max_thickness_left", "plaque_max_thickness_right")
  if (carotid_stenosis) vars <- c(vars,
                                  "stenosis_present_left", "stenosis_present_right",
                                  "stenosis_site_left", "stenosis_site_right",
                                  "stenosis_degree_left", "stenosis_degree_right",
                                  "stenosis_psv_left", "stenosis_psv_right")
  
  # 提取存在的变量
  vars_exist <- vars[vars %in% names(d_card)]
  d_sub <- d_card[, vars_exist]
  
  # left join 到 x，先删除已有列
  x <- x %>%
    dplyr::select(-any_of(setdiff(vars_exist, "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

parse_endo <- function(x,
                       DM = TRUE,
                       GLU = TRUE,
                       GLU_mgdl = FALSE,
                       HbA1c = TRUE,
                       INS = FALSE,
                       INS_µUmL = FALSE,
                       HOMA_IR = TRUE,
                       TYG = TRUE,
                       ins_res = TRUE,
                       
                       TC = FALSE,
                       TG = FALSE,
                       TG_mgdl = FALSE,
                       HDL_C = FALSE,
                       LDL_C = FALSE,
                       Lp_a = FALSE,
                       tc_level = FALSE,
                       ldl_level = FALSE,
                       tg_level = FALSE,
                       
                       FT3 = FALSE,
                       FT4 = FALSE,
                       TSH = FALSE,
                       Testosterone = FALSE,
                       
                       Waist_Circ = FALSE,
                       Hip_Circ = FALSE,
                       WHR = FALSE,
                       BRI = FALSE,
                       abdominal_obesity = FALSE,
                       high_bp = FALSE,
                       high_bg = FALSE,
                       dyslipidemia = TRUE,
                       met_syndrome = TRUE) {
  
  # 检查 d_endo 是否存在；如不存在则读取 CSV
  if (!exists("d_endo")) {
    if (file.exists("d_endo.csv")) {
      message("读取 d_endo.csv 文件...")
      d_endo <- read.csv("d_endo.csv")
    } else {
      stop("找不到 d_endo 数据框，也未找到 d_endo.csv 文件。")
    }
  }
  
  # 确保 id 存在于两个数据中
  if (!"id" %in% names(x) | !"id" %in% names(d_endo)) {
    stop("x 和 d_endo 都必须包含 'id' 变量。")
  }
  
  # 构建要提取的变量列表
  vars <- c("id")
  
  if (DM) vars <- c(vars, "DM")
  if (GLU) vars <- c(vars, "GLU")
  if (GLU_mgdl) vars <- c(vars, "GLU_mgdl")
  if (HbA1c) vars <- c(vars, "HbA1c")
  if (INS) vars <- c(vars, "INS")
  if (INS_µUmL) vars <- c(vars, "INS_µUmL")
  if (HOMA_IR) vars <- c(vars, "HOMA_IR")
  if (TYG) vars <- c(vars, "TYG")
  if (ins_res) vars <- c(vars, "ins_res")
  
  if (TC) vars <- c(vars, "TC")
  if (TG) vars <- c(vars, "TG")
  if (TG_mgdl) vars <- c(vars, "TG_mgdl")
  if (HDL_C) vars <- c(vars, "HDL_C")
  if (LDL_C) vars <- c(vars, "LDL_C")
  if (Lp_a) vars <- c(vars, "Lp_a")
  if (tc_level) vars <- c(vars, "tc_level")
  if (ldl_level) vars <- c(vars, "ldl_level")
  if (tg_level) vars <- c(vars, "tg_level")
  
  if (FT3) vars <- c(vars, "FT3")
  if (FT4) vars <- c(vars, "FT4")
  if (TSH) vars <- c(vars, "TSH")
  if (Testosterone) vars <- c(vars, "Testosterone")
  
  if (Waist_Circ) vars <- c(vars, "Waist_Circ")
  if (Hip_Circ) vars <- c(vars, "Hip_Circ")
  if (WHR) vars <- c(vars, "WHR")
  if (BRI) vars <- c(vars, "BRI")
  if (abdominal_obesity) vars <- c(vars, "abdominal_obesity")
  if (high_bp) vars <- c(vars, "high_bp")
  if (high_bg) vars <- c(vars, "high_bg")
  if (dyslipidemia) vars <- c(vars, "dyslipidemia")
  if (met_syndrome) vars <- c(vars, "met_syndrome")
  
  # 提取存在变量
  vars_exist <- vars[vars %in% names(d_endo)]
  d_sub <- d_endo[, vars_exist]
  
  # 合并进 x
  x <- x %>%
    dplyr::select(-any_of(setdiff(vars_exist, "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

parse_immo <- function(x,
                       hs_CRP = TRUE,
                       NEUT = FALSE,
                       LYMPH = FALSE,
                       PLT = FALSE,
                       YS_FA = FALSE,
                       YS_VB12 = FALSE,
                       IL6 = FALSE,
                       TNFα = FALSE,
                       NLR = TRUE,
                       SII = TRUE,
                       nlr_flag = TRUE,
                       sii_flag = TRUE,
                       inflammation_group = TRUE) {
  
  # 检查 d_immo 是否存在；如不存在则读取
  if (!exists("d_immo")) {
    if (file.exists("d_immo.csv")) {
      message("读取 d_immo.csv 文件...")
      d_immo <- read.csv("d_immo.csv")
    } else {
      stop("找不到 d_immo 数据框，也未找到 d_immo.csv 文件。")
    }
  }
  
  # 确保 id 存在于两个数据框中
  if (!"id" %in% names(x) | !"id" %in% names(d_immo)) {
    stop("x 和 d_immo 都必须包含 'id' 变量。")
  }
  
  # 构建变量列表
  vars <- c("id")
  
  if (hs_CRP) vars <- c(vars, "hs_CRP")
  if (NEUT) vars <- c(vars, "NEUT")
  if (LYMPH) vars <- c(vars, "LYMPH")
  if (PLT) vars <- c(vars, "PLT")
  if (YS_FA) vars <- c(vars, "YS_FA")
  if (YS_VB12) vars <- c(vars, "YS_VB12")
  if (IL6) vars <- c(vars, "IL6")
  if (TNFα) vars <- c(vars, "TNFα")
  if (NLR) vars <- c(vars, "NLR")
  if (SII) vars <- c(vars, "SII")
  if (nlr_flag) vars <- c(vars, "nlr_flag")
  if (sii_flag) vars <- c(vars, "sii_flag")
  if (inflammation_group) vars <- c(vars, "inflammation_group")
  
  # 提取存在变量
  vars_exist <- vars[vars %in% names(d_immo)]
  d_sub <- d_immo[, vars_exist]
  
  # 合并进 x
  x <- x %>%
    dplyr::select(-any_of(setdiff(vars_exist, "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}


parse_scvd <- function(x,
                       ptau217 = TRUE,
                       APOE4 = TRUE,
                       Fazekas = TRUE,
                       Fazekas_burden_v = FALSE,
                       Fazekas_burden_d = FALSE,
                       Fazekas_burden_mix = FALSE,
                       WMH = TRUE,
                       lacuna = TRUE,
                       serve_lacuna = TRUE,
                       infarction = FALSE,
                       chm = FALSE,
                       burden = TRUE,
                       burden2 = TRUE,
                       burdenf = TRUE) {
  
  # 检查 d_scvd 是否存在；如不存在则尝试读取
  if (!exists("d_scvd")) {
    if (file.exists("d_scvd.csv")) {
      message("读取 d_scvd.csv 文件...")
      d_scvd <- read.csv("d_scvd.csv")
    } else {
      stop("找不到 d_scvd 数据框，也未找到 d_scvd.csv 文件。")
    }
  }
  
  # 检查 id 是否存在
  if (!"id" %in% names(x) | !"id" %in% names(d_scvd)) {
    stop("x 和 d_scvd 都必须包含 'id' 变量。")
  }
  
  # 构建变量列表
  vars <- c("id")
  
  if (ptau217) vars <- c(vars, "ptau217")
  if (APOE4) vars <- c(vars, "APOE4")
  if (Fazekas) vars <- c(vars, "Fazekas")
  if (Fazekas_burden_v) vars <- c(vars, "Fazekas_burden_v")
  if (Fazekas_burden_d) vars <- c(vars, "Fazekas_burden_d")
  if (Fazekas_burden_mix) vars <- c(vars, "Fazekas_burden_mix")
  if (WMH) vars <- c(vars, "WMH")
  if (lacuna) vars <- c(vars, "lacuna")
  if (serve_lacuna) vars <- c(vars, "serve_lacuna")
  if (infarction) vars <- c(vars, "infarction")
  if (chm) vars <- c(vars, "chm")
  if (burden) vars <- c(vars, "burden")
  if (burden2) vars <- c(vars, "burden2")
  if (burdenf) vars <- c(vars, "burdenf")
  
  # 提取存在变量
  vars_exist <- vars[vars %in% names(d_scvd)]
  d_sub <- d_scvd[, vars_exist]
  
  # 合并
  x <- x %>%
    dplyr::select(-any_of(setdiff(vars_exist, "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}



#隐私差分----
library(diffpriv)

mask_df <- function(df, 
                           noise_level = 0.1, 
                           skip_cols = c("id"), 
                           seed = 42) {
  set.seed(seed)
  df_masked <- df
  
  for (col in names(df)) {
    if (col %in% skip_cols) next
    
    vec <- df[[col]]
    
    if (is.numeric(vec)) {
      # 数值型：加噪声（基于标准差比例）
      sd_val <- sd(vec, na.rm = TRUE)
      noise <- rnorm(length(vec), mean = 0, sd = noise_level * sd_val)
      df_masked[[col]] <- vec + noise
      
    } else if (is.factor(vec) || is.character(vec)) {
      # 分类变量：随机打乱或采样
      df_masked[[col]] <- sample(vec, length(vec), replace = FALSE)
      
    } else if (is.logical(vec)) {
      # 布尔型：按概率翻转
      flip <- rbinom(length(vec), 1, noise_level)
      df_masked[[col]] <- ifelse(flip == 1, !vec, vec)
      
    } else if (inherits(vec, "Date") || inherits(vec, "POSIXct")) {
      # 日期型：加减随机天数
      offset <- sample(-30:30, length(vec), replace = TRUE)
      df_masked[[col]] <- vec + offset
      
    } else {
      message("跳过无法识别的列：", col)
    }
  }
  
  return(df_masked)
}


