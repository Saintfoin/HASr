# Tests for utility functions
# 实用函数测试

test_that("plot_activity_by_sex creates valid ggplot object", {
  # Skip if ggplot2 is not available
  skip_if_not_installed("ggplot2")
  
  # Create sample activity data
  activity_data <- data.frame(
    sex = rep(c("Male", "Female"), each = 8),
    age_group = rep(c("55-64", "65-74", "75+", "55-64"), 4),
    activity_type = rep(c("High", "Moderate", "Low", "Sedentary"), each = 4),
    percent = c(25, 30, 20, 25, 20, 35, 25, 20, 30, 25, 25, 20, 15, 30, 30, 25)
  )
  
  # Test plot creation for males
  male_plot <- plot_activity_by_sex(activity_data, "Male")
  
  expect_s3_class(male_plot, "ggplot")
  
  # Test plot creation for females
  female_plot <- plot_activity_by_sex(activity_data, "Female")
  
  expect_s3_class(female_plot, "ggplot")
})

test_that("plot_activity_by_sex handles edge cases", {
  skip_if_not_installed("ggplot2")
  
  # Test with minimal data
  minimal_data <- data.frame(
    sex = "Male",
    age_group = "55-64",
    activity_type = "High",
    percent = 100
  )
  
  result <- plot_activity_by_sex(minimal_data, "Male")
  expect_s3_class(result, "ggplot")
  
  # Test with no matching sex
  no_match_data <- data.frame(
    sex = "Female",
    age_group = "55-64",
    activity_type = "High",
    percent = 100
  )
  
  # Should create plot but with no data
  result_empty <- plot_activity_by_sex(no_match_data, "Male")
  expect_s3_class(result_empty, "ggplot")
})

test_that("utility functions handle various input types", {
  # Test clean_numeric with different input types
  expect_equal(clean_numeric("123"), 123)
  expect_equal(clean_numeric("123.45"), 123.45)
  expect_equal(clean_numeric("123kg"), 123)
  expect_true(is.na(clean_numeric("abc")))
  expect_true(is.na(clean_numeric("")))
  
  # Test clean_and_convert with different formats
  expect_equal(clean_and_convert("1,234"), 1234)
  expect_equal(clean_and_convert(" 123 "), 123)
  expect_equal(clean_and_convert("1.5e2"), 150)
  expect_true(is.na(clean_and_convert("text")))
})

test_that("parse_birth_date handles various date formats", {
  # Test Chinese date format
  chinese_date <- "1965年5月7日"
  result1 <- parse_birth_date(chinese_date)
  expect_false(is.na(result1))
  
  # Test numeric format
  numeric_date <- "19650507"
  result2 <- parse_birth_date(numeric_date)
  expect_false(is.na(result2))
  
  # Test dot format
  dot_date <- "1965.05.07"
  result3 <- parse_birth_date(dot_date)
  expect_false(is.na(result3))
  
  # Test slash format
  slash_date <- "1965/05/07"
  result4 <- parse_birth_date(slash_date)
  expect_false(is.na(result4))
  
  # All should parse to the same date
  dates <- c(chinese_date, numeric_date, dot_date, slash_date)
  parsed_dates <- parse_birth_date(dates)
  
  # Check that all non-NA dates are the same
  unique_dates <- unique(parsed_dates[!is.na(parsed_dates)])
  expect_length(unique_dates, 1)
})

test_that("parse_birth_date handles edge cases", {
  # Test with 6-digit format (year-month only)
  short_date <- "196505"
  result <- parse_birth_date(short_date)
  expect_false(is.na(result))
  
  # Test with invalid dates
  invalid_dates <- c("invalid", "123", "abcd")
  results <- parse_birth_date(invalid_dates)
  expect_true(all(is.na(results)))
  
  # Test with mixed valid and invalid
  mixed_dates <- c("1965年5月7日", "invalid", "19650507")
  mixed_results <- parse_birth_date(mixed_dates)
  expect_equal(sum(!is.na(mixed_results)), 2)
})

test_that("Functions handle vector inputs correctly", {
  # Test clean_numeric with vector input
  vector_input <- c("123kg", "45.6cm", "78mg")
  vector_result <- clean_numeric(vector_input)
  expect_equal(vector_result, c(123, 45.6, 78))
  
  # Test clean_and_convert with vector input
  vector_input2 <- c("1,234", "5.67", "8.9e2")
  vector_result2 <- clean_and_convert(vector_input2)
  expect_equal(vector_result2, c(1234, 5.67, 890))
  
  # Test with empty vector
  empty_result <- clean_numeric(character(0))
  expect_length(empty_result, 0)
})

test_that("Functions preserve data types appropriately", {
  # Test that numeric functions return numeric
  expect_type(clean_numeric("123"), "double")
  expect_type(clean_and_convert("123"), "double")
  
  # Test that date function returns Date
  date_result <- parse_birth_date("1965-05-07")
  expect_s3_class(date_result, "POSIXct")
})

test_that("Functions handle special characters correctly", {
  # Test clean_numeric with various units
  units_test <- c("123kg", "45.6cm", "78mg/dl", "90%", "12.5°C")
  units_result <- clean_numeric(units_test)
  expect_equal(units_result, c(123, 45.6, 78, 90, 12.5))
  
  # Test clean_and_convert with special characters
  special_test <- c("1,234.56", "€123.45", "$67.89", "¥100")
  special_result <- clean_and_convert(special_test)
  expect_equal(special_result[1], 1234.56)
  expect_false(is.na(special_result[2]))
})

test_that("Error handling works correctly", {
  # Test that functions don't crash with unusual inputs
  expect_error(clean_numeric(NULL), NA)
  expect_error(clean_and_convert(NULL), NA)
  expect_error(parse_birth_date(NULL), NA)
  
  # Test with very long strings
  long_string <- paste(rep("a", 1000), collapse = "")
  expect_true(is.na(clean_numeric(long_string)))
  
  # Test with special values
  expect_true(is.na(clean_numeric(Inf)))
  expect_true(is.na(clean_numeric(-Inf)))
})