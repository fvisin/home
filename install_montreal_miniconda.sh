#!/bin/bash          
# Download latest miniconda http://conda.pydata.org/miniconda.html
if [ -d "$HOME/.miniconda" ]; then
    wget -nc http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
    echo "Go through the miniconda installation, install in ~/.miniconda and DO NOT prepend path"
    read -t 10 -p "Hit ENTER to continue or wait ten seconds" ;
    chmod +x Miniconda-latest-Linux-x86_64.sh
    ./Miniconda-latest-Linux-x86_64.sh
    rm Miniconda-latest-Linux-x86_64.sh
fi

# install requirements ---> non ha senso farlo in root perché non è condiviso
#conda install -y pip mkl numpy=1.8.1 scipy pil matplotlib pytables
# in the lab numpy and scipy are optimized
#conda install -y pip pil matplotlib pytables python

if [ -d "$HOME/.local" ]; then
    read -t 10 -p "The $HOME/.local directory will be renamed to '.local_old_by_autoinstall_script'. Press ENTER to continue."
    mv "$HOME/.local" "$HOME/.local_old_by_autoinstall_script"
fi


# install blocks
# --------------
echo "Installing blocks ..."
CLR
BL
conda create -y -n blocks python ipython pip pil matplotlib pytables hdf5 cython pyyaml nose progressbar bokeh
BL
read -r -p "Do you want to install mkl? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        conda install mkl
        ;;
    *)
        conda install atlas
        ;;
esac
conda install -y pydot numpy scipy
uptheano
upblocks
cd ~/exp/fuel
python setup.py develop
cd ~/exp/blocks
python setup.py develop


# install pylearn2
# ----------------
echo "Installing pylearn2 ..."
CLR
PL
conda create -y -n pylearn2 python ipython pip pil matplotlib pytables hdf5 cython pyyaml nose 
PL
read -r -p "Do you want to install mkl? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        conda install mkl
        ;;
    *)
        conda install atlas
        ;;
esac
conda install -y pydot numpy=1.8.1 scipy
uptheano
cd ~/exp
git clone git@github.com:fvisin/pylearn2.git
cd pylearn2
python setup.py develop


# install arctic
CLR
AR
conda create -y -n arctic python ipython pip pil pytables hdf5 cython nose 
AR
read -r -p "Do you want to install mkl? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        conda installuu mkl
        ;;
    *)
        conda install atlas
        ;;
esac
conda install -y pydot numpy scipy
pip install ipdb pycuda
uptheano

