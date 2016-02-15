# ls aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias lla='ls -alF'
alias lh='ls -sh'
alias la='ls -A'
alias l='ls -CF'

#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

# Colourize grep output.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Graphical vim
if type vimx >/dev/null 2>&1; then 
    alias vim='vimx'
fi

# Git fast-forward merge
alias gff='git merge --ff-only'

# hub command for better GitHub integration.
# [ $(which hub 2>/dev/null) ] && alias git=hub

# Force password authentication with SSH. Used to get around the situation
# where SSH freezes while trying to do public key authentication because
# DIRO has the NFS/Kerberos Setup From Hell.
# From http://unix.stackexchange.com/q/15138
alias sshpw='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'

# Quick and dirty installation of packages with pip from GitHub.
ghpip() {
    if [ $# == 0 ]; then
        echo "usage: ghpip user/project [branch/refspec]"
        return 1
    fi
    if [ $# == 1 ]; then
        GITHUBPATH=$1
        BRANCH=master
    else
        GITHUBPATH=$1
        BRANCH=$2
    fi
    pip install --upgrade "git+git://github.com/$GITHUBPATH.git@$BRANCH"
}

# disk usage
disk_usage() {
    # TODO: apparently ncdu is better
    du -h $1 2> >(grep -v '^du: cannot \(access\|read\)' >&2) | grep '[0-9\.]\+G' | sort -rn
}

# rsync options
alias rsyncopt="rsync -r -X --partial -z -h --progress --bwlimit=20000 --copy-links "

# Manage the weird pkscreen routine for lisa lab
alias frascreen="pkscreen; sleep 5; screen -r; sleep 2"

# Quick set THEANO_FLAGS
CPU(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cpu,floatX=float32$BLAS_FLAG; }
CPU0(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cpu0,floatX=float32$BLAS_FLAG; }
CPU1(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cpu1,floatX=float32$BLAS_FLAG; }
CPU2(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cpu2,floatX=float32$BLAS_FLAG; }
GPU(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu,floatX=float32,scan.allow_gc=False$BLAS_FLAG; }
GPU0(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu0,floatX=float32,scan.allow_gc=False$BLAS_FLAG; }
GPU1(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu1,floatX=float32,scan.allow_gc=False$BLAS_FLAG; }
GPU2(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu2,floatX=float32,scan.allow_gc=False$BLAS_FLAG; }
GPU0SLOW(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu0,floatX=float32$BLAS_FLAG; }
GPU1SLOW(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu1,floatX=float32$BLAS_FLAG; }
GPU2SLOW(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu2,floatX=float32$BLAS_FLAG; }
CUDA0(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cuda0,floatX=float16$BLAS_FLAG; }
PROFILE(){ export CUDA_LAUNCH_BLOCKING=1;export THEANO_FLAGS="$THEANO_FLAGS_INIT",proﬁle_memory=True,profile=True,$THEANO_FLAGS; }

# Frameworks update
# ==================
GITUSER='fvisin'
# theano
uptheano() {
    currdir=`pwd`
    # normal
    if [ -z ${VIRTUAL_ENV} ]; then
        export THEANO_PATH=$HOME/exp/theano/theano
        if [ ! -d $THEANO_PATH ]; then
            echo "Installing theano for the first time..."
            git clone -o theano 'git@github.com:Theano/Theano.git' $THEANO_PATH
            cd $THEANO_PATH
            # python setup.py develop
        else
            echo "Upgrading theano..."
            cd $THEANO_PATH
            git fetch theano
            git merge --ff-only theano/master master
            PPATH=$PYTHONPATH
            export PYTHONPATH=$PYTHONPATH:$THEANO_PATH
            bin/theano-cache clear
            export PYTHONPATH=$PPATH
        fi
    # virtual environment
    else
        export THEANO_PATH=$HOME/exp/theano/$CONDA_DEFAULT_ENV/
        if [ ! -d $THEANO_PATH ]; then
            echo "Installing theano for the first time in this environment..."
            git clone -o theano 'git@github.com:Theano/Theano.git' $THEANO_PATH
            cd $THEANO_PATH
            git clone -o theano 'git@github.com:$GITUSER/Theano.git' $THEANO_PATH
            git remote add origin git@github.com:fvisin/Theano.git
            python setup.py develop
        else
            echo "Upgrading theano in this environment..."
            cd $THEANO_PATH
            git fetch theano
            git merge --ff-only theano/master master
            bin/theano-cache clear
        fi
    fi
    cd $currdir
}

# fuel and blocks
upblocks() {
    BL
    currdir=`pwd`
    # fuel 
    if [ ! -d ~/exp/fuel ]; then
        echo "Installing fuel for the first time..."
        cd "$HOME"/exp
        git clone git@github.com:$GITUSER/fuel.git
        cd fuel
        git remote add fuel git@github.com:bartvm/fuel.git
    else
        echo "Upgrading fuel..."
    fi
    # update
    cd ~/exp/fuel
    git fetch fuel
    git merge --ff-only fuel/master master
    pip install -e file:.#egg=fuel[test,docs]
    python setup.py build_ext --inplace  # rebuild cython

    # blocks 
    if [ ! -d ~/exp/blocks ]; then
        echo "Installing blocks for the first time..."
        cd "$HOME"/exp
        git clone git@github.com:$GITUSER/blocks.git 
        cd blocks
        git remote add blocks git@github.com:bartvm/blocks.git
    else
        echo "Upgrading blocks..."
    fi
    # update
    cd ~/exp/blocks
    git fetch blocks
    git merge --ff-only blocks/master master
    pip install -e file:.#egg=blocks[test,docs] -r requirements.txt
    cd $currdir
}

# arctic
uparctic() {
    AR
    currdir=`pwd`
    cd ~/exp/arctic
    git fetch arctic
    git merge --ff-only arctic/master master
    cd $currdir
}

# conda: we don't want to mess with system-wide conda
upconda() {
    $HOME/.miniconda/bin/conda update conda
}

# ENVIRONMENTS
# =============
BL() {
    export VIRTUAL_ENV="$HOME/.miniconda/envs/blocks"
    export PATH="$HOME/.miniconda/bin:$PATH"
    export PYTHONPATH="$HOME/.miniconda/envs/blocks/lib/python2.7/site-packages/:$PYTHONPATH"
    export PYTHONPATH=$PYTHONPATH:"$HOME/exp/jobman"
    source activate blocks
}
AR() {
    export VIRTUAL_ENV="$HOME/.miniconda/envs/arctic"
    export PATH="$HOME/.miniconda/bin:$PATH"
    export PYTHONPATH="$HOME/.miniconda/envs/arctic/lib/python2.7/site-packages/:$PYTHONPATH"
    export PYTHONPATH=$PYTHONPATH:"$HOME/exp/jobman"
    source activate arctic
}
TH() {
    echo "Resetting THEANO_FLAGS, PYTHONPATH and PATH ..."
    CLR
    export PATH=$PATH:"/data/lisa/exp/visin/theano/theano/bin"
    export PYTHONPATH=$PYTHONPATH:"/data/lisa/exp/visin/theano/theano/"
}
CLR() {
    if [ ! -z $CONDA_DEFAULT_ENV ]; then
        source ~/.miniconda/bin/deactivate 
    fi
    export THEANO_FLAGS="$THEANO_FLAGS_INIT"
    export PYTHONPATH="$PYTHONPATH_INIT"
    export PATH="$PATH_INIT"
    unset VIRTUAL_ENV
}

export -f uptheano
export -f upblocks
export -f uparctic
export -f BL
export -f AR
export -f CLR
