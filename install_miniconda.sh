#!/bin/bash          

export PYTHONPATH=""

# Download latest miniconda http://conda.pydata.org/miniconda.html
if [ ! -d "$HOME/.miniconda" ]; then
    wget -nc http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
    echo "Go through the miniconda installation, install in ~/.miniconda and DO prepend path"
    read -t 10 -p "Hit ENTER to continue or wait ten seconds" ;
    chmod +x Miniconda-latest-Linux-x86_64.sh
    ./Miniconda-latest-Linux-x86_64.sh
    rm Miniconda-latest-Linux-x86_64.sh
    echo "****** ATTENTION ******"
    echo "Open a new SSH session and relaunch the script to go on."
    exit
fi


# Install the python env
echo "---------------------------------------"
echo "Installing the required python packages"
echo "---------------------------------------"
if [ ! -z $CONDA_DEFAULT_ENV ]; then
    source ~/.miniconda/bin/deactivate
fi
export PATH=$HOME'/.miniconda/bin':$PATH
# source module_load if any
if [ -f "module_load.sh" ]; then
    source module_load.sh
fi
conda install -y python mkl pip pil pytables h5py hdf5 cython nose numpy scipy numpydoc matplotlib pydot-ng scikit-learn scikit-image tabulate
# pip install --upgrade ipython==4.1.0 ipdb==0.8.1 retrying progressbar2 pycuda
pip install --upgrade ipython==5.1.0 ipdb retrying progressbar2 pycuda pep257


# Install my source
cd
if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
    ssh-keygen
fi
echo "Add the following ssh key to github and THEN press enter:"
cat  "$HOME/.ssh/id_rsa.pub"
read
if [ ! -d "exp" ]; then
    mkdir exp
fi
cd exp
if [ ! -d "theano" ]; then
    git clone https://github.com/Theano/Theano.git theano
    pip install -e theano
fi
if [ ! -d "reseg" ]; then
    git clone git@github.com:fvisin/reseg_private.git reseg
fi
if [ ! -d "lasagne" ]; then
    git clone https://github.com/Lasagne/Lasagne.git lasagne
    pip install -e lasagne
fi
if [ ! -d "reseg" ]; then
    git clone --recursive git@github.com:fvisin/dataset_loaders.git
    echo "WARNING !!!" 
    echo
    echo "Adding dataset_loaders to PYTHONPATH. Check your ~/.bashrc afterwards"
    echo 'export PYTHONPATH=$PYTHONPATH:$HOME/exp/dataset_loaders' >> ~/.bashrc
    ln -s $WORK/datasets/ $HOME/exp/dataset_loaders/dataset_loaders/datasets
    cd "$HOME/exp/dataset_loaders/dataset_loaders/images/coco/PythonAPI"
    make all  # make mscoco
fi
