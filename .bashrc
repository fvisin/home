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
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
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


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


######################################## FRA ####################################
if [ `hostname` == 'fraptop' ]; then
    ##### laptop only profile
    
    # CUDA
    #export PATH=/usr/lib/nvidia-cuda-toolkit:$PATH
    #export LD_LIBRARY_PATH=/usr/lib/nvidia-cuda-toolkit/lib:$LD_LIBRARY_PATH
    export CUDA_ROOT=/usr/lib/nvidia-cuda-toolkit
    # CUDA ALTERNATIVES
    #export PATH=/usr/local/cuda/bin:$PATH
    #export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/lib:$LD_LIBRARY_PATH
    #export CUDA_ROOT=/usr/local/cuda/bin
   
    # Set TMP
    export TMP='/tmp'

    # Set BLAS_FLAG
    export BLAS_FLAG=''

    # PATHS
    export PYLEARN2_DATA_PATH='/home/francesco/exp/datasets'
    export BLOCKS_DATA_PATH='/home/francesco/exp/datasets'
    export FUEL_DATA_PATH='/home/francesco/exp/datasets'

else
    ##### lab only profile
    . ~/.profile

    if [ -e "/opt/lisa/os_v3/.local.bashrc" ];
      then source /opt/lisa/os_v3/.local.bashrc; 
    fi
    #umask 027

    # Set BLAS_FLAG
    export BLAS_FLAG=',blas.ldflags="-L/usr/lib64/ -lblas"'

    # PATHS
    export PYLEARN2_DATA_PATH='/data/lisa/data'
    export BLOCKS_DATA_PATH='/data/lisa/data'
    export FUEL_DATA_PATH='/data/lisa/data'

fi

# GIT AUTOCOMPLETE
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi

# Ctrl-D
IGNOREEOF=10   # Shell only exists after the 10th consecutive Ctrl-d

export THEANORC=~/.theanorc
export BIBINPUTS=.:$HOME/articles/bib:
export BSTINPUTS=.:$HOME/articles/bst:
export TEXINPUTS=.:$HOME/articles/sty:

alias CPU='export THEANO_FLAGS=device=cpu,floatX=float3'$BLAS_FLAG
alias CPU0='export THEANO_FLAGS=device=cpu0,floatX=float3'$BLAS_FLAG
alias CPU1='export THEANO_FLAGS=device=cpu1,floatX=float3'$BLAS_FLAG
alias CPU2='export THEANO_FLAGS=device=cpu2,floatX=float3'$BLAS_FLAG
alias GPU='export THEANO_FLAGS=device=gpu,floatX=float32,scan.allow_gc=False'$BLAS_FLAG
alias GPU0='export THEANO_FLAGS=device=gpu0,floatX=float32,scan.allow_gc=False'$BLAS_FLAG
alias GPU1='export THEANO_FLAGS=device=gpu1,floatX=float32,scan.allow_gc=False'$BLAS_FLAG
alias GPU2='export THEANO_FLAGS=device=gpu2,floatX=float32,scan.allow_gc=False'$BLAS_FLAG
alias GPU1SLOW='export THEANO_FLAGS=device=gpu1,floatX=float32'$BLAS_FLAG
alias GPU2SLOW='export THEANO_FLAGS=device=gpu2,floatX=float32'$BLAS_FLAG
alias PROFILE='export CUDA_LAUNCH_BLOCKING=1;export THEANO_FLAGS=proﬁle_memory=True,profile=True,$THEANO_FLAGS'

# PATHS
#=======
export PYTHONPATH=~/.local/lib/python2.7/site-packages/:$PYTHONPATH
export PATH=~/.local/bin/:$PATH
export PYTHONPATH_INIT=$PYTHONPATH
export PATH_INIT=$PATH

# THEANO AND PYLEARN2
#=====================
export THEANO_FLAGS='floatX=float32,scan.allow_gc=False'$BLAS_FLAG
export THEANO_FLAGS_INIT=$THEANO_FLAGS

# PYLEARN2
#==========
#export PYLEARN2_VIEWER_COMMAND="eog --new-instance"
export PYLEARN2_DATA_PATH='/home/francesco/exp/datasets'
export PYLEARN2_DATA_PATH='/data/lisa/data'
export PYLEARN2_PICKLE_PROTOCOL='pickle.HIGHEST_PROTOCOL'	# better pickle compression

# UPGRADES
#==========
# theano
uptheano() {
    pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
}

# blocks
upblocks() {
    BL
    currdir=`pwd`
    if [ ! -d ~/exp/fuel ]; then
        cd $HOME'/exp'
        git clone git@github.com:fvisin/fuel.git
        cd fuel
        git remote add fuel git@github.com:bartvm/fuel.git
    fi
    cd ~/exp/fuel
    git fetch fuel
    git rebase fuel/master master
    if [ ! -d ~/exp/blocks ]; then
        cd $HOME'/exp'
        git clone git@github.com:fvisin/blocks.git
        cd blocks
        git remote add blocks git@github.com:bartvm/blocks.git
    fi
    cd ~/exp/blocks
    git fetch blocks
    git rebase blocks/master master
    pip install --user --upgrade --no-deps -e 'git+git@github.com:fvisin/blocks.git#egg=blocks[test,plot,docs]' --src=$HOME/exp -b $TMP/build #-r https://raw.githubusercontent.com/bartvm/blocks/install_again/requirements.txt'
    cd $currdir
    rm -rf $TMP/build
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
    export PYTHONPATH=''
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
export -f uparctic
export -f PL
export -f BL
export -f AR
export -f CLR

# OTHERS
#========
export EDITOR=vim
export PATH=$HOME'/.local/bin':$PATH
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
