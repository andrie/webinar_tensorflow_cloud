library(keras)


# Flags -------------------------------------------------------------------

FLAGS <- flags(
  # layers
  flag_integer("conv_filters_1", 16),
  flag_integer("conv_filters_2", 16),
  flag_numeric("dropout_1", 0.1),
  flag_integer("dense_units_1", 64),
  flag_integer("dense_units_2", 64),
  flag_numeric("dropout_2", 0.1),
  # training
  flag_integer("epochs", 6),
  flag_integer("batch_size", 128)
)

# Data Preparation -----------------------------------------------------

num_classes <- 10

# Input image dimensions
img_rows <- 28
img_cols <- 28

# The data, shuffled and split between train and test sets
mnist <- dataset_mnist()
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y

# Redefine  dimension of train/test inputs
x_train <- array_reshape(x_train, c(nrow(x_train), img_rows, img_cols, 1))
x_test <- array_reshape(x_test, c(nrow(x_test), img_rows, img_cols, 1))
input_shape <- c(img_rows, img_cols, 1)

# Transform RGB values into [0,1] range
x_train <- x_train / 255
x_test <- x_test / 255

cat('x_train_shape:', dim(x_train), '\n')
cat(nrow(x_train), 'train samples\n')
cat(nrow(x_test), 'test samples\n')

# Convert class vectors to binary class matrices
y_train <- to_categorical(y_train, num_classes)
y_test <- to_categorical(y_test, num_classes)

# Define Model -----------------------------------------------------------

model <- keras_model_sequential()
model %>%
  layer_conv_2d(filters = FLAGS$conv_filters_1, kernel_size = c(3,3), activation = 'relu',
                input_shape = input_shape, name = "conv_1") %>% 
  layer_conv_2d(filters = FLAGS$conv_filters_2, kernel_size = c(3,3), activation = 'relu',
                name = "conv_2") %>%
  layer_max_pooling_2d(pool_size = c(2, 2), name = "pool_1") %>%
  layer_dropout(rate = FLAGS$dropout_1) %>%
  layer_flatten() %>% 
  layer_dense(units = FLAGS$dense_units_1, activation = 'relu', name = "dense_1") %>% 
  layer_dense(units = FLAGS$dense_units_2, activation = 'relu', name = "dense_2") %>%
  layer_dropout(rate = FLAGS$dropout_2) %>%
  layer_dense(units = num_classes, activation = 'softmax', name = "output")

# Compile model
model %>% compile(
  loss = loss_categorical_crossentropy,
  optimizer = optimizer_adadelta(),
  metrics = c('accuracy')
)

# Train & Evaluate -------------------------------------------------------

model %>% fit(
  x_train, y_train,
  batch_size = FLAGS$batch_size,
  epochs = FLAGS$epochs,
  verbose = 1,
  validation_data = list(x_test, y_test)
)
scores <- model %>% evaluate(
  x_test, y_test, verbose = 0
)

# Output metrics
cat('Test loss:', scores[[1]], '\n')
cat('Test accuracy:', scores[[2]], '\n')
