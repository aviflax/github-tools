# GitHub Tools

Tools for working with GitHub in a large org with many repos.

## The Tools

“Tools” is maybe an ambitious word; right now these are all “just” scripts:

| Tool | Description | Input (stdin, happy path) | Output (stdout, happy path) |
| ---- | ----------- | ------------------------- | --------------------------- |
| `list` | lists the org’s repos: either those with a specified topic or those to which you’re subscribed | *none* | list of repos |
| `subscribe` | subscribes you to a set of repos | list of repos | *none* |
| `unsubscribe` | unsubscribes you from a set of repos | list of repos | *none* |

Wherein:

* “you” means the user associated with the supplied [GitHub Personal Access Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)
* “subscribe” means change your “watching” status to “watching”
* “unsubscribe” means change your “watching” status to “not watching”

## Requirements

1. [Docker](https://www.docker.com/community-edition#/download)
1. Bash or a Bash-like shell
1. An Internet connection
1. A GitHub Account
1. A GitHub Personal Access Token (see below)

### Obtaining a GitHub Personal Access Token

Please see [Creating a personal access token for the command line](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).

We recommend you save your personal access token in your password manager, because GitHub will not
show you the token again after it’s been generated.

## Using the Tools

In order to be explicit, many of the examples below include the required environment variables ORG and
TOKEN right in the shell commands. This can be annoying to work with, so users may wish to set them
once in their shell by running `export ORG=FundingCircle` etc.

### In Combination

The tools adhere to [the UNIX philosophy](https://en.wikipedia.org/wiki/Unix_philosophy#Doug_McIlroy_on_Unix_programming) as articulated by [Doug McIlroy](https://en.wikipedia.org/wiki/Douglas_McIlroy):

> Write programs that do one thing and do it well. Write programs to work together. Write programs
> to handle text streams, because that is a universal interface.

Therefore you can combine many of these tools together using UNIX pipes.

#### Some Examples

First, you’ll want to `export` the required environment variables:

```shell
export ORG=FundingCircle
export TOKEN=FOO
```

##### First

This would remove **all** your (org) subscriptions:

```shell
./list subs | tee repos_unsubscribed | ./unsubscribe
```

…and this would then restore those subscriptions:

```shell
cat repos_unsubscribed | ./subscribe
```

##### Second

This would subscribe you to all repos with the topic _marketplace_:

```shell
./list repos marketplace | ./subscribe
```

…and this would unsubscribe you from those repos:

```shell
./list repos marketplace | ./unsubscribe
```

### Individually

#### List the (Org) Repos that have a Certain Topic

`list repos <topic>` will output all the repos that belong to the specified organization that have the specified topic.

([Topics](https://help.github.com/articles/about-topics/) are equivalent to tags or labels; same
idea, different name.)

```shell
ORG=FundingCircle TOKEN=FOO ./list repos <topic> | tee repos
```

#### List All of the (Org) Repos

`list repos` will output all the repos that belong to the specified organization:

```shell
ORG=FundingCircle TOKEN=FOO ./list repos
```

#### Listing the (Org) Repos to Which You’re Subscribed

`list subs` will output all the repos that belong to the specified organization to which you’re
subscribed:

```shell
ORG=FundingCircle TOKEN=FOO list subs | tee repos
```

#### Unsubscribing From a Set of (Org) Repos

Assuming the set of repos to which you’d like to unsubscribe is in the local file `repos`:

```shell
cat repos | ORG=FundingCircle TOKEN=FOO ./unsubscribe
```

#### Subscribing to a Set of (Org) Repos

Assuming the set of repos to which you’d like to subscribe is in the local file `repos`:

```shell
cat repos | ORG=FundingCircle TOKEN=FOO ./subscribe
```
