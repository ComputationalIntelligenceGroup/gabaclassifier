# this shoudl replace neurostrr:::read_branch
read_json <- function(json) {
  a <- neurostrcpp::json2dataframe(json)
  colnames(a) <-  gsub('^measures\\.', '', colnames(a))
  a
}
get_neurostr_features <- function(file) {
 json_branch <- neurostrcpp::compute_branch_features(file)
 branch <- read_json(json_branch)
 ## extend branch with is terminal etc. could be done initially in neurostrr.
 branch <- neurostrr::extend_branch(branch)
 branch$x <- NULL
 branch$y <- NULL
 branch$z <- NULL
 json_node <- neurostrcpp::compute_node_features(file)
 node <- read_json(json_node)
 dplyr::left_join(node, branch,  by = c("neuron", "neurite", "neurite_type", "branch", "node"))
}
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
add_custom_vars <- function(db, layer) {
  # now i compute variables. add metadata.
  ids <- unique(db$neuron)
  t <- get_layers_thickness()
  thick <- setNames(t$thickness, t$layer)
  sds <- setNames(t$thickness_sd, t$layer)
  inds <- setNames(seq_along(ids), ids)
  db_axon <- neuroimm::compute_axon_vars(db, layer, t )
  db_axon <- neuroimm::add_derived(db_axon)
  # orig <- db_axon
  db_axon
  # todo: add dendrite vars!!!
  # todo: add terminal vars!!!
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
compute_features <- function(file, layer) {
  db <- get_neurostr_features(file)
  db <- format_neurostr(db)
  db <- add_custom_vars(db, layer)
  format_vars(db)
}
