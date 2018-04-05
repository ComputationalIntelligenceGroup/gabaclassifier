# features <- add_scale_vars(features, thickness)
# features <- add_laminar_features(features, thickness)
count_b_sv_term <- function(branch_id, cell) {
  child <- paste0(branch_id, '-', 1:2)
  tips <- subset(cell, branch %in% child & is_terminal)

  preter <- subset(cell, branch == branch_id & is_pre_terminal)[, c('x', 'y', 'z')]
  preter <- as.matrix(preter)[1, ]
  tips <- as.matrix(tips[, c('x', 'y', 'z')])
  sum(apply(tips, 1, is_short_vert, preter ))
}
is_short_vert <- function(term, parent) {
 dy <- abs(parent['y'] - term['y'])
 dx <- abs(parent['x'] - term['x'])
 unname(dy < 50 & dx < (dy / 2))
}
count_short_vertical_terminals <- function(cell) {
  pret <- subset(cell, is_pre_terminal)$branch
  if (length(pret) == 0) return(NA)
  pret <- unique(pret)
  sum(sapply(pret, count_b_sv_term, cell))
}
add_derived <- function(dataset) {
  dataset$density_bifs <- dataset$N_bifurcations / dataset$total_length
  dataset$density_dist <-  dataset$path_dist.max / dataset$total_length
  dataset$density_area <-  dataset$grid_area / dataset$total_length
  dataset$ratio_x <- dataset$width / dataset$x_sd
  dataset$ratio_y <- dataset$height / dataset$y_sd
  dataset
}

add_derived_dend <- function(dataset) {
  dataset <- add_derived(dataset)
  dataset$tree_length.avg <- dataset$total_length / dataset$N_stems
  dataset
}

