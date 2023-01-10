# MacOS Bootstraper

A tool providing a bunch of generic boostrappers to configure a development enviroment focused on MacOS.


## Usage

This tool provides a single script that will iterate through all the provided bootstrappers and execute each of them, sequentially. It can be run multiple times, all bootstrappers should be checking if the target changes have been made, or simply replacing these changes with the same outcome.

Here's a list of all the steps needed:

1. Clone this GitHub repository to your local machine;
2. If needed, create a dedicated group under /groups, dedicated to your team, and provide your own configuration:
    - In config, define which boostrappers you would like to run
    - In Brewfile, define which packages would be useful for your team
3. Edit the main config file, at the root of the project, and select which groups to bootstrap
4. Run: `make all`

Note that most of the boostrappers will ask for user confirmation at the beggining before making any changes on the machine.
