test_that("Compute features nominal", {
  file <- '/home/bmihaljevic/code/bbp-data/data/BBP_SWC/C030502A.swc'
  # todo: put this inside
  layer <- setNames(object =  c('23'), 'C030502A.swc')
  db <- compute_features(file, layer)
  expect_equal(dim(db), c(1, 291))
})


test_that("Compute features for multiple neurons", {
})

test_that("Compute features for a neuron not in trainig data", {
# TODO
})
