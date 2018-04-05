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
 # TODO: use merge function for branch and node?
 branch$x <- NULL
 branch$y <- NULL
 branch$z <- NULL
 json_node <- neurostrcpp::compute_node_features(file)
 node <- read_json(json_node)
 dplyr::left_join(node, branch,  by = c("neuron", "neurite", "neurite_type", "branch", "node"))
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
compute_features <- function(file, layer) {
  db <- get_neurostr_features(file)
  db <- format_neurostr(db)
  db <- add_custom_vars(db, layer)
  format_vars(db)
}
