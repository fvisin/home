#!/bin/bash          

INSTALL_BLOCKS=0
INSTALL_PYLEARN2=0
INSTALL_ARCTIC=1
INSTALL_MKL=1
INSTALL_WITH_CUDA=0

read -t 10 -p "NOTE: to avoid compilation errors, you might need to install libhdf5-dev." ;

export PYTHONPATH=""
# Download latest miniconda http://conda.pydata.org/miniconda.html
if [ ! -d "$HOME/.miniconda" ]; then
    wget -nc http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
    echo "Go through the miniconda installation, install in ~/.miniconda and DO NOT prepend path"
    read -t 10 -p "Hit ENTER to continue or wait ten seconds" ;
    chmod +x Miniconda-latest-Linux-x86_64.sh
    ./Miniconda-latest-Linux-x86_64.sh
    rm Miniconda-latest-Linux-x86_64.sh
fi

# Verify pip installation
pip -v >/dev/null 2>&1 || { 
    echo "pip is missing, I will try to install it"
    sudo apt-get install python-pip 
}


# Rename .local if existing
# if [ -d "$HOME/.local" ]; then
#     read -r -p "$HOME/.local is not empty. This could lead to library compatibility problems. Do you want it to be renamed to '.local_old_by_autoinstall_script'? [y/N] " response
#     case $response in
#     [yY][eE][sS]|[yY]) 
#         mv "$HOME/.local" "$HOME/.local_old_by_autoinstall_script"
#         ;;
#     *)
#         ;;
#     esac
# fi

# pylint
# read -r -p "Do you want to install pylint in .local? [y/N]" response 
#     case $response in
#     [yY][eE][sS]|[yY]) 
#         cd "$HOME/.local"
#         hg clone https://bitbucket.org/logilab/pylint/
#         hg clone https://bitbucket.org/logilab/astroid
#         mkdir logilab && touch logilab/__init__.py
#         hg clone http://hg.logilab.org/logilab/common logilab/common
#         cd pylint && python setup.py install --user
#         ;;
#     *)
#         ;;
#     esac

# not environment specific plugins
pip install --user --upgrade pep257

# Install blocks
# --------------
if [ $INSTALL_BLOCKS -eq 1 ]; then
    echo; echo; echo;
    echo "-----------------"
    echo "Installing blocks"
    echo "-----------------"
    if [ ! -z $CONDA_DEFAULT_ENV ]; then
        source ~/.miniconda/bin/deactivate
    fi
    export PATH="$HOME/.miniconda/bin":$PATH
    export PYTHONPATH="$HOME/.local_extra/lib/python2.7/site-packages"
    conda create -y -n blocks python pip pil matplotlib pytables h5py hdf5 cython pyyaml nose progressbar bokeh numpydoc pydot
    source activate blocks
    if [ -z $INSTALL_MKL ]; then
        read -r -p "Do you want to install mkl? [y/N] " response
    else
        response=$INSTALL_MKL
    fi 
    case $response in
        [yY][eE][sS]|[yY]|[1]) 
            conda install -y mkl
            ;;
        *)
            # should not installed. Numpy already installs the right thing. get rid of it
            conda install -y atlas
            ;;
    esac
    conda install -y pydot numpy=1.9.2 scipy six=1.9.0 pandas=0.16.0 PyYaml 
    # conda install -y --channel https://conda.anaconda.org/trent ipdb --> works like shit
    pip install --upgrade ipython==4.1.0 ipdb==0.8.1
    if [ $INSTALL_WITH_CUDA -eq 1 ]; then
        pip install --upgrade pycuda
    fi
    uptheano
    upblocks
    #cd ~/exp/fuel
    #python setup.py develop
    #cd ~/exp/blocks
    #python setup.py develop
fi

# Install pylearn2
# ----------------
if [ $INSTALL_PYLEARN2 -eq 1 ]; then
    echo; echo; echo;
    echo "-------------------"
    echo "Installing pylearn2"
    echo "-------------------"
    if [ ! -z $CONDA_DEFAULT_ENV ]; then
        source ~/.miniconda/bin/deactivate
    fi
    export PATH=$HOME'/.miniconda/bin':$PATH
    export PYTHONPATH=$HOME'/.local/lib/python2.7/site-packages'
    conda create -y -n pylearn2 python pip pil matplotlib pytables h5py hdf5 cython pyyaml nose numpydoc matplotlib pydot
    source activate pylearn2
    if [ -z $INSTALL_MKL ]; then
        read -r -p "Do you want to install mkl? [y/N] " response
    else
        response=$INSTALL_MKL
    fi 
    case $response in
        [yY][eE][sS]|[yY]|[1]) 
            conda install -y mkl
            ;;
        *)
            conda install -y atlas
            ;;
    esac
    conda install -y pydot numpy=1.9.2 scipy
    # conda install -y --channel https://conda.anaconda.org/trent ipdb --> works like shit
    pip install --upgrade ipython==4.1.0 ipdb==0.8.1
    if [ $INSTALL_WITH_CUDA -eq 1 ]; then
        pip install --upgrade pycuda 
    fi
    uptheano
    cd ~/exp
    git clone git@github.com:fvisin/pylearn2.git
    cd pylearn2
    python setup.py develop
fi

# Install arctic
# --------------
if [ $INSTALL_ARCTIC -eq 1 ]; then
    echo; echo; echo;
    echo "-----------------"
    echo "Installing arctic"
    echo "-----------------"
    if [ ! -z $CONDA_DEFAULT_ENV ]; then
        source ~/.miniconda/bin/deactivate
    fi
    export PATH=$HOME'/.miniconda/bin':$PATH
    conda create -y -n arctic python pip pil pytables h5py hdf5 cython nose numpydoc matplotlib pydot
    source activate arctic
    if [ -z $INSTALL_MKL ]; then
        read -r -p "Do you want to install mkl? [y/N] " response
    else
        response=$INSTALL_MKL
    fi 
    case $response in
        [yY][eE][sS]|[yY]|[1]) 
            conda install -y mkl
            ;;
        *)
            conda install -y atlas
            ;;
    esac
    conda install -y pydot numpy scipy
    # conda install -y --channel https://conda.anaconda.org/trent ipdb --> works like shit
    pip install --upgrade ipython==4.1.0 ipdb==0.8.1
    pip install --upgrade retrying progressbar2
    if [ $INSTALL_WITH_CUDA -eq 1 ]; then
        pip install --upgrade pycuda 
    fi
    # installa a mano pycuda
    # wget https://pypi.python.org/packages/source/p/pycuda/pycuda-2014.1.tar.gz
    # tar xfz pycuda-2014.1.tar.gz
    # cd pycuda-2014.1
    # python configure.py --cuda-root=$CUDA_ROOT
    # make install
    # cd ..
    # rm pycuda-2014.1 -rf pycuda-2014.1.tar.gz
    uptheano
fi
