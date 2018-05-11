# GitHub Tools

Tools for working with GitHub in a large org with many repos.

## The Tools

“Tools” is maybe an ambitious word; right now these are all “just” scripts:

| Tool | Description | Input (stdin, happy path) | Output (stdout, happy path) |
| ---- | ----------- | ------------------------- | --------------------------- |
| `list` | lists the org’s repos: (all, by topic, or those to which you’re subscribed) | *none* | list of repos |
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
1. A [GitHub Personal Access Token](#obtaining-a-github-personal-access-token)

### Obtaining a GitHub Personal Access Token

Please see [Creating a personal access token for the command line](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).

We recommend you save your personal access token in your password manager, because GitHub will not
show you the token again after it’s been generated.

## Using the Tools

**Please note:** in order to be explicit and to facilitate copying-and-pasting all of the examples below include the
required environment variables GITHUB_ORG and GITHUB_TOKEN.

You **must** replace the placeholder values (REPLACE_ME) with an actual
[GitHub Organization name](https://help.github.com/articles/about-organizations/) and an actual
[Personal Access Token](#obtaining-a-github-personal-access-token) before running the examples.

### In Combination

The tools adhere to [the UNIX philosophy](https://en.wikipedia.org/wiki/Unix_philosophy#Doug_McIlroy_on_Unix_programming)
as articulated by [Doug McIlroy](https://en.wikipedia.org/wiki/Douglas_McIlroy):

> Write programs that do one thing and do it well. Write programs to work together. Write programs
> to handle text streams, because that is a universal interface.

Therefore you can combine many of these tools together using UNIX pipes.

#### Some Examples

##### First

This would remove **all** your (org) subscriptions:

```shell
export GITHUB_ORG=REPLACE_ME GITHUB_TOKEN=REPLACE_ME
./list repos --subscribed | tee repos_subscribed.bak | ./unsubscribe
```

…and this would then restore those subscriptions:

```shell
export GITHUB_ORG=REPLACE_ME GITHUB_TOKEN=REPLACE_ME
cat repos_subscribed.bak | ./subscribe
```

##### Second

This would subscribe you to all repos with the topic _marketplace_:

```shell
export GITHUB_ORG=REPLACE_ME GITHUB_TOKEN=REPLACE_ME
./list repos --topic marketplace | tee marketplace_repos | ./subscribe
```

…and this would unsubscribe you from those repos:

```shell
export GITHUB_ORG=REPLACE_ME GITHUB_TOKEN=REPLACE_ME
cat marketplace_repos | ./unsubscribe
```

### Individually

#### List the (Org) Repos that have a Certain Topic

`list repos --topic <topic>` will output all the repos that belong to the specified organization that have the specified topic.

([Topics](https://help.github.com/articles/about-topics/) are equivalent to tags or labels; same
idea, different name.)

```shell
export GITHUB_ORG=REPLACE_ME GITHUB_TOKEN=REPLACE_ME
./list repos --topic <topic> | tee repos
```

#### List All of the (Org) Repos

`list repos --all` will output all the repos that belong to the specified organization:

```shell
export GITHUB_ORG=REPLACE_ME GITHUB_TOKEN=REPLACE_ME
./list repos --all
```

#### List the (Org) Repos to Which You’re Subscribed

`list subs` will output all the repos that belong to the specified organization to which you’re
subscribed:

```shell
GITHUB_ORG=REPLACE_ME GITHUB_TOKEN=REPLACE_ME
./list repos --subscribed | tee repos
```

#### Unsubscribing From a Set of (Org) Repos

Assuming the set of repos to which you’d like to unsubscribe is in the local file `repos`:

```shell
GITHUB_ORG=REPLACE_ME GITHUB_TOKEN=REPLACE_ME
cat repos | ./unsubscribe
```

#### Subscribing to a Set of (Org) Repos

Assuming the set of repos to which you’d like to subscribe is in the local file `repos`:

```shell
GITHUB_ORG=REPLACE_ME GITHUB_TOKEN=REPLACE_ME
cat repos | ./subscribe
```

## Working on the Tools

### Running the Tests

```shell
ruby/run_all_tests.sh
```
