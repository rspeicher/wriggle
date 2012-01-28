require 'find'

require 'wriggle/path'
require 'wriggle/wriggle'

# = Wriggle
#
# A simple directory crawler DSL.
#
# == Usage
#
#   require 'wriggle'
#
#   wriggle '/path/to/files' do |w|
#     # Print a list of files
#     w.file { |path| puts path }
#
#     # Build a list of Rails controller files
#     controllers = []
#     w.files /_controller\.rb/ do |path|
#       controllers << path
#     end
#
#     # Print the path of any file named "spec_helper.rb"
#     w.file('spec_helper.rb') { |path| puts path }
#
#     # Build an array of Ruby code files
#     ruby_files = []
#     w.extension :rb do |path|
#       ruby_files << path
#     end
#
#     # Build an array of video files
#     video_files = []
#     w.extensions %w(mpg mpeg wmv avi mkv) do |path|
#       video_files << path
#     end
#
#     # Delete directories that are empty
#     w.directories do |path|
#       Dir.rmdir(path) unless Dir.entries(path).length > 2
#     end
#
#     # Print a list of directories matching "foo"
#     # NOTE: Matches "/baz/bar/foo" and "/foo" but not "/foo/bar/baz"
#     w.directory(/foo/) { |path| puts path }
#   end
module Wriggle
  # Crawl the given +path+
  #
  # @raise ArgumentError Given path does not exist or is not a directory
  def wriggle(path, &block)
    raise ArgumentError, "#{path} does not exist or is not a directory" unless File.directory?(path)

    Wriggle.new(path, &block)
  end
end

self.send(:include, Wriggle)
