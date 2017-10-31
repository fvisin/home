## SETUP
* Clone the repository in a temporary directory:

  (HTTPS) `git clone https://github.com/fvisin/home.git ~/home`
  
  (GIT) `git clone git@github.com:fvisin/home.git ~/home`

* Access the temporary directory: `cd ~/home`

* Move every file to the your home:

  (LINUX) `find . -mindepth 1 -maxdepth 1 -exec mv -t.. -- {} +`
  (Mac) `find . -mindepth 1 -maxdepth 1  -execdir mv '{}' .. \;`
  
* Remove the temporary directory: `cd ; rm -r ~/home`

## SOLARIZED GNOME-TERMINAL
(From: https://xorcode.com/code/2011/04/11/solarized-vim-eclipse-ubuntu.html)

Run `. .solarize_gnome_terminal.sh` to setup your gnome-terminal with the
solarized palette.

---

## Optional steps for MAC
#### Install homebrew in ~/.homebrew
```
cd ~
mkdir .homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C .homebrew
```

#### Reclaim home to allow to mount FS other than NFS
```
sudo defaults write /Library/Preferences/com.google.corp.machineinfo EnableAutofs -bool FALSE
sudo gmac-updater
```

#### Install useful software via brew
```
brew install coreutils
brew install mosh
```
