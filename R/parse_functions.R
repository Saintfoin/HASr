#' @title 解析人口统计学数据 / Parse Demographic Data
#' @description 
#' 从人口统计学数据框中提取指定变量并合并到目标数据框中。
#' Extract specified variables from demographic data frame and merge into target data frame.
#' 
#' @param x 目标数据框，必须包含'id'变量 / Target data frame, must contain 'id' variable
#' @param age 逻辑值，是否提取年龄 / Logical, whether to extract age
#' @param age_group 逻辑值，是否提取年龄分组 / Logical, whether to extract age group
#' @param sex 逻辑值，是否提取性别 / Logical, whether to extract sex
#' @param education 逻辑值，是否提取教育程度 / Logical, whether to extract education
#' @param marital_status 逻辑值，是否提取婚姻状况 / Logical, whether to extract marital status
#' @param current_job 逻辑值，是否提取当前职业 / Logical, whether to extract current job
#' @param previous_job 逻辑值，是否提取既往职业 / Logical, whether to extract previous job
#' @param personal_income 逻辑值，是否提取个人收入 / Logical, whether to extract personal income
#' @param self_rated_income 逻辑值，是否提取自评收入 / Logical, whether to extract self-rated income
#' @param household_income 逻辑值，是否提取家庭收入 / Logical, whether to extract household income
#' @param medical_insurance 逻辑值，是否提取医疗保险 / Logical, whether to extract medical insurance
#' @param smoking 逻辑值，是否提取吸烟状况 / Logical, whether to extract smoking status
#' @param drinking 逻辑值，是否提取饮酒状况 / Logical, whether to extract drinking status
#' @param bmi 逻辑值，是否提取BMI / Logical, whether to extract BMI
#' @param bmi_group 逻辑值，是否提取BMI分组 / Logical, whether to extract BMI group
#' @param ses_index 逻辑值，是否提取社会经济地位指数 / Logical, whether to extract SES index
#' @param height_cm 逻辑值，是否提取身高(cm) / Logical, whether to extract height in cm
#' @param weight_kg 逻辑值，是否提取体重(kg) / Logical, whether to extract weight in kg
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
    # 尝试从多个可能的路径读取文件
    possible_paths <- c(
      "d_demo.csv",
      "data/d_demo.csv",
      file.path(system.file(package = "HASr"), "data", "d_demo.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 d_demo.csv 文件: ", path)
        d_demo <- read.csv(path)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
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

#' @title 解析神经系统数据 / Parse Neurological Data
#' @description 
#' 从神经系统数据框中提取指定变量并合并到目标数据框中。
#' Extract specified variables from neurological data frame and merge into target data frame.
#' 
#' @param x 目标数据框，必须包含'id'变量 / Target data frame, must contain 'id' variable
#' @param memory 逻辑值，是否提取记忆测试 / Logical, whether to extract memory tests
#' @param fom 逻辑值，是否提取FOM评分 / Logical, whether to extract FOM scores
#' @param fluency 逻辑值，是否提取流畅性测试 / Logical, whether to extract fluency tests
#' @param mmse_moca 逻辑值，是否提取MMSE/MoCA评分 / Logical, whether to extract MMSE/MoCA scores
#' @param vision_hearing 逻辑值，是否提取视听功能 / Logical, whether to extract vision/hearing function
#' @param sleepiness 逻辑值，是否提取嗜睡评估 / Logical, whether to extract sleepiness assessment
#' @param adl 逻辑值，是否提取日常生活能力 / Logical, whether to extract ADL
#' @param iadl 逻辑值，是否提取工具性日常生活能力 / Logical, whether to extract IADL
#' @param falls 逻辑值，是否提取跌倒相关 / Logical, whether to extract falls-related data
#' @param diagnostics 逻辑值，是否提取诊断信息 / Logical, whether to extract diagnostic information
#' 
#' @return 合并后的数据框 / Merged data frame
#' 
#' @examples
#' \dontrun{
#' # 提取认知功能和ADL评估
#' result <- parse_neuro(my_data, mmse_moca = TRUE, adl = TRUE)
#' }
#' 
#' @export
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
    # 尝试从多个可能的路径读取文件
    possible_paths <- c(
      "d_neuro.csv",
      "data/d_neuro.csv",
      file.path(system.file(package = "HASr"), "data", "d_neuro.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 d_neuro.csv 文件: ", path)
        d_neuro <- read.csv(path)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
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

#' @title 解析骨骼肌肉系统数据 / Parse Musculoskeletal Data
#' @description 
#' 从骨骼肌肉系统数据框中提取指定变量并合并到目标数据框中。
#' Extract specified variables from musculoskeletal data frame and merge into target data frame.
#' 
#' @param x 目标数据框，必须包含'id'变量 / Target data frame, must contain 'id' variable
#' @param prior_hip_fracture 逻辑值，是否提取既往髋部骨折史 / Logical, whether to extract prior hip fracture history
#' @param parental_hip_fracture 逻辑值，是否提取父母髋部骨折史 / Logical, whether to extract parental hip fracture history
#' @param current_smoking 逻辑值，是否提取当前吸烟状况 / Logical, whether to extract current smoking status
#' @param alcohol_3units_per_day 逻辑值，是否提取每日3单位以上饮酒 / Logical, whether to extract 3+ units alcohol per day
#' @param glucocorticoids 逻辑值，是否提取糖皮质激素使用 / Logical, whether to extract glucocorticoid use
#' @param rheumatoid_arthritis 逻辑值，是否提取类风湿关节炎 / Logical, whether to extract rheumatoid arthritis
#' @param secondary_osteoporosis 逻辑值，是否提取继发性骨质疏松 / Logical, whether to extract secondary osteoporosis
#' @param fracture_number 逻辑值，是否提取骨折数量 / Logical, whether to extract fracture number
#' @param falls_last12mo 逻辑值，是否提取过去12个月跌倒次数 / Logical, whether to extract falls in last 12 months
#' @param fall_count 逻辑值，是否提取跌倒计数 / Logical, whether to extract fall count
#' @param falls_count 逻辑值，是否提取跌倒总数 / Logical, whether to extract total falls count
#' @param falls_fracture 逻辑值，是否提取跌倒致骨折 / Logical, whether to extract falls with fracture
#' @param functional_status 逻辑值，是否提取功能状态 / Logical, whether to extract functional status
#' @param CR 逻辑值，是否提取肌酐 / Logical, whether to extract creatinine
#' @param T 逻辑值，是否提取睾酮 / Logical, whether to extract testosterone
#' @param GDX1 逻辑值，是否提取维生素D / Logical, whether to extract vitamin D
#' @param calc 逻辑值，是否提取钙 / Logical, whether to extract calcium
#' @param phosp 逻辑值，是否提取磷 / Logical, whether to extract phosphorus
#' @param vitd 逻辑值，是否提取维生素D / Logical, whether to extract vitamin D
#' @param oc 逻辑值，是否提取骨钙素 / Logical, whether to extract osteocalcin
#' @param tp1np 逻辑值，是否提取I型前胶原氨基端前肽 / Logical, whether to extract P1NP
#' @param bctx 逻辑值，是否提取β-CTX / Logical, whether to extract β-CTX
#' @param major_fracture_risk 逻辑值，是否提取主要骨折风险 / Logical, whether to extract major fracture risk
#' @param hip_fracture_risk 逻辑值，是否提取髋部骨折风险 / Logical, whether to extract hip fracture risk
#' @param any_fracture_5yr 逻辑值，是否提取5年任何骨折风险 / Logical, whether to extract 5-year any fracture risk
#' @param any_fracture_10yr 逻辑值，是否提取10年任何骨折风险 / Logical, whether to extract 10-year any fracture risk
#' @param hip_fracture_5yr 逻辑值，是否提取5年髋部骨折风险 / Logical, whether to extract 5-year hip fracture risk
#' @param hip_fracture_10yr 逻辑值，是否提取10年髋部骨折风险 / Logical, whether to extract 10-year hip fracture risk
#' @param sarcopenia_status 逻辑值，是否提取肌少症状态 / Logical, whether to extract sarcopenia status
#' @param acr_score 逻辑值，是否提取ACR评分 / Logical, whether to extract ACR score
#' @param acr_suspected_knee_oa 逻辑值，是否提取ACR疑似膝关节炎 / Logical, whether to extract ACR suspected knee OA
#' @param koos_score_std 逻辑值，是否提取KOOS标准化评分 / Logical, whether to extract KOOS standardized score
#' @param koos_category 逻辑值，是否提取KOOS分类 / Logical, whether to extract KOOS category
#' @param womac_score_std 逻辑值，是否提取WOMAC标准化评分 / Logical, whether to extract WOMAC standardized score
#' @param womac_category 逻辑值，是否提取WOMAC分类 / Logical, whether to extract WOMAC category
#' @param vigorous_activity 逻辑值，是否提取剧烈活动 / Logical, whether to extract vigorous activity
#' @param moderate_activity 逻辑值，是否提取中等活动 / Logical, whether to extract moderate activity
#' @param light_activity 逻辑值，是否提取轻度活动 / Logical, whether to extract light activity
#' @param sedentary_time 逻辑值，是否提取久坐时间 / Logical, whether to extract sedentary time
#' @param total_activity_time 逻辑值，是否提取总活动时间 / Logical, whether to extract total activity time
#' @param met_total 逻辑值，是否提取总MET值 / Logical, whether to extract total MET
#' @param fall_binary 逻辑值，是否提取跌倒二分类 / Logical, whether to extract fall binary
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
  
  if (!exists("db")) {
    # 尝试从多个可能的路径读取文件
    possible_paths <- c(
      "db.csv",
      "data/db.csv",
      file.path(system.file(package = "HASr"), "data", "db.csv")
    )
    
    file_found <- FALSE
    for (path in possible_paths) {
      if (file.exists(path)) {
        message("读取 db.csv 文件: ", path)
        db <- read.csv(path)
        file_found <- TRUE
        break
      }
    }
    
    if (!file_found) {
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