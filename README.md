# Wriggle

A simple directory crawler DSL.

## Usage

    require 'wriggle'

    wriggle '/path/to/files' do |w|
      # Build an array of Ruby code files
      ruby_files = []
      w.file :rb do |path|
        ruby_files << path
      end

      # Build an array of video files
      video_files = []
      w.files %w(mpg mpeg wmv avi mkv) do |path|
        video_files << path
      end

      # Delete directories that are empty
      w.directories do |path|
        Dir.rmdir(path) unless Dir.entries(path).length > 2
      end

      # Print a list of directories matching "foo"
      # NOTE: Matches "/baz/bar/foo" and "/foo" but not "/foo/bar/baz"
      w.directory /foo/ do |path|
        puts path
      end
    end

## Note on Patches/Pull Requests

* Fork
* Code
* Commit
* Push
* Pull Request

## Copyright

Copyright (c) 2010 Robert Speicher. See LICENSE for details.
