# this shoudl replace neurostrr:::read_branch
read_json <- function(json) {
  a <- jsonlite::fromJSON(json)
  cols <- setdiff(colnames(a), 'measures')
  a <- cbind(a[, cols], a$measures)
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
format <- function(db) {
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
  db_axon <- compute_axon_vars(db, layer, t )
  db_axon <- add_derived(db_axon)
  # orig <- db_axon
  db_axon

  # todo: add dendrite vars!!!
  # todo: add terminal vars!!!
  # todo: check: no columns missing wrt to the dataset model was trained with. maybe can access it through model object.
}
compute_features <- function(file, layer) {
  db <- get_neurostr_features(file)
  db <- format(db)
  db <- format(db)
  add_custom_vars(db, layer)
}
