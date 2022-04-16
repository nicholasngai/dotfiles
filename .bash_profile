export PATH=~/.local/bin:$PATH
export C_INCLUDE_PATH=~/.local/include:$C_INCLUDE_PATH
export LD_LIBRARY_PATH=~/.local/lib:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=~/.local/lib:$LD_LIBRARY_PATH

case "$(uname -s)" in
    Darwin)
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

export GPG_TTY=$(tty)

alias gpg='gpg --expert --no-symkey-cache'

# nvm configuration.
export NVM_DIR=~/.nvm
. "$NVM_DIR/nvm.sh"
. "$NVM_DIR/bash_completion"
