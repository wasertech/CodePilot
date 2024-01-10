#!/usr/bin/zsh

# This script is used to run the CodePilot application.

zsh --version

# Assert Git, GitHub CLI, and ssh-keygen are installed
# If not, explain how to install them
# If they are, continue

# Assert Git is installed
if [[ -z $(which git) ]]; then
    echo "Git is not installed"
    # distro=$(lsb_release -i | cut -f 2-)
    # explain "how to install Git on $distro"
    echo "Git is required to run CodePilot"
    echo "Install Git using your package manager and re-run codepilot"
    exit 1
fi

# Assert GitHub CLI is installed
if [[ -z $(which gh) ]]; then
    echo "GitHub CLI is not installed"
    # distro=$(lsb_release -i | cut -f 2-)
    # explain "how to install GitHub CLI on $distro"
    echo "GitHub CLI is required to run CodePilot"
    echo "Install GitHub CLI and re-run codepilot"
    exit 1
fi

# Assert ssh-keygen is installed
if [[ -z $(which ssh-keygen) ]]; then
    echo "ssh-keygen is not installed"
    # distro=$(lsb_release -i | cut -f 2-)
    # explain "how to install ssh-keygen on $distro"
    echo "ssh-keygen is required to run CodePilot"
    distro=$(lsb_release -i | cut -f 2-)
    suggest "install openssh on $distro" || echo "Install openssh and re-run codepilot"
    exit 1
fi

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

    if [[ -f ~/.ssh/id_$algo.pub  && -f ~/.ssh/id_$algo ]]; then
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

        ssh-keygen -t $algo -b $bits -C "$email" || echo "SSH key generation failed" && return 1
        echo "SSH key generated successfully"
    
        echo "Add the following SSH key to your GitHub account"
        cat ~/.ssh/id_$algo.pub
        echo
        cat ~/.ssh/id_$algo.pub | xclip -selection clipboard && echo "SSH key copied to clipboard" || echo "Could not copy SSH key to clipboard (xclip not installed)"
        
        echo "Opening GitHub in the browser"
        xdg-open "https://github.com/settings/keys" && echo "GitHub has been opened in the browser" || echo "Could not open GitHub in the browser (xdg-open not installed)"

        read -p "Press any key to continue once you have added the SSH key to your GitHub account" -n 1 -s

        echo "SSH key added to GitHub account"
    fi
    
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

    log=$(git_ssh_login) || echo "Git login failed" && return 1
    if [[ $log -eq 0 ]]; then
        echo "Git login successful"
        return 0
    else
        echo "Git login failed"
        return 1
    fi
}

function gh_login() {
    echo "Logging in to GitHub CLI"
    gh auth login --web -h github.com || echo "Failed to log in to GitHub CLI" && return 1
    echo "Successfully logged in to GitHub CLI"
    return 0
}

function gh_copilot_install() {
    gh extension install github/gh-copilot --force
}

function gh_copilot_login() {
    git_log=$(git_login)
    if [[ $git_log -eq 0 ]]; then
        echo "Successfully logged in to Git"
    else
        echo "Failed to log in to Git"
        return 1
    fi
    
    gh_log=$(gh_login)
    if [[ $gh_log -eq 0 ]]; then
        echo "Successfully logged in to GitHub CLI"
    else
        echo "Failed to log in to GitHub CLI"
        return 1
    fi
}

function check_copilot() {
    if [[ -z $(which git 2> /dev/null) ]]; then
        echo "Git is not installed"
        # distro=$(lsb_release -i | cut -f 2-)
        # explain "how to install Git on $distro"
        echo "Git is required to run CodePilot"
        echo "Install Git and re-run codepilot"
        return 1
    fi

    if [[ -z $(which gh 2> /dev/null) ]]; then
        echo "GitHub CLI is not installed"
        # distro=$(lsb_release -i | cut -f 2-)
        # explain "how to install GitHub CLI on $distro"
        echo "GitHub CLI is required to run CodePilot"
        echo "Install GitHub CLI and re-run codepilot"
        return 1
    fi

    # check if 'gh copilot --version' successfully returns a version
    version=$(gh copilot --version 2> /dev/null)
    if [[ -z $version ]]; then
        echo "GitHub Copilot CLI is not installed"
        echo "Logging in to GitHub CLI"
        gh_copilot_login && \
        echo "Successfully logged in to GitHub CLI" || echo "Failed to log in to GitHub CLI" && return 1
        echo "Installing GitHub Copilot CLI"
        echo "Please wait..."
        gh_copilot_install && \
        echo "GitHub Copilot CLI installed successfully" || echo "Failed to install GitHub Copilot CLI" && return 1
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
        echo "What is ... ?"
        echo "  whatis '<command|concept>'"
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
        echo "Use Docker to ..."
        echo "  use_docker_to '<goal>'"
        echo
        echo "Use Python to ..."
        echo "  use_py_to '<goal>'"
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
            howdoi)
                echo "To get help for the howdoi command, run 'howdoi --help'."
                ;;
            tldr)
                echo "To get help for the tldr command, run 'tldr --help'."
                ;;
            whatis)
                echo "To get help for the whatis command, run 'whatis --help'."
                ;;
            use_git_to)
                echo "To get help for the use_git_to command, run 'use_git_to --help'."
                ;;
            use_gh_to)
                echo "To get help for the use_gh_to command, run 'use_gh_to --help'."
                ;;
            use_sh_to)
                echo "To get help for the use_sh_to command, run 'use_sh_to --help'."
                ;;
            use_docker_to)
                echo "To get help for the use_docker_to command, run 'use_docker_to --help'."
                ;;
            use_py_to)
                echo "To get help for the use_py_to command, run 'use_py_to --help'."
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
        echo "Usage: howdoi <goal>"
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

