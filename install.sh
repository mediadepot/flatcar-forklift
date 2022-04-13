#!/usr/bin/env sh

# https://www.flatcar.org/docs/latest/reference/developer-guides/kernel-modules/
# install writable overlay for /usr/lib64/modules directory
mkdir /opt/overlay/modules
mkdir /opt/overlay/modules.wd

cp ./usr-lib64-modules.mount /etc/systemd/system/usr-lib64-modules.mount

# install flatcar-forklift service
cp /opt/flatcar-forklift/forklift@.service /etc/systemd/system/forklift@.service
