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
The Vagrant configuration should be copied from `Vagrantfile.sample` to `Vagrantfile`.

    cp Vagrantfile.sample Vagrantfile

This Vagrant configuration uses NFS. Under Linux or MacOS this image should work out of the box, as long
as you have NFS installed. Under Windows, you might want to try WinNFSd or change the configuration in 
`Vagrantfile` to use an alternative to NFS. Alternatively (for any OS) you might want to opt for the `rsync` option -
just make sure to run the command `vagrant rsync-auto` on the host side.

Memory is assigned to the VM by modifying the `--memory` variable in `Vagrantfile`. Note that some
parameters like the `query_cache` in `mysqld.cnf` might also be tuned accordingly.

The folder `vagrant_files` includes a couple of files that are copied to the VM. Because the installer needs
to access to the Magento repositories, make sure to add a file `composer-auth.json` with your Magento
credentials in place. If you skip this step, the Magento install will fail. An example is located in
`composer-auth.json.sample`.

You can also include a `resolv.conf` file in the `vagrant_files` folder to override DNS settings within the VM.

## Usage
Bring up this Vagrant image:

    vagrant up

Once the machine is up and running, Vagrant will run all the steps in the script `vagrant-init.sh`. After
all steps are done, Magento 2 should be available under the following URL:

http://magento2.local/ (with this hostname being mapped to IP `192.168.70.70`)

Backend login is available under http://magento2.local/admin. You can login with `admin` and password `admin123`.

You can manage the VM by SSH-ing to it:

    vagrant ssh

The machine is in Developer Mode by default. Magento 2 is installed into the folder `source` of the
Vagrant folder, so that you can access all files via the hosting environment (your computer).

## Caveats
The current setup installs Magento 2 first in `/home/vagrant/source` and then moves this folder to `/vagrant/source`.
This is because in some environments, the file syncing (NFS) of the Magento cache-folder `var/cache` causes traffic to
go bezerk. By installing things in a non-synced folder, and then moving everything to the synced folder afterwards, this
problem is bypassed.

## Recommendations
Do make sure to tune all things as documented above.

Optionally also change the repo URL (currently in the `magento2-install.sh` script) to use an alternative Magento source. Using the
  Yireo dev server is not giving you any guarantees, but works much faster for us than using the original `repo.magento.com`.

It might be needed to install a separate NFS plugin:

    vagrant plugin install vagrant-winnfsd

## Troubleshooting
### Unknown configuration section 'vbguest'
If you get this error, try to install the `vbguest` plugin within
Vagrant. For instance using a commmand like `vagrant plugin install
vagrant-vbguest`.

### Using sshfs
When using SSHFS, run `vagrant plugin install vagrant-sshfs`.
