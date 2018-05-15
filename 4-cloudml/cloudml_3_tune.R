# devtools::install_github("rstudio/cloudml")
# cloudml::gcloud_install()
# cloudml::gcloud_init()

# Then navigate to the CloudML console:
# https://console.cloud.google.com/mlengine/

library(cloudml)
library(here)

setwd(here("4-cloudml"))
cloudml_train("mnist_cnn_cloudml.R", collect = TRUE, config = "tuning_1.yml")

trials <- job_trials()
trials

library(dplyr)
trials_clean <- trials %>% 
  mutate_at(vars(starts_with("hyperParameters")), round, 2) %>% 
  rename_all(~sub("finalMetric.", "", .)) %>% 
  rename_all(~sub("hyperparameters.", "", .)) %>% 
  select(-c(trainingStep, epochs)) %>% 
  arrange(desc(objectiveValue))

trials_clean

library(ggplot2)
trials_clean %>% 
  ggplot(aes(x = trialId, y = objectiveValue)) +
  geom_point() +
  stat_smooth(method = "lm") +
  theme_bw(20)

job_collect(trials = "best")

# cloudml_train("mnist_cnn_cloudml.R", collect = TRUE, config = "tuning_2.yml")


setwd(here())

