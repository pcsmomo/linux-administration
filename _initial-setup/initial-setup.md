- update apt up-to-date
  - `sudo apt update`
- install vscode
- install git, `sudo apt install git`
  - set up ssh
  - `git config --global user.name ""`
  - `git config --global user.email ""`
- install tig, `sudo apt install tig`

- Typing delay
  - Settings > Universal Access > Repeat Keys > Delay - 1cm from the left

- install terminator
  - `sudo apt update && sudo apt install terminator`

- install nvm / node
  - [nvm github](https://github.com/nvm-sh/nvm)
  - `wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash`
```sh
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```
  - `nvm install node`