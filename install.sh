#!/bin/sh

# Gum Color Settings
export GUM_CHOOSE_CURSOR_FOREGROUND="#7289da"
export GUM_CONFIRM_SELECTED_BACKGROUND="#7289da"
export GUM_CONFIRM_SELECTED_FOREGROUND="#000000"
export GUM_SPIN_SPINNER_FOREGROUND="#7289da"

remove_gumcli_folder() {
  rm -rf /tmp/gumcli
}

if ! which wget; then
  echo "ERROR: wget not found. Please install wget to continue."
  exit 1
fi

if ! which tar; then
  echo "ERROR: tar not found. Please install tar to continue."
  exit 1
fi

# Setup Gum for the CLI interface, if it doesn't exist

gumalias=false

if ! which gum; then
  if [ ! -d "/tmp/gumcli" ]; then
    echo ""
    echo "Installing Gum..."
    echo ""

    wget -4 https://github.com/charmbracelet/gum/releases/download/v0.13.0/gum_0.13.0_Linux_x86_64.tar.gz

    mv gum_0.13.0_Linux_x86_64.tar.gz /tmp/

    mkdir /tmp/gumcli

    tar -xzf /tmp/gum_0.13.0_Linux_x86_64.tar.gz -C /tmp/gumcli

    chmod +x /tmp/gumcli/gum

    rm /tmp/gum_0.13.0_Linux_x86_64.tar.gz

    gumalias=true
  fi
else
  echo ""
  echo "Found Gum, not installing to /tmp."
  echo ""
fi


if [ "$gumalias" = "true" ]; then
  alias gum="/tmp/gumcli/gum"
fi

clear
gum style --border double --margin "1" --padding "1 2" --border-foreground "#7289da" "Easy-Discord-Updater Installer"

option=$(gum choose "Install" "Configure Install" "About E-D-U" "Quit Installer")

case $option in
  "Quit Installer")
    gum spin --title "Bye!" sleep 2
    clear
    remove_gumcli_folder
    exit 0
    ;;
esac
