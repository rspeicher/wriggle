# Wriggle ![](http://stillmaintained.com/tsigo/wriggle.png)

A simple directory crawler DSL.

## Usage

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
    ./.bundle
    ./.bundle/config
    ./.document
    ./.git
    ./.git/COMMIT_EDITMSG
    ./.git/FETCH_HEAD
    ./.git/HEAD
    ./.git/ORIG_HEAD
    ./.git/config
    ./.git/description
    (git structure removed)
    ./.gitignore
    ./.travis.yml
    ./.yardoc
    ./.yardoc/checksums
    ./.yardoc/objects
    ./.yardoc/objects/Wriggle
    ./.yardoc/objects/Wriggle/VERSION.dat
    ./.yardoc/objects/Wriggle/Wriggle
    ./.yardoc/objects/Wriggle/Wriggle/crawl_i.dat
    ./.yardoc/objects/Wriggle/Wriggle/directories_i.dat
    ./.yardoc/objects/Wriggle/Wriggle/directory_i.dat
    ./.yardoc/objects/Wriggle/Wriggle/dispatch_directory_i.dat
    ./.yardoc/objects/Wriggle/Wriggle/dispatch_file_i.dat
    ./.yardoc/objects/Wriggle/Wriggle/extension_i.dat
    ./.yardoc/objects/Wriggle/Wriggle/extensions_i.dat
    ./.yardoc/objects/Wriggle/Wriggle/file_i.dat
    ./.yardoc/objects/Wriggle/Wriggle/files_i.dat
    ./.yardoc/objects/Wriggle/Wriggle/initialize_i.dat
    ./.yardoc/objects/Wriggle/Wriggle.dat
    ./.yardoc/objects/Wriggle/wriggle_i.dat
    ./.yardoc/objects/Wriggle.dat
    ./.yardoc/objects/root.dat
    ./.yardoc/proxy_types
    ./Gemfile
    ./Gemfile.lock
    ./LICENSE
    ./README.md
    ./Rakefile
    ./doc
    ./doc/Wriggle
    ./doc/Wriggle/Wriggle.html
    ./doc/Wriggle.html
    ./doc/_index.html
    ./doc/class_list.html
    ./doc/css
    ./doc/css/common.css
    ./doc/css/full_list.css
    ./doc/css/style.css
    ./doc/file.README.html
    ./doc/file_list.html
    ./doc/frames.html
    ./doc/index.html
    ./doc/js
    ./doc/js/app.js
    ./doc/js/full_list.js
    ./doc/js/jquery.js
    ./doc/method_list.html
    ./doc/top-level-namespace.html
    ./lib
    ./lib/wriggle
    ./lib/wriggle/version.rb
    ./lib/wriggle.rb
    ./pkg
    ./pkg/wriggle-1.0.0.gem
    ./pkg/wriggle-1.1.0.gem
    ./pkg/wriggle-1.2.0.gem
    ./pkg/wriggle-1.3.0.gem
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

## Copyright

Copyright (c) 2011 Robert Speicher. See LICENSE for details.
