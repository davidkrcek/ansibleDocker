export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'
export TERM=xterm

export FZF_BASE="/home/ansible/.fzf"

##### Zsh/Oh-my-Zsh Configuration
export ZSH="/home/ansible/.oh-my-zsh"

ZSH_THEME="spaceship-prompt/spaceship"
plugins=(git ssh-agent zsh-syntax-highlighting zsh-history-substring-search zsh-autosuggestions zsh-completions fzf  )

SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_PROMPT_SEPARATE_LINE="false"
source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh