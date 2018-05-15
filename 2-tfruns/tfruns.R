library(tfruns)
library(here)


setwd(here("2-tfruns"))
tfruns::training_run("mnist_cnn.R")
tfruns::ls_runs()
tfruns::ls_runs(eval_acc > 0.985, order = eval_acc)
tfruns::view_run()
tfruns::compare_runs()

setwd(here())
