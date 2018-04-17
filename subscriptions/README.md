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

In order to be explicit, all the examples below include the required
environment variables ORG and TOKEN right in the shell commands. This can be
annoying to work with, so users may wish to set them once in their shell by
running `export ORG=FundingCircle` etc.

### Listing the Repos to Which You’re Subscribed

`list.sh` will output all the repos to which 

Run this in bash or a bash-like shell:

```shell
ORG=FundingCircle TOKEN=FOO ./list.sh | tee repos
```

### Unsubscribing From a Set of Repos

Assuming the set of repos to which you’d like to unsubscribe is in the local
file `repos`:

```shell
cat repos | ORG=FundingCircle TOKEN=FOO ./unsubscribe.sh
```

### Subscribing to a Set of Repos

Run this in bash or a bash-like shell:

```shell
ORG=FundingCircle TOKEN=FOO ./subscribe.sh my-excellent-topic
```

If you wish, you can also pipe in a list of repos (bare names only; one repo
per line) rather than specifying a topic.
