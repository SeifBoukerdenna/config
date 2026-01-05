
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme (Powerlevel10k)
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search git-auto-fetch)

source $ZSH/oh-my-zsh.sh

# User configuration
alias docker="/Applications/Docker.app/Contents/Resources/bin/docker"
alias ls="eza --icons=always --color=always"
alias ll="eza -al --icons=always --group-directories-first"
alias tree="eza --tree --icons=always"
alias cat="bat"

# Load Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# FZF
eval "$(fzf --zsh)"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# PATH configurations
export PATH="$HOME/.console-ninja/.bin:$HOME/.local/share/solana/install/active_release/bin:$HOME/.local/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Google Cloud SDK
if [ -f '/Users/malikmacbook/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/malikmacbook/Downloads/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/malikmacbook/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/malikmacbook/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Docker Completions
fpath=(/Users/malikmacbook/.docker/completions $fpath)
autoload -Uz compinit
compinit

# --- DISABLED STARSHIP (Conflict with P10k) ---
# eval "$(starship init zsh)" 
if ! pgrep -x "borders" > /dev/null; then
    borders active_color=0xff7aa2f7 inactive_color=0xff414868 width=5.0 &
fi
# --- SAFE ZELLIJ AUTO-START ---
# This checks if we are in an interactive terminal (TTY) and not already in Zellij.
if [[ -z "$ZELLIJ" ]] && [[ -t 1 ]]; then
    # We use 'exec' to replace the current shell with Zellij. 
    # This prevents the 'shell inside a shell' memory issue and often fixes the panic.
    exec zellij
fi

# Auto-maximize Alacritty when opening Neovim

 
nvim() {
  # 0. Capture current Alacritty window geometry (x y w h)
  local winGeom winX winY winW winH

  winGeom="$(osascript <<'EOF'
tell application "System Events"
  if not (exists process "Alacritty") then return ""
  tell process "Alacritty"
    if (count of windows) is 0 then return ""
    set winPos to position of front window
    set winSize to size of front window
    set {x, y} to winPos
    set {w, h} to winSize
    return (x as string) & " " & (y as string) & " " & (w as string) & " " & (h as string)
  end tell
end tell
EOF
)"

  if [ -n "$winGeom" ]; then
    # parse "x y w h"
    read -r winX winY winW winH <<EOF
$winGeom
EOF
  fi

  # 1. Maximize Alacritty to desktop bounds
  osascript <<'EOF'
tell application "Finder"
  set desktopBounds to bounds of window of desktop
end tell

set x1 to item 1 of desktopBounds
set y1 to item 2 of desktopBounds
set x2 to item 3 of desktopBounds
set y2 to item 4 of desktopBounds

set screenWidth to x2 - x1
set screenHeight to y2 - y1

tell application "System Events"
  tell process "Alacritty"
    set position of front window to {x1, y1}
    set size of front window to {screenWidth, screenHeight}
  end tell
end tell
EOF

  # 2. Run Neovim
  command nvim "$@"

  # 3. Restore original geometry (only if we actually captured it)
  if [ -n "$winGeom" ]; then
    osascript - "$winX" "$winY" "$winW" "$winH" <<'EOF'
on run argv
  if (count of argv) is not 4 then return

  set winX to item 1 of argv as integer
  set winY to item 2 of argv as integer
  set winW to item 3 of argv as integer
  set winH to item 4 of argv as integer

  tell application "System Events"
    if not (exists process "Alacritty") then return
    tell process "Alacritty"
      if (count of windows) is 0 then return
      set position of front window to {winX, winY}
      set size of front window to {winW, winH}
    end tell
  end tell
end run
EOF
  fi
}
