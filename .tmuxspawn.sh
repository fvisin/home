#!/bin/bash
. .bashrc

# Open detached session, with MILA as first window
tmux new-session -d -s tmux -n 'MILA' 'ssh -XYC visin@elisa1.iro.umontreal.ca'

# Add new windows
tmux new-window -t tmux:1 -n 'nvidia-server' 'ssh -XYC francesco@131.175.120.145'
tmux new-window -t tmux:2 -n 'localhost'
tmux split-window -v 'ipython'
tmux split-window -h
 
# Attach to session
tmux select-window -t tmux:0
tmux -2 attach-session -t tmux
