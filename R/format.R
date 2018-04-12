# No other code should depend on these being called. Should be called on end.
format_neurostr <- function(db) {
  db <- neurostrplus::convert2lm(db)
  vars <- colnames(db)
  vars <- gsub('^node_length$', 'compartment_length', vars)
  vars <- gsub('^node_root_dist$', 'euclidean_dist', vars)
  vars <- gsub('^node_root_path$', 'path_dist', vars)
  vars
  colnames(db) <- vars
  db
}
