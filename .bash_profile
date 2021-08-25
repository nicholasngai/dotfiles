export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/opt/mysql@5.7/bin:$PATH
export PATH=/usr/local/opt/mysql-client@5.7/bin:$PATH
export PATH=/usr/local/opt/openssl@1.1/bin:$PATH
export BASH_SILENCE_DEPRECATION_WARNING=1
export FILTER_BRANCH_SQUELCH_WARNING=1

export GPG_TTY=$(tty)

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

alias tar='tar --disable-copyfile --exclude=.DS_Store'
alias gpg='gpg --expert --no-symkey-cache'
alias certbot='certbot --config-dir /usr/local/etc/letsencrypt/ --logs-dir /usr/local/var/log/letsencrypt/ --work-dir /usr/local/var/lib/letsencrypt/'
alias mysqlssh='ssh -fN -L 3307:localhost:3306 nngai@pedantry.hopto.org && mysql -h localhost -P 3307 -u root; killall ssh'

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
