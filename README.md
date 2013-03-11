# Scatter Deploys

This is an example of a deploy repo that can be used with [Scatter](https://github.com/evansolomon/scatter/).  The easiest use case would be to check out this (your) deploy repo to `~/.deploys`.

You can install Scatter with `gem installs scatter_deploy`.

## Example Deploys

I packaged up a few example deploy scripts.

### WordPress plugin

The `wp` executable in the `__shared` directory can be used as a shared resource to automate WordPress plugin deploys to the WordPress.org repository.  If you save your plugin in a directory whose name matches its WordPress.org slug (with an optional leading `wp-`), you can simply run `scatter -s wp` to publish the plugin to WordPress.org.  For example, if your plugin slug is something like `my-wp-plugin-name`, your Git repository could be in `/path/to/your/code/my-wp-plugin-name`.  If you want better namespacing, you can also use `/path/to/your/code/wp-my-wp-plugin-name`.

### Git pull

A very basic form of deploy is a simple `git pull`.  The `git-pull-site` directory shows an example of automating those deploys, plus a little bit of extra validation that the repo is in the state you expect (`reset` and `clean`).  Assuming your code is in a directory like `/path/to/your/code/git-pull-site` you could just run `scatter` and the deploy script would be called automatically.

### Capistrano

Capistrano is a great deploy tool, which Scatter will happily use.  The `capistrano-site` directory shows a basic Capistrano config, which `scatter` will automatically find and use its `cap deploy` command.  Again, this assumes a directory structure like `/path/to/your/code/capistrano-site`  If you want to run another task, you can use Scatter's `scatter cap`, such as: `scatter cap nginx:restart`.

### Rubygem

The `gem` executable in the `__shared` directory will automatically publish a Gem to http://rubygems.org.  In this case, you'd run `scatter -s gem` from anywhere in your Gem's directory.  It will automatically be bundled and pushed.

## Further documentation

See [Scatter's readme](https://github.com/evansolomon/scatter/blob/master/README.md).
