#!/bin/bash

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAGIC_ANCHOR="Setup by setup_i3.sh"

X_LINK_FILE="xinitrc Xmodmap"

CRD="chrome-remote-desktop-session"

install() {
    # sync all git submodule
    cd $CONFIG_DIR
    git submodule update --init --recursive

    if [ -d "$CONFIG_DIR/i3" ]; then
        echo "Setting up i3"
        ln -s "$CONFIG_DIR/i3" $HOME/.i3
    fi

    if [ -f "$CONFIG_DIR/$CRD" ]; then
        echo "Setting up $CRD"
        ln -s "$CONFIG_DIR/$CRD" $HOME/.$CRD
    fi
    
    for f in $(echo $X_LINK_FILE)
    do
        if [ -f "$CONFIG_DIR/x/$f" ]; then
            echo "Setting up $f"

            ln -s "$CONFIG_DIR/x/$f" $HOME/.$f
        fi
    done

    echo "Setting up Xresources"
    echo "! BEGIN: $MAGIC_ANCHOR" >> $HOME/.Xresources
    if [ -f "$CONFIG_DIR/x/Xresources" ]; then
      echo "#include \"$CONFIG_DIR/x/Xresources\"" >> $HOME/.Xresources
    fi
    echo "! END: $MAGIC_ANCHOR" >> $HOME/.Xresources
}

uninstall() {
    if [ -d "$CONFIG_DIR/i3" ]; then
        echo "Removing i3"
        find $HOME/.i3 -type l -delete
    fi

    if [ -f "$CONFIG_DIR/$CRD" ]; then
        echo "Removing $CRD"
        find $HOME/.$CRD -type l -delete
    fi

    for f in $(echo $X_LINK_FILE)
    do
        if [ -f "$CONFIG_DIR/x/$f" ]; then
            echo "Removing file $f"
            find $HOME/.$f -type l -delete
        fi
    done

    echo "Removing config from Xresources"
    TMP_FILE=$(mktemp)
    sed "/$MAGIC_ANCHOR/,/$MAGIC_ANCHOR/d" $HOME/.Xresources > $TMP_FILE && mv $TMP_FILE $HOME/.Xresources
}

case "$1" in
'install')
    install
    ;;
'uninstall')
    uninstall
    ;;
*)
    echo "Usage ${BASH_SOURCE[0]} install/uninstall"
    exit
    ;;
esac
