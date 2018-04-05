# No other code should depend on these being called. Should be called on end.
format_neurostr <- function(db) {
  db <- neurostrr::convert2lm(db)
  vars <- colnames(db)
  vars <- gsub('^node_length$', 'compartment_length', vars)
  vars <- gsub('^node_root_dist$', 'euclidean_dist', vars)
  vars <- gsub('^node_root_path$', 'path_dist', vars)
  vars
  colnames(db) <- vars
  db
}

format_vars <- function(db) {
  ind_vert <- grep('vertical', colnames(db))
  # stopifnot(length(ind_vert) == 4)
  # TODO uncomment above
  colnames(db) <- gsub('^vertical', 'radial', colnames(db))
  colnames(db) <- gsub('\\.vertical', '.radial', colnames(db))
  db$l1_cy <- NULL
  db$l1_mean <- NULL

  colnames(db) <- gsub('_cx', '_gx', colnames(db))
  colnames(db) <- gsub('_gxo', '_gxa', colnames(db))
  colnames(db) <- gsub('origin_init', 'axon_origin', colnames(db))
  colnames(db) <- gsub('origin_above_below', 'axon_above_below', colnames(db))
  colnames(db) <- gsub('short_vertical', 'short_vertical_terminals', colnames(db))

  db[ ,grep('x_std_mean', colnames(db))] <- NULL
  db[ ,grep('_min', colnames(db))] <- NULL
  db[ ,grep('_max', colnames(db))] <- NULL
  db[ ,grep('type_one', colnames(db))] <- NULL
  db[ ,grep('type_two', colnames(db))] <- NULL
  db[ ,grep('com\\.dist', colnames(db))] <- NULL
  # colnames(db)[grep('_max', colnames(db))]

  grid_density <- db$grid_coarse.area / db$grid_area

  grid <- colnames(db)[grep('grid', colnames(db))]
  grid <- setdiff(grid, c('grid_area', 'd.grid_area', 'grid_mean', 'd.grid_mean'))
  db[, grid] <- NULL
  # TODO: uncomment
  # db$grid_density <- grid_density
  db
}
