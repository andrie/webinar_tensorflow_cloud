library(tfruns)
library(here)

# FLAGS <- flags(
#   # layers
#   flag_integer("conv_filters_1", 16),
#   flag_integer("conv_filters_2", 16),
#   flag_numeric("dropout_1", 0.1),
#   flag_integer("dense_units_1", 64),
#   flag_integer("dense_units_2", 64),
#   flag_numeric("dropout_2", 0.1),
#   # training
#   flag_integer("epochs", 6),
#   flag_integer("batch_size", 128)
# )



setwd(here("3-flags"))
tfruns::training_run(
  "mnist_cnn_flags.R", 
  flags = list(
    conv_filters_1 = 16,
    conv_filters_2 = 16
  )
)

tfruns::training_run(
  "mnist_cnn_flags.R", 
  flags = list(
    conv_filters_1 = 32,
    conv_filters_2 = 32
  )
)

compare_runs()

# 27,648 total combinations of flags (sampled to 138 combinations)

tuning_run(
  "mnist_cnn_flags.R", 
  sample = 0.005,
  flags = list(
    conv_filters_1 = c(8, 16, 32, 64),
    conv_filters_2 = c(8, 16, 32, 64),
    dropout_1 = c(0, 0.1, 0.2, 0.3, 0.4, 0.5),
    dense_units_1 = c(32, 64, 128, 256),
    dense_units_2 = c(32, 64, 128, 256),
    dropout_2 = c(0, 0.1, 0.2, 0.3, 0.4, 0.5),
    epochs = 12,
    batch_size = c(32, 64, 128)
  )
)

runs <- ls_runs()
runs
runs %>% View()
runs

ls_runs(order = "eval_acc") %>% 
  head()

ls_runs(order = "eval_acc") %>% 
  head(2) %>% 
  tfruns::compare_runs()


setwd(here())
