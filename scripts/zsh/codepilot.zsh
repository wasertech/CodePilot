#!/usr/bin/zsh

# This script is used to run the CodePilot application.

local ANSI_ITALIC="\e[3m"
local ANSI_BOLD="\e[1m"
local ANSI_RESET="\e[0m"
local ANSI_YELLOW="\e[33m"
local ANSI_CMD="${ANSI_ITALIC}${ANSI_YELLOW}"

local DISPLAY_COPILOT_CMD="${ANSI_CMD}copilot${ANSI_RESET}"
local DISPLAY_COPILOT="${ANSI_ITALIC}${ANSI_BOLD}CodePilot${ANSI_RESET}"
local DISPLAY_GH="${ANSI_ITALIC}${ANSI_BOLD}GitHub CLI${ANSI_RESET}"
local DISPLAY_GIT="${ANSI_ITALIC}${ANSI_BOLD}Git${ANSI_RESET}"
local DISPLAY_SSH="${ANSI_ITALIC}${ANSI_BOLD}ssh-keygen${ANSI_RESET}"

zsh --version

# Assert Git, GitHub CLI, and ssh-keygen are installed
# If not, explain how to install them
# If they are, continue

# Assert Git is installed
if [[ -z $(which git) ]]; then
    echo -e "${DISPLAY_GIT} is not installed"
    # distro=$(lsb_release -i | cut -f 2-)
    # explain "how to install Git on $distro"
    echo -e "${DISPLAY_GIT} is required to run ${DISPLAY_COPILOT}"
    echo -e "Install ${DISPLAY_GIT} using your package manager and re-run '${DISPLAY_COPILOT_CMD}'"
    exit 1
fi

# Assert GitHub CLI is installed
if [[ -z $(which gh) ]]; then
    echo -e "${DISPLAY_GH} is not installed"
    # distro=$(lsb_release -i | cut -f 2-)
    # explain "how to install GitHub CLI on $distro"
    echo -e "${DISPLAY_GH} is required to run ${DISPLAY_COPILOT}"
    echo -e "Install ${DISPLAY_GH} and re-run '${DISPLAY_COPILOT_CMD}'"
    exit 1
fi

