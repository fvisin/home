# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=999999
HISTFILESIZE=50000

# Catch terminal window resizes properly: check the window size after each 
# command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If this is an gnome-terminal set the title to user@host:dir
# For konsole, just modify the preferences to print %w
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1" # gnome
    ;;
*)
    ;;
esac

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

eval `dircolors ~/.dircolors`

################################### LAPTOP ####################################
if [[ `hostname` == 'fraptop' || `hostname` == 'nvidia-robotica' || `hostname` == 'AITeam' ]]; then

    # enable bash completion in interactive shells
    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi
 
    # CUDA
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64/${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
    export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda/lib64/${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
    export CPATH=/usr/local/cuda/include${CPATH:+:${CPATH}}
    export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
    export CUDA_ROOT=/usr/local/cuda/

    # texlive path
    export PATH=/usr/local/texlive/2016/bin/x86_64-linux${PATH:+:${PATH}}
    export INFOPATH=/usr/local/texlive/2016/texmf-dist/doc/info

    # Set TMP
    export TMP='/tmp'
    export TMPDIR='/tmp'

    # PATHS
    export BLOCKS_DATA_PATH='/home/francesco/exp/datasets'
    export FUEL_DATA_PATH='/home/francesco/exp/datasets'

    # LC
    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

################################### HELIOS ####################################
elif [[ `dnsdomainname` == "helios" ]]; then
    # Source global definitions
    if [ -f /etc/bashrc ]; then
        . /etc/bashrc
    fi

    # CLUMEQ
    for i in /clumeq/etc/profile.d/*.sh ; do
       if [ -r "$i" ]; then
           . $i
       fi
    done

    # Source group definitions
    if [ -f /rap/jvb-000-aa/stack/.bashrc ]; then
       . /rap/jvb-000-aa/stack/.bashrc
    else
       echo "No config available. Please report this."
    fi

    # User specific environment and startup programs
    export PATH=$HOME/bin${PATH:+:${PATH}}
    #source /rap/jvb-000-aa/local_v3/.local.bashrc
    # Source group definitions
    if [ -f /rap/jvb-000-aa/stack/.bashrc ]; then
        . /rap/jvb-000-aa/stack/.bashrc
    else
        echo "No config available. Please report this."
    fi

    # LC
    export LC_CTYPE=en_CA.UTF-8
    export LC_ALL=en_CA.UTF-8

################################### LAB #######################################
elif [[ `hostname -d` == 'iro.umontreal.ca' ]] ; then
    ##### Load the lab profile
    export GPUARRAY=none
    if [ -e "~/.profile" ];
      then . ~/.profile
    fi
        
    if [ -e "/opt/lisa/os_v5/.local.bashrc" ];
      then echo "os_v5"; source "/opt/lisa/os_v5/.local.bashrc";
    elif [ -e "/opt/lisa/os_v4/.local.bashrc" ];
      then echo "os_v4"; source "/opt/lisa/os_v4/.local.bashrc";
    fi

    # Set BLAS_FLAG
    export BLAS_FLAG=',blas.ldflags="-L/usr/lib/ -lblas"'

    # tmux stores open sessions in TMPDIR. Has to be explicitly set or when 
    # connecting with ssh the local TMPDIR will be set in some cases.
    # export TMPDIR=/Tmp/visin  # use -S flag instead

    # PATHS
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

    # Disable caching
    export CHROMIUM_FLAGS="--disk-cache-dir=/dev/null --disk-cache-size=1"

    # David's tmux hack!
    # https://github.com/dwf/dotfiles/blob/4bca935672492f7be054bd1d7b69fe48ac4cb86a/shell/.bashrc.d/site/lisa#L32
    #alias tmux="krenew -b -t tmux"
    TMUX_EXECUTABLE=`which tmux`
    TMUX_EXECUTABLE="$TMUX_EXECUTABLE -S /Tmp/$USER/tmux-socket"
    function tmux() {
        TERM=xterm-256color
        if [ $# -eq 0 ] || [ $1 == "new-session" ]; then
            CREDENTIALS=$(echo $KRB5CCNAME |cut -d':' -f 2)
            NEWTICKET=$(mktemp /tmp/krb5cc_${UID}_tmux_XXXXXXXXXXXXXXX)
            cp $CREDENTIALS $NEWTICKET
            KRB5CCNAME="FILE:$NEWTICKET" $TMUX_EXECUTABLE "$@"
            echo cp $CREDENTIALS $NEWTICKET
            echo KRB5CCNAME="FILE:$NEWTICKET" tmux "$@"
        else
            $TMUX_EXECUTABLE "$@"
        fi
    }

    function run_tmux_pkboost() {
        pkboost +d $1
        export TMUX_PKBOOST=$(pgrep -f "pkboost \+d $1")
        $TMUX_EXECUTABLE set-environment -g TMUX_PKBOOST $TMUX_PKBOOST
        echo pkboost +d $1
        echo export TMUX_PKBOOST=$(pgrep -f "pkboost \+d $1")
        echo tmux set-environment -g TMUX_PKBOOST $TMUX_PKBOOST
    }

    export -p tmux
    export -p run_tmux_pkboost

    if [ -n "$TMUX" ]; then
        TMUX_DIR=`dirname \`echo $TMUX |cut -d ',' -f 1\``
        TMUX_PID=`echo $TMUX |cut -d ',' -f 2`
        if [ -z "$TMUX_PKBOOST" ]; then
            run_tmux_pkboost $TMUX_PID
        fi
    fi

    # Set cache to be local
    # export XDG_CACHE_HOME='/Tmp/visin'

    # Set browser for ipython notebook
    # export BROWSER='/opt/lisa/os/firefox-39.0.x86_64/firefox-bin'
    export BROWSER=$FIREFOX_BIN

    # LC
    export LC_CTYPE=en_CA.UTF-8
    export LC_ALL=en_CA.UTF-8

fi

################################# COMMON POST #################################

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

# PATHS
#=======
export PYTHONPATH_INIT="$PYTHONPATH"
export PATH=$HOME/.local/bin:${PATH:+:${PATH}}
export PATH_INIT="$PATH"

# THEANO AND LIBGPUARRAY
#=======================
export THEANO_FLAGS=$BLAS_FLAG
export THEANO_FLAGS_INIT="$THEANO_FLAGS"
# libgpuarray
export LD_LIBRARY_PATH=$HOME/.local/lib64/:$HOME/.local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export LIBRARY_PATH=$HOME/.local/lib64/:$HOME/.local/lib${LIBRARY_PATH:+:${LIBRARY_PATH}}
export CPATH=$HOME/.local/include${CPATH:+:${CPATH}}

# OTHERS
#========
export EDITOR=vim

# autojump
[[ -s /u/visin/.autojump/etc/profile.d/autojump.sh ]] && source /u/visin/.autojump/etc/profile.d/autojump.sh

# cool bash and git bash extension
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
fi

# SOLARIZED
# if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then TERM=gnome-256color; fi
# See http://unix.stackexchange.com/questions/105926/how-to-include-commands-in-bashs-ps1-without-breaking-line-length-calculation

# You can get a list of colors with:
# for i in {0..255}; do
#     printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
# done

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      BASE03=$(tput setaf 234)
      BASE02=$(tput setaf 235)
      BASE01=$(tput setaf 240)
      BASE00=$(tput setaf 241)
      BASE0=$(tput setaf 244)
      BASE1=$(tput setaf 245)
      BASE2=$(tput setaf 254)
      BASE3=$(tput setaf 230)
      YELLOW=$(tput setaf 136)
      ORANGE=$(tput setaf 166)
      RED=$(tput setaf 160)
      MAGENTA=$(tput setaf 125)
      VIOLET=$(tput setaf 61)
      BLUE=$(tput setaf 33)
      CYAN=$(tput setaf 37)
      GREEN=$(tput setaf 64)
    else
      BASE03=$(tput setaf 8)
      BASE02=$(tput setaf 0)
      BASE01=$(tput setaf 10)
      BASE00=$(tput setaf 11)
      BASE0=$(tput setaf 12)
      BASE1=$(tput setaf 14)
      BASE2=$(tput setaf 7)
      BASE3=$(tput setaf 15)
      YELLOW=$(tput setaf 3)
      ORANGE=$(tput setaf 9)
      RED=$(tput setaf 1)
      MAGENTA=$(tput setaf 5)
      VIOLET=$(tput setaf 13)
      BLUE=$(tput setaf 4)
      CYAN=$(tput setaf 6)
      GREEN=$(tput setaf 2)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
# else
    # Linux console colors. I don't have the energy
    # to figure out the Solarized values
    # foreground colors
    # BLACK=\e[0;30m        # Black
    # RED=\e[0;31m          # Red
    # GREEN=\e[0;32m        # Green
    # YELLOW=\e[0;33m       # Yellow
    # BLUE=\e[0;34m         # Blue
    # PURPLE=\e[0;35m       # Purple
    # CYAN=\e[0;36m         # Cyan
    # WHITE=\e[0;37m        # White
    # MAGENTA="\033[1;31m"
    # ORANGE="\033[1;33m"
    # GREEN="\033[1;32m"
    # PURPLE="\033[1;35m"
    # WHITE="\033[1;37m"
    # BOLD=""
    # RESET="\033[m"
fi

# format bash
# RESET=${WHITE}
PS1='\[${GREEN}\]┌─────── \u@\h\[${BLUE}\] [\w]\[${YELLOW}\]$(__git_ps1 " (%s)")\n\[${GREEN}\]└─ λ \[${RESET}\]'
# VIRTUAL_ENV_DISABLE_PROMPT=1 source ~/Enthought/Canopy_64bit/User/bin/activate

# Set an xterm title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Uncomment to use my own conda env
# export PATH=$HOME/.miniconda/bin:$PATH
