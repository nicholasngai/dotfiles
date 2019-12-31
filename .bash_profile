export PATH=/usr/local/opt/openssl@1.1/bin:/usr/local/sbin:$PATH
export HOMEBREW_CASK_OPTS='--appdir=~/Applications'
export BASH_SILENCE_DEPRECATION_WARNING=1

export SSH_AUTH_SOCK=~/.gnupg/S.gpg-agent.ssh

function socksssh() {
    if ! [[ -z $1 ]]; then
        IFS=$'\n';
        for service in $(networksetup -listallnetworkservices | tail -n +2); do
            networksetup -setsocksfirewallproxy $service localhost 1080;
        done;
        ssh -NvD localhost:1080 $1;
        for service in $(networksetup -listallnetworkservices | tail -n +2); do
            networksetup -setsocksfirewallproxystate $service off;
        done;
    fi;
}

function vncssh() {
    sshhost=$1;
    if [ -z "$2" ]; then
        vnchost=localhost;
    else
        vnchost=$2;
    fi;
    (sleep 2; open vnc://localhost:5910;) & ssh -NvL 5910:$vnchost:5900 $sshhost;
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

function wpenumusers() {
    for i in `seq -w 1 $2`; do
        sleep 1;
        echo "$i: "`curl -A '' -Lvx socks5h://localhost:9050 "$1/?author=$i" 2>&1 | grep -oE '(?:Location.*|<title>.*?</title>)' | tr -d '\r' | tr '\n' ' '` &
    done | tee /dev/tty | sort > wpuserenum.txt;
}

function wpenumusersdirect() {
    for i in `seq -w 1 $2`; do
        sleep 1;
        echo "$i: "`curl -A '' -Lv "$1/?author=$i" 2>&1 | grep -oE '(?:Location.*|<title>.*?</title>)' | tr -d '\r' | tr '\n' ' '` &
    done | tee /dev/tty | sort > wpuserenum.txt;
}

alias tar='tar --disable-copyfile --exclude=.DS_Store'
alias gpg='gpg --expert --no-symkey-cache'
alias certbot='certbot --config-dir /usr/local/etc/letsencrypt/ --logs-dir /usr/local/var/log/letsencrypt/ --work-dir /usr/local/var/lib/letsencrypt/'
alias mysqlssh='ssh -fN -L 3307:localhost:3306 nngai@pedantry.hopto.org && mysql -h localhost -P 3307 -u root; killall ssh'
export PATH="/usr/local/opt/mysql@5.7/bin:/usr/local/opt/mysql-client@5.7/bin:$PATH"