# Assert ssh-keygen is installed
if [[ -z $(which ssh-keygen) ]]; then
    echo -e "${DISPLAY_SSH} is not installed"
    # distro=$(lsb_release -i | cut -f 2-)
    # explain "how to install ssh-keygen on $distro"
    echo -e "${DISPLAY_SSH} is required to run ${DISPLAY_COPILOT}"
    distro=$(lsb_release -i | cut -f 2-)
    suggest "install openssh on $distro" || echo -e "Install ${ANSI_ITALIC}${ANSI_BOLD}openssh${ANSI_RESET} and re-run '${DISPLAY_COPILOT_CMD}'"
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
        cat ~/.ssh/id_$algo.pub | xclip -selection clipboard && echo "SSH key copied to clipboard" || echo -e "Could not copy SSH key to clipboard (${ANSI_ITALIC}${ANSI_BOLD}xclip${ANSI_RESET} not installed)"
        
        echo "Opening GitHub in the browser..."
        xdg-open "https://github.com/settings/keys" && echo "GitHub has been opened in the browser" || echo -e "Could not open GitHub in the browser (${ANSI_ITALIC}${ANSI_BOLD}xdg-open${ANSI_RESET} not installed)"

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
    echo "Logging into GitHub CLI"
    gh auth login --web -h github.com || echo "Failed to log into GitHub CLI" && return 1
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
        echo -e "Git is required to run ${DISPLAY_COPILOT}"
        echo -e "Install Git and re-run '${ANSI_COPILOT_CMD}'"
        return 1
    fi

    if [[ -z $(which gh 2> /dev/null) ]]; then
        echo "GitHub CLI is not installed"
        # distro=$(lsb_release -i | cut -f 2-)
        # explain "how to install GitHub CLI on $distro"
        echo -e "GitHub CLI is required to run ${DISPLAY_COPILOT}"
        echo -e "Install GitHub CLI and re-run '${ANSI_COPILOT_CMD}'"
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
    _out=$(python3 -c "cmd_out='''$cmd_out'''; split=cmd_out.split('${split_word}'); _out = '\n'.join([ l for l in split[1].split('\n')[1:]]) if len(split) >= 2 else cmd_out; print(_out)")
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
        echo -e "  ${ANSI_CMD}help <command>${ANSI_RESET}"
        echo
        echo "How do I ... ?"
        echo -e "  ${ANSI_CMD}howdoi '<goal>'${ANSI_RESET}"
        echo
        echo "Too long; didn't read (the manual). Give me the gist of how to use this command:"
        echo -e "  ${ANSI_CMD}tldr '<command>'${ANSI_RESET}"
        echo
        echo "What is ... ?"
        echo -e "  ${ANSI_CMD}whatis '<command|concept>'${ANSI_RESET}"
        echo
        echo "Use git to ..."
        echo -e "  ${ANSI_CMD}use_git_to '<goal>'${ANSI_RESET}"
        echo
        echo "Use GitHub CLI to ..."
        echo -e "  ${ANSI_CMD}use_gh_to '<goal>'${ANSI_RESET}"
        echo
        echo "Use the shell to ..."
        echo -e "  ${ANSI_CMD}use_sh_to '<goal>'${ANSI_RESET}"
        echo
        echo "Use Docker to ..."
        echo -e "  ${ANSI_CMD}use_docker_to '<goal>'${ANSI_RESET}"
        echo
        echo "Use Python to ..."
        echo -e "  ${ANSI_CMD}use_py_to '<goal>'${ANSI_RESET}"
        echo
        echo "Explain ..."
        echo -e "  ${ANSI_CMD}explain '<goal>'${ANSI_RESET}"
        echo
        echo "Suggest Command Interactively"
        echo -e "  ${ANSI_CMD}suggest${ANSI_RESET}"
        echo
        echo "Suggest [Git, GitHub, Shell] Command to ..."
        echo -e "  ${ANSI_CMD}suggest -t [git|gh|shell] '<goal>'${ANSI_RESET}"
    elif [ $@ = '--help' ]; then
        echo "(Meta)Help"
        echo "Get help about a command."
        echo
        echo -e "Usage: ${ANSI_CMD}help <command>${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}help nano${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}help --help${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}help${ANSI_RESET}"
        return 0
    else
        case $1 in
            suggest)
                echo -e "To get help for the suggest command, run '${ANSI_CMD}suggest --help${ANSI_RESET}'."
                ;;
            explain)
                echo -e "To get help for the explain command, run '${ANSI_CMD}explain --help${ANSI_RESET}'."
                ;;
            copilot)
                echo -e "To get help for the copilot, run '${ANSI_CMD}copilot --help${ANSI_RESET}'."
                ;;
            codepilot)
                echo -e "To get help for the codepilot, run '${ANSI_CMD}codepilot --help${ANSI_RESET}'."
                ;;
            howdoi)
                echo -e "To get help for the howdoi command, run '${ANSI_CMD}howdoi --help${ANSI_RESET}'."
                ;;
            tldr)
                echo -e "To get help for the tldr command, run '${ANSI_CMD}tldr --help${ANSI_RESET}'."
                ;;
            whatis)
                echo -e "To get help for the whatis command, run '${ANSI_CMD}whatis --help${ANSI_RESET}'."
                ;;
            use_git_to)
                echo -e "To get help for the use_git_to command, run '${ANSI_CMD}use_git_to --help${ANSI_RESET}'."
                ;;
            use_gh_to)
                echo -e "To get help for the use_gh_to command, run '${ANSI_CMD}use_gh_to --help${ANSI_RESET}'."
                ;;
            use_sh_to)
                echo -e "To get help for the use_sh_to command, run '${ANSI_CMD}use_sh_to --help${ANSI_RESET}'."
                ;;
            use_docker_to)
                echo -e "To get help for the use_docker_to command, run '${ANSI_CMD}use_docker_to --help${ANSI_RESET}'."
                ;;
            use_py_to)
                echo -e "To get help for the use_py_to command, run '${ANSI_CMD}use_py_to --help${ANSI_RESET}'."
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
        echo -e "Usage: ${ANSI_CMD}howdoi <goal>${ANSI_RESET}"
        return 1
    else
        explain "How do I $@ ?"
    fi
    return 0
}

