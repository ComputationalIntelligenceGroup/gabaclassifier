classify_interneuron<- function(file, layer) {
  db <- compute_features(file, layer)
  model <- gabaclassifier:::model
  predict(model, db)
}
# classify <- function(file) {
#   # read swc. I need neurostr for this?
#   # call neurostr to get some output. just pass it the path. here i am using the neurostr executable files. so, one would need them installed.
#     # i can also have the neurostr executables as r functions that do call a lot of neurostr functions. thus, executables are not so much needed with R.
#   # on the output from neurostr, add additional variables with my own code.
#   # finally, once the input is obtained, use the predict method of the final model. get the type.
# }
# file = '~/test-file.swc'
# classify(file)
# # wd <- getwd()
# setwd('~/code/bbp-interneurons-classify/')
# source('r/init.R')
# setwd('~/code/gabaclassifier/')
# # do parallel here
#
# classifiers <- mods
# dataset <- droplevels(dataset)
# dataset <- standardize(dataset)
# t <- mlr::makeClassifTask(id = 'test', data = dataset, target = 'class')
# measures <- list(mlr::acc)
# rdesc <- mlr::makeResampleDesc("CV", iters = 7, stratify = TRUE)
# sd <- 0
# set.seed(sd)
# res <- mlr::benchmark(classifiers, t, rdesc, show.info = FALSE, measures = measures, keep.pred = TRUE, models = FALSE)
# res
#
# wrapped <- lapply(classifiers, mlr::makeMulticlassWrapper, mcw.method = 'onevsone')
# # RMLR fails; may it is multinomial
# set.seed(sd)
# resone <- mlr::benchmark(wrapped[-6], t, rdesc, show.info = FALSE, measures = measures, keep.pred = TRUE, models = FALSE)
# resone
#
# wrapped <- lapply(classifiers, mlr::makeMulticlassWrapper, mcw.method = 'onevsrest')
# set.seed(sd)
# resall <- mlr::benchmark(wrapped[-6], t, rdesc, show.info = FALSE, measures = measures, keep.pred = TRUE, models = FALSE)
# resall
#
# res
# resone
# resall
#
# # So, basically, my OVA results are no better than these?
# # 60 misclassified
# cm <- table(resone$results$test$RF$pred$data$truth, resone$results$test$RF$pred$data$response)
# specs <- diag(cm) / rowSums(cm)
# round(specs, 2)
# sum(cm) - sum(diag(cm))

# load the data set
# combine the classifiers
# try with more data. that would require neurostr and my code on more cells.
# if you combine the classifiers, you may good results. just apply some useful ones.
#
# // I can import the classifiers and models directly from source files.
# // Code:
#     learning and models. get this by source, probably will not be reused.
#     assessment part. methodology. it is OK to have it rather clean
#     mlr: this is OK to be exported elsewhere, e.g., to mlearn. can be tested as well
#     will remove all those testing data sets. they make no sense
#     bring feature computation into here. start from the reconstructions.
#     initially, keep the paper outside.

# mlr-helper
# mlr-extend: sampling method


