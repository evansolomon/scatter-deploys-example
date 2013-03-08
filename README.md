# Scatter WP Plugin Deploy

This is an example of a deploy repo that can be used with [Scatter](https://github.com/evansolomon/scatter/).  The easiest use case would be to check out this (your) deploy repo to `/path/to/scatter/deploys`, which is `gitignore`'d by Scatter and will be automatically searched by the `scatter` (and `scap`) command.

## Example Deploys

I packaged up a few example deploy scripts.

### WordPress plugin

The `wp-plugin` executable can be used as a shared resource to automate WordPress plugin deploys to the WordPress.org repository.  The `wp-plugin-name` directory shows a sample deploy script that would use the `wp-plugin` helper.

### Git pull

A very basic form of deploy is a simple `git pull`.  The `git-pull-site` directory shows an example of automating those deploys, plus a little bit of extra validation that the repo is in the state you expect (`reset` and `clean`).

### Capistrano

Capistrano is a great deploy tool, which Scatter will happily use.  The `capistrano-site` directory shows a basic Capistrano config, which Scatter will automatically find and use its `cap deploy` command.  If you want to run another task, you can use Scatter's `scap`, such as: `scap nginx:restart`.

## Further documentation

See [Scatter's readme](https://github.com/evansolomon/scatter/blob/master/README.md).
