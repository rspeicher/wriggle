# Wriggle

A simple directory crawler DSL.

## Usage

    require 'wriggle'

    wriggle '/path/to/files' do

      # Build an array of Ruby code files
      ruby_files = []
      file :rb do |path|
        ruby_files << path
      end

      # Build an array of video files
      video_files = []
      file %w(mpg mpeg wmv avi mkv) do |path|
        video_files << path
      end

      # Delete directories that are empty
      directory do |path|
        Dir.rmdir(path) unless Dir.entries(path).length > 2
      end
    end

## Note on Patches/Pull Requests

* Fork
* Code
* Commit
* Push
* Pull Request

## Copyright

Copyright (c) 2010 rspeicher. See LICENSE for details.
