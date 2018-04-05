#' Computes vars on a domain
compute_axon_vars <- function(data, layer, thickness) {
  data <- neurostrr::filter_neurite(data)
  stopifnot("Axon" == unique(data$neurite_type))
  db <- neurostrr::compute_vars_both(data)
  db_cust <- compute_custom_vars(data, layer, thickness)
  # rotated <- neurostrr::rotate_fan_in(data)
  rotated <-  data
  rotated[, 'z'] <- 0
  db_xy <- plyr::ddply(rotated, ~ neuron, neurostrr::extend_xyz)
  db_xy$neuron <- NULL
  db_cust_rot <- compute_custom_rotated_vars(rotated, layer, thickness)
  vertical_terms <- plyr::ddply(rotated, ~ neuron, count_short_vertical_terminals)
  vertical_terms$neuron <- NULL
  colnames(vertical_terms)[1] <- 'short_vertical'
  # cbind or merge custom_rotated

  origin <- plyr::ddply(rotated, ~ neuron, compute_origin)
  origin$neuron <- NULL
  colnames(origin) <- paste0('origin_', colnames(origin))

  cbind(db, db_xy, db_cust, db_cust_rot, vertical_terms, origin )
}
compute_dend_vars <- function(data) {
  data <- neurostrr::filter_neurite(data, axon = FALSE)
  stopifnot("Dendrite" == unique(data$neurite_type))
  db <- neurostrr::compute_vars_both(data)
  db_cust <- compute_custom_vars(data)
  rotated <- neurostrr::rotate_fan_in(data)
  db_xy <- plyr::daply(rotated, ~ neuron, neurostrr::extend_xyz)
  inser <- sapply(rownames(db), compute_eccent_insertion)
  inser <- t(inser)
  #  TODO!! remove this.
  load('mdist.rdata')
  mdist <- mdist[rownames(db)]
  mdist <- data.frame(displaced = unname(mdist))
  cbind(db, db_xy, db_cust, insert = inser, mdist)
}
list_unique_vars <- function(db) {
  cols <- colnames(db)
  cols <- gsub('\\..*$', '', cols)
  cols <- unique(cols)
  cols
}
# TODO: used??
compute_dend_lens <- function(neuron) {
  stopifnot(length(unique(neuron$neuron)) == 1,
            unique(neuron$neurite_type) == 'Dendrite')
  neurites <- dplyr::group_by(neuron, neurite)
  lens <- dplyr::summarise(neurites, length = sum(length, na.rm = TRUE))
  lens$length
}