function whatis() {
    if [[ $# -eq 0 ]] || [ $@ = '--help' ]; then
        /usr/bin/whatis --help || echo "Usage: whatis <command|concept>"
        return 1
    else
        # check if whatis is installed
        _whatis='/usr/bin/whatis'
        if [[ ! -f $_whatis ]]; then
            echo "whatis is not installed"
        else
            $_whatis $@
        fi
        
        explain "what is '$@' ?"
    fi
    return 0
}

function use_git_to() {
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

function use_gh_to() {
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

function use_sh_to() {
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

function use_docker_to() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: use_docker_to <goal>"
        echo "Example: use_docker_to 'List all running containers'"
        echo "Example: use_docker_to 'List all images'"
        echo "Example: use_docker_to 'List all volumes'"
        echo "Example: use_docker_to 'List all networks'"
        return 1
    else
        suggest -t shell "$@ using Docker"
    fi
    return 0
}

function use_py_to(){
    if [[ $# -eq 0 ]]; then
        echo "Use Python to ..."
        echo
        echo "Usage: use_py_to <goal>"
        echo "Example: use_py_to 'Convert a string to lowercase'"
        echo "Example: use_py_to 'Strip string of whitespace and linebreaks'"
        echo "Example: use_py_to 'Display simple progress bar'"
        echo "Example: use_py_to 'Display a window with a button to exit'"
        return 1
    else
        suggest -t shell "$@ in python"
    fi
    return 0
}

function codepilot_update() {
    echo "Updating CodePilot"
    if [[ -z $(which wget) ]]; then
        echo "wget is not installed"
        distro=$(lsb_release -i | cut -f 2-)
        echo "Please install wget on $distro"
        exit 1
    fi

    local_bin_path=~/.local/bin

    wget -O codepilot.sh https://raw.githubusercontent.com/wasertech/CodePilot/main/scripts/bash/codepilot.sh 2>/dev/null
    chmod +x codepilot.sh

    wget -O codepilot.zsh https://raw.githubusercontent.com/wasertech/CodePilot/main/scripts/zsh/codepilot.zsh 2>/dev/null
    chmod +x codepilot.zsh

    mkdir -p $local_bin_path

    # remove the codepilot script from $local_bin_path
    echo "Removing old codepilot script from $local_bin_path"
    rm -f $local_bin_path/codepilot.sh
    rm -f $local_bin_path/codepilot.zsh

    # copy the codepilot script to $local_bin_path
    echo "Copying codepilot script to $local_bin_path"
    cp -f codepilot.sh codepilot.zsh $local_bin_path/
    echo "CodePilot updated successfully!"
    echo "You might want to start a new shell session... or source the correct codepilot script."
    return 0
}

function welcome() {
    echo "Welcome in the Shell! I am GitHub Copilot."
    echo
    echo "Here how to operate the shell:" && \
    explain 'how to operate the shell' || echo "Unfortunately, I wasn't able to create a guide for you to operate the shell."
    echo
    echo "To get some help you can type 'help'."
    echo "Type 'exit' to exit the shell."
    echo
    return 0
}

alias help='copilot_help'

pilot=$(check_copilot)
if [[ $pilot -eq 0 ]]; then
    echo "Your copilot is ready to help you! Type 'welcome' or 'help' to get started."
else
    echo "Your copilot is not ready to help you. Please check the error messages above."
fi
