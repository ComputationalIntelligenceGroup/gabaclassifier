# this shoudl replace neurostrr:::read_branch
read_json <- function(json) {
  a <- jsonlite::fromJSON(json)
  cols <- setdiff(colnames(a), 'measures')
  a <- cbind(a[, cols], a$measures)
  colnames(a) <-  gsub('^measures\\.', '', colnames(a))
  a
}
get_features <- function(file) {
 json_branch <- neurostrcpp::compute_branch_features(file)
 branch <- read_json(json_branch)
 branch$x <- NULL
 branch$y <- NULL
 branch$z <- NULL
 json_node <- neurostrcpp::compute_node_features(file)
 node <- read_json(json_node)
 dplyr::left_join(node, branch,  by = c("neuron", "neurite", "neurite_type", "branch", "node"))
}

# get full neuron

# debugonce(get_features)
db <- get_features('/home/bmihaljevic/code/bbp-data/data/BBP_SWC/C030502A.swc')
head(db, n = 20)

## extend branch with is terminal etc. could be done initially in neurostrr.

# init prepare

# then i can apply convert 2 lm
db <- neurostrr::convert2lm(db)
vars <- colnames(db)
vars <- gsub('^node_length$', 'compartment_length', vars)
vars <- gsub('^node_root_dist$', 'euclidean_dist', vars)
vars <- gsub('^node_root_path$', 'path_dist', vars)
vars
colnames(db) <- vars

# notes:

# prune:
# var names identical for modelling to be possible
# **fun** <- 'list_branch_usable_measures'
