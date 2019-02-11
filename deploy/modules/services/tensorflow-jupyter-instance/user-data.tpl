#!/bin/bash -v

#sudo apt-get install -y expect

# create fs if needed
# if output matches below, filesystem has not been initialized
file -s ${ebs_device_name} | grep -q '${ebs_device_name}: data' &> /dev/null

RESULT=$?

if [ $RESULT -eq 0 ]; then
  echo creating fs
  # TODO: initialize filesystem.
else
  echo fs exists
  echo "creating data dir"
  sudo mkdir ${ebs_mount_point}
  echo "mounting ebs"
  sudo echo "${ebs_device_name}       ${ebs_mount_point}   ext4    defaults,nofail  0 2" >> /etc/fstab
  sleep 2
fi

export PATH=/home/ubuntu/anaconda3/bin:$PATH
sudo mount ${ebs_device_name} ${ebs_mount_point}
sudo mount -a

#sudo apt-get update
#sudo apt-get install -y git binutils make
#git clone https://github.com/aws/efs-utils
#cd efs-utils
#make deb
#sudo apt-get install -y ./build/amazon-efs-utils*deb
#sudo mount -t efs fs-e654ecae:/ /efs

#sudo echo "mounting efs"
#sudo mkdir /{efs_mount_point}
#sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2  ${efs_host}:/ ${efs_mount_point}


sudo curl -L https://s3.amazonaws.com/lfcunha-notebook-cert/mycert.pem -o /etc/mycert.pem
sudo curl -L https://s3.amazonaws.com/lfcunha-notebook-cert/mykey.key -o /etc/mykey.key


pip install --no-cache-dir -I  pillow

# Jupyter notebook configuration file
sudo cat <<EOT >> /home/ubuntu/.jupyter/jupyter_notebook_config.py
#------------------------------------------------------------------------------
# KernelSpecManager(LoggingConfigurable) configuration
#------------------------------------------------------------------------------

## If there is no Python kernelspec registered and the IPython kernel is
#  available, ensure it is added to the spec list.
#c.KernelSpecManager.ensure_native_kernel = True

## The kernel spec class.  This is configurable to allow subclassing of the
#  KernelSpecManager for customized behavior.
#c.KernelSpecManager.kernel_spec_class = 'jupyter_client.kernelspec.KernelSpec'

## Whitelist of allowed kernel names.
#
#  By default, all installed kernels are allowed.
#c.KernelSpecManager.whitelist = set()
c.NotebookApp.kernel_spec_manager_class = 'environment_kernels.EnvironmentKernelSpecManager'
c.NotebookApp.iopub_data_rate_limit = 10000000000
c.NotebookApp.open_browser = False
c.NotebookApp.ip = '*'
#c.NotebookApp.certfile = '/etc/mycert.pem'
#c.NotebookApp.keyfile = '/etc/mykey.key'
c.NotebookApp.password = '${hashed_notebook_password}'
c.NotebookApp.port = 8888
EOT

# start the jupyter notebook
jupyter notebook
#cd /data
#nohup jupyter notebook &