#' Compute all custom non-rotated
compute_custom_vars <- function(all_neuron_nodes, layer, thickness) {
  stopifnot(length(unique(all_neuron_nodes$neurite_type)) == 1)
  l1 <- compute_l1_probs(all_neuron_nodes, layer, thickness)
  tips <- plyr::ddply(all_neuron_nodes, ~ neuron, compute_tips_vars)
  colnames(tips)[-1] <- paste0('tips_', colnames(tips)[-1])
  # Just make sure they all match in row names

  db <- merge(l1, tips, by = 'neuron')
  sholl <- plyr::ddply(all_neuron_nodes, ~ neuron, compute_all_sholl)
  colnames(sholl)[-1] <- paste0('sholl_', colnames(sholl)[-1])
  db <- merge(db, sholl, by = 'neuron')

  grid <- plyr::ddply(all_neuron_nodes, ~ neuron, compute_grid)
  colnames(grid)[-1] <- paste0('grid_', colnames(grid)[-1])
  db <- merge(db, grid, by = 'neuron')



  rownames(db) <- db$neuron
  db$neuron <- NULL
  db
}
compute_tips_vars <- function(neuron) {
  td <- compute_tips_distances(neuron)
  summarize_tips_distances(td)
}
#' Compute custom rotated vars, after fan-in projection
compute_custom_rotated_vars <- function(all_neuron_nodes, layer, thickness) {
  stopifnot(length(unique(all_neuron_nodes$neurite_type)) == 1)
  uw_l1 <- plyr::ddply(all_neuron_nodes, ~ neuron, upper_width)
  l1 <- compute_l1_probs(all_neuron_nodes, layer, thickness)
  uw_l1[- 1] <- uw_l1[ -1]  * l1[ ,'l1_prob']
  colnames(uw_l1)[-1] <- paste0('l1_', colnames(uw_l1)[-1])

  horizontal <- plyr::ddply(all_neuron_nodes, ~ neuron, horizontal_growth)
  colnames(horizontal)[-1] <- paste0('horizontal_', colnames(horizontal)[-1])
  db <- merge(horizontal, uw_l1, by = 'neuron')

  rownames(db) <- db$neuron
  db$neuron <- NULL
  db
}
#' Compute metadata vars l1 and translaminar
#' @param  all_neuron_nodes nodes of all neurons
compute_l1_probs <- function(all_neuron_nodes, layer, t) {
  stopifnot(length(unique(all_neuron_nodes$neurite_type)) == 1)
  # get ids of neurons
  ids <- unique(all_neuron_nodes$neuron)
  # get layers
  stopifnot(all(ids %in% names(layer)))
  layers <- as.character(layer[ids])
  # get layers thicknesses
  thick <- setNames(t$thickness, t$layer)
  sds <- setNames(t$thickness_sd, t$layer)
  inds <- setNames(seq_along(ids), ids)
  probs <- vapply(inds, function(i) {
   nodes <- subset(all_neuron_nodes, neuron == ids[i])
   layer <- layers[i]
   l1 <- neurostrr::prob_l1(neuron = nodes, layer, thick, sds)
   trans <- compute_prob_translaminar(neuron = nodes, layer, thick, sds, assume_middle = TRUE)
   c(l1, trans)
  }, FUN.VALUE = numeric(2))
  data.frame(neuron = colnames(probs), l1_prob = probs[1,  ], translaminar = probs[2, ])
}
# compute_translaminar <- function(neuron, layer, thicknesses, assume_middle = assume_middle) {
#   stopifnot(length(unique(neuron$neuron)) == 1)
#   neuron <- subset(neuron, neurite_type == 'Axon')
#   above_height <- max(max(neuron[, 'y']), 0)
#   below_height <- abs(min(min(neuron[, 'y']), 0))
#   thickness <-  thicknesses[as.character(layer)]
#   laminar_height <- min(thickness / 2, below_height) + min(thickness / 2, above_height)
#   height <- above_height  + below_height
#   laminar_height / height
# }
#' Compute translaminar
compute_prob_translaminar <- function(neuron, layer, thicknesses, sds, assume_middle = assume_middle) {
  stopifnot(length(unique(neuron$neuron)) == 1,
            length(unique(neuron$neurite_type)) == 1,
            is.character(layer))
  thickness <-  thicknesses[layer]
  sd <- sds[layer]
  above_height <- max(max(neuron[, 'y']), 0)
  pabove <- compute_prob_translaminar_side(above_height, thickness, sd)
  below_height <- abs(min(min(neuron[, 'y']), 0))
  pbelow <- compute_prob_translaminar_side(below_height, thickness, sd)
  if (layer == '6') pbelow <- 0
  max(pabove, pbelow)
}
compute_origin <- function(cell) {
  init <- subset(cell, is_initial)[1, 'y']
  if (length(init) == 0) {
    return (rep(NA, 2) )
  }
  # bifur <- subset(cell, branch == '1-1')[1, 'y']
  #
  # if (length(bifur ) == 0) {
  #   return (init = unlist(init), bifur = NA)
  # }
  # third <- subset(cell, branch == '1-1-1')[1, 'y']
  # third2 <- subset(cell, branch == '1-1-2')[1, 'y']
  # third3 <- subset(cell, branch == '1-1-1-1')[1, 'y']
  # third4 <- subset(cell, branch == '1-1-1-2')[1, 'y']

  # a <- c(init = unlist(init), bifur = unlist(bifur))
  # if (!(length(a) == 2)) browser()
  # a

  sube <- subset(cell, x > 100)
  above <- min(sube$path_dist)
  if (is.infinite(above)) above <- 0
  sube <- subset(cell, x < -100)
  below <- min(sube$path_dist)
  if (is.infinite(below)) below <- 0
  c(above = above, below = below)
  c(init = unlist(init), above_below = below - above)
}
compute_prob_translaminar_side <- function(height, thickness, sd) {
  pnorm(height, mean = thickness / 2, sd = sd / 4)
  # pnorm(height, mean = thickness / 2 + 100, sd = 50)
}
#' MC upper part specific width
#'
#' Considers symmetry in X (mean X), width in X, and the growth direction (mainly vertical or horizontal)
#' Note: for growth direction, the parent (or child) of segment may not be in the upper 165 part, but not very important
upper_width <- function(neuron) {
  stopifnot(all(neuron$neurite_type == 'Axon'))
  maxy <- max(neuron$y)
  miny <- maxy - 165
  neuron <- subset(neuron, y >= miny & y <= maxy)
  # how much it grows in x; probably correlated to x_sd
  cxo <- sum(abs(neuron$change_x))
  cx <- sum(sign(neuron$x)* neuron$change_x)
  cy <- sum(abs(neuron$change_y))
  # This normalized segments; probably should not do it.
  # coso <- neuron$change_x  / neuron$change_y
  # coso[is.infinite(coso)] <- 1
  # coso <- sum(coso * sign(neuron$x))
  bifs <- subset(neuron, N_descs > 1)
  c(mean = mean(neuron$x), std_mean = mean(neuron$x) / sd(neuron$x), width = diff(range(neuron$x)), bifs = nrow(bifs), cx = cx, cy = cy, cxo = cxo)
}
horizontal_growth <- function(neuron) {
  stopifnot(length(unique(neuron$neurite_type)) == 1)
  cxo <- sum(abs(neuron$change_x))
  cx <- sum(sign(neuron$x)* neuron$change_x)
  cyo <- sum(abs(neuron$change_y))
  c(cx = cx, cxo = cxo, cyo = cyo, horizontal_growth = cx / cxo)
  # length = sum(neuron$node_length)
  # length = length
  # meanx = mean(ake$x),
  # sign = sign,
  # sign <- sum(sign(neuron$x) * sign(neuron$change_x))
}
compute_far <- function(cell) {
   # med <- sum(cell$euclidean_dist > 300 & cell$euclidean_dist < 600)
  cell <- cell[!is.na(cell$N_descs), ]
  far <- sum(cell$euclidean_dist > 150)
  near <- sum(cell$euclidean_dist < 150)
  # c(near = near, med = med, far = far, total = nrow(cell))
  c(abs = near, prop = near / (near + far), total = nrow(cell))
}
compute_all_sholl <- function(neuron) {
  stopifnot(length(unique(neuron$neurite_type)) == 1)
  vert <- compute_vert_sholl(neuron)
  horiz <- compute_horiz_sholl(neuron)
  sholl <- compute_sholl(neuron)
  # fat <- compute_sholl(neuron, bins <- c(seq(0, 900, by = 300) ))
  far <- compute_far(neuron)
  # c(vert = vert, horiz = horiz, sholl, large = fat, far = far)
  c(vert = vert, horiz = horiz, local = far, sholl)
}
get_sholl_bins <- function() {
  c(seq(0, 50 * 40 , by = 20) )
}
compute_vert_sholl <- function(cell) {
  bins <- get_sholl_bins()
  reps <- shollize(abs(cell$y), bins, cell$branch)
  # c(sd = sd(reps), mean = mean(reps), median = median(reps))
  c(sd = sd(reps), mean = mean(reps))
}
compute_horiz_sholl <- function(cell) {
  bins <- get_sholl_bins()
  reps <- shollize(abs(cell$x), bins, cell$branch)
  c(sd = sd(reps), mean = mean(reps))
}
compute_sholl <- function(cell, bins = get_sholl_bins() ) {
  reps <- shollize(cell$euclidean_dist, bins, cell$branch)
  c(sd = sd(reps), mean = mean(reps))
}
shollize <- function(x, bins, branch) {
  binni <- cut(x, bins)
  names(bins)[2:length(bins)] <- levels(binni)
  sholl <- tapply(branch, binni, identity)
  sholl <- lapply(sholl, unique)
  sholl <- sapply(sholl, length)
  reps <- mapply(rep, bins[names(sholl)], sholl)
  unlist(reps)
}
compute_kbox <- function(cell) {
 boxes <- seq(10, 600, by = 10)
 bins <- lapply(boxes, function(x) seq(-2000, 2000, by = x))
 res <- lapply(bins, function(bin) gridize(cell$x, cell$y, bin, cell$branch)      )
 lens <- sapply(res, length)
 ake <- data.frame(r = log(1 / boxes), y = log(lens))
 lm <- lm(y ~ r, ake)
 lm$coefficients[['r']]
}
compute_grid <- function(cell) {
  # bins <- seq(-140, 140, by = 20)
  # reps <- gridize(cell$x, cell$y, bins, cell$branch)
  # local <- rep(NA, 4)
  # if (length(reps) > 0) {
  #   local <- c(sd = sd(reps), mean = mean(reps), len = length(reps), singleton = sum(reps == 1))
  # }

  bins <- seq(-2000, 2000, by = 20)
  reps <- gridize(cell$x, cell$y, bins, cell$branch)
  global <- c(sd = sd(reps), mean = mean(reps), area = length(reps), singleton = sum(reps == 1))

  bins <- seq(-2000, 2000, by = 100)
  reps <- gridize(cell$x, cell$y, bins, cell$branch)
  coarse <- c(sd = sd(reps), mean = mean(reps),  area = length(reps), singleton = sum(reps == 1))

  # bins <- seq(-2000, 2000, by = 200)
  # reps <- gridize(cell$x, cell$y, bins, cell$branch)
  # vcoarse <- c(sd = sd(reps), mean = mean(reps), len = length(reps), singleton = sum(reps == 1))

  c(global, coarse = coarse)
}
gridize <- function(x, y, bins, branch) {
  binnx <- cut(x, bins)
  binny <- cut(y, bins)
  bin_full <- paste0(as.character(binnx), as.character(binny))
  bin_full[grep('NA', bin_full)] <- NA

  sholl <- tapply(branch, bin_full, identity)
  sholl <- lapply(sholl, unique)
  sholl <- sapply(sholl, length)
  sholl
}
#' Nearest tips
compute_tips_distances <- function(neuron) {
  stopifnot(length(unique(neuron$neurite_type)) == 1,
            length(unique(neuron$neuron)) == 1)
  terminals <- subset(neuron, is_terminal)
  terminals <- terminals[ , c('x', 'y', 'z')]
  # soma <- get_soma_centroid(neuron)
  # soma <- c(0, 0, 0)
  # apply(terminals, 1, function(x) mlearn::compute_euclidean(x, soma))
  d <- dist(terminals)
  d <- as.matrix(d)
  diag(d) <- Inf
  # apply(d, 1, function(x) sort(x)[1:1])
  # maxs <- apply(d, 1, function(x) max(sort(x)[1:1]))
  # means <- apply(d, 1, function(x) mean(sort(x)[1:1]))
  # medians <- apply(d, 1, function(x) median(sort(x)[1:1]))
  # cbind(max = maxs, mean = means, median = medians)
  apply(d, 1, function(x) min(x))
}
summarize_tips_distances <- function(data) {
  # d <- apply(data, 2, function(x) c(mean = mean(x), sd = sd(x), median = median(x), max = max(x)))
  # unlist(as.data.frame(d), use.names = TRUE)
  x <- data
  c(mean = mean(x), sd = sd(x), median = median(x), max = max(x))
}
#  ===================================================================================================
#  Dendrite insertion points
#  ===================================================================================================
get_insertion_points <- function(id) {
  n <- neuro:::read_swc(paste0('~/code/bbp-data/data/BBP_SWC/', id, '.swc'))
  btc <- subset(n, Label %in% c(3, 4))
  soma <- neuro::filter_soma(n)
  init <- btc$Parent %in% soma$PointNo
  as.matrix(btc[init ,c('X','Y')])
}
replicate_insert_points <-  function(lens, points) {
  reps <- lapply(seq_len(nrow(points)), function(i) matrix(rep(points[i, ], each = lens[i]), ncol  = 2))
  Reduce(rbind, reps)
  # all <- matrix(unlist(all), ncol = 3)
}
get_lens <- function(id) {
  btc <- subset(full_neurons, neuron == id)
  btc <- neurostrr::filter_neurite(btc, axon = FALSE)
  floor(compute_dend_lens(btc))
}
compute_eccent_insertion <- function(id) {
  points <- get_insertion_points(id )
  # plot_insertion_points(id)
  lens <- get_lens(id)
  a <- replicate_insert_points(lens = lens, points)
  stopifnot(nrow(a) == sum(lens))
  a <- cbind(a, z = 0)
  colnames(a) <- c('x', 'y', 'z')
  eccs <- neurostrr:::compute_pca_vars(a)[c('eccentricity', 'vertical')]
  # result <- c(eccs, max_dist = max(dist(points)))
  result <- eccs
  if (nrow(points) == 1) {
   result[] <- 0
  }
  result
}
