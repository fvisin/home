# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# [ -z "$PS1" ] && return

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

# # set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi
# 
# # set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color) color_prompt=yes;;
# esac
# 
# # uncomment for a colored prompt, if the terminal has the capability; turned
# # off by default to not distract the user: the focus in a terminal window
# # should be on the output of commands, not on the prompt
# #force_color_prompt=yes
# 
# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#     # We have color support; assume it's compliant with Ecma-48
#     # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#     # a case would tend to support setf rather than setaf.)
#     color_prompt=yes
#     else
#     color_prompt=
#     fi
# fi
# 
# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# # Add an "alert" alias for long running commands.  Use like so:
# #   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
 
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
if [[ `hostname` == 'fraptop' || `hostname` == 'nvidia-robotica' ]]; then

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
    export TMPDIR='/tmp'

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

    # tmux stores open sessions in TMPDIR. Has to be explicitly set or when 
    # connecting with ssh the local TMPDIR will be set in some cases.
    export TMPDIR=/Tmp/visin

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
elif [[ `hostname -d` == 'iro.umontreal.ca' ]] ; then
    ##### Load the lab profile
    if [ -e "~/.profile" ];
      then . ~/.profile
    fi
        
    if [ -e "/opt/lisa/os_v5/.local.bashrc" ];
      then source "/opt/lisa/os_v5/.local.bashrc"; 
    elif [ -e "/opt/lisa/os_v4/.local.bashrc" ];
      then source "/opt/lisa/os_v4/.local.bashrc"; 
    fi

    # Set BLAS_FLAG
    # export BLAS_FLAG=',blas.ldflags="-L/usr/lib64/ -lblas"'
    unset BLAS_FLAG

    # tmux stores open sessions in TMPDIR. Has to be explicitly set or when 
    # connecting with ssh the local TMPDIR will be set in some cases.
    export TMPDIR=/Tmp/visin

    # PATHS
    export PYLEARN2_DATA_PATH='/data/lisa/data'
    export BLOCKS_DATA_PATH='/data/lisa/data'
    export FUEL_DATA_PATH='/data/lisa/data'

    # I'd rather not use the PYTHONPATH, opting for my own conda installation.
    unset PYTHONPATH
    
    # Fred's up-to-date Firefox install. Use the directory that appears
    # alphabetically last, which hopefully should always be the most recent.
    if [ -d /opt/lisa/os ]; then
        FIREFOX_BIN=`/bin/ls -d /opt/lisa/os/firefox-* | tail -n 1`/bin
        if [ -e $FIREFOX_BIN ] ; then
            front_of_path $FIREFOX_BIN
        fi
    fi

    # David's tmux hack!
    TMUX_EXECUTABLE=`which tmux`
    function tmux() {
        if [ $# -eq 0 ] || [ $1 == "new-session" ]; then
            CREDENTIALS=$(echo $KRB5CCNAME |cut -d':' -f 2)
            NEWTICKET=$(mktemp /tmp/krb5cc_${UID}_tmux_XXXXXXXXXXXXXXX)
            echo cp $CREDENTIALS $NEWTICKET
            cp $CREDENTIALS $NEWTICKET
            echo KRB5CCNAME="FILE:$NEWTICKET" tmux "$@"
            echo ""
            KRB5CCNAME="FILE:$NEWTICKET" $TMUX_EXECUTABLE "$@"
        else
            $TMUX_EXECUTABLE "$@"
        fi
    }

    function run_tmux_pkboost() {
        echo pkboost +d $1
        pkboost +d $1
        echo export TMUX_PKBOOST=$(pgrep -f "pkboost \+d $1")
        export TMUX_PKBOOST=$(pgrep -f "pkboost \+d $1")
        echo tmux set-environment -g TMUX_PKBOOST $TMUX_PKBOOST
        $TMUX_EXECUTABLE set-environment -g TMUX_PKBOOST $TMUX_PKBOOST
    }

    if [ -n "$TMUX" ]; then
        TMUX_DIR=`dirname \`echo $TMUX |cut -d ',' -f 1\``
        TMUX_PID=`echo $TMUX |cut -d ',' -f 2`
        if [ -z "$TMUX_PKBOOST" ]; then
            run_tmux_pkboost $TMUX_PID
        fi
    fi

    # Set browser for ipython notebook
    # export BROWSER='/opt/lisa/os/firefox-39.0.x86_64/firefox-bin'
    export BROWSER=$FIREFOX_BIN

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
# better pickle compression
export PYLEARN2_PICKLE_PROTOCOL='pickle.HIGHEST_PROTOCOL'	

# OTHERS
#========
export EDITOR=vim

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

# Set an xterm title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
