#!/bin/bash -e

## sudo apt-get purge bcmwl-kernel-source
## sudo apt-get install bcmwl-kernel-source
sudo modprobe -r b43 ssb wl
sudo modprobe wl 
