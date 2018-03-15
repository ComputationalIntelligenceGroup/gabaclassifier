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
 branch <- neurostrr::extend_branch(branch)
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

# now i compute variables. add metadata.

ids <- unique(db$neuron)
t <- get_layers_thickness()
thick <- setNames(t$thickness, t$layer)
sds <- setNames(t$thickness_sd, t$layer)
inds <- setNames(seq_along(ids), ids)

layer <- setNames(object =  c('23'), ids)

# source('~/code/neuro-intermorpho/R/functions.r')
# source('~/code/neuro-intermorpho/R/custom-funs.R')
library(neuroimm)
detach('package:neuroimm', unload = TRUE)
library(neuroimm)
db_axon <- compute_axon_vars(db, layer, t )
db_axon <- add_derived(db_axon)
# orig <- db_axon

# now i just need to classify this cell.

# notes:

# prune:
# var names identical for modelling to be possible
# **fun** <- 'list_branch_usable_measures'
# publishing this will also depend on metadata being available.


# **for a new cell, the metadata must be input!!!**
# that is why that function must change.

# todo tests

# todo: meta is actually not needed for prediction. maybe i will remove it.
# i just need laminar thickenss data, not meta.
# licence of blue brain data??? write to epfl people.

# todo vars computation
### check: compute_prob_translaminair


### CORREGIR EL NOMBRE DE LA NEURON EN NEUROSTRCPP


# Data
# - I need to include the metadata somewhere. bbp layer, laminar thickness.
# - It is contained in the final project. Pass it, formatted as data frame, to others. The others depend on its structure but that just so.
#
# about a 1000 cells at neuromorpho. use them!!!
#
# # pkgs
# - THere should be a package dedicated just to mapping between gardener and bbp. avoid duplication.
# - also neurostr to lmeasure mapping package similar to neurostrr


