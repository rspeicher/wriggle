require 'find'

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
#
# === Custom Yields
#
# The main <tt>wriggle</tt> block accepts a <tt>yield</tt> option which, if
# given, will create a new object of the specified class before yielding it to
# the defined block(s).
#
# Any object which accepts a String as its only required argument to
# <tt>new</tt> can be used.
#
# For example, if you'd prefer the convenience of working with Pathname instead
# of a regular String, you could do the following:
#
#   require 'wriggle'
#   require 'pathname'
#
#   wriggle '/path/to/files', yield: Pathname do |w|
#     w.file { |path| puts path.extname }
#   end
module Wriggle
  # Crawl the given +path+
  #
  # @raise ArgumentError Given path does not exist or is not a directory
  def wriggle(path, options = {}, &block)
    raise ArgumentError, "#{path} does not exist or is not a directory" unless File.directory?(path)

    Wriggle.new(path, options, &block)
  end
end

self.send(:include, Wriggle)
