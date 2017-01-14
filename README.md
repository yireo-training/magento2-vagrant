# Vagrant image for Magento 2
This repository contains all the files to get a VM up and running via Vagrant. Recommended is to assign at least 4Gb of RAM to this VM.

## Specifications
This Vagrant installs the following into a VM:
- Nginx
- PHP7
- Redis
- Magerun2
- Magento 2

## Configuration
This Vagrant configuration uses NFS. Under Linux or MacOS this image should work out of the box, as long
as you have NFS installed. Under Windows, you might want to try WinNFSd or change the configuration in 
`Vagrantfile` to use an alternative to NFS.

Memory is assigned to the VM by modifying the `--memory` variable in `Vagrantfile`. Note that some
parameters like the `query_cache` in `mysqld.cnf` might also be tuned accordingly.

The folder `vagrant_files` includes a couple of files that are copied to the VM. Because the installer needs
to access to the Magento repositories, make sure to add a file `composer-auth.json` with your Magento
credentials in place. If you skip this step, the Magento install will fail. An example is located in
`composer-auth.json.sample`.

## Usage
Bring up this Vagrant image:

    vagrant up

Once the machine is up and running, Vagrant will run all the steps in the script `vagrant-init.sh`. After
all steps are done, Magento 2 should be available under the following URL:

http://192.168.70.70/

You can manage the VM by SSH-ing to it:

    vagrant ssh

The machine is in Developer Mode by default. Magento 2 is installed into the folder `source` of the
Vagrant folder, so that you can access all files via the hosting environment (your computer).

