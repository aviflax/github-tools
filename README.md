# GitHub Tools

Tools for working with GitHub in a large org with many repos.

## The Tools

* `./list repos` will list _all_ the specified org’s repos
* `./list repos topic` will list those of the specified org’s repos with the specified topic
* `./list subs` will list those of the specified org’s repos to which you are subscribed
* `./subscribe` will subscribe you to a set of specified repos
* `./unsubscribe` will unsubscribe you from a set of specified repos

Wherein:

* “you” means the user associated with the supplied [GitHub Personal Access Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)
* “subscribe” means change your “watching” status to “watching”
* “unsubscribe” means change your “watching” status to “not watching”
