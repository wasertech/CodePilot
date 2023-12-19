# CodePilot
Your AI command line copilot.

> I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

You need an active subscription to [GitHub Copilot](https://github.com/settings/copilot) to use this tool.

## Introduction

CodePilot is a collection of shell scripts that wrap the [GitHub Copilot CLI](https://github.com/github/gh-copilot) into a more user-friendly interface through the use of various aliases and functions.

Such as:

---

### Explain

You can ask GitHub Copilot to explain something.

```shell
❯ explain "how to navigate dirs"
```

**Welcome to GitHub Copilot in the CLI!**
> version 0.5.3-beta (2023-11-09)

_I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve._

#### Explanation:

  To navigate directories, you can use the following commands:
                              
  - `cd` is used to change directory.                                                                                                                  
    - `cd` foldername changes the current directory to foldername.                                                                                     
    - `cd` `..` moves up one directory level.                                                                                                            
    - `cd` `~` moves to the home directory.                                                                                                              
    - `cd` `/` moves to the root directory.                                                                                                              
    - `cd` `-` switches to the previous directory.                                                                                                       
  - `pwd` displays the current working directory.                                                                                                      
  - `ls` lists files and directories in the current directory.                                                                                         
    - `ls -l` provides a detailed listing.                                                                                                             
    - `ls -a` shows hidden files and directories.                                                                                                      
    - `ls -h` displays file sizes in human-readable format.                                                                                            
    - `ls -t` sorts files by modification time.                                                                                                        
    - `ls` -r reverses the order of the listing.

---

You can also ask in various ways.

### How do I?

```shell
❯ howdoi "navigate dirs"
```

**Welcome to GitHub Copilot in the CLI!**
> version 0.5.3-beta (2023-11-09)

_I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve._

#### Explanation:

  To navigate directories in a shell:                                                                                                                
                                                                                                                                                     
  - `cd` is used to change the current directory.                                                                                                      
    - `cd <directory>` changes the current directory to the specified directory.                                                                       
    - `cd ..` moves one level up to the parent directory.                                                                                              
    - `cd ~` moves to the home directory.                                                                                                              
  - `pwd` prints the current working directory.                                                                                                        
  - `ls` lists the files and directories in the current directory.                                                                                     
    - `ls <directory>` lists the files and directories in the specified directory.                                                                     
    - `-l` provides a long listing format.                                                                                                             
    - `-a` includes hidden files and directories in the listing.                                                                                       
    - `-t` sorts the listing by modification time.                                                                                                     
    - `-r` reverses the order of the listing.                                                                                                          
    - `-h` uses human-readable file sizes in the listing.                                                                                              
  - `mkdir` creates a new directory.                                                                                                                   
    - `mkdir <directory>` creates a directory with the specified name.

---

### Use the Shell to ...


```shell
❯ use_sh_to "navigate dirs"
```

**Welcome to GitHub Copilot in the CLI!**
> version 0.5.3-beta (2023-11-09)

_I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve._

#### Suggestion:

```shell
cd /path/to/directory
```                        

_? Select an option_
> Exit

---

Based on `use_sh_to`, you can also ask for help with Docker.

### Use Docker to ...

Like with previous `use_*_to` commands, you can converse with GitHub Copilot to sugesst the most adequate command. This time, for Docker.

```shell
❯ use_docker_to "navigate dirs"
```

Welcome to GitHub Copilot in the CLI!
version 0.5.3-beta (2023-11-09)

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

Suggestion not readily available. Please revise for better results.

? _What would you like the shell command to do?_ 
> load a volume and navigate to in in the container using bash as my entrypoint

#### Suggestion:

  ```shell
  docker run -v /path/to/volume:/container/path -it image_name bash
  ```

? _Select an option_
> Revise command

? _How should this be revised?_ 
> How would I navigate to /container/path once in the container?

#### Suggestion:

  ```shell
  cd /container/path
  ```

? _Select an option_
> Exit

---

Notice **some commands are designed to accept only certain arguments**, such as (but not limited to) command names.

### Help

```shell
❯ help "navigate dirs"
```

**Welcome to GitHub Copilot in the CLI!**
> version 0.5.3-beta (2023-11-09)

_I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve._

#### Explanation:

  To get more information about the behavior of a program in the command line, you can use the following commands:                                   
                                                                                                                                                     
  1. `man <program_name>`: This command displays the manual pages for a specific program, providing detailed information about its usage, options, and 
  behavior.                                                                                                                                          
    - The `<program_name>` should be replaced with the name of the program you want to learn more about.                                               
  2. `<program_name> --help`: Many programs provide a built-in help option that displays a summary of the command-line options and their descriptions. 
    - Replace `<program_name>` with the name of the program you want to learn more about.                                                              
  3. Online search: You can also search for the program`s documentation or user guides online to find more detailed information about its behavior   
  and usage.

**Welcome to GitHub Copilot in the CLI!**
> version 0.5.3-beta (2023-11-09)

_I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve._

Explanation not readily available. Please revise for better results.

---

Help is designed to accept the name of one or more commands.

```shell
❯ help --help
```

(Meta)**Help**

_Get help about a command._

_Usage_: `help <command>`

_Example_: `help nano`

_Example_: `help --help`

_Example_: `help`

---

So in in this case the correct way to ask for help would be:

```shell
❯ help "cd"
```

**Welcome to GitHub Copilot in the CLI!**
> version 0.5.3-beta (2023-11-09)

_I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve._

#### Explanation:                                                                                                                                         
                                                                                                                                                     
  To get more information about the behavior of the cd command as a program in the command line, you can use the man command which displays the      
  manual page for a given command. To get the manual page for cd, you can run man cd.                                                                


**Welcome to GitHub Copilot in the CLI!**
> version 0.5.3-beta (2023-11-09)

_I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve._

#### Explanation:

  - cd is used to change the current working directory.                                                                                              
    - Usage: cd `[directory]`                                                                                                                          
      - `[directory]` is an optional parameter specifying the directory you want to change to.                                                         
    - If no `[directory]` is provided, cd changes to the user`s home directory.                                                                        
    - You can use relative or absolute paths as the `[directory]` parameter.                                                                           
    - You can use special characters like `.` (current directory) and `..` (parent directory) in the path.                                               
    - Examples:                                                                                                                                      
      - `cd /path/to/directory`: Changes to the directory `/path/to/directory`.                                                                          
      - `cd ~`: Changes to the user`s home directory.                                                                                                  
      - `cd ..`: Changes to the parent directory.                                                                                                      
      - `cd`: Changes to the user`s home directory.

---

Much more helpful but sometimes it can be a bit too much helpful. Who finds the time to read the docs? Let's get a TL;DR version.

### Too long; didn't read (the manual)

Give me the gist of how to use the `cd` command.

```shell
❯ tldr 'cd'
```

**Welcome to GitHub Copilot in the CLI!**
> version 0.5.3-beta (2023-11-09)

_I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve._

#### Explanation:                                                                                                                                         
                                                                                                                                                     
  - cd is used to change the current working directory.                                                                                              
    - The basic usage of cd is simply cd <directory>, where <directory> is the name of the directory you want to navigate to.                        
    - Here are some examples of cd usages:                                                                                                           
      - cd /path/to/directory navigates to the absolute path /path/to/directory.                                                                     
      - cd .. navigates to the parent directory of the current directory.                                                                            
      - cd ~ navigates to the home directory of the current user.                                                                                    
      - cd - navigates to the previous working directory.                                                                                            
      - cd / navigates to the root directory.                                                                                                        
      - cd without any arguments navigates to the home directory.

---

### What is ... ?

```shell
❯ whatis "cd"
```

**Welcome to GitHub Copilot in the CLI!**
version 0.5.3-beta (2023-11-09)

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

Explanation:                                                                                                                                         
                                                                                                                                                     
  • cd is a command used to change the current working directory

---

You don't have to remember all these commands. You can ask GitHub Copilot to remind you by asking for help.

```shell
❯ help
```

**Welcome to GitHub Copilot in the CLI!**
> version 0.5.3-beta (2023-11-09)

_I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve._

#### Explanation:
  To get help in the shell, you can use the following commands:                                                                                      
                                                                                                                                                     
  - `man` `[command]`: Displays the manual page for a specific command.                                                                                  
  - `help` `[built-in command]`: Provides information about built-in shell commands.                                                                     
  - `[command] --help`: Displays help information for a specific command.                                                                              
  - `info` `[command]`: Shows documentation for a command using the GNU info system.                                                                     
  - `apropos` `[keyword]`: Searches the manual page descriptions for a given keyword.                                                                    
  - `tldr` `[command]`: Provides simplified and community-driven usage examples for command-line tools.                                                  
  - `whatis` `[command]`: Displays a brief summary of a command.                                                                                         


Some useful commands:

- Get help for a particular command
  
  ```shell
  help <command>
  ```
  
- How do I ... ?
  
  ```shell
  howdoi '<goal>'
  ```

- Too long; didn't read (the manual).
  
  Give me the gist of how to use this command:
  
  ```shell
  tldr '<command>'
  ```

- What is ... ?
  
  ```shell
  whatis '<command|concept>'
  ```

- Use git to ...
  
  ```shell
  use_git_to '<goal>'
  ```

- Use GitHub CLI to ...
  
  ```shell
  use_gh_to '<goal>'
  ```

- Use the shell to ...
  
  ```shell
  use_sh_to '<goal>'
  ```

- Use Docker to ...
  
  ```shell
  use_docker_to '<goal>'
  ```

- Explain ...
  
  ```shell
  explain '<goal>'
  ```

- Suggest Command Interactively
  
  ```shell
  suggest
  ```

- Suggest [Git, GitHub, Shell] Command to ...
  
  ```shell
  suggest -t [git|gh|shell] '<goal>'
  ```

## Pre-requisites

The following are required to use CodePilot:

- A Shell: [Bash](https://www.gnu.org/software/bash/) or [Zsh](https://www.zsh.org/)
- [Git](https://git-scm.com/)
- [GitHub CLI](https://cli.github.com/)

They must be installed and configured before you can use CodePilot. An active [GitHub Copilot](https://copilot.github.com/) subscription is also required.

## Installation

Copy and paste the following command in your terminal.

```shell
wget -O install https://raw.githubusercontent.com/wasertech/CodePilot/main/install && chmod +x install && ./install
```

Then hit enter and follow the instructions.

## Usage

### Commands

Some typical commands you can use with CodePilot are:

#### Welcome

```shell
❯ welcome
```

> Welcome to GitHub Copilot in the CLI!
> version 0.5.3-beta (2023-11-09)
>
> I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.
>
> Explanation:                                                                                                                                         
>                                                                                                                                                     
>  To operate the shell:                                                                                                                              
>                                                                                                                                                     
>  - Use commands to perform specific tasks or operations.                                                                                            
>  - Use command options or flags to modify the behavior of commands.                                                                                 
>  - Combine commands using pipes (|) to pass the output of one command as the input to another.                                                      
>  - Use redirection operators (`>`, `>>`, `<`) to redirect input and output.
> 
>  - Use command substitution (`$(...)` or `...`) to capture the output of a command and use it as part of another command.                             
>  - Use variables to store and manipulate data.                                                                                                      
>  - Use loops (for, while) to iterate over lists or execute commands repeatedly.                                                                     
>  - Use conditionals (if, case) to control the flow of execution based on conditions.                                                                
>  - Use control operators (&&, ||, ;) to combine multiple commands and control their execution.                                                      
>  - Use file and directory manipulation commands (`ls`, cp, mv, rm, mkdir, `cd`) to work with files and directories.                                     
>  - Use text processing commands (grep, sed, awk) to search for patterns and manipulate text.                                                        
>  - Use package management commands (apt-get, yum, brew) to manage software packages.                                                                
>  - Use version control system commands (git, svn) to manage source code repositories.                                                               
>  - Use system monitoring commands (ps, top, htop) to monitor system processes.                                                                      
>  - Use network-related commands (ping, curl, ssh) to interact with network resources.                                                               
>  - Use help commands (man, info, --help) to get information about commands and their usage.                                                         
>  - Use the shell`s built-in features (history, command line editing, tab completion) to enhance productivity.                                       
>                                                                                                                                                     
>  Note: The shell and its usage may vary depending on the operating system and shell you are using. 

#### Help

```shell
❯ help
```

> Welcome to GitHub Copilot in the CLI!
> version 0.5.3-beta (2023-11-09)
>
> I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.
>
> Explanation:                                                                                                                                         
>                                                                                                                                                     
>  To get help in the shell, you can use the following commands:                                                                                      
>                                                                                                                                                     
>  - man <command> displays the manual page for a specific command.                                                                                   
>  - <command> --help displays a brief usage message and available options for a specific command.                                                    
>  - info <command> displays detailed information about a specific command.                                                                           
>                                                                                                                                                     
>  Note: Some commands may not have detailed help available and may only provide basic usage information.                                             
>
> Some useful commands:
>
> Get help for a command:
> 
>   help nano
> 
> How do I ... ?
> 
>   howdoi 'print hello world'
> 
> Too long; didn't read (the manual page). Give me the gist of how to use this command:
>
>   tldr 'git commit'
> 
> Use git to ...
> 
>   use_git_to 'Undo the most recent local commits'
> 
> Use GitHub CLI to ...
> 
>   use_gh_to 'Create pull request'
> 
> Use the shell to ...
> 
>   use_sh_to 'Kill processes holding onto deleted files'
> 
> Explain ...
> 
>   explain 'what is a dbus session bus'
> 
> Suggest Command Interactively
> 
>   suggest

#### Explain

Explain a command or a concept.

```shell
❯ explain 'what is a dbus session bus'
```

#### Suggest

Suggest a command to run.

```shell
❯ suggest -t shell "split csv using awk"
```

#### Use Git (command)

Get help with Git.

```shell
❯ use_git_to 'Undo the most recent local commits'
```

#### Use GitHub CLI

Get help with GitHub CLI.

```shell
❯ use_gh_to 'Create pull request'
```

#### Use the Shell

Get help with the shell.

```shell
❯ use_sh_to 'Kill processes holding onto deleted files'
```

#### How do I ... ?

Ask GitHub Copilot how to do something.

```shell
❯ howdoi 'print hello world'
```

#### Too long; didn't read (the manual page)

Give me the gist of how to use this command.

```shell
❯ tldr 'git commit'
```

### `copilot` `==` `codepilot`

You can run CodePilot by using either `copilot` or `codepilot` commands interchangeably.

```shell
❯ which copilot
```

> copilot: aliased to gh copilot

```shell
❯ which codepilot
```

> codepilot: aliased to gh copilot

```shell
❯ codepilot --version
version 0.5.3-beta (2023-11-09)
❯ copilot --help
Your AI command line copilot.

Usage:
  copilot `[command]`

Examples:

$ gh copilot suggest "Install git"
$ gh copilot explain "traceroute github.com"


Available Commands:
  config      Configure options
  explain     Explain a command
  suggest     Suggest a command

Flags:
  -h, --help      help for copilot
  -v, --version   version for copilot

Use "copilot `[command]` --help" for more information about a command.
```
