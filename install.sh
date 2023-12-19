#!/bin/sh

# Gum Color Settings
export GUM_CHOOSE_CURSOR_FOREGROUND="#7289da"
export GUM_CONFIRM_SELECTED_BACKGROUND="#7289da"
export GUM_CONFIRM_SELECTED_FOREGROUND="#000000"
export GUM_SPIN_SPINNER_FOREGROUND="#7289da"

remove_gumcli_folder() {
  rm -rf /tmp/gumcli
}

install_discord() {
  gum style --border double --margin "1" --padding "1 2" --border-foreground "#7289da" "Installing Discord..."

  rm /tmp/edu-discord.tar.gz
  gum spin --spinner "line" --title "Getting the latest version of Discord..." --show-output -- wget -4 "https://discord.com/api/download?platform=linux&format=tar.gz" -O /tmp/edu-discord.tar.gz

  rm -rf /tmp/edu-discord-bin
  mkdir /tmp/edu-discord-bin
  gum spin --spinner "dot" --title "Extracting Discord..." --show-output -- tar -xzf /tmp/edu-discord.tar.gz -C /tmp/edu-discord-bin

  mkdir -p "$HOME/.local/share/applications/"

  gum spin --spinner "minidot" --title "Moving to your local directory..." --show-output -- mv /tmp/edu-discord-bin "$HOME/.local/share/edu-discord-bin"

  gum spin --spinner "hamburger" --title "Moving Launcher to local applications..." --show-output -- mv "$HOME/.local/share/edu-discord-bin/Discord/discord.desktop" "$HOME/.local/share/applications/discord.desktop"

  gum spin --spinner "pulse" --title "Adding Discord to Path..." --show-output -- echo 'export PATH="$HOME/.local/share/edu-discord/Discord/:$PATH"' >> "$HOME/.profile"

  mkdir -p "$HOME/.local/bin"
  gum spin --spinner "moon" --title "Installing command to update Discord..." --show-output -- wget -4 "https://raw.githubusercontent.com/TheKamboy/easy-discord-updater/master/edui" -O "$HOME/.local/bin/edui"

  gum style --border double --margin "1" --padding "1 2" --border-foreground "#7289da" "Done!"
  
  echo "Make sure you have \".local/bin\" added to your PATH."
  echo ""
  echo "Also, you can update Discord by running \"edui\" in your terminal, if you have \".local/bin\" added to your PATH."
  echo ""
  remove_gumcli_folder
  exit 0
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

    mkdir -p /tmp/gumcli

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

option=$(gum choose "Install" "Quit Installer")

case $option in
  "Quit Installer")
    gum spin --title "Bye!" sleep 2
    clear
    remove_gumcli_folder
    exit 0
    ;;
  "Install")
    install_discord
    ;;
esac
