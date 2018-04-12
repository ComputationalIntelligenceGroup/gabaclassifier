context("general")

test_that("vector2df", {
  df <- vector2dataframe(setNames(letters, letters) )
  expect_equal(colnames(df), letters)
  expect_equal(nrow(df), 1)
})

test_that("Classify", {
  # file <- '/home/bmihaljevic/code/bbp-data/data/BBP_SWC/'
  file <- system.file('extdata', 'C030502A.swc', package = 'gabaclassifier')
  layer <- '23'
  class <- classify_interneuron(file, layer)
  expect_equal(as.character(class), 'NBC')
})
