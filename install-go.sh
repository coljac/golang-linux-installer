#!/bin/bash
curl -s "https://go.dev/dl/" | grep linux-amd64 | sed 's/.*class="download downloadBox".*href="\/dl\/\(go[^"]*gz\)".*/\1/g' | head -1 | xargs -I {} curl  -o $HOME/{} "https://dl.google.com/go/{}"
USERNAME=$(whoami) 
SUDO=
if [[ $USERNAME != "root" ]]; then SUDO=sudo; fi

$SUDO rm -rf /usr/local/go && $SUDO tar -C /usr/local -xzf $HOME/go1.23.0.linux-amd64.tar.gz

rcfile=$HOME/."$(getent passwd $USERNAME | cut -d: -f7 | xargs -I{} basename {} | sed 's/$/rc/')"
if [[ -e "$rcfile" ]]; then
    if ! command -v go > /dev/null 2>&1 && [[ -z "$(cat $rcfile | grep '/usr/local/go/bin')" ]]; then
        read -p "Update $rcfile? (y/N): " choice
        case "$choice" in 
          y|Y ) echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $rcfile ;;
          * ) echo "";;
        esac
    fi
fi
