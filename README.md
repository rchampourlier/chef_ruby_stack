## Summary

* Install rbenv and ruby_build to manage and install rubies.
* Install Bundler to manage the gems as you do in production.
* Setup Bundler to vendor the gems in `vendor/bundle` so that it acts like a gemsets-manager.

## Details

* **rbenv** is installed system-wide.
* **ruby-build** is installed.
* The rubies specified in the ["ruby_stack"]["rubies"] option are installed.
* **Bundler** (latest release) is installed within each ruby (globally).
* `~/.bundle/config` is created to configure Bundler so that it bundles the gems inside each project's `vendor/bundle` directory.

## Dependencies

The following cookbooks are required for this recipe:

* ruby_build
* rbenv

You can add the following to your `Cheffile` if you're using Librarian:

```
cookbook 'ruby_build', :git => 'https://github.com/fnichol/chef-ruby_build.git', :ref => 'v0.6.2'
cookbook 'rbenv', :git => 'https://github.com/fnichol/chef-rbenv', :ref => 'v0.6.8'
```

## Example config

Except for the alias of `bundle exec` at the end of the tutorial, this setup is approximatively doing the same setup as this [tutorial](http://www.softr.li/blog/2012/04/10/moving-from-rvm-to-rbenv/) for a `vagrant` user on an Ubuntu machine:

```ruby Cheffile
site "http://community.opscode.com/api/v1"

cookbook 'ruby_build',
  :git => 'https://github.com/fnichol/chef-ruby_build.git',
  :ref => 'v0.6.2'

cookbook 'rbenv',
  :git => 'https://github.com/fnichol/chef-rbenv',
  :ref => 'v0.6.8'

cookbook 'ruby_stack',
  :path => 'local_cookbooks/ruby_stack'
```

```json dna.json
{
  "run_list": [
    "recipe[ruby_stack]"
  ],

  "ruby_stack": {
    "rubies": ["1.9.2-p290"],
    "global": "1.9.2-p290",
    "users": "vagrant"
  }
}
```

Running the recipe with `chef-solo`:

```
sudo chef-solo -c solo_config.rb -j dna.json
```