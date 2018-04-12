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
