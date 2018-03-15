#
# classify <- function(file) {
#   # read swc. I need neurostr for this?
#   # call neurostr to get some output. just pass it the path. here i am using the neurostr executable files. so, one would need them installed.
#     # i can also have the neurostr executables as r functions that do call a lot of neurostr functions. thus, executables are not so much needed with R.
#   # on the output from neurostr, add additional variables with my own code.
#   # finally, once the input is obtained, use the predict method of the final model. get the type.
# }
# file = '~/test-file.swc'
# classify(file)


# l <- mlr::makeLearner('classif.svm')
# # l <- mlr::makeLearner('classif.randomForest')
# smoted <- mlr::makeSMOTEWrapper(l, sw.rate = 2)
# multi_smoted <- mlr::makeMulticlassWrapper(smoted, mcw.method = 'onevsone')
# set.seed(0)
# res <- mlr::benchmark(list(multi_smoted), t, rdesc, show.info = FALSE, measures = list(mlr::acc), keep.pred = TRUE)
# tbl

# load('~/code/bbp-interneurons-classify/multi-class-model.rdata')
# devtools::use_data(model, internal = TRUE)
predict(gabaclassifier:::model, newdata = )
