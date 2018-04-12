# Tools for Working with GitHub Subscriptions

## Requirements

1. Docker
1. Bash or a Bash-like shell
1. An Internet connection
1. A GitHub Account
1. A GitHub OAuth 2.0 Token (see below)

## Obtaining a GitHub OAuth 2.0 Token

TODO

## Usage

In a bash or bash-like shell, pipe a list of (simple) repo names, one per line
(UNIX style) into `run.sh`, like so:

```shell
pbpaste | GITHUB_TOKEN=FOO ./run.sh
```

`pbpaste` is a MacOS program, but hopefully you get the idea — pipe whatever
you want into the script, as long as it’s a newline-delimited list.
