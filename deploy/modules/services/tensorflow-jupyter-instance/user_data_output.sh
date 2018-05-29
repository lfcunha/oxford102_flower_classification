#!/bin/bash -v

#sudo apt-get install -y expect

# create fs if needed
# if output matches below, filesystem has not been initialized
file -s /dev/xvdf | grep -q '/dev/xvdf: data' &> /dev/null

RESULT=0

if [  -eq 0 ]; then
  echo creating fs
  # TODO: initialize filesystem.
else
  echo fs exists
  echo "creating data dir"
  sudo mkdir /data
  echo "mounting ebs"
  sudo echo "/dev/xvdf       /data   ext4    defaults,nofail  0 2" >> /etc/fstab
  sudo mount -a
fi


#sudo echo "mounting efs"
#sudo mkdir /{efs_mount_point}
#sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2  10.0.0.71:/ /efs


#sudo echo "Hello, World" > /var/index.html
#nohup busybox httpd -f -p 8080 &


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
c.NotebookApp.certfile = '/etc/mycert.pem'
c.NotebookApp.keyfile = '/etc/mykey.key'
c.NotebookApp.password = 'sha1:adc8323b5ab9:9865c35c8573307ec44b8eb98256e06dc57320ee' # mydataflowernotebookpassword
c.NotebookApp.port = 8888
EOT

# start the jupyter notebook
#jupyter notebook
