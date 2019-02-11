from time import time

from keras import applications
from keras import optimizers
from keras.callbacks import ModelCheckpoint, LearningRateScheduler, TensorBoard, EarlyStopping, CSVLogger
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Activation, Dropout, Flatten, Dense
from keras.models import Sequential
from keras.preprocessing.image import ImageDataGenerator
from keras.applications.nasnet import preprocess_input
import numpy as np
import pickle as pk

seed = 42


if __name__ == "__main__":
    def get_image_generator(image_augmentation=False, validation_split=0.2):
        if not image_augmentation:
            return ImageDataGenerator(rescale=1./255,
                                      validation_split=validation_split)

        return ImageDataGenerator(
            rescale=1. / 255,
            rotation_range=40,
            width_shift_range=0.2,
            height_shift_range=0.2,
            shear_range=0.2,
            zoom_range=0.2,
            horizontal_flip=True,
            fill_mode='nearest',
            validation_split=validation_split)


    def get_model(model_name, incluce_bottleneck=True, input_shape=(256, 256)):
        img_width, img_height = input_shape

        if model_name.lower() == "inceptionv3":
            img_width, img_height = (299, 299)
            return applications.inception_v3.InceptionV3(weights="imagenet",
                                                         include_top=incluce_bottleneck,
                                                         input_shape=(img_width, img_height, 3))


    def freeze_layers(_model, top_n_layers_to_train=0):
        if not top_n_layers_to_train:
            for layer in _model[:]:
                layer.trainable = False
        else:
            for layer in model[:-top_n_layers_to_train]:
                layer.trainable = False

    def thaw_layers(_model):
        for layer in _model[:]:
            layer.trainable = True

    def add_bottlebeck(_model, _nr_categories):
        x = _model.output
        x = Flatten()(x)
        x = Dense(1024, activation="relu")(x)
        x = Dropout(0.5)(x)
        # x = Dense(102, activation="relu")(x)
        predictions = Dense(_nr_categories, activation="softmax")(x)

        return predictions


    def compile_model(_model, optimizer):
        _model.compile(loss="categorical_crossentropy", optimizer=optimizer,
                            metrics=["accuracy"])


    def get_optimizer(optimizer, params):
        return optimizer(**params)
        #return optimizers.SGD(lr=0.0001, momentum=0.9)


    def grid_search(architectures, optimizers, optimizer_params):
        for architecture in architectures:
            for optimizer in optimizers:
                optimizer = optimizer(**optimizer_params[optimizer])
                model = get_model(architecture(architecture, incluce_bottleneck=True, input_shape=(256, 256)))


    import os


    def run_training(model, train_generator, validation_generator, params, num_train_img, num_val_img):
        np.random.seed(seed)
        log_time = time()
        params['log_time'] = log_time
        batch_size = params.get("batch_size")

        base = '/data/oxford102/experiments'
        path = os.path.join(base, str(log_time))
        checkpoint = ModelCheckpoint(os.path.join(path, "small_convnet_{}.h5".format(log_time)), monitor='val_acc',
                                     verbose=1, save_best_only=True, save_weights_only=False, mode='auto', period=1)
        early = EarlyStopping(monitor='val_acc', min_delta=0, patience=3, verbose=1, mode='auto')
        tensorboard = TensorBoard(log_dir="logs/{}".format(log_time), histogram_freq=0, write_graph=True,
                                  write_images=True)
        csv_logger = CSVLogger(os.path.join(path, "small_convnet_{}.csv".format(log_time)), append=True, separator=';')

        try:
            if not os.path.exists(path):
                os.makedirs(path)
            history_callback = model.fit_generator(
                train_generator,
                steps_per_epoch=num_train_img // batch_size,
                epochs=params.get("epochs"),
                validation_data=validation_generator,
                validation_steps=num_val_img // batch_size,
                callbacks=[checkpoint, early, tensorboard, csv_logger])
        except Exception as e:
            raise (e)
        finally:
            pk.dump(params, open("experimental_params/experiments_{}.pk".format(log_time), "wb"),
                    protocol=pk.HIGHEST_PROTOCOL)
            model.save_weights(os.path.join(path, 'model_weights_final_{}.h5'.format(
                log_time)))  # always save your weights after training or during training
            print(params)
            params


    from keras.initializers import glorot_uniform  # Or your initializer of choice


    def run(params):
        import tensorflow as tf
        sess = tf.Session()

        from keras import backend as K
        K.set_session(sess)
        model = None
        import gc
        gc.collect()
        model = setup_model(params)
        initial_weights = model.get_weights()
        with sess.as_default():
            new_weights = [glorot_uniform()(w.shape).eval() for w in initial_weights]
        model.set_weights(new_weights)
        train_generator, validation_generator = get_generators(params)
        run_training(model, train_generator, validation_generator, params, 4604, 1094)


    img_width, img_height = 256, 256
    train_data_dir = "/data/oxford102/train/"
    validation_data_dir = "/data/oxford102/train/"
    nb_train_samples = 4604
    nb_validation_samples = 1094

    nr_categories = 102
    batch_size = 16
    epochs = 50

    model = get_model("inceptionv3",  incluce_bottleneck=False)
    freeze_layers(model, 0)
    model = add_bottlebeck(model, nr_categories)
    optimizer = get_optimizer(optimizers.SGD, dict(lr=0.0001, momentum=0.9))
    compile_model(model, optimizer)

    import keras.applications.nasnet.preprocess_input as p


"""
    A) 
    # https://gist.github.com/fchollet/f35fbc80e066a49d65f1688a7e99f069
    # https://blog.keras.io/building-powerful-image-classification-models-using-very-little-data.html
    predict bottleneck features, then use:
        - simple CNN
        - logistic regression
        
       
    B) train bottleneck features on new data
        
   
        
"""



    model = applications.inception_v3.InceptionV3(weights = "imagenet", include_top=False, input_shape = (img_width, img_height, 3))
    #from keras.models import load_model
    #model = load_model("/data/vgg16_fungi_all_p2.h5")

"""
Train for a max of 24 hours
"""

# model1: vgg


# mod