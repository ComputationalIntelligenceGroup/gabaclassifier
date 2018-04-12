#' Classify an interneruon
#' @export
#' @param  file a character. Path to the reconstruction SWC file.
#' @param layer a character. The layer containing the soma.
classify_interneuron <- function(file, layer) {
  ok <- check_neuron(file, layer)
  if (!ok) return()
  quantified <- neurostrplus::quantify_gaba(file, layer, get_layer_thickness_mean(),  get_layer_thickness_sd())
  # make it a data frame?
  quantified <- vector2dataframe(quantified)
  model <- gabaclassifier:::model
  predict(model, quantified)
}
vector2dataframe <- function(named_vector) {
  # check has names and dim NULL
  df <- t(data.frame(named_vector))
  rownames(df) <- NULL
  colnames(df) <- names(named_vector)
  df
}
check_neuron <- function(file, layer) {
  check <- neurostrplus::check_reconstruction(file, layer)
  pass <- all(check$pass)
  if (!pass) {
     message("The following checks have failed:")
     print(subset(check, !pass))
  }
  pass
}
