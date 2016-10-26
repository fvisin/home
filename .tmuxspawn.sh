#!/bin/sh
tmux new-session -d -s tmux_servers
 
#tmux new-window -t tmux_servers:0 -n 'MILA' 'ssh -XYC visin@elisa1.iro.umontreal.ca'
tmux new-window -t tmux_servers:1 -n 'nvidia-server' 'ssh -XYC francesco@131.175.120.145'
tmux new-window -t tmux_servers:2 -n 'localhost'
 
tmux select-window -t tmux_servers:0
tmux attach-session -t tmux_servers
