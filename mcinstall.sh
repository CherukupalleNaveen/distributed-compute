#!/bin/bash

mkdir -p /home/panini/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /home/panini/miniconda3/miniconda.sh
bash /home/panini/miniconda3/miniconda.sh -b -u -p /home/panini/miniconda3
rm -rf /home/panini/miniconda3/miniconda.sh

/home/panini/miniconda3/bin/conda init bash
/home/panini/miniconda3/bin/conda init zsh

