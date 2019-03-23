import scipy.io

"""
base_dir = '/content/gdrive/My\ Drive/102flowers'

!mkdir -p $base_dir

# Get image dataset

!wget -cq http://www.robots.ox.ac.uk/~vgg/data/flowers/102/102flowers.tgz
!tar -xvf 102flowers.tgz
!mv job $base_dir/102flowers/


#get image labels

!wget -cq http://www.robots.ox.ac.uk/~vgg/data/flowers/102/imagelabels.mat
!mv imagelabels.mat $base_dir/102flowers/



# Get image segmentations

!wget -cq  http://www.robots.ox.ac.uk/~vgg/data/flowers/102/102segmentations.tgz
!mv segmim $base_dir/102flowers/

"""

base_dir = '/content/gdrive/My Drive/102flowers/'


mat = scipy.io.loadmat(base_dir + 'imagelabels.mat')

labels = mat['labels'][0]