# Tools for Working with GitHub Repositories

## Requirements

1. Docker
1. Bash or a Bash-like shell
1. An Internet connection
1. A GitHub Account
1. A GitHub OAuth 2.0 Token (see below)

## Obtaining a GitHub OAuth 2.0 Token

Please see [Creating a personal access token for the command line](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).

We recommend you save your personal access token in your password manager, because GitHub will not
show you the token again after it’s been generated.

## Usage

In order to be explicit, all the examples below include the required environment variables ORG and
TOKEN right in the shell commands. This can be annoying to work with, so users may wish to set them
once in their shell by running `export ORG=FundingCircle` etc.

### List All of the Organization’s Repos

`list.sh` will output all the repos that belong to the specified organization.

Run this in bash or a bash-like shell:

```shell
ORG=FundingCircle TOKEN=FOO ./list.sh
```
