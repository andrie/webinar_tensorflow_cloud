# devtools::install_github("rstudio/cloudml")
# cloudml::gcloud_install()
# cloudml::gcloud_init()

# Then navigate to the CloudML console:
# https://console.cloud.google.com/mlengine/

library(cloudml)
library(here)

setwd(here("4-cloudml"))
cloudml_train("mnist_cnn_cloudml.R", collect = TRUE)

job_status()
job_collect()
view_runs()
ls_runs()
ls_runs(eval_acc > 0.97)

setwd(here())

