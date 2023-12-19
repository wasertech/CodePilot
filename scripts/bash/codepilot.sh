#!/usr/bin/bash

# This script is used to run the CodePilot application.

bash --version

codepilot="gh copilot"

alias codepilot="$codepilot"
alias copilot="$codepilot"
alias suggest="${codepilot} suggest"
alias _explain="${codepilot} explain"

function git_ssh_login() {
    howdoi "login with ssh with git"

    read -p "Enter the encryption algorithm you want to use [rsa]: " algo

    if [[ -z $algo ]]; then
        algo="rsa"
    fi

    # Check if the ssh key already exists

    if [[ -f ~/.ssh/id_$algo.pub ]]; then
        echo "SSH key already exists; assuming you have already added it to your GitHub account"
    else
        echo "SSH key does not exist"
        read -p "Enter the number of bits you want to use [4096]: " bits

        if [[ -z $bits ]]; then
            bits="4096"
        fi

        read -p "Enter the email address of your GitHub account [$HOST]: " email

        if [[ -z $email ]]; then
            email="$HOST"
        fi

        ssh-keygen -t $algo -b $bits -C "$email" && echo "SSH key generated successfully" || echo "SSH key generation failed" && return 1
        
        echo "Add the following SSH key to your GitHub account"
        cat ~/.ssh/id_$algo.pub | xclip -selection clipboard && echo "SSH key copied to clipboard" || echo "Could not copy SSH key to clipboard (xclip not installed)"
        
        echo "Opening GitHub in the browser"
        xdg-open "https://github.com/settings/keys" && echo "GitHub has been opened in the browser" || echo "Could not open GitHub in the browser (xdg-open not installed)"

        read -p "Press any key to continue once you have added the SSH key to your GitHub account" -n 1 -s
    fi

    echo "SSH key added to GitHub account"

    echo "Testing SSH connection to GitHub"
    ssh -T git@github.com && echo "SSH connection to GitHub successful" && return 0 || echo "SSH connection to GitHub failed" && return 1
}

function git_login() {
    howdoi "login with git"

    read -p "Enter your GitHub username: " username

    if [[ -z $username ]]; then
        echo "Username cannot be empty"
        return 1
    fi

    read -p "Enter your GitHub email address: " email

    if [[ -z $email ]]; then
        echo "Email address cannot be empty"
        return 1
    fi

    git config --global user.name "$username"
    git config --global user.email "$email"

    git_ssh_login && echo "Git login successful" && return 0 || echo "Git login failed" && return 1
}

function gh_login() {
    echo "Logging in to GitHub CLI"
    gh auth login --web -h github.com
}

function gh_copilot_install() {
    gh extension install github/gh-copilot --force
}

function gh_copilot_login() {
    git_login && gh_login
}

function check_copilot() {
    if [[ -z $(which git) ]]; then
        echo "Git is not installed"
        # distro=$(lsb_release -i | cut -f 2-)
        # explain "how to install Git on $distro"
        echo "Git is required to run CodePilot"
        echo "Install Git and re-run codepilot"
        return 1
    fi

    if [[ -z $(which gh) ]]; then
        echo "GitHub CLI is not installed"
        # distro=$(lsb_release -i | cut -f 2-)
        # explain "how to install GitHub CLI on $distro"
        echo "GitHub CLI is required to run CodePilot"
        echo "Install GitHub CLI and re-run codepilot"
        return 1
    fi

    # check if 'gh copilot --version' successfully returns a version
    version=$(gh copilot --version)
    if [[ -z $version ]]; then
        echo "GitHub Copilot CLI is not installed"
        echo "Installing GitHub Copilot CLI"
        echo "Please wait..."
        gh_copilot_install && \
        echo "GitHub Copilot CLI installed successfully"
        echo "Logging in to GitHub Copilot CLI"
        gh_copilot_login
        echo "GitHub Copilot CLI login successful"
    fi

    return 0
}

