[ -f ~/.bashrc ] && . ~/.bashrc

export PATH=/usr/local/bin${PATH:+:$PATH}
export C_INCLUDE_PATH=/usr/local/include${C_INCLUDE_PATH:+:$C_INCLUDE_PATH}
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}

case "$(uname -s)" in
    Linux)
        export LD_LIBRARY_PATH=~/.local/lib:/usr/local/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
        ;;
    Darwin)
        export DYLD_LIBRARY_PATH=~/.local/lib:/usr/local/lib${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}

        export BASH_SILENCE_DEPRECATION_WARNING=1
        export FILTER_BRANCH_SQUELCH_WARNING=1
        export COPYFILE_DISABLE=true

        # Get Homebrew prefix.
        if [ "$(arch)" = 'x86_64' ]; then
            HOMEBREW_PREFIX=/usr/local
        else
            HOMEBREW_PREFIX=/opt/homebrew
            export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH:+:$PATH}
            export C_INCLUDE_PATH=$HOMEBREW_PREFIX/include${C_INCLUDE_PATH:+:$C_INCLUDE_PATH}
            export PKG_CONFIG_PATH=$HOMEBREW_PREFIX/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}
        fi

        # Bash completion.
        if [ -f "$HOMEBREW_PREFIX/etc/bash_completion" ]; then
          . "$HOMEBREW_PREFIX/etc/bash_completion"
        fi

        # Homebrew Ruby.
        export PATH=$HOMEBREW_PREFIX/opt/ruby/bin${PATH:+:$PATH}
        export C_INCLUDE_PATH=$HOMEBREW_PREFIX/opt/ruby/include${C_INCLUDE_PATH:+:$C_INCLUDE_PATH}
        export DYLD_LIBRARY_PATH=$HOMEBREW_PREFIX/opt/ruby/lib${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}

        alias tar='tar --exclude=.DS_Store'
        alias certbot="certbot --config-dir $HOMEBREW_PREFIX/etc/letsencrypt/ --logs-dir $HOMEBREW_PREFIX/var/log/letsencrypt/ --work-dir $HOMEBREW_PREFIX/var/lib/letsencrypt/"
        ;;
esac

alias gpg='gpg --expert --no-symkey-cache'

# Go configuration.
if command -v go >/dev/null; then
    if [ -n "$(go env GOBIN)" ]; then
        export PATH=$(go env GOBIN)${PATH:+:$PATH}
    else
        export PATH=$(go env GOPATH)/bin${PATH:+:$PATH}
    fi
fi

# Rust configuration.
export PATH=~/.cargo/bin${PATH:+:$PATH}

# nvm configuration.
export NVM_DIR=~/.nvm
. "$NVM_DIR/nvm.sh"
. "$NVM_DIR/bash_completion"

# opam configuration
test -r /Users/nngai/.opam/opam-init/init.sh && . /Users/nngai/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

export PATH=~/.local/bin${PATH:+:$PATH}
export C_INCLUDE_PATH=~/.local/include${C_INCLUDE_PATH:+:$C_INCLUDE_PATH}
export PKG_CONFIG_PATH=~/.local/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}
export EDITOR=ex
export VISUAL=vim
export HISTSIZE=100000
export HISTFILESIZE=100000
export GPG_TTY=$(tty)
