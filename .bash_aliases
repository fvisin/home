# ls aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias lla='ls -alF'
alias lh='ls -sh'
alias la='ls -A'
alias l='ls -CF'

# Colourize grep output.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Colourize diff
command -v colordiff >/dev/null 2>&1 && { alias diff=colordiff; }

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

# Force 256 colors tmux
alias tmux="TERM=xterm-256color tmux"

alias python_no_tcmalloc="/usr/bin/python"
python() {
    if [[ -f /usr/local/lib/libtcmalloc.so.4 ]]; then
        msg="WARNING:Using Google's malloc.\nCall python_no_tcmalloc "
        msg=$msg"to use the default python instead.\n"
        echo -e $msg
        LD_PRELOAD=/usr/local/lib/libtcmalloc.so.4 /usr/bin/python "$@"
    elif [[ -f /usr/lib/libtcmalloc.so.4 ]]; then
        msg="WARNING:Using Google's malloc.\nCall python_no_tcmalloc "
        msg=$msg"to use the default python instead.\n"
        echo -e $msg
        LD_PRELOAD=/usr/lib/libtcmalloc.so.4 /usr/bin/python "$@"
    elif [[ -f $HOME/.local/lib/libtcmalloc.so.4 ]]; then
        msg="WARNING:Using Google's malloc.\nCall python_no_tcmalloc "
        msg=$msg"to use the default python instead.\n"
        echo -e $msg
        LD_PRELOAD=$HOME/.local/lib/libtcmalloc.so.4 /usr/bin/python "$@"
    else
        /usr/bin/python "$@"
    fi
}

