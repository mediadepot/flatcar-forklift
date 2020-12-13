# forklift

 SystemD service to deploy always up-to-date kernel modules for Flatcar Container Linux

# Background

Compiling drivers on Flatcar Container Linux is typically non-trivial because the OS ships without build tools and no
obvious way to access the kernel sources. Forklift works by pre-compiling your kernel modules inside of a Flatcar Container Linux developer
container. On startup the Forklift service will pull down the docker image containing pre-compiled kernel module binaries that
match your Flatcar version, cache the binaries on your host, and then load the kernel modules.

This project currently supports generating NVIDIA kernel modules, however it can be extended to support any module.

Forklift is based on the following CoreOS projects:

- https://github.com/squat/modulus
- https://github.com/BugRoger/coreos-nvidia-driver

# SystemD Installation

```
sudo git clone https://github.com/mediadepot/flatcar-forklift.git /opt/flatcar-forklift
sudo cp /opt/flatcar-forklift/forklift@.service /etc/systemd/system/forklift@.service

sudo systemctl enable forklift@nvidia
sudo systemctl start forklift@nvidia

# read the logs
sudo journalctl -fu  forklift@nvidia
```

# Supported Drivers

| Driver Name | Url |
| --- | --- |
| NVIDIA | https://github.com/mediadepot/docker-flatcar-nvidia-driver |
