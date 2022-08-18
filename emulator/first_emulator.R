# based on https://tensorflow.rstudio.com/tutorials/keras/regression

# ## install tensorflow & keras
#   # https://tensorflow.rstudio.com/install/
#  reticulate::virtualenv_create("r-reticulate")
# # tensorflow::install_tensorflow(envname = "r-reticulate")
# keras::install_keras(envname = "r-reticulate")
# ### 

library(tensorflow)
library(keras)
library(tidyverse)
library(tidymodels)


data <- read_csv("ens_plus_data.csv") %>% 
    select(c(2,4:19,20,31))

split <- initial_split(data, 0.8) 
train_dataset <- training(split)
test_dataset <- testing(split)


## split features from labels

train_features <- train_dataset %>% 
  select(-npp)
test_features <- test_dataset %>% 
  select(-npp)

train_labels <- train_dataset %>% 
  select(npp)
test_labels <- test_dataset %>% 
  select(npp)

## Normalize the data

normalizer <- layer_normalization(axis = -1L)

normalizer %>% adapt(as.matrix(train_features))

# first a single variable, SLA
sla <- matrix(train_features$SLA)

sla_normalizer <- layer_normalization(input_shape = shape(1), axis = NULL)
sla_normalizer %>% adapt(sla)

## build Keras Sequential model

sla_model <- keras_model_sequential() %>% 
  sla_normalizer()  %>% 
  layer_dense(units = 1)

summary(sla_model)

predict(sla_model, sla[1:10,])

sla_model %>% 
  compile(
      optimizer = optimizer_adam(learning_rate = 0.1),
      loss = 'mean_absolute_error'
  )

history <- sla_model  %>% 
  fit(as.matrix(train_features)[,1:3], 
      as.matrix(train_labels), 
      epochs = 100, 
      verbose = 0, 
      validation_split = 0.2)

plot(history)

test_results <- list()
test_results[["sla_model"]] <- sla_model %>% evaluate(
  as.matrix(test_features$SLA),
  as.matrix(test_labels),
  verbose = 0
)

x <- seq(0, 250, length.out = 251)
y <- predict(sla_model, x)
