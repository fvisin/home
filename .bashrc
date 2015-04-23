. ~/.profile

# GIT AUTOCOMPLETE
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi

# Ctrl-D
IGNOREEOF=10   # Shell only exists after the 10th consecutive Ctrl-d

# LAB SETTINGS
#==============
if [ -e "/opt/lisa/os_v3/.local.bashrc" ];
  then source /opt/lisa/os_v3/.local.bashrc; 
fi
export BIBINPUTS=.:$HOME/articles/bib:
export BSTINPUTS=.:$HOME/articles/bst:
export TEXINPUTS=.:$HOME/articles/sty:
umask 027

alias CPU='export THEANO_FLAGS=device=cpu,floatX=float32,blas.ldflags="-L/usr/lib64/ -lblas"'
alias CPU0='export THEANO_FLAGS=device=cpu0,floatX=float32,blas.ldflags="-L/usr/lib64/ -lblas"'
alias CPU1='export THEANO_FLAGS=device=cpu1,floatX=float32,blas.ldflags="-L/usr/lib64/ -lblas"'
alias CPU2='export THEANO_FLAGS=device=cpu2,floatX=float32,blas.ldflags="-L/usr/lib64/ -lblas"'
alias GPU='export THEANO_FLAGS=device=gpu,floatX=float32,scan.allow_gc=False,blas.ldflags="-L/usr/lib64/ -lblas"'
alias GPU0='export THEANO_FLAGS=device=gpu0,floatX=float32,scan.allow_gc=False,blas.ldflags="-L/usr/lib64/ -lblas"'
alias GPU1='export THEANO_FLAGS=device=gpu1,floatX=float32,scan.allow_gc=False,blas.ldflags="-L/usr/lib64/ -lblas"'
alias GPU2='export THEANO_FLAGS=device=gpu2,floatX=float32,scan.allow_gc=False,blas.ldflags="-L/usr/lib64/ -lblas"'
alias GPU1SLOW='export THEANO_FLAGS=device=gpu1,floatX=float32,blas.ldflags="-L/usr/lib64/ -lblas"'
alias GPU2SLOW='export THEANO_FLAGS=device=gpu2,floatX=float32,blas.ldflags="-L/usr/lib64/ -lblas"'
alias PROFILE='export CUDA_LAUNCH_BLOCKING=1;export THEANO_FLAGS=proﬁle_memory=True,profile=True,$THEANO_FLAGS'

# THEANO AND PYLEARN2
#=====================
export THEANO_FLAGS='floatX=float32,scan.allow_gc=False,blas.ldflags="-L/usr/lib64/ -lblas"'
export THEANO_FLAGS_INIT=$THEANO_FLAGS
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'~/.local/lib/python2.7/site-packages/Theano-0.6.0-py2.7.egg/theano/'

# PYLEARN2
#==========
#export PYLEARN2_VIEWER_COMMAND="eog --new-instance"
export PYLEARN2_DATA_PATH='/data/lisa/data'
export PYLEARN2_PICKLE_PROTOCOL='pickle.HIGHEST_PROTOCOL'	# better pickle compression

# BLOCKS AND FUEL 
#=================
# to install use miniconda with "conda create -n blocks_env python"
export BLOCKS_DATA_PATH='/data/lisa/data'
export FUEL_DATA_PATH='/data/lisa/data'
# theano
uptheano() {
    pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
}

# check if upblocks works/makes sense
upblocks() {
    BL
    currdir=`pwd`
    cd ~/exp/fuel
    git fetch fuel
    git rebase fuel/master master 

    cd ~/exp/blocks
    git fetch blocks
    git rebase blocks/master master
    pip install --user --upgrade --no-deps -e git+git@github.com:fvisin/blocks.git#egg=blocks[test,plot,docs] --src=$HOME/exp -b /Tmp/visin/build
    cd $currdir
    rm -rf /Tmp/visin/build
}

# ARCTIC
#========
# to install use miniconda with "conda create -n arctic python mkl numpy pytables" and "pip install ipdb pycuda"
uparctic() {
    AR
    currdir=`pwd`
    cd ~/exp/arctic
    git fetch arctic
    git rebase arctic/master master 
    cd $currdir
}

# OTHERS
#========
export EDITOR=vim
export PATH=$HOME'/.local/bin':$PATH
# added by Miniconda 3.9.1 installer
#export PATH='/u/visin/.miniconda/bin':$PATH
alias frascreen="pkscreen; sleep 5; screen -r; sleep 2"

# ENVIRONMENTS
# =============
export PYTHONPATH_INIT=$PYTHONPATH
export PATH_INIT=$PATH
PL() {
    export PATH=$HOME'/.miniconda/bin':$PATH
    export PATH=$HOME'/exp/pylearn2/pylearn2/scripts':$PATH
    #export PYTHONPATH=$HOME'/exp/pylearn2/pylearn2'
    export PYTHONPATH=''
    source activate pylearn2
}
BL() {
    export PATH=$HOME'/.miniconda/bin':$PATH
    export PYTHONPATH=''
    #export PYTHONPATH=$HOME'/exp/blocks/blocks'
    source activate blocks
}
AR() {
    export PATH=$HOME'/.miniconda/bin':$PATH
    source activate arctic
}
CLR() {
    source ~/.miniconda/bin/deactivate 
    export THEANO_FLAGS=$THEANO_FLAGS_INIT
    export PYTHONPATH=$PYTHONPATH_INIT
    export PATH=$PATH_INIT
}

export -f uptheano
export -f upblocks
export -f PL
export -f BL
export -f CLR

# disk usage
disk_usage() {
    du -h $1 2> >(grep -v '^du: cannot \(access\|read\)' >&2) | grep '[0-9\.]\+G' | sort -rn
}
# autojump
[[ -s /u/visin/.autojump/etc/profile.d/autojump.sh ]] && source /u/visin/.autojump/etc/profile.d/autojump.sh

# cool bash and git bash extension
source ~/.git-prompt.sh
# foreground colors
BLACK='\[\e[0;30m\]'        # Black
RED='\[\e[0;31m\]'          # Red
GREEN='\[\e[0;32m\]'        # Green
YELLOW='\[\e[0;33m\]'       # Yellow
BLUE='\[\e[0;34m\]'         # Blue
PURPLE='\[\e[0;35m\]'       # Purple
CYAN='\[\e[0;36m\]'         # Cyan
WHITE='\[\e[0;37m\]'        # White

# format bash
RESET=${WHITE}
PS1=${GREEN}'┌─────── \u@\h'${BLUE}' [\w]'${YELLOW}'$(__git_ps1 " (%s)")\n'${GREEN}'└─ λ '${RESET}
# VIRTUAL_ENV_DISABLE_PROMPT=1 source ~/Enthought/Canopy_64bit/User/bin/activate

