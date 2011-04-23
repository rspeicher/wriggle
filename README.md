# Wriggle ![](http://stillmaintained.com/tsigo/wriggle.png)

A simple directory crawler DSL.

## Usage

``` ruby
require 'wriggle'

wriggle '/path/to/files' do |w|
  # Print a list of files
  w.file { |path| puts path }

  # Build a list of Rails controller files
  controllers = []
  w.files /_controller\.rb/ do |path|
    controllers << path
  end

  # Print the path of any file named "spec_helper.rb"
  w.file('spec_helper.rb') { |path| puts path }

  # Build an array of Ruby code files
  ruby_files = []
  w.extension :rb do |path|
    ruby_files << path
  end

  # Build an array of video files
  video_files = []
  w.extensions %w(mpg mpeg wmv avi mkv) do |path|
    video_files << path
  end

  # Delete directories that are empty
  w.directories do |path|
    Dir.rmdir(path) unless Dir.entries(path).length > 2
  end

  # Print a list of directories matching "foo"
  # NOTE: Matches "/baz/bar/foo" and "/foo" but not "/foo/bar/baz"
  w.directory(/foo/) { |path| puts path }
end
```

## Caveats

Wriggle is a wrapper around Ruby's standard library,
[Find](http://ruby-doc.org/stdlib/libdoc/find/rdoc/index.html). As such, it
crawls its starting path recursively. This is currently its default -- and only
-- behavior.

Defined blocks are yielded to as `Find` encounters a directory or file, *not
necessarily the order in which the blocks were defined*.

As an example, here is Wriggle crawling its own tree:

    ruby-1.9.2-p180 :001 > require 'wriggle'
     => true
    ruby-1.9.2-p180 :002 > wriggle '.' do |w|
    ruby-1.9.2-p180 :003 >   w.file { |path| puts path }
    ruby-1.9.2-p180 :004?>   w.directory { |path| puts path }
    ruby-1.9.2-p180 :005?> end
    .
    ./.document
    ./.gitignore
    ./.travis.yml
    ./Gemfile
    ./Gemfile.lock
    ./LICENSE
    ./README.md
    ./Rakefile
    ./lib
    ./lib/wriggle
    ./lib/wriggle/version.rb
    ./lib/wriggle.rb
    ./spec
    ./spec/spec_helper.rb
    ./spec/support
    ./spec/support/temporary_files.rb
    ./spec/wriggle_spec.rb
    ./wriggle.gemspec

If it were important to output a list of directories *and then* a list of
files, it might be best to collect each in their own arrays and then, outside
of the `wriggle` block, loop through them to print each entry.

## Install

    gem install wriggle

## Documentation

[API Docs](http://rdoc.info/github/tsigo/wriggle/master/Wriggle)

## Contributing

Pull requests and bug reports are very appreciated.

* [Bug reports](https://github.com/tsigo/wriggle/issues)
* Patches: Fork and send a pull request.
  * Include specs where it makes sense.

### Developer Quickstart

Once you've cloned this repository or your own fork, these steps should
adequately prepare you to begin contributing to the project.

#### Create a new RVM gemset (optional)

    rvm gemset create wriggle
    rvm gemset use wriggle

#### Bundler

First, [install Bundler](https://github.com/carlhuda/bundler) if you haven't
already. Then install the development dependencies.

    bundle install

#### Run Specs

    rake spec

If everything passes, you're good to go!

## Copyright

Copyright (c) 2011 Robert Speicher. See LICENSE for details.
