from time import time

from keras import optimizers
from keras.callbacks import ModelCheckpoint, LearningRateScheduler, TensorBoard, EarlyStopping
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Activation, Dropout, Flatten, Dense
from keras.models import Sequential
from keras.preprocessing.image import ImageDataGenerator


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


    def get_model(optimizer=optimizers.SGD, verbose=False, n_categories=2):

        model = Sequential()

        #conv_layer1
        model.add(Conv2D(32, (3, 3), input_shape=(150, 150, 3)))
        model.add(Activation('relu'))
        model.add(MaxPooling2D(pool_size=(2, 2)))

        # conv_layer2
        model.add(Conv2D(32, (3, 3)))
        model.add(Activation('relu'))
        model.add(MaxPooling2D(pool_size=(2, 2)))

        # conv_layer3
        model.add(Conv2D(64, (3, 3)))
        model.add(Activation('relu'))
        model.add(MaxPooling2D(pool_size=(2, 2)))

        model.add(Flatten())  # this converts our 3D feature maps to 1D feature vectors
        model.add(Dense(256))
        model.add(Activation('relu'))
        model.add(Dropout(0.5))

        if n_categories == 2:
            model.add(Activation('sigmoid'))
        else:
            model.add(Dense(n_categories, activation="softmax"))

        model.compile(loss='categorical_crossentropy',
                      optimizer=optimizer,
                      metrics=['accuracy'])

        if verbose:
            model.summary()

        return model


    _model = get_model(optimizers.SGD(lr=0.0001, momentum=0.9), n_categories=102)

    data_generator = get_image_generator()

    img_width, img_height = 256, 256
    batch_size = 32
    epochs = 50
    data_dir = "data/oxford102/train/"

    train_generator = data_generator.flow_from_directory(
        data_dir,  # this is the target directory
        target_size=(img_width, img_height),  # all images will be resized to 250x250
        batch_size=batch_size,
        class_mode='categorical',
        subset="training")

    validation_generator = data_generator.flow_from_directory(
        data_dir,  # this is the target directory
        target_size=(img_width, img_height),  # all images will be resized to 250x250
        batch_size=batch_size,
        class_mode='categorical',
        subset="validation")

    checkpoint = ModelCheckpoint("inception_resnet_v2_oxford102_train_dataset.h5", monitor='val_acc', verbose=1,
                                 save_best_only=True, save_weights_only=False, mode='auto', period=1)
    early = EarlyStopping(monitor='val_acc', min_delta=0, patience=5, verbose=1, mode='auto')

    tensorboard = TensorBoard(log_dir="logs/{}".format(time()), histogram_freq=0, write_graph=True, write_images=True)

    nb_train_samples = 4604
    nb_validation_samples = 1094

    _model.fit_generator(
        train_generator,
        validation_data=validation_generator,
        steps_per_epoch=nb_train_samples / batch_size,
        validation_steps=nb_validation_samples / batch_size,
        epochs=epochs,
        callbacks=[checkpoint, early, tensorboard])
