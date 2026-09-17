# 42
alias ccf="cc -Wall -Wextra -Werror $@"
alias norm="norminette"
alias normh="norminette -R CheckDefine"

alias c='cursor'

# config
alias zshconf="hx ~/.zshrc"
alias hxconf="hx ~/.config/helix/config.toml"
alias vimconf='vi ~/.config/vimrc'

# shorter commands
alias vi="vim"
alias val="valgrind --leak-check=full --leak-kind=all --track-origins=yes"
alias updatedb="sudo /usr/libexec/locate.updatedb"
alias genclass="/Users/arthur/Storage/cpp_class_generator/main.py"
alias lg="lazygit"
alias zj="zellij"
alias gcaa="git commit --amend"

if command -v eza &> /dev/null; then
  alias ls="eza"
  alias ll="eza -l"
  alias la="eza -la"
fi

if command -v nvim &> /dev/null; then
  alias vim="nvim"
fi

if [ "$(uname)" != 'Darwin' ]; then
  alias ipall="ip -br -c a"
fi

alias ec="editorconfig-checker"
alias vm="utmctl"

# Cargo
alias co=cargo
alias cr='cargo run'
alias crr='cargo run --release'
alias crq='cargo run --quiet'
alias cl='cargo clean'
alias ccl='cargo clippy'
alias cb='cargo build'
alias cbr='cargo build --release'
alias ct='cargo test'
alias ca='cargo add'
alias ci='cargo install'
alias cfi='cargo fix'
alias cf='cargo fmt'
alias cfe='cargo fetch'
alias cpa='cargo package'
alias cs='cargo search'

# Makefile
alias m='make'
alias ma='make all'
alias mf='make -j8'
alias mre='make re'
alias mc='make clean'
alias mfc='make fclean'
alias mr='make run'
alias mt='make test'

if command -v grc &> /dev/null; then
  alias nmap="grc nmap"
fi
