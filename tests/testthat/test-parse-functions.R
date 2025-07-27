# Tests for data parsing functions
# 数据解析函数测试

test_that("parse_birth_date works correctly", {
  # Test various date formats
  dates <- c("1965年5月7日", "19650507", "1965.05.07", "1965/05/07", "1965-05-07")
  
  result <- parse_birth_date(dates)
  
  # All should parse to the same date
  expect_true(all(!is.na(result)))
  expect_true(all(result == result[1], na.rm = TRUE))
  
  # Test with NA input
  expect_true(is.na(parse_birth_date(NA)))
  
  # Test with empty string
  expect_true(is.na(parse_birth_date("")))
})

test_that("clean_numeric works correctly", {
  # Test basic numeric extraction
  messy_numbers <- c("123.45kg", "67.8cm", "45mg/dl")
  result <- clean_numeric(messy_numbers)
  
  expect_equal(result, c(123.45, 67.8, 45))
  
  # Test with pure numbers
  pure_numbers <- c("123", "45.67")
  expect_equal(clean_numeric(pure_numbers), c(123, 45.67))
  
  # Test with NA
  expect_true(is.na(clean_numeric(NA)))
})

test_that("clean_and_convert works correctly", {
  # Test various formats
  messy_data <- c("1,234.56", " 789.01 ", "2.5e-3")
  result <- clean_and_convert(messy_data)
  
  expect_equal(result[1], 1234.56)
  expect_equal(result[2], 789.01)
  expect_equal(result[3], 0.0025)
  
  # Test with scientific notation
  sci_notation <- "1.5e+3"
  expect_equal(clean_and_convert(sci_notation), 1500)
})

test_that("parse_demo handles missing parameters correctly", {
  # Check if d_demo.csv exists in data folder
  demo_file <- file.path("../../data/d_demo.csv")
  if (file.exists(demo_file)) {
    test_data <- data.frame(id = 1:3)
    
    # Test with minimal parameters
    result <- parse_demo(test_data, age = TRUE, sex = TRUE)
    
    expect_true("age" %in% names(result) || "sex" %in% names(result))
    expect_equal(nrow(result), 3)
    
    # Test with BMI calculation
    result_bmi <- parse_demo(test_data, age = TRUE, sex = TRUE, bmi = TRUE)
    expect_true("bmi" %in% names(result_bmi) || "age" %in% names(result_bmi))
  } else {
    skip("d_demo.csv file not found in data folder")
  }
})

test_that("parse_neuro handles cognitive variables correctly", {
  # Check if d_neuro.csv exists in data folder
  neuro_file <- file.path("../../data/d_neuro.csv")
  if (file.exists(neuro_file)) {
    test_data <- data.frame(id = 1:3)
    
    # Test cognition parsing
    result <- parse_neuro(test_data, mmse_moca = TRUE)
    
    expect_true("mmse_score" %in% names(result) || "moca_score" %in% names(result))
    expect_equal(nrow(result), 3)
  } else {
    skip("d_neuro.csv file not found in data folder")
  }
})

test_that("parse_msk handles musculoskeletal variables correctly", {
  # Create sample MSK data and assign to global environment
  db <- data.frame(
    UserID = 1:3,
    frax_score = c(15.2, 8.7, 22.1),
    bone_density = c(0.85, 0.92, 0.78)
  )
  assign("db", db, envir = .GlobalEnv)
  
  # Assign to global environment for function to find
  assign("db", db, envir = .GlobalEnv)
  
  test_data <- data.frame(id = 1:3)
  
  # Test MSK parsing with default parameters
  result <- parse_msk(test_data)
  
  expect_true("id" %in% names(result))
  expect_equal(nrow(result), 3)
  
  # Clean up
  rm(db, envir = .GlobalEnv)
})

test_that("Functions handle edge cases properly", {
  # Skip if d_demo.csv doesn't exist
  demo_file <- "data/d_demo.csv"
  if (!file.exists(demo_file)) {
    skip("d_demo.csv file not found")
  }
  
  # Test with empty data frame (must have id column)
  empty_df <- data.frame(id = integer(0))
  result_empty <- parse_demo(empty_df, age = TRUE)
  expect_equal(nrow(result_empty), 0)
  
  # Test single row data frame
  single_row <- data.frame(
    id = 1,
    existing_var = "test"
  )
  result_single <- parse_demo(single_row, age = TRUE, sex = TRUE)
  expect_equal(nrow(result_single), 1)
  
  # Test data frame with all NA values
  na_df <- data.frame(
    id = c(1, 2, 3),
    existing_var = c(NA, NA, NA)
  )
  result_na <- parse_demo(na_df, age = TRUE, sex = TRUE)
  expect_equal(nrow(result_na), 3)
})