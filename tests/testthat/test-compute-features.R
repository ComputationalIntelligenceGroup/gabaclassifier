context("general")

test_that("vector2df", {
  df <- vector2dataframe(setNames(letters, letters) )
  expect_equal(colnames(df), letters)
  expect_equal(nrow(df), 1)
})

test_that("Classify", {
  file <- '/home/bmihaljevic/code/bbp-data/data/BBP_SWC/C030502A.swc'
  layer <- '23'
  classify_interneuron(file, layer)
})
