#!/bin/bash

ERROR_STR="'bc' is required to select the tmux version but it's not installed."
ERROR_STR="$ERROR_STR Tmux will fallback to using the config for version < 1.9"
ERROR_STR="$ERROR_STR, which might not work."

set_tmux_config () {
    tmux_home="$HOME/.tmux"
    tmux_version="$(tmux -V | cut -d ' ' -f2)"

    type bc >/dev/null 2>&1 || { echo >&2; echo >&2 "ATTENTION:"; echo >&2 $ERROR_STR;}
    
    if [[ $(echo "$tmux_version >= 2.1" | bc) -eq 1 ]] ; then
        config_file="$tmux_home/tmux_ge_2.1.conf"
    elif [[ $(echo "$tmux_version >= 1.9" | bc) -eq 1 ]] ; then
        config_file="$tmux_home/tmux_1.9_to_2.1.conf"
    else
        config_file="$tmux_home/tmux_lt_1.9.conf"
    fi

    if [ -f "$HOME/.tmux.conf" ]; then
        rm "$HOME/.tmux.conf"
    fi
    cat "$tmux_home/tmux_base.conf" > "$HOME/.tmux.conf"
    cat "$config_file" >> "$HOME/.tmux.conf"
}
set_tmux_config 
