[ -f ~/.bashrc ] && . ~/.bashrc

case "$(uname -s)" in
    Linux)
        export LD_LIBRARY_PATH=~/.local/lib:/usr/local/lib${LD_LIBRARY_PATH+:}$LD_LIBRARY_PATH
        ;;
    Darwin)
        export DYLD_LIBRARY_PATH=~/.local/lib:/usr/local/lib${DYLD_LIBRARY_PATH+:}$DYLD_LIBRARY_PATH

        export BASH_SILENCE_DEPRECATION_WARNING=1
        export FILTER_BRANCH_SQUELCH_WARNING=1
        export COPYFILE_DISABLE=true

        function socksssh() {
            if ! [[ -z $1 ]]; then
                IFS=$'\n';
                for service in $(networksetup -listallnetworkservices | tail -n +2); do
                    networksetup -setsocksfirewallproxy $service localhost 1080;
                done;
                ssh -NvD localhost:1080 "$@";
                for service in $(networksetup -listallnetworkservices | tail -n +2); do
                    networksetup -setsocksfirewallproxystate $service off;
                done;
            fi;
        }

        function vncssh() {
            (sleep 2; open vnc://localhost:5910;) & ssh -NvL 5910:localhost:5900 "$@";
            #if [ $? -eq 0 ]; then
            #    open vnc://localhost:5910;
            #fi;
        }

        function wiresharkssh() {
            if [ -z $1 ]; then
                return;
            fi;
            mkfifo /tmp/tcpdump;
            ssh $1 tcpdump -U -s 0 -w - not port 22 > /tmp/tcpdump & wireshark -i /tmp/tcpdump;
            rm /tmp/tcpdump;
        }

        alias tar='tar --exclude=.DS_Store'
        alias certbot='certbot --config-dir /usr/local/etc/letsencrypt/ --logs-dir /usr/local/var/log/letsencrypt/ --work-dir /usr/local/var/lib/letsencrypt/'
        alias mysqlssh='ssh -fN -L 3307:localhost:3306 nngai@pedantry.hopto.org && mysql -h localhost -P 3307 -u root; killall ssh'
        ;;
esac

alias gpg='gpg --expert --no-symkey-cache'

# Go configuration.
if command -v go >/dev/null; then
    if [ -n "$(go env GOBIN)" ]; then
        PATH=$(go env GOBIN)${PATH+:}$PATH
    else
        PATH=$(go env GOPATH)/bin${PATH+:}$PATH
    fi
fi

# nvm configuration.
export NVM_DIR=~/.nvm
. "$NVM_DIR/nvm.sh"
. "$NVM_DIR/bash_completion"

# opam configuration
test -r /Users/nngai/.opam/opam-init/init.sh && . /Users/nngai/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

export PATH=~/.local/bin:/usr/local/bin${PATH+:}$PATH
export C_INCLUDE_PATH=~/.local/include:/usr/local/include${C_INCLUDE_PATH+:}$C_INCLUDE_PATH
export PKG_CONFIG_PATH=~/.local/lib/pkgconfig:/usr/local/lib/pkgconfig${PKG_CONFIG_PATH+:}$PKG_CONFIG_PATH
export EDITOR=ex
export VISUAL=vim
export HISTSIZE=100000
export GPG_TTY=$(tty)
