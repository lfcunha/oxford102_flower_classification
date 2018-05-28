# Terraform syntax
```bash

terraform init # do this to install new providers

terraform state list  # list resources

terraform state show aws_instance.notebook  # describe a resource

terraform plan

terraform apply

terraform graph  # can visualize output with graphviz online

terraform destroy
```

### Notes:
Variables Must be one of "string", "list", or "map".

If no default provided, it will prompt when running "terraform apply"

A value can be passed in the command:
```bash
terraform plan -var server_port="8080"
```

Use output to print resource properties, instead of having to use "state show ..."; After, you can get it again with:
```bash
terraform output public_ip
```



# Training


https://classroom.udacity.com/nanodegrees/nd013/parts/fbf77062-5703-404e-b60c-95b78b2f3f9e/modules/6df7ae49-c61c-4bb2-a23e-6527e69209ec/lessons/e12c47b6-316e-4a0b-aae5-2f2c5fcd99f5/concepts/10489223-72fa-4393-848b-f882ba3cf7f9


The Four Main Cases When Using Transfer Learning
Transfer learning involves taking a pre-trained neural network and adapting the neural network to a new, different data set.

Depending on both:

the size of the new data set, and
the similarity of the new data set to the original data set
the approach for using transfer learning will be different. There are four main cases:

new data set is small, new data is similar to original training data
new data set is small, new data is different from original training data
new data set is large, new data is similar to original training data
new data set is large, new data is different from original training data

Four Cases When Using Transfer Learning

A large data set might have one million images. A small data could have two-thousand images. The dividing line between a large data set and small data set is somewhat subjective. Overfitting is a concern when using transfer learning with a small data set.

Images of dogs and images of wolves would be considered similar; the images would share common characteristics. A data set of flower images would be different from a data set of dog images.

Each of the four transfer learning cases has its own approach. In the following sections, we will look at each case one by one.



We have a large, but different dataset. We're goint to treat it as Case 3, where the dataset is similar. Meaning,
we're going to replace the last convolutional data and initiate its weights randomly. The rest of layers will bi iniated with the network weights


## Case 4: Large Data Set, Different Data
If the new data set is large and different from the original training data:

remove the last fully connected layer and replace with a layer matching the number of classes in the new data set
retrain the network from scratch with randomly initialized weights
alternatively, you could just use the same strategy as the "large and similar" data case
Even though the data set is different from the training data, initializing the weights from the pre-trained network might make training faster. So this case is exactly the same as the case with a large, similar data set.

If using the pre-trained network as a starting point does not produce a successful model, another option is to randomly initialize the convolutional neural network weights and train the network from scratch.

##Case 3: Large Data Set, Similar Data:
If the new data set is large and similar to the original training data:

remove the last fully connected layer and replace with a layer matching the number of classes in the new data set
randomly initialize the weights in the new fully connected layer
initialize the rest of the weights using the pre-trained weights
re-train the entire neural network
Overfitting is not as much of a concern when training on a large data set; therefore, you can re-train all of the weights.

Because the original training set and the new data set share higher level features, the entire neural network is used as well.

Here is how to visualize this approach:



### Training:
data storage:
EFS: too slow. go with EBS

### Cost (time and money)


| instance       |batch size      |price           |time/epoch (hr) | train layers|
| ------------- |:-------------:| :---------------:| :-------------:|------------:|
|p3.2xlarge     |         16   |  $3.06 per Hour   |   3            |    5:       | 
|p3.2xlarge     |        160   |  $3.06 per Hour   |   3            |    5:       | 
|p2.xlarge      |         16   |  $0.9 per Hour    |   6            |    5:       | 
|p2.xlarge      |         16   |  $0.9 per Hour    |   4            |    12:      |     
|p2.xlarge      |         16   |  $0.9 per Hour    |   3            |    18:      |     
|p2.xlarge      |         16   |  $0.9 per Hour    |   2.75         |    None     |     
