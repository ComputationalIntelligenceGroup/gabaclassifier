# TODO metadata should be removed from here
# read_metadata <- function(unclear_class = FALSE) {
#   path <- system.file("extdata", "metadata.csv", package = "gabaclassifier")
#   stopifnot(nchar(path) > 0)
#   m <- read.csv(path, row.names = 1, quote = "\"")
#   layers <- unique(as.character(m$layer))
#   m$layer <- factor(m$layer, levels = sort(layers))
#   if (!unclear_class) {
#     m <- m[!is.na(m$class), ]
#   }
#   m <- droplevels(m)
#   m
# }
read_layer_thickness <- function() {
  path <- system.file("extdata", "layer-thicknesses.csv", package = "gabaclassifier")
  stopifnot(nchar(path) > 0)
  thickness <- read.csv(path)
  stopifnot(sum(thickness$thickness) == 2082)
  thickness
}
get_layers_thickness <- function() {
  thickness <- read_layer_thickness()
  thickness[2, 'thickness'] <- thickness[2, 'thickness'] + thickness[3, 'thickness']
  # TODO: not sure if this is correct:
  thickness[2, 'thickness_sd'] <- thickness[2, 'thickness_sd'] + thickness[3, 'thickness_sd']
  thickness[2, 'layer'] <- '23'
  thickness <- thickness[-3, ]
  stopifnot(sum(thickness$thickness) == 2082)
  as.data.frame(thickness)
}
get_layer_thickness_mean <- function() {
  thick <- get_layers_thickness()
  setNames(thick$thickness, thick$layer)
}
get_layer_thickness_sd <- function() {
  thick <- get_layers_thickness()
  setNames(thick$thickness_sd, thick$layer)
}
