* clone with 

  ```
  git clone https://github.com/fvisin/home.git
  ```
or
  ```
  git clone git@github.com:fvisin/home.git
  ```

* `cd home`

* move every file to parent directory with: 
  ```
  find . -mindepth 1 -maxdepth 1 -exec mv -t.. -- {} +
  ```

* remove home with: `cd ..; rm -r ~/home`

## SOLARIZED GNOME-TERMINAL
From: https://xorcode.com/code/2011/04/11/solarized-vim-eclipse-ubuntu.html
Run `. .solarize_gnome_terminal.sh` to setup your gnome-terminal with the
solarized palette.