function tldr() {
    if [[ $# -eq 0 ]] || [ $@ = '--help' ]; then
        echo -e "Usage: ${ANSI_CMD}tldr <command>${ANSI_RESET}"
        return 1
    else
        explain "How do I use $@ ? Give me a tldr of example usages."
    fi
    return 0
}

function whatis() {
    if [[ $# -eq 0 ]] || [ $@ = '--help' ]; then
        /usr/bin/whatis --help || echo -e "Usage: ${ANSI_CMD}whatis <command|concept>${ANSI_RESET}"
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
        echo -e "Usage: ${ANSI_CMD}use_git_to <goal>${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_git_to 'Undo the most recent local commits'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_git_to 'Clean up local branches'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_git_to 'Setup LFS for images'${ANSI_RESET}"
        return 1
    else
        suggest -t git "$@"
    fi
    return 0
}

function use_gh_to() {
    if [[ $# -eq 0 ]] || [ $@ = '--help' ]; then
        echo -e "Usage: ${ANSI_CMD}use_gh_to <goal>"
        echo -e "Example: ${ANSI_CMD}use_gh_to 'Create pull request'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_gh_to 'List pull requests waiting for my review'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_gh_to 'Summarize work I have done in issues and pull requests for promotion'${ANSI_RESET}"
        return 1
    else
        suggest -t gh "$@"
    fi
    return 0
}

function use_sh_to() {
    if [[ $# -eq 0 ]]; then
        echo -e "Usage: ${ANSI_CMD}use_sh_to <goal>${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_sh_to 'Kill processes holding onto deleted files'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_sh_to 'Test whether there are SSL/TLS issues with github.com'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_sh_to 'Convert SVG to PNG and resize'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_sh_to 'Convert MOV to animated PNG'${ANSI_RESET}"
        return 1
    else
        suggest -t shell "$@"
    fi
    return 0
}

function use_docker_to() {
    if [[ $# -eq 0 ]]; then
        echo -e "Usage: ${ANSI_CMD}use_docker_to <goal>${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_docker_to 'List all running containers'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_docker_to 'List all images'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_docker_to 'List all volumes'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_docker_to 'List all networks'${ANSI_RESET}"
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
        echo -e "Usage: ${ANSI_CMD}use_py_to <goal>${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_py_to 'Convert a string to lowercase'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_py_to 'Strip string of whitespace and linebreaks'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_py_to 'Display simple progress bar'${ANSI_RESET}"
        echo -e "Example: ${ANSI_CMD}use_py_to 'Display a window with a button to exit'${ANSI_RESET}"
        return 1
    else
        suggest -t shell "$@ in python3"
    fi
    return 0
}

function codepilot_update() {
    echo "Updating CodePilot"
    if [[ -z $(which wget) ]]; then
        echo -e "${ANSI_CMD}wget${ANSI_RESET} is not installed"
        distro=$(lsb_release -i | cut -f 2-)
        echo -e "Please install ${ANSI_CMD}wget${ANSI_RESET} on $distro"
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
    echo -e "To get some help you can type '${ANSI_CMD}help${ANSI_RESET}'."
    echo -e "Type '${ANSI_CMD}exit${ANSI_RESET}' to exit the shell."
    echo
    return 0
}

alias help='copilot_help'

pilot=$(check_copilot)
if [[ $pilot -eq 0 ]]; then
    echo -e "Your copilot is ready to help you! Type '${ANSI_CMD}welcome${ANSI_RESET}' or '${ANSI_CMD}help${ANSI_RESET}' to get started."
else
    echo -e "Your copilot is not ready to help you. Please check for error message(s) above."
fi
