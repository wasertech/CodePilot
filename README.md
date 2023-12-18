# CodePilot
Your AI command line copilot.

> I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

You need an active subscription to GitHub Copilot to use this tool.

## Installation

```shell
...
```

## Usage

To be sourced in your shell.

```shell
❯ source copilot
```

> Welcome in the Shell. I am GitHub Copilot. I can help you operate the shell.
> To get started, type 'welcome' to learn how to operate the shell.
> To get more help you can type 'help'.
> Type 'exit' to exit the shell.

## Commands


### Welcome

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
>  • Use commands to perform specific tasks or operations.                                                                                            
>  • Use command options or flags to modify the behavior of commands.                                                                                 
>  • Combine commands using pipes (|) to pass the output of one command as the input to another.                                                      
>  • Use redirection operators (>, >>, <) to redirect input and output.                                                                               
>  • Use command substitution ($(...) or `...`) to capture the output of a command and use it as part of another command.                             
>  • Use variables to store and manipulate data.                                                                                                      
>  • Use loops (for, while) to iterate over lists or execute commands repeatedly.                                                                     
>  • Use conditionals (if, case) to control the flow of execution based on conditions.                                                                
>  • Use control operators (&&, ||, ;) to combine multiple commands and control their execution.                                                      
>  • Use file and directory manipulation commands (ls, cp, mv, rm, mkdir, cd) to work with files and directories.                                     
>  • Use text processing commands (grep, sed, awk) to search for patterns and manipulate text.                                                        
>  • Use package management commands (apt-get, yum, brew) to manage software packages.                                                                
>  • Use version control system commands (git, svn) to manage source code repositories.                                                               
>  • Use system monitoring commands (ps, top, htop) to monitor system processes.                                                                      
>  • Use network-related commands (ping, curl, ssh) to interact with network resources.                                                               
>  • Use help commands (man, info, --help) to get information about commands and their usage.                                                         
>  • Use the shell`s built-in features (history, command line editing, tab completion) to enhance productivity.                                       
>                                                                                                                                                     
>  Note: The shell and its usage may vary depending on the operating system and shell you are using. 

### Help

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
>  • man <command> displays the manual page for a specific command.                                                                                   
>  • <command> --help displays a brief usage message and available options for a specific command.                                                    
>  • info <command> displays detailed information about a specific command.                                                                           
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

### Explain

```shell
❯ explain 'what is a dbus session bus'
```

### Suggest

```shell
❯ suggest -t shell "split csv using awk"
```

### Use git to ...

```shell
❯ use_git_to 'Undo the most recent local commits'
```

### Use GitHub CLI to ...

```shell
❯ use_gh_to 'Create pull request'
```

### Use the shell to ...

```shell
❯ use_sh_to 'Kill processes holding onto deleted files'
```

### How do I ... ?

```shell
❯ howdoi 'print hello world'
```

### Too long; didn't read (the manual page)

Give me the gist of how to use this command.

```shell
❯ tldr 'git commit'
```

### Copilot == Codepilot

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
  copilot [command]

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

Use "copilot [command] --help" for more information about a command.
```
