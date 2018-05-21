#!/bin/bash -v

apt-get install -y expect

# create fs if needed
sudo echo "creating fs"
sudo scripts/check_fs.sh ${ebs_device_name}

sudo mkdir ${ebs_mount_point}
sudo echo "${ebs_device_name}       ${ebs_mount_point}   ext4    defaults,nofail  0 2" >> /etc/fstab

sudo echo "mounting ebs"
sudo mount -a

sudo echo "mounting efs"
sudo mkdir /{efs_mount_point}
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2  ${efs_host}:/ ${efs_mount_point}



#sudo mkdir /data
#echo "test" > /data/test.txt
#sudo mount /dev/xvdb /data

#echo "Hello, World" > index.html
#nohup busybox httpd -f -p 8080 &