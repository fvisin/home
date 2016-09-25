#!/bin/bash

load_tmux_config () {
    tmux_home=~/.tmux
    tmux_version="$(tmux -V | cut -c 6-)"
    
    if [[ $(echo "$tmux_version >= 2.1" | bc) -eq 1 ]] ; then
        tmux source-file "$tmux_home/tmux_gt_2.1.conf"
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
