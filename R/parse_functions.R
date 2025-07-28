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

#' @title 解析人口统计学数据 / Parse Demographic Data
#' @description 
#' 从人口统计学数据框中提取并合并指定变量。
#' Extract and merge specified variables from demographic data frame.
#' 
#' @param x 数据框，必须包含 'id' 变量 / Data frame that must contain 'id' variable
#' @param age 是否提取年龄 / Whether to extract age
#' @param sex 是否提取性别 / Whether to extract sex
#' @param education 是否提取教育程度 / Whether to extract education level
#' @param marriage 是否提取婚姻状况 / Whether to extract marital status
#' @param occupation 是否提取职业 / Whether to extract occupation
#' @param income 是否提取收入 / Whether to extract income
#' @param insurance 是否提取医疗保险 / Whether to extract medical insurance
#' @param smoking 是否提取吸烟状况 / Whether to extract smoking status
#' @param drinking 是否提取饮酒状况 / Whether to extract drinking status
#' @param bmi 是否提取BMI / Whether to extract BMI
#' @param height 是否提取身高 / Whether to extract height
#' @param weight 是否提取体重 / Whether to extract weight
#' 
#' @return 合并后的数据框 / Merged data frame
#' 
#' @examples
#' \dontrun{
#' # 提取年龄、性别和BMI
#' result <- parse_demo(my_data, age = TRUE, sex = TRUE, bmi = TRUE)
#' }
#' 
#' @export
parse_demo <- function(x,
                       age = FALSE,
                       sex = FALSE,
                       education = FALSE,
                       marriage = FALSE,
                       occupation = FALSE,
                       income = FALSE,
                       insurance = FALSE,
                       smoking = FALSE,
                       drinking = FALSE,
                       bmi = FALSE,
                       height = FALSE,
                       weight = FALSE) {
  
  # 尝试加载数据
  if (!exists("d_demo")) {
    possible_paths <- c(
      "d_demo.csv",
      "data/d_demo.csv",
      file.path(system.file(package = "HASr"), "data", "d_demo.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 d_demo.csv 文件: ", path)
        d_demo <- read.csv(path, stringsAsFactors = FALSE)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
      stop("找不到 d_demo 数据框，也未找到 d_demo.csv 文件。")
    }
  }
  
  # 验证输入
  if (!"id" %in% names(x)) {
    stop("x 必须包含 'id' 变量。")
  }
  if (!"UserID" %in% names(d_demo)) {
    stop("d_demo 必须包含 'UserID' 变量。")
  }
  
  # 变量映射
  var_map <- c(
    age = "age",
    sex = "sex",
    education = "education",
    marriage = "marriage",
    occupation = "occupation",
    income = "income",
    insurance = "insurance",
    smoking = "smoking",
    drinking = "drinking",
    bmi = "bmi",
    height = "height",
    weight = "weight"
  )
  
  # 选择被设置为 TRUE 的变量
  user_flags <- mget(names(var_map), envir = parent.frame(), ifnotfound = FALSE)
  selected_vars <- names(var_map)[unlist(user_flags)]
  demo_vars <- unname(var_map[selected_vars])
  demo_vars <- c("UserID", demo_vars)
  
  # 提取子集并重命名
  d_sub <- d_demo[, intersect(demo_vars, names(d_demo)), drop = FALSE]
  names(d_sub)[names(d_sub) == "UserID"] <- "id"
  
  # 合并数据
  x <- x %>%
    dplyr::select(-any_of(setdiff(names(d_sub), "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

#' @title 解析神经系统数据 / Parse Neurological Data
#' @description 
#' 从神经系统数据框中提取并合并指定变量。
#' Extract and merge specified variables from neurological data frame.
#' 
#' @param x 数据框，必须包含 'id' 变量 / Data frame that must contain 'id' variable
#' @param memory 是否提取记忆相关变量 / Whether to extract memory-related variables
#' @param fom 是否提取FOM评分 / Whether to extract FOM score
#' @param fluency 是否提取流畅性 / Whether to extract fluency
#' @param mmse_moca 是否提取MMSE/MoCA / Whether to extract MMSE/MoCA
#' @param vision_hearing 是否提取视听功能 / Whether to extract vision and hearing function
#' @param sleepiness 是否提取嗜睡评估 / Whether to extract sleepiness assessment
#' @param adl 是否提取ADL / Whether to extract ADL
#' @param iadl 是否提取IADL / Whether to extract IADL
#' @param falls 是否提取跌倒信息 / Whether to extract falls information
#' @param diagnosis 是否提取诊断信息 / Whether to extract diagnosis information
#' 
#' @return 合并后的数据框 / Merged data frame
#' 
#' @examples
#' \dontrun{
#' # 提取记忆和认知功能
#' result <- parse_neuro(my_data, memory = TRUE, mmse_moca = TRUE)
#' }
#' 
#' @export
parse_neuro <- function(x,
                        memory = FALSE,
                        fom = FALSE,
                        fluency = FALSE,
                        mmse_moca = FALSE,
                        vision_hearing = FALSE,
                        sleepiness = FALSE,
                        adl = FALSE,
                        iadl = FALSE,
                        falls = FALSE,
                        diagnosis = FALSE) {
  
  # 尝试加载数据
  if (!exists("d_neuro")) {
    possible_paths <- c(
      "d_neuro.csv",
      "data/d_neuro.csv",
      file.path(system.file(package = "HASr"), "data", "d_neuro.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 d_neuro.csv 文件: ", path)
        d_neuro <- read.csv(path, stringsAsFactors = FALSE)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
      stop("找不到 d_neuro 数据框，也未找到 d_neuro.csv 文件。")
    }
  }
  
  # 验证输入
  if (!"id" %in% names(x)) {
    stop("x 必须包含 'id' 变量。")
  }
  if (!"UserID" %in% names(d_neuro)) {
    stop("d_neuro 必须包含 'UserID' 变量。")
  }
  
  # 变量映射
  var_map <- c(
    memory = "memory",
    fom = "fom",
    fluency = "fluency",
    mmse_moca = "mmse_moca",
    vision_hearing = "vision_hearing",
    sleepiness = "sleepiness",
    adl = "adl",
    iadl = "iadl",
    falls = "falls",
    diagnosis = "diagnosis"
  )
  
  # 选择被设置为 TRUE 的变量
  user_flags <- mget(names(var_map), envir = parent.frame(), ifnotfound = FALSE)
  selected_vars <- names(var_map)[unlist(user_flags)]
  neuro_vars <- unname(var_map[selected_vars])
  neuro_vars <- c("UserID", neuro_vars)
  
  # 提取子集并重命名
  d_sub <- d_neuro[, intersect(neuro_vars, names(d_neuro)), drop = FALSE]
  names(d_sub)[names(d_sub) == "UserID"] <- "id"
  
  # 合并数据
  x <- x %>%
    dplyr::select(-any_of(setdiff(names(d_sub), "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

#' @title 解析骨骼肌肉系统数据 / Parse Musculoskeletal Data
#' @description 
#' 从骨骼肌肉系统数据框中提取并合并指定变量。
#' Extract and merge specified variables from musculoskeletal data frame.
#' 
#' @param x 数据框，必须包含 'id' 变量 / Data frame that must contain 'id' variable
#' @param prior_hip_fracture 是否提取既往髋部骨折史 / Whether to extract prior hip fracture history
#' @param parental_hip_fracture 是否提取父母髋部骨折史 / Whether to extract parental hip fracture history
#' @param current_smoking 是否提取当前吸烟状况 / Whether to extract current smoking status
#' @param alcohol_3units_per_day 是否提取每日3单位酒精摄入 / Whether to extract 3 units alcohol per day
#' @param glucocorticoids 是否提取糖皮质激素使用 / Whether to extract glucocorticoid use
#' @param rheumatoid_arthritis 是否提取类风湿关节炎 / Whether to extract rheumatoid arthritis
#' @param secondary_osteoporosis 是否提取继发性骨质疏松 / Whether to extract secondary osteoporosis
#' @param fracture_number 是否提取骨折数量 / Whether to extract fracture number
#' @param falls_last12mo 是否提取过去12个月跌倒 / Whether to extract falls in last 12 months
#' @param fall_count 是否提取跌倒次数 / Whether to extract fall count
#' @param falls_count 是否提取跌倒计数 / Whether to extract falls count
#' @param falls_fracture 是否提取跌倒骨折 / Whether to extract falls fracture
#' @param functional_status 是否提取功能状态 / Whether to extract functional status
#' @param CR 是否提取肌酐 / Whether to extract creatinine
#' @param T 是否提取睾酮 / Whether to extract testosterone
#' @param GDX1 是否提取GDX1 / Whether to extract GDX1
#' @param calc 是否提取钙 / Whether to extract calcium
#' @param phosp 是否提取磷 / Whether to extract phosphorus
#' @param vitd 是否提取维生素D / Whether to extract vitamin D
#' @param oc 是否提取骨钙素 / Whether to extract osteocalcin
#' @param tp1np 是否提取TP1NP / Whether to extract TP1NP
#' @param bctx 是否提取BCTX / Whether to extract BCTX
#' @param major_fracture_risk 是否提取主要骨折风险 / Whether to extract major fracture risk
#' @param hip_fracture_risk 是否提取髋部骨折风险 / Whether to extract hip fracture risk
#' @param any_fracture_5yr 是否提取5年任何骨折 / Whether to extract any fracture in 5 years
#' @param any_fracture_10yr 是否提取10年任何骨折 / Whether to extract any fracture in 10 years
#' @param hip_fracture_5yr 是否提取5年髋部骨折 / Whether to extract hip fracture in 5 years
#' @param hip_fracture_10yr 是否提取10年髋部骨折 / Whether to extract hip fracture in 10 years
#' @param sarcopenia_status 是否提取肌少症状态 / Whether to extract sarcopenia status
#' @param acr_score 是否提取ACR评分 / Whether to extract ACR score
#' @param acr_suspected_knee_oa 是否提取ACR疑似膝关节炎 / Whether to extract ACR suspected knee OA
#' @param koos_score_std 是否提取KOOS标准评分 / Whether to extract KOOS standardized score
#' @param koos_category 是否提取KOOS分类 / Whether to extract KOOS category
#' @param womac_score_std 是否提取WOMAC标准评分 / Whether to extract WOMAC standardized score
#' @param womac_category 是否提取WOMAC分类 / Whether to extract WOMAC category
#' @param vigorous_activity 是否提取剧烈活动 / Whether to extract vigorous activity
#' @param moderate_activity 是否提取中等活动 / Whether to extract moderate activity
#' @param light_activity 是否提取轻度活动 / Whether to extract light activity
#' @param sedentary_time 是否提取久坐时间 / Whether to extract sedentary time
#' @param total_activity_time 是否提取总活动时间 / Whether to extract total activity time
#' @param met_total 是否提取总MET / Whether to extract total MET
#' @param fall_binary 是否提取跌倒二分类 / Whether to extract fall binary
#' 
#' @return 合并后的数据框 / Merged data frame
#' 
#' @examples
#' \dontrun{
#' # 提取骨折风险和肌少症状态
#' result <- parse_msk(my_data, major_fracture_risk = TRUE, sarcopenia_status = TRUE)
#' }
#' 
#' @export
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
  
  # 尝试加载数据
  if (!exists("db")) {
    possible_paths <- c(
      "db.csv",
      "data/db.csv",
      file.path(system.file(package = "HASr"), "data", "db.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 db.csv 文件: ", path)
        db <- read.csv(path, stringsAsFactors = FALSE)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
      stop("找不到 db 数据框，也未找到 db.csv 文件。")
    }
  }
  
  # 验证输入
  if (!"id" %in% names(x)) {
    stop("x 必须包含 'id' 变量。")
  }
  if (!"UserID" %in% names(db)) {
    stop("db 必须包含 'UserID' 变量。")
  }
  
  # 变量映射
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
  
  # 提取子集并重命名
  d_sub <- db[, intersect(db_vars, names(db)), drop = FALSE]
  names(d_sub)[names(d_sub) == "UserID"] <- "id"
  names(d_sub) <- gsub("^K1$", "fall_count", names(d_sub))
  
  # 合并数据
  x <- x %>%
    dplyr::select(-any_of(setdiff(names(d_sub), "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

#' @title 解析心血管数据 / Parse Cardiovascular Data
#' @description 
#' 从心血管数据框中提取并合并指定变量。
#' Extract and merge specified variables from cardiovascular data frame.
#' 
#' @param x 数据框，必须包含 'id' 变量 / Data frame that must contain 'id' variable
#' @param lvdd 是否提取左心室舒张功能障碍 / Whether to extract left ventricular diastolic dysfunction
#' @param lv_enlargement 是否提取左心增大 / Whether to extract left ventricular enlargement
#' @param valvular_disease 是否提取瓣膜疾病 / Whether to extract valvular disease
#' @param pulmonary_hypertension 是否提取肺动脉高压 / Whether to extract pulmonary hypertension
#' @param pericardial_effusion 是否提取心包积液 / Whether to extract pericardial effusion
#' @param echo_measurements 是否提取超声心动图测量 / Whether to extract echocardiographic measurements
#' @param lvef 是否提取左心室射血分数 / Whether to extract left ventricular ejection fraction
#' @param hypertension_diagnosis 是否提取高血压诊断 / Whether to extract hypertension diagnosis
#' @param blood_pressure 是否提取血压 / Whether to extract blood pressure
#' @param heart_rate 是否提取心率 / Whether to extract heart rate
#' @param lipids 是否提取血脂 / Whether to extract lipids
#' @param carotid_imt 是否提取颈动脉IMT / Whether to extract carotid IMT
#' @param carotid_plaque 是否提取颈动脉斑块 / Whether to extract carotid plaque
#' @param carotid_stenosis 是否提取颈动脉狭窄 / Whether to extract carotid stenosis
#' 
#' @return 合并后的数据框 / Merged data frame
#' 
#' @examples
#' \dontrun{
#' # 提取血压和血脂
#' result <- parse_card(my_data, blood_pressure = TRUE, lipids = TRUE)
#' }
#' 
#' @export
parse_card <- function(x,
                       lvdd = FALSE,
                       lv_enlargement = FALSE,
                       valvular_disease = FALSE,
                       pulmonary_hypertension = FALSE,
                       pericardial_effusion = FALSE,
                       echo_measurements = FALSE,
                       lvef = FALSE,
                       hypertension_diagnosis = FALSE,
                       blood_pressure = FALSE,
                       heart_rate = FALSE,
                       lipids = FALSE,
                       carotid_imt = FALSE,
                       carotid_plaque = FALSE,
                       carotid_stenosis = FALSE) {
  
  # 尝试加载数据
  if (!exists("d_card")) {
    possible_paths <- c(
      "d_card.csv",
      "data/d_card.csv",
      file.path(system.file(package = "HASr"), "data", "d_card.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 d_card.csv 文件: ", path)
        d_card <- read.csv(path, stringsAsFactors = FALSE)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
      stop("找不到 d_card 数据框，也未找到 d_card.csv 文件。")
    }
  }
  
  # 验证输入
  if (!"id" %in% names(x)) {
    stop("x 必须包含 'id' 变量。")
  }
  if (!"UserID" %in% names(d_card)) {
    stop("d_card 必须包含 'UserID' 变量。")
  }
  
  # 变量映射
  var_map <- c(
    lvdd = "lvdd",
    lv_enlargement = "lv_enlargement",
    valvular_disease = "valvular_disease",
    pulmonary_hypertension = "pulmonary_hypertension",
    pericardial_effusion = "pericardial_effusion",
    echo_measurements = "echo_measurements",
    lvef = "lvef",
    hypertension_diagnosis = "hypertension_diagnosis",
    blood_pressure = "blood_pressure",
    heart_rate = "heart_rate",
    lipids = "lipids",
    carotid_imt = "carotid_imt",
    carotid_plaque = "carotid_plaque",
    carotid_stenosis = "carotid_stenosis"
  )
  
  # 选择被设置为 TRUE 的变量
  user_flags <- mget(names(var_map), envir = parent.frame(), ifnotfound = FALSE)
  selected_vars <- names(var_map)[unlist(user_flags)]
  card_vars <- unname(var_map[selected_vars])
  card_vars <- c("UserID", card_vars)
  
  # 提取子集并重命名
  d_sub <- d_card[, intersect(card_vars, names(d_card)), drop = FALSE]
  names(d_sub)[names(d_sub) == "UserID"] <- "id"
  
  # 合并数据
  x <- x %>%
    dplyr::select(-any_of(setdiff(names(d_sub), "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

#' @title 解析内分泌数据 / Parse Endocrine Data
#' @description 
#' 从内分泌数据框中提取并合并指定变量。
#' Extract and merge specified variables from endocrine data frame.
#' 
#' @param x 数据框，必须包含 'id' 变量 / Data frame that must contain 'id' variable
#' @param diabetes 是否提取糖尿病 / Whether to extract diabetes
#' @param glucose 是否提取血糖 / Whether to extract glucose
#' @param hba1c 是否提取糖化血红蛋白 / Whether to extract HbA1c
#' @param insulin 是否提取胰岛素 / Whether to extract insulin
#' @param homa_ir 是否提取HOMA-IR / Whether to extract HOMA-IR
#' @param tyg 是否提取TYG指数 / Whether to extract TYG index
#' @param insulin_resistance 是否提取胰岛素抵抗 / Whether to extract insulin resistance
#' @param lipids 是否提取血脂 / Whether to extract lipids
#' @param thyroid 是否提取甲状腺功能 / Whether to extract thyroid function
#' @param testosterone 是否提取睾酮 / Whether to extract testosterone
#' @param anthropometry 是否提取人体测量 / Whether to extract anthropometry
#' @param metabolic_syndrome 是否提取代谢综合征 / Whether to extract metabolic syndrome
#' 
#' @return 合并后的数据框 / Merged data frame
#' 
#' @examples
#' \dontrun{
#' # 提取糖尿病和代谢综合征
#' result <- parse_endo(my_data, diabetes = TRUE, metabolic_syndrome = TRUE)
#' }
#' 
#' @export
parse_endo <- function(x,
                       diabetes = FALSE,
                       glucose = FALSE,
                       hba1c = FALSE,
                       insulin = FALSE,
                       homa_ir = FALSE,
                       tyg = FALSE,
                       insulin_resistance = FALSE,
                       lipids = FALSE,
                       thyroid = FALSE,
                       testosterone = FALSE,
                       anthropometry = FALSE,
                       metabolic_syndrome = FALSE) {
  
  # 尝试加载数据
  if (!exists("d_endo")) {
    possible_paths <- c(
      "d_endo.csv",
      "data/d_endo.csv",
      file.path(system.file(package = "HASr"), "data", "d_endo.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 d_endo.csv 文件: ", path)
        d_endo <- read.csv(path, stringsAsFactors = FALSE)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
      stop("找不到 d_endo 数据框，也未找到 d_endo.csv 文件。")
    }
  }
  
  # 验证输入
  if (!"id" %in% names(x)) {
    stop("x 必须包含 'id' 变量。")
  }
  if (!"UserID" %in% names(d_endo)) {
    stop("d_endo 必须包含 'UserID' 变量。")
  }
  
  # 变量映射
  var_map <- c(
    diabetes = "diabetes",
    glucose = "glucose",
    hba1c = "hba1c",
    insulin = "insulin",
    homa_ir = "homa_ir",
    tyg = "tyg",
    insulin_resistance = "insulin_resistance",
    lipids = "lipids",
    thyroid = "thyroid",
    testosterone = "testosterone",
    anthropometry = "anthropometry",
    metabolic_syndrome = "metabolic_syndrome"
  )
  
  # 选择被设置为 TRUE 的变量
  user_flags <- mget(names(var_map), envir = parent.frame(), ifnotfound = FALSE)
  selected_vars <- names(var_map)[unlist(user_flags)]
  endo_vars <- unname(var_map[selected_vars])
  endo_vars <- c("UserID", endo_vars)
  
  # 提取子集并重命名
  d_sub <- d_endo[, intersect(endo_vars, names(d_endo)), drop = FALSE]
  names(d_sub)[names(d_sub) == "UserID"] <- "id"
  
  # 合并数据
  x <- x %>%
    dplyr::select(-any_of(setdiff(names(d_sub), "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

#' @title 解析免疫数据 / Parse Immune Data
#' @description 
#' 从免疫数据框中提取并合并指定变量。
#' Extract and merge specified variables from immune data frame.
#' 
#' @param x 数据框，必须包含 'id' 变量 / Data frame that must contain 'id' variable
#' @param inflammatory_markers 是否提取炎症标志物 / Whether to extract inflammatory markers
#' @param blood_cells 是否提取血细胞 / Whether to extract blood cells
#' @param vitamins 是否提取维生素 / Whether to extract vitamins
#' @param cytokines 是否提取细胞因子 / Whether to extract cytokines
#' @param inflammatory_indices 是否提取炎症指数 / Whether to extract inflammatory indices
#' @param inflammatory_groups 是否提取炎症分组 / Whether to extract inflammatory groups
#' 
#' @return 合并后的数据框 / Merged data frame
#' 
#' @examples
#' \dontrun{
#' # 提取炎症标志物和细胞因子
#' result <- parse_immo(my_data, inflammatory_markers = TRUE, cytokines = TRUE)
#' }
#' 
#' @export
parse_immo <- function(x,
                       inflammatory_markers = FALSE,
                       blood_cells = FALSE,
                       vitamins = FALSE,
                       cytokines = FALSE,
                       inflammatory_indices = FALSE,
                       inflammatory_groups = FALSE) {
  
  # 尝试加载数据
  if (!exists("d_immo")) {
    possible_paths <- c(
      "d_immo.csv",
      "data/d_immo.csv",
      file.path(system.file(package = "HASr"), "data", "d_immo.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 d_immo.csv 文件: ", path)
        d_immo <- read.csv(path, stringsAsFactors = FALSE)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
      stop("找不到 d_immo 数据框，也未找到 d_immo.csv 文件。")
    }
  }
  
  # 验证输入
  if (!"id" %in% names(x)) {
    stop("x 必须包含 'id' 变量。")
  }
  if (!"UserID" %in% names(d_immo)) {
    stop("d_immo 必须包含 'UserID' 变量。")
  }
  
  # 变量映射
  var_map <- c(
    inflammatory_markers = "inflammatory_markers",
    blood_cells = "blood_cells",
    vitamins = "vitamins",
    cytokines = "cytokines",
    inflammatory_indices = "inflammatory_indices",
    inflammatory_groups = "inflammatory_groups"
  )
  
  # 选择被设置为 TRUE 的变量
  user_flags <- mget(names(var_map), envir = parent.frame(), ifnotfound = FALSE)
  selected_vars <- names(var_map)[unlist(user_flags)]
  immo_vars <- unname(var_map[selected_vars])
  immo_vars <- c("UserID", immo_vars)
  
  # 提取子集并重命名
  d_sub <- d_immo[, intersect(immo_vars, names(d_immo)), drop = FALSE]
  names(d_sub)[names(d_sub) == "UserID"] <- "id"
  
  # 合并数据
  x <- x %>%
    dplyr::select(-any_of(setdiff(names(d_sub), "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

#' @title 解析脑小血管病数据 / Parse Small Cerebral Vessel Disease Data
#' @description 
#' 从脑小血管病数据框中提取并合并指定变量。
#' Extract and merge specified variables from small cerebral vessel disease data frame.
#' 
#' @param x 数据框，必须包含 'id' 变量 / Data frame that must contain 'id' variable
#' @param biomarkers 是否提取生物标志物 / Whether to extract biomarkers
#' @param genetic_markers 是否提取遗传标志物 / Whether to extract genetic markers
#' @param imaging_markers 是否提取影像学标志物 / Whether to extract imaging markers
#' 
#' @return 合并后的数据框 / Merged data frame
#' 
#' @examples
#' \dontrun{
#' # 提取生物标志物和影像学标志物
#' result <- parse_scvd(my_data, biomarkers = TRUE, imaging_markers = TRUE)
#' }
#' 
#' @export
parse_scvd <- function(x,
                       biomarkers = FALSE,
                       genetic_markers = FALSE,
                       imaging_markers = FALSE) {
  
  # 尝试加载数据
  if (!exists("d_scvd")) {
    possible_paths <- c(
      "d_scvd.csv",
      "data/d_scvd.csv",
      file.path(system.file(package = "HASr"), "data", "d_scvd.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 d_scvd.csv 文件: ", path)
        d_scvd <- read.csv(path, stringsAsFactors = FALSE)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
      stop("找不到 d_scvd 数据框，也未找到 d_scvd.csv 文件。")
    }
  }
  
  # 验证输入
  if (!"id" %in% names(x)) {
    stop("x 必须包含 'id' 变量。")
  }
  if (!"UserID" %in% names(d_scvd)) {
    stop("d_scvd 必须包含 'UserID' 变量。")
  }
  
  # 变量映射
  var_map <- c(
    biomarkers = "biomarkers",
    genetic_markers = "genetic_markers",
    imaging_markers = "imaging_markers"
  )
  
  # 选择被设置为 TRUE 的变量
  user_flags <- mget(names(var_map), envir = parent.frame(), ifnotfound = FALSE)
  selected_vars <- names(var_map)[unlist(user_flags)]
  scvd_vars <- unname(var_map[selected_vars])
  scvd_vars <- c("UserID", scvd_vars)
  
  # 提取子集并重命名
  d_sub <- d_scvd[, intersect(scvd_vars, names(d_scvd)), drop = FALSE]
  names(d_sub)[names(d_sub) == "UserID"] <- "id"
  
  # 合并数据
  x <- x %>%
    dplyr::select(-any_of(setdiff(names(d_sub), "id"))) %>%
    dplyr::left_join(d_sub, by = "id")
  
  return(x)
}

#' @title 数据隐私差分处理 / Data Privacy Differential Processing
#' @description 
#' 对数据框进行隐私差分处理，支持数值型、分类、布尔和日期型数据的加噪或随机化。
#' Apply differential privacy processing to data frame, supporting noise addition or randomization for numeric, categorical, boolean and date data.
#' 
#' @param df 数据框 / Data frame
#' @param epsilon 隐私预算参数 / Privacy budget parameter
#' @param numeric_noise_sd 数值型数据噪声标准差 / Standard deviation of noise for numeric data
#' @param categorical_prob 分类数据随机化概率 / Randomization probability for categorical data
#' @param date_noise_days 日期数据噪声天数 / Noise days for date data
#' 
#' @return 处理后的数据框 / Processed data frame
#' 
#' @examples
#' \dontrun{
#' # 对数据进行隐私差分处理
#' masked_data <- mask_df(my_data, epsilon = 1.0)
#' }
#' 
#' @export
mask_df <- function(df, epsilon = 1.0, numeric_noise_sd = 0.1, categorical_prob = 0.05, date_noise_days = 30) {
  
  if (!is.data.frame(df)) {
    stop("输入必须是数据框。")
  }
  
  if (epsilon <= 0) {
    stop("epsilon 必须大于 0。")
  }
  
  df_masked <- df
  
  for (col in names(df)) {
    if (is.numeric(df[[col]])) {
      # 数值型数据：添加拉普拉斯噪声
      noise <- stats::rlaplace(length(df[[col]]), location = 0, scale = numeric_noise_sd / epsilon)
      df_masked[[col]] <- df[[col]] + noise
      
    } else if (is.factor(df[[col]]) || is.character(df[[col]])) {
      # 分类数据：随机化
      n <- length(df[[col]])
      random_indices <- sample(1:n, size = round(n * categorical_prob))
      if (length(random_indices) > 0) {
        df_masked[[col]][random_indices] <- sample(df[[col]], length(random_indices), replace = TRUE)
      }
      
    } else if (is.logical(df[[col]])) {
      # 布尔数据：随机翻转
      n <- length(df[[col]])
      flip_indices <- sample(1:n, size = round(n * categorical_prob))
      if (length(flip_indices) > 0) {
        df_masked[[col]][flip_indices] <- !df_masked[[col]][flip_indices]
      }
      
    } else if (inherits(df[[col]], "Date") || inherits(df[[col]], "POSIXct")) {
      # 日期数据：添加随机天数
      noise_days <- sample(-date_noise_days:date_noise_days, length(df[[col]]), replace = TRUE)
      df_masked[[col]] <- df[[col]] + noise_days
    }
  }
  
  return(df_masked)
}

# 辅助函数：拉普拉斯分布随机数生成
rlaplace <- function(n, location = 0, scale = 1) {
  u <- stats::runif(n, -0.5, 0.5)
  location - scale * sign(u) * log(1 - 2 * abs(u))
}