# Autocomplete ssh names in bash (defined in .ssh/config)
_complete_ssh_hosts () {
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                    cut -f 1 -d ' ' | \
                    sed -e s/,.*//g | \
                    grep -v ^# | \
                    uniq | \
                    grep -v "\[" ;
            cat ~/.ssh/config | \
                    grep "^Host " | \
                    awk '{print $2}'
            `
    COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
    return 0
}
complete -F _complete_ssh_hosts ssh

# Montreal
lisa() {
    if [ $# == 0 ]; then
        sshpass -f ~/.lisa ssh -YC visin@elisa1
    elif [ $# == 1 ]; then
        sshpass -f ~/.lisa ssh -YC -L $1:localhost:$1 visin@elisa1
    else
        echo "usage: sshlisa [port]"
    fi
}
alias lisassh=lisa
lisascp() {
    sshpass -f ~/.lisa scp -Cr visin@elisa1.iro.umontreal.ca:$1 $2
}
lisarsync() {
    sshpass -f ~/.lisa rsync -a -X --partial -h --progress --copy-links visin@elisa1.iro.umontreal.ca:$1 $2
}
alias squeue='squeue -o "%.6i %.1t %.6q %.7m %.12b %.3C %.3D %.18k %.11L %R"'

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

# who is using gpus
gpu_who() {
    for i in `nvidia-smi -q -d PIDS | grep ID | cut -d ":" -f2`; do ps -u -p "$i"; done
}

# rsync options
alias rsyncopt="rsync -a -X --partial -h --progress --bwlimit=20000 --copy-links "
alias rsyncopt_nolimit="rsync -a -X --partial -h --progress --copy-links "
cpdataset() {
    if [ "$#" -ne 4 ]; then
        echo "Usage: cpdataset <source_files> <dest_user> <dest_server> <dest_root_dir>"
    else
        tar czf - $1 | ssh $2@$3 "cd $4 && tar xvzf -"
    fi
    }
export -f cpdataset

# Manage the weird pkscreen routine for lisa lab
alias frascreen="pkscreen; sleep 5; screen -r; sleep 2"

# Quick set THEANO_FLAGS
CPU(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cpu,floatX=float32; }
CPU0(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cpu0,floatX=float32; }
CPU1(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cpu1,floatX=float32; }
CPU2(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cpu2,floatX=float32; }
GPU(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu,floatX=float32,scan.allow_gc=False; }
GPU0FAST(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu0,floatX=float32,scan.allow_gc=False; }
GPU1FAST(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu1,floatX=float32,scan.allow_gc=False; }
GPU2FAST(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu2,floatX=float32,scan.allow_gc=False; }
GPU3FAST(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu3,floatX=float32,scan.allow_gc=False; }
GPU4FAST(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu4,floatX=float32,scan.allow_gc=False; }
GPU5FAST(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu5,floatX=float32,scan.allow_gc=False; }
GPU6FAST(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu6,floatX=float32,scan.allow_gc=False; }
GPU7FAST(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu7,floatX=float32,scan.allow_gc=False; }
GPU8FAST(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu8,floatX=float32,scan.allow_gc=False; }
GPU0(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu0,floatX=float32; }
GPU1(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu1,floatX=float32; }
GPU2(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu2,floatX=float32; }
GPU3(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu3,floatX=float32; }
GPU4(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu4,floatX=float32; }
GPU5(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=gpu5,floatX=float32; }
CUDA(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cuda,floatX=float32; }
CUDA0(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cuda0,floatX=float32; }
CUDA1(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cuda1,floatX=float32; }
CUDA2(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cuda2,floatX=float32; }
CUDA3(){ export THEANO_FLAGS="$THEANO_FLAGS_INIT",device=cuda3,floatX=float32; }
FC(){ export THEANO_FLAGS=compiler=fast_compile${THEANO_FLAGS:+,${THEANO_FLAGS}}; }
PROFILE(){ export CUDA_LAUNCH_BLOCKING=1;export THEANO_FLAGS="$THEANO_FLAGS_INIT",proﬁle_memory=True,profile=True,$THEANO_FLAGS; }
PL(){ export THEANO_FLAGS="$THEANO_FLAGS",dnn.conv.algo_bwd_filter=time_once,dnn.conv.algo_bwd_data=time_once,optimizer_excluding=local_softmax_dnn_grad; }
TF(){ echo $THEANO_FLAGS; }
TEN() {
    export LIBRARY_PATH=:/Tmp/lisa/os_v5/cudnn_v4:/Tmp/lisa/os_v5/lib:/Tmp/lisa/os_v5/lib64:/usr/local/lib:/usr/lib64/atlas/::/usr/local/cuda/lib/:/usr/local/cuda/lib64/:/usr/local/cuda/lib/:/usr/local/cuda/lib64/:/Tmp/lisa/os_v5/lib32:/u/visin/.local/lib/libgpuarray/lib64/:/u/visin/.local/lib/libgpuarray/lib
    export LD_LIBRARY_PATH=/Tmp/lisa/os_v5/cudnn_v4:/Tmp/lisa/os_v5/lib:/Tmp/lisa/os_v5/lib64:/usr/local/lib:/usr/lib64/atlas/::/usr/local/cuda/lib/:/usr/local/cuda/lib64/:/usr/local/cuda/lib/:/usr/local/cuda/lib64/:/Tmp/lisa/os_v5/lib32:/u/visin/.local/lib/libgpuarray/lib64/:/u/visin/.local/lib/libgpuarray/lib
    export CPATH=/Tmp/lisa/os_v5/cudnn_v4:/Tmp/lisa/os_v5/include::/u/visin/.local/lib/libgpuarray/include
}
CVD_CLR(){ export CUDA_VISIBLE_DEVICES=''; }
CVD0(){ export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:+${CUDA_VISIBLE_DEVICES},}0; }
CVD1(){ export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:+${CUDA_VISIBLE_DEVICES},}1; }
CVD2(){ export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:+${CUDA_VISIBLE_DEVICES},}2; }
CVD3(){ export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:+${CUDA_VISIBLE_DEVICES},}3; }
CVD4(){ export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:+${CUDA_VISIBLE_DEVICES},}4; }
CVD5(){ export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:+${CUDA_VISIBLE_DEVICES},}5; }
CVD6(){ export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:+${CUDA_VISIBLE_DEVICES},}6; }
CVD7(){ export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:+${CUDA_VISIBLE_DEVICES},}7; }

# Displays
D0(){ export DISPLAY=localhost:0.0; }
D10(){ export DISPLAY=localhost:10.0; }
D11(){ export DISPLAY=localhost:11.0; }
D12(){ export DISPLAY=localhost:12.0; }

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
    # export PYTHONPATH="$HOME/.miniconda/envs/blocks/lib/python2.7/site-packages/:$PYTHONPATH"
    source activate blocks
}
AR() {
    export VIRTUAL_ENV="$HOME/.miniconda/envs/arctic"
    export PATH="$HOME/.miniconda/bin:$PATH"
    # export PYTHONPATH="$HOME/.miniconda/envs/arctic/lib/python2.7/site-packages/:$PYTHONPATH"
    source activate arctic
}
TH() {
    echo "Resetting THEANO_FLAGS, PYTHONPATH and PATH ..."
    CLR
    export PATH=$PATH:"/data/lisa/exp/visin/theano/theano/bin"
    # export PYTHONPATH=$PYTHONPATH:"/data/lisa/exp/visin/theano/theano/"
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
export -f TF
export -f TEN
