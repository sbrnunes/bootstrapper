# MacOS Bootstraper

A tool providing a bunch of generic boostrappers to configure a development enviroment focused on MacOS.


## Usage

This tool provides a single script that will iterate through all the provided bootstrappers and execute each of them, sequentially. It can be run multiple times, all bootstrappers should be checking if the target changes have been made, or simply replacing these changes with the same outcome.

Here's a list of all the steps needed:

1. Clone this GitHub repository to your local machine
2. If needed, create a dedicated group under /groups, dedicated to your team, and provide your own configuration:
    - In config, define which boostrappers you would like to run
    - In Brewfile, define which packages would be useful for your team
3. Edit the main config file, at the root of the project, and select which groups to bootstrap
4. Run: `make all`

Note that most of the boostrappers will ask for user confirmation at the beggining before making any changes on the machine.

## Example output

```
 $ make all
./bootstrap.sh
[./bootstrap.sh] Boostrapping group default. Would you like to continue?
[./bootstrap.sh] Enter [y|n]: y
[./bootstrappers/ssh/bootstrap.sh] Running 'ssh' for group 'default'
[./bootstrappers/ssh/bootstrap.sh] This bootstrapper is going to provision the required ssh keys in your machine.
[./bootstrappers/ssh/bootstrap.sh] Would you like to continue?
[./bootstrappers/ssh/bootstrap.sh] Enter [y|n]:y
[./bootstrappers/ssh/bootstrap.sh] SSH keys have been found inside ~/.ssh, skipping...
[./bootstrappers/xcode/bootstrap.sh] Running 'xcode' for group 'default'
[./bootstrappers/xcode/bootstrap.sh] Checking Command Line Tools for Xcode
[./bootstrappers/xcode/bootstrap.sh] Command Line Tools for Xcode have been installed.
[./bootstrappers/homebrew/bootstrap.sh] Running 'homebrew' for group 'default'
[./bootstrappers/homebrew/bootstrap.sh] This bootstrapper is going to install homebrew and some base packages.
[./bootstrappers/homebrew/bootstrap.sh] Would you like to continue?
[./bootstrappers/homebrew/bootstrap.sh] Enter [y|n]:y
[./bootstrappers/homebrew/bootstrap.sh] Homebrew already installed!
[./bootstrappers/homebrew/bootstrap.sh] Found eval "$(/opt/homebrew/bin/brew shellenv)" in /Users/snunes/env.sh
Updated 3 taps (homebrew/core, homebrew/cask and homebrew/cask-drivers).
==> New Casks
superlist
==> Outdated Formulae
ca-certificates                                                         go                                                                      pyenv

You have 3 outdated formulae installed.
You can upgrade them with brew upgrade
or list them with brew outdated.
[./bootstrappers/homebrew/bootstrap.sh] Installing required packages...
Using cask
Using git
Using jq
Using tree
Using watch
Using wget
Using fzf
Using bash
Homebrew Bundle complete! 8 Brewfile dependencies now installed.
Warning: Skipping ca-certificates: most recent version 2023-01-10 not installed
Removing: /Users/snunes/Library/Caches/Homebrew/ca-certificates--2022-10-11... (127.5KB)
Warning: Skipping go: most recent version 1.19.5 not installed
Removing: /Users/snunes/Library/Caches/Homebrew/go--1.19.4... (175.6MB)
Warning: Skipping pyenv: most recent version 2.3.10 not installed
Removing: /Users/snunes/Library/Caches/Homebrew/pyenv--2.3.9... (716.2KB)
Removing: /Users/snunes/Library/Caches/Homebrew/Cask/visual-studio-code--1.74.2... (118.2MB)
==> This operation has freed approximately 294.5MB of disk space.
[./bootstrappers/iterm/bootstrap.sh] Running 'iterm' for group 'default'
[./bootstrappers/iterm/bootstrap.sh] This bootstrapper is going to download and install iterm2 via Homebrew.
[./bootstrappers/iterm/bootstrap.sh] Would you like to continue?
[./bootstrappers/iterm/bootstrap.sh] Enter [y|n]:y
[./bootstrappers/iterm/bootstrap.sh] Installing iterm2
==> Downloading https://iterm2.com/downloads/stable/iTerm2-3_4_19.zip
Already downloaded: /Users/snunes/Library/Caches/Homebrew/downloads/ef4e7b5b9c5b2bf03d2753730da0103fdf94728d5657b8fc91d18bf3536ed635--iTerm2-3_4_19.zip
==> Installing Cask iterm2
==> Purging files for version 3.4.19 of Cask iterm2
Error: It seems there is already an App at '/Applications/iTerm.app'.
Warning: Cask 'font-source-code-pro' is already installed.

To re-install font-source-code-pro, run:
  brew reinstall --cask font-source-code-pro
[./bootstrappers/zsh/bootstrap.sh] Running 'zsh' for group 'default'
[./bootstrappers/zsh/bootstrap.sh] This bootstrapper is going to install Zsh and Oh My Zsh via Homebrew.
[./bootstrappers/zsh/bootstrap.sh] Would you like to continue?
[./bootstrappers/zsh/bootstrap.sh] Enter [y|n]:y
[./bootstrappers/zsh/bootstrap.sh] Installing Zsh...
Warning: zsh 5.9 is already installed and up-to-date.
To reinstall 5.9, run:
  brew reinstall zsh
[./bootstrappers/zsh/bootstrap.sh] Installing Oh My Zsh...
The $ZSH folder already exists (/Users/snunes/.oh-my-zsh).

You ran the installer with the $ZSH setting or the $ZSH variable is
exported. You have 3 options:

1. Unset the ZSH variable when calling the installer:
   `ZSH= sh install.sh`
2. Install Oh My Zsh to a directory that doesn't exist yet:
   `ZSH=path/to/new/ohmyzsh/folder sh install.sh`
3. (Caution) If the folder doesn't contain important information,
   you can just remove it with `rm -r /Users/snunes/.oh-my-zsh`

[./bootstrappers/zsh/bootstrap.sh] Installing plugins...
fatal: destination path '/Users/snunes/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting' already exists and is not an empty directory.
fatal: destination path '/Users/snunes/.oh-my-zsh/custom/plugins/zsh-autosuggestions' already exists and is not an empty directory.
fatal: destination path '/Users/snunes/.oh-my-zsh/custom/plugins/zsh-completions' already exists and is not an empty directory.
[./bootstrappers/zsh/bootstrap.sh] Making sure the proper shell is being used...
Changing shell for jdoe.
Password for jdoe: ****
chsh: no changes made
[./bootstrappers/zsh/bootstrap.sh] Copying .zhrc from ./templates
[./bootstrappers/zsh/bootstrap.sh] Restart the terminal to loah Zsh.
[./bootstrappers/vscode/bootstrap.sh] Running 'vscode' for group 'default'
[./bootstrappers/vscode/bootstrap.sh] This bootstrapper is going to download and install VSCode via Homebrew
[./bootstrappers/vscode/bootstrap.sh] Would you like to continue?
[./bootstrappers/vscode/bootstrap.sh] Enter [y|n]:y
[./bootstrappers/vscode/bootstrap.sh] Installing VScode
Warning: Cask 'visual-studio-code' is already installed.

To re-install visual-studio-code, run:
  brew reinstall --cask visual-studio-code
[./bootstrappers/ruby/bootstrap.sh] Running 'ruby' for group 'default'
[./bootstrappers/ruby/bootstrap.sh] This bootstrapper is going to download and install Ruby and rbenv via Homebrew
[./bootstrappers/ruby/bootstrap.sh] Would you like to continue?
[./bootstrappers/ruby/bootstrap.sh] Enter [y|n]:y
Warning: rbenv 1.2.0 is already installed and up-to-date.
To reinstall 1.2.0, run:
  brew reinstall rbenv
Warning: ruby-build 20221225 is already installed and up-to-date.
To reinstall 20221225, run:
  brew reinstall ruby-build
Warning: rbenv-default-gems 1.0.0_1 is already installed and up-to-date.
To reinstall 1.0.0_1, run:
  brew reinstall rbenv-default-gems
Warning: rbenv-gemset 0.5.10 is already installed and up-to-date.
To reinstall 0.5.10, run:
  brew reinstall rbenv-gemset
[./bootstrappers/ruby/bootstrap.sh] Restart the terminal to load rbenv.
[./bootstrappers/jdk/bootstrap.sh] Running 'jdk' for group 'default'
[./bootstrappers/jdk/bootstrap.sh] This bootstrapper is going to download and install the JDK and jenv via Homebrew
[./bootstrappers/jdk/bootstrap.sh] Would you like to continue?
[./bootstrappers/jdk/bootstrap.sh] Enter [y|n]:y
[./bootstrappers/jdk/bootstrap.sh] Installing openjdk 11...
Warning: No available formula with the name "openjdk@". Did you mean openjdk, openjdk@8, openjdk@11, openjdk@17, openj9 or openvdb?
==> Searching for similarly named formulae and casks...
==> Formulae
openjdk ✔                           openjdk@11 ✔                        openjdk@17 ✔                        openjdk@8                           openj9                              openvdb

To install openjdk ✔, run:
  brew install openjdk ✔

==> Casks
adoptopenjdk                                                            microsoft-openjdk                                                       openkey

To install adoptopenjdk, run:
  brew install --cask adoptopenjdk
[./bootstrappers/jdk/bootstrap.sh] Symlinking openjdk from Homebrew so that system java wrappers can find it ...
Password:
[./bootstrappers/jdk/bootstrap.sh] Installing jEnv...
Warning: jenv 0.5.5_2 is already installed and up-to-date.
To reinstall 0.5.5_2, run:
  brew reinstall jenv
[./bootstrappers/jdk/bootstrap.sh] Adding Java Virtual Machines from /Library/Java/JavaVirtualMachines to jEnv...
[./bootstrappers/jdk/bootstrap.sh] jEnv is ready. Use 'jenv versions' to list all the available java versions.
[./bootstrappers/jdk/bootstrap.sh] Use 'jenv help' for help with using this tool.
[./bootstrappers/git/bootstrap.sh] Running 'git' for group 'default'
[./bootstrappers/git/bootstrap.sh] This bootstrapper is going to install Git and setup the authentication.
[./bootstrappers/git/bootstrap.sh] Would you like to continue?
[./bootstrappers/git/bootstrap.sh] Enter [y|n]:y
[./bootstrappers/git/bootstrap.sh] Installing Git...
Warning: git 2.39.0 is already installed and up-to-date.
To reinstall 2.39.0, run:
  brew reinstall git
[./bootstrappers/git/bootstrap.sh] Setting global configuration...
[./bootstrappers/git/bootstrap.sh] Enter your name (to be displayed in commits): John Doe
[./bootstrappers/git/bootstrap.sh] Enter your email (to be used with your commits): john.doe@acme.com
[./bootstrappers/git/bootstrap.sh] Create a personal access token in https://github.com/settings/tokens with the following scopes and paste it below:
  - repo
    - repo:status
    - repo_deployment
    - public_repo
    - repo:invite
    - security_events
  - admin:org
    - read:org
  - admin:repo_hook
    - write:repo_hook
    - read:repo_hook
  - admin:org_hook
  - user
    - user:email
  - admin:gpg_key
    - write:gpg_key
[./bootstrappers/git/bootstrap.sh] Token: *****
[./bootstrappers/git/bootstrap.sh] Setting GITHUB_TOKEN...
[./bootstrappers/git/bootstrap.sh] Setting HOMEBREW_GITHUB_API_TOKEN...
[./bootstrappers/git/bootstrap.sh] Setting BUNDLE_GITHUB__COM...
```