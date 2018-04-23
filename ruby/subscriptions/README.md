# Tools for Working with GitHub Subscriptions

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

### Deleting All Your (Org) Subscriptions

Run this in bash or a bash-like shell:

```shell
export ORG=FundingCircle
export TOKEN=FOO
./list.sh | tee repos_unsubscribed | ./unsubscribe.sh
```

### Listing the (Org) Repos to Which You’re Subscribed

`list.sh` will output all the repos that belong to the specified organization to which you’re
subscribed.

Run this in bash or a bash-like shell:

```shell
ORG=FundingCircle TOKEN=FOO ./list.sh | tee repos
```

### Unsubscribing From a Set of (Org) Repos

Assuming the set of repos to which you’d like to unsubscribe is in the local file `repos`:

```shell
cat repos | ORG=FundingCircle TOKEN=FOO ./unsubscribe.sh
```

### Subscribing to a Set of (Org) Repos

`subscribe.sh` will subscribe you to all the org’s repos with the specified topic.

([Topics](https://help.github.com/articles/about-topics/) are equivalent to tags or labels; same
idea, different name.)

Run this in bash or a bash-like shell:

```shell
ORG=FundingCircle TOKEN=FOO ./subscribe.sh some-topic
```

If you wish, you can also pipe in a list of repos (bare names only; one repo per line) rather than
specifying a topic. In this case, make the first argument `-` like so:

```shell
cat repos | ORG=FundingCircle TOKEN=FOO ./subscribe.sh -
```
