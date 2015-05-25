#!/bin/bash          

INSTALL_BLOCKS=1
INSTALL_PYLEARN2=1
INSTALL_ARCTIC=1
INSTALL_MKL=1

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

# Install flake8 in .local (shared)
echo "Installing flake8 ..."
pip install flake8 --user --upgrade

# Install blocks
# --------------
if [ $INSTALL_BLOCKS -eq 1 ]; then
    echo; echo; echo;
    echo "-----------------"
    echo "Installing blocks"
    echo "-----------------"
    CLR
    export PATH="$HOME/.miniconda/bin":$PATH
    export PYTHONPATH="$HOME/.local_extra/lib/python2.7/site-packages"
    conda create -y -n blocks python ipython pip pil matplotlib pytables h5py hdf5 cython pyyaml nose progressbar bokeh
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
            conda install -y atlas
            ;;
    esac
    conda install -y pydot numpy=1.9.2 scipy six=1.9.0 pandas=0.16.0 PyYaml=3.11 
    pip install --upgrade toolz==0.7.1 ipdb pycuda 
    pip install --upgrade --no-deps -e 'git+https://github.com/dwf/picklable_itertools.git#egg=picklable-itertools' -b $TMP/build
    rm -rf $TMP/build
    pip install --upgrade --no-deps -e 'git+https://github.com/bartvm/fuel#egg=fuel' -b $TMP/build
    rm -rf $TMP/build
    uptheano
    upblocks
    cd ~/exp/fuel
    python setup.py develop
    cd ~/exp/blocks
    python setup.py develop
fi

# Install pylearn2
# ----------------
if [ $INSTALL_PYLEARN2 -eq 1 ]; then
    echo; echo; echo;
    echo "-------------------"
    echo "Installing pylearn2"
    echo "-------------------"
    CLR
    export PATH=$HOME'/.miniconda/bin':$PATH
    export PYTHONPATH=$HOME'/.local/lib/python2.7/site-packages'
    conda create -y -n pylearn2 python ipython pip pil matplotlib pytables h5py hdf5 cython pyyaml nose 
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
    conda install -y pydot numpy=1.8.1 scipy
    pip install --upgrade ipdb pycuda
    uptheano
    cd ~/exp
    git clone git@github.com:fvisin/pylearn2.git
    cd pylearn2
    python setup.py develop
fi

# Install arctic
if [ $INSTALL_ARCTIC -eq 1 ]; then
    echo; echo; echo;
    echo "-----------------"
    echo "Installing arctic"
    echo "-----------------"
    CLR
    export PATH=$HOME'/.miniconda/bin':$PATH
    conda create -y -n arctic python ipython pip pil pytables h5py hdf5 cython nose 
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
    pip install --upgrade ipdb pycuda
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
