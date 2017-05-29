#!/bin/bash

ERROR_STR="'bc' is required to select the tmux version but it's not installed."
ERROR_STR="$ERROR_STR Falling back to config lt1.9"

load_tmux_config () {
    tmux_home=~/.tmux
    tmux_version="$(tmux -V | cut -d ' ' -f2)"

    type bc >/dev/null 2>&1 || { echo >&2 $ERROR_STR;}
    
    if [[ $(echo "$tmux_version >= 2.1" | bc) -eq 1 ]] ; then
        tmux source-file "$tmux_home/tmux_ge_2.1.conf"
        exit
    elif [[ $(echo "$tmux_version >= 1.9" | bc) -eq 1 ]] ; then
        tmux source-file "$tmux_home/tmux_1.9_to_2.1.conf"
        exit
    else
        tmux source-file "$tmux_home/tmux_lt_1.9.conf"
        exit
    fi
}
load_tmux_config 