function clean_output(){
    if [[ $# -eq 0 ]]; then
        echo "Usage: clean_output <output>"
        return 1
    else
        cmd_out=$@
        split_word="# Explanation:"
    fi
    # cmd_out=$(explain "what is hello world in bash")
    _out=$(python -c "cmd_out='''$cmd_out'''; split=cmd_out.split('${split_word}'); _out = '\n'.join([ l for l in split[1].split('\n')[1:]]) if len(split) >= 2 else cmd_out; print(_out)")
    echo "$_out"
    return 0
}

function explain() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: explain <query>"
        return 1
    else
        cmd_in=$@
    fi
    cmd_out=$(_explain "$cmd_in")
    clean_output "$cmd_out"
    return 0
}

function copilot_help() {
    if [[ $# -eq 0 ]]; then
        explain 'how to get help in the shell'
        echo
        echo "Some useful commands:"
        echo
        echo "Get help for a particular command"
        echo "  help <command>"
        echo
        echo "How do I ... ?"
        echo "  howdoi '<goal>'"
        echo
        echo "Too long; didn't read (the manual). Give me the gist of how to use this command:"
        echo "  tldr '<command>'"
        echo
        echo "Use git to ..."
        echo "  use_git_to '<goal>'"
        echo
        echo "Use GitHub CLI to ..."
        echo "  use_gh_to '<goal>'"
        echo
        echo "Use the shell to ..."
        echo "  use_sh_to '<goal>'"
        echo
        echo "Explain ..."
        echo "  explain '<goal>'"
        echo
        echo "Suggest Command Interactively"
        echo "  suggest"
        echo
        echo "Suggest [Git, GitHub, Shell] Command to ..."
        echo "  suggest -t [git|gh|shell] '<goal>'"
    elif [ $@ = '--help' ]; then
        echo "(Meta)Help"
        echo "Get help about a command."
        echo
        echo "Usage: help <command>"
        echo "Example: help nano"
        echo "Example: help --help"
        echo "Example: help"
        return 0
    else
        case $1 in
            suggest)
                echo "To get help for the suggest command, run 'suggest --help'."
                ;;
            explain)
                echo "To get help for the explain command, run 'explain --help'."
                ;;
            copilot)
                echo "To get help for the copilot, run 'copilot --help'."
                ;;
            codepilot)
                echo "To get help for the codepilot, run 'codepilot --help'."
                ;;
            *)
                explain "how to get more information about '$@' behavior as a program in the command line"
                explain "how to use the following command: '$@'"
                ;;
        esac
    fi
    return 0
}

function howdoi() {
    if [[ $# -eq 0 ]] || [ $@ = '--help' ]; then
        echo "Usage: howdoi <question>"
        return 1
    else
        explain "How do I $@ ?"
    fi
    return 0
}

function tldr() {
    if [[ $# -eq 0 ]] || [ $@ = '--help' ]; then
        echo "Usage: tldr <command>"
        return 1
    else
        explain "How do I use $@ ? Give me a tldr of example usages."
    fi
    return 0
}

use_git_to() {
    if [[ $# -eq 0 ]] || [ $@ = '--help' ]; then
        echo "Usage: use_git_to <goal>"
        echo "Example: use_git_to 'Undo the most recent local commits'"
        echo "Example: use_git_to 'Clean up local branches'"
        echo "Example: use_git_to 'Setup LFS for images'"
        return 1
    else
        suggest -t git "$@"
    fi
    return 0
}

use_gh_to() {
    if [[ $# -eq 0 ]] || [ $@ = '--help' ]; then
        echo "Usage: use_gh_to <goal>"
        echo "Example: use_gh_to 'Create pull request'"
        echo "Example: use_gh_to 'List pull requests waiting for my review'"
        echo "Example: use_gh_to 'Summarize work I have done in issues and pull requests for promotion'"
        return 1
    else
        suggest -t gh "$@"
    fi
    return 0
}

use_sh_to() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: use_sh_to <goal>"
        echo "Example: use_sh_to 'Kill processes holding onto deleted files' "
        echo "Example: use_sh_to 'Test whether there are SSL/TLS issues with github.com' "
        echo "Example: use_sh_to 'Convert SVG to PNG and resize' "
        echo "Example: use_sh_to 'Convert MOV to animated PNG' "
        return 1
    else
        suggest -t shell "$@"
    fi
    return 0
}

function welcome() {
    explain 'how to operate the shell' && \
    return 0
}

alias help='copilot_help'

check_copilot && \
echo
echo "Your copilot is ready to help you! Type 'help' to get started." \
|| echo "Your copilot is not ready to help you. Please check the error messages above."
# echo "Welcome in the Shell! I am GitHub Copilot."
# echo "To get started, type 'welcome' to learn how to operate the shell."
# echo "To get some help you can type 'help'."
# echo "Type 'exit' to exit the shell."
echo