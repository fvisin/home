# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=5000

# Catch terminal window resizes properly: check the window size after each 
# command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

################################### LAPTOP ####################################
if [ `hostname` == 'fraptop' ]; then

    # enable bash completion in interactive shells
    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi
 
    # CUDA
    export PATH=/usr/local/cuda/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/lib:$LD_LIBRARY_PATH
    export CUDA_ROOT=/usr/local/cuda/bin
   
    # Set TMP
    export TMP='/tmp'

    # Set BLAS_FLAG
    unset BLAS_FLAG

    # PATHS
    export PYLEARN2_DATA_PATH='/home/francesco/exp/datasets'
    export BLOCKS_DATA_PATH='/home/francesco/exp/datasets'
    export FUEL_DATA_PATH='/home/francesco/exp/datasets'

################################### HELIOS ####################################
elif [[ `hostname` == *"helios"* ]]; then
    source /rap/jvb-000-aa/local_v2/.local.bashrc
    
    # CLUMEQ
    for i in /clumeq/etc/profile.d/*.sh ; do
        if [ -r "$i" ]; then
            . $i
        fi
    done

    # User specific environment and startup programs
    export PATH=$PATH:$HOME/bin
    #export PATH=/software-gpu/cuda/7.0.28/bin:$PATH
    #export LD_LIBRARY_PATH=/software-gpu/cuda/7.0.28/lib:$LD_LIBRARY_PATH
    export CULA_ROOT="./cula17"
    export CULA_INC_PATH="$CULA_ROOT/include"
    export CULA_LIB_PATH_32="$CULA_ROOT/lib"
    export CULA_LIB_PATH_64="$CULA_ROOT/lib64"
    export LD_LIBRARY_PATH=$CULA_LIB_PATH_64:$LD_LIBRARY_PATH
    source ~/load_modules.sh

################################### LAB #######################################
elif [ `echo $HOSTNAME | cut -d '.' -f 2` == 'iro' ] ; then
    ##### Load the lab profile
    if [ -e "~/.profile" ];
      then . ~/.profile
    fi
        
    if [ -e "/opt/lisa/os_v4/.local.bashrc" ];
      then source "/opt/lisa/os_v4/.local.bashrc"; 
    fi

    # Set BLAS_FLAG
    # export BLAS_FLAG=',blas.ldflags="-L/usr/lib64/ -lblas"'
    unset BLAS_FLAG

    # PATHS
    export PYLEARN2_DATA_PATH='/data/lisa/data'
    export BLOCKS_DATA_PATH='/data/lisa/data'
    export FUEL_DATA_PATH='/data/lisa/data'

    # set browser for ipython notebook
    export BROWSER='/opt/lisa/os/firefox-39.0.x86_64/firefox-bin'

fi

################################### COMMON ###################################

if [ -z ${THEANORC+x} ]; then
    export THEANORC=~/.theanorc
fi

# GIT AUTOCOMPLETE
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi

# Ctrl-D
IGNOREEOF=10   # Shell only exists after the 10th consecutive Ctrl-d

export BIBINPUTS=.:$HOME/articles/bib:
export BSTINPUTS=.:$HOME/articles/bst:
export TEXINPUTS=.:$HOME/articles/sty:

alias CPU='export THEANO_FLAGS=device=cpu,floatX=float32'$BLAS_FLAG
alias CPU0='export THEANO_FLAGS=device=cpu0,floatX=float32'$BLAS_FLAG
alias CPU1='export THEANO_FLAGS=device=cpu1,floatX=float32'$BLAS_FLAG
alias CPU2='export THEANO_FLAGS=device=cpu2,floatX=float32'$BLAS_FLAG
alias GPU='export THEANO_FLAGS=device=gpu,floatX=float32,scan.allow_gc=False'$BLAS_FLAG
alias GPU0='export THEANO_FLAGS=device=gpu0,floatX=float32,scan.allow_gc=False'$BLAS_FLAG
alias GPU1='export THEANO_FLAGS=device=gpu1,floatX=float32,scan.allow_gc=False'$BLAS_FLAG
alias GPU2='export THEANO_FLAGS=device=gpu2,floatX=float32,scan.allow_gc=False'$BLAS_FLAG
alias GPU0SLOW='export THEANO_FLAGS=device=gpu0,floatX=float32'$BLAS_FLAG
alias GPU1SLOW='export THEANO_FLAGS=device=gpu1,floatX=float32'$BLAS_FLAG
alias GPU2SLOW='export THEANO_FLAGS=device=gpu2,floatX=float32'$BLAS_FLAG
alias PROFILE='export CUDA_LAUNCH_BLOCKING=1;export THEANO_FLAGS=proﬁle_memory=True,profile=True,$THEANO_FLAGS'

# PATHS
#=======
export PATH="$HOME/.local/bin/:$HOME/exp/jobman/bin:"$PATH
export PYTHONPATH_INIT="$PYTHONPATH"
export PATH_INIT="$PATH"

# THEANO AND PYLEARN2
#=====================
export THEANO_FLAGS=$BLAS_FLAG
export THEANO_FLAGS_INIT="$THEANO_FLAGS"

# PYLEARN2
#==========
#export PYLEARN2_VIEWER_COMMAND="eog --new-instance"
export PYLEARN2_PICKLE_PROTOCOL='pickle.HIGHEST_PROTOCOL'	# better pickle compression

# UPGRADES
#==========
# theano
uptheano() {
    currdir=`pwd`
    # normal
    if [ -z ${VIRTUAL_ENV} ]; then
        if [ ! -d $HOME/exp/theano/theano ]; then
            echo "Installing theano for the first time..."
            git clone git@github.com:fvisin/Theano.git $HOME/exp/theano/theano
            cd $HOME/exp/theano/theano
            git remote add theano git@github.com:Theano/Theano.git
            python setup.py develop
        else
            echo "Upgrading theano..."
        fi
            cd $HOME/exp/theano/theano
            git fetch theano
            git rebase theano/master master
    # virtual environment
    else
        export THEANO_PATH=$HOME/exp/theano/$CONDA_DEFAULT_ENV/
        if [ ! -d $THEANO_PATH ]; then
            echo "Installing theano for the first time in this environment..."
            git clone 'git@github.com:Theano/Theano.git' $THEANO_PATH
            cd $THEANO_PATH
            python setup.py develop
        else
            echo "Upgrading theano in this environment..."
            cd $THEANO_PATH
            git pull origin
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
        git clone git@github.com:fvisin/fuel.git
        cd fuel
        git remote add fuel git@github.com:bartvm/fuel.git
    fi
    # update
    cd ~/exp/fuel
    git fetch fuel
    git rebase fuel/master master
    pip install -e file:.#egg=fuel[test,docs]
    python setup.py build_ext --inplace  # rebuild cython

    # blocks 
    if [ ! -d ~/exp/blocks ]; then
        echo "Installing blocks for the first time..."
        cd "$HOME"/exp
        git clone git@github.com:fvisin/blocks.git 
        cd blocks
        git remote add blocks git@github.com:bartvm/blocks.git
    fi
    # update
    cd ~/exp/blocks
    git fetch blocks
    git rebase blocks/master master
    pip install -e file:.#egg=blocks[test,docs] -r requirements.txt
    cd $currdir
}

# arctic
uparctic() {
    AR
    currdir=`pwd`
    cd ~/exp/arctic
    git fetch arctic
    git rebase arctic/master master
    cd $currdir
}

# ENVIRONMENTS
# =============
PL() {
    export VIRTUAL_ENV="$HOME/.miniconda/envs/pylearn2"
    export PATH="$HOME/.miniconda/bin:$PATH"
    export PATH="$HOME/exp/pylearn2/pylearn2/scripts:$PATH"
    export PATH="$HOME/.local_extra/bin:$PATH"
    export PYTHONPATH="$HOME/.local_extra/lib/python2.7/site-packages"
    export PYTHONPATH="$HOME/.miniconda/envs/pylearn2/lib/python2.7/site-packages/:$PYTHONPATH"
    export PYTHONPATH=$PYTHONPATH:"$HOME/exp/jobman"
    source activate pylearn2
}
BL() {
    export VIRTUAL_ENV="$HOME/.miniconda/envs/blocks"
    export PATH="$HOME/.miniconda/bin:$PATH"
    export PATH="$HOME/.local_extra/bin:$PATH"
    export PYTHONPATH="$HOME/.local_extra/lib/python2.7/site-packages"
    export PYTHONPATH="$HOME/.miniconda/envs/blocks/lib/python2.7/site-packages/:$PYTHONPATH"
    export PYTHONPATH=$PYTHONPATH:"$HOME/exp/jobman"
    source activate blocks
}
AR() {
    export VIRTUAL_ENV="$HOME/.miniconda/envs/arctic"
    export PATH="$HOME/.miniconda/bin:$PATH"
    export PATH="$HOME/.local_extra/bin:$PATH"
    export PYTHONPATH="$HOME/.local_extra/lib/python2.7/site-packages"
    export PYTHONPATH="$HOME/.miniconda/envs/arctic/lib/python2.7/site-packages/:$PYTHONPATH"
    export PYTHONPATH=$PYTHONPATH:"$HOME/exp/jobman"
    source activate arctic
}
CLR() {
    if [ ! -z $CONDA_DEFAULT_ENV ]; then
        source ~/.miniconda/bin/deactivate 
    fi
    export THEANO_FLAGS="$THEANO_FLAGS_INIT"
    export PYTHONPATH="$PYTHONPATH_INIT"
    export PATH="$PATH_INIT"
    export VIRTUAL_ENV=""
}

export -f uptheano
export -f upblocks
export -f uparctic
export -f PL
export -f BL
export -f AR
export -f CLR

# OTHERS
#========
export EDITOR=vim
alias frascreen="pkscreen; sleep 5; screen -r; sleep 2"

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
