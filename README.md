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

* In order to color the results of `ls` you need to install coreutils via brew as suggested here:
  https://github.com/seebi/dircolors-solarized/issues/10#issuecomment-2641754
  We use a slightly different setup than the one suggested. To get the colors to work with coreutils, you might 
  have to change the coreutils dir in .bash_aliases 

* This setup assumes you installed:
  - MacVim
  - cmake (e.g., via homebrew: `brew install cmake`)
