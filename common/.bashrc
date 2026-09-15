#!/bin/bash
# --- common/.bashrc ---

# Non-interactive check
[[ $- != *i* ]] && return

# PATH and every ~/.bash_<name> config (aliases, colors, per-package files)
src="$HOME/.bash_init"; [ -f "$src" ] && . "$src"

# Only set PS1 if no custom prompt engine is active
if [[ -z "$STARSHIP_SHELL$POSH_THEME$P9K_TTY" ]]; then
    # Set colorized prompt if tput color is supported
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # UID check for color coding
        [ "$(id -u)" -eq 0 ] && u_clr=$red || u_clr=$grn
        export PS1="\[$u_clr\]\u\[$ylw\]@\[$cyn\]\h\[$wht\]: \[$blu\]\w\[$blk\] \[$mgn\]\$ \[$rst\]"
    else
        # Fallback for non-color terminals
        PS1='${debian_chroot:+($debian_chroot)}\u@\h: \w\$ '
    fi
fi

# SSH Agent - Interactive Shell Only
if [[ $- == *i* ]]; then
    # Ensure the socket is available
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" &>/dev/null
    fi

    # Load keys if the agent is currently empty
    if ssh-add -l &>/dev/null | grep -q "The agent has no identities"; then
        ssh-add-all &>/dev/null
    fi
fi

# Variable and prompt cleanup
unset src u_clr
echo -ne "${rst}"

[[ $(which fastfetch) ]] && fastfetch
