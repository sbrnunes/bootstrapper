# MacOS Bootstraper

A tool providing a bunch of generic boostrappers to configure a development enviroment focused on MacOS.


## Usage

This tool provides a single script that will iterate through all the provided bootstrappers and execute each of them, sequentially.

It can be run multiple times. All bootstrappers should be checking if the target changes have been made, or simply replacing these changes with the same outcome.

As an alternative, each boostrapper can be run independently. See below how.

Here's a list of all the steps needed:

1. Clone the GitHub repo:
    ```bash
    git clone git@github.com:sbrnunes/bootstrapper.git
    ```
2. Edit the config file and select just the boostrappers to run
3. Execute the main script at the root of the project:
    ```
    ./boostrap.sh
    ```

Note that most of the boostrappers will ask for user confirmation at the beggining before making any changes on the machine.

## Supported bootstrappers

### SSH

Generates a private/public key pair, automaticaly loads the private key into the MacOS ssh-agent, and outputs the public key at the end, which can then be loaded into any required system for authentication purposes (e.g., GitHub).

Can be executed independently with:
```bash
./bootstrappers/bootstrap-ssh.sh
```

### XCode

XCode Command Line Tools is a dependency to install Homebrew.

Can be executed independently with:
```bash
./bootstrappers/bootstrap-xcode.sh
```

### Homebrew

One of the most used package managers for MacOS.

Can be executed independently with:
```bash
./bootstrappers/bootstrap-homebrew.sh
```

### iTerm2

iTerm2 is an open source replacement for Apple's Terminal. It's highly customizable and comes with a lot of useful features.

Can be executed independently with:
```bash
./bootstrappers/bootstrap-iterm.sh
```

### Zsh with Oh My Zsh

The Z shell (also known as zsh) is a Unix shell that is built on top of bash (the default shell for macOS) with additional features.

Can be executed independently with:
```bash
./bootstrappers/bootstrap-zsh.sh
```

### VScode

Visual Studio Code is a lightweight code editor with support for many programming languages through extensions

Can be executed independently with:
```bash
./bootstrappers/bootstrap-vscode.sh
```

### Ruby and rbenv

MacOS comes with Ruby installed, but this bootstrapper installs ruby and rbenv via Homebrew to manage and install our own Ruby versions for our development environment.

Can be executed independently with:
```bash
./bootstrappers/bootstrap-ruby.sh
```

### JDK and jEnv

Using Java to build software applications requires the installation of a JDK ("Java Development Kit") or a JRE ("Java Runtime Environment"). By default, this bootstrapper will be installing and loading jEnv with JDK 11.

Can be executed independently with:
```bash
./bootstrappers/bootstrap-jdk.sh
```