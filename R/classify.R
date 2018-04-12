classify_interneuron<- function(file, layer) {
  db <- compute_features(file, layer)
  quantified <- neurostrr::quantify_gaba(file, layer, thickness,  thickness_sd)
  # make it a data frame?
  model <- gabaclassifier:::model
  predict(model, db)
}

# TODO: standardize the vars? irrelevant for RF but generally possibly OK.
# TODO: try ovo or similar

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


