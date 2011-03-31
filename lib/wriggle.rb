require 'find'

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
#     w.file 'spec_helper.rb' { |path| puts path }
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
#     w.directory /foo/ { |path| puts path }
#   end
module Wriggle
  # Crawl the given +path+
  #
  # @raise ArgumentError Given path does not exist or is not a directory
  def wriggle(path, &block)
    raise ArgumentError, "#{path} does not exist or is not a directory" unless File.directory?(path)

    Wriggle.new(path, &block)
  end

  class Wriggle
    def initialize(root, &block)
      @root             = root
      @file_blocks      = []
      @directory_blocks = []
      @extension_blocks = []

      crawl(&block)
    end

    # Define a block to be called when a file is encountered
    #
    # @example All files
    #   file { |file| ... }
    #
    # @yield [path] Full, absolute file path
    # @raise ArgumentError When no block provided
    def file(*names, &block)
      raise ArgumentError, "a block is required" unless block_given?
      @file_blocks << {:names => names.flatten, :block => block}
    end

    # Define a block to be called when a directory is encountered
    #
    # Provide one or more patterns to match the directory's basename against
    #
    # @example All directories
    #   directory { |dir| ... }
    # @example Directories matching <tt>/lib/</tt>
    #   directory /lib/ { |dir| ... }
    # @example Directories matching <tt>/lib/</tt> or <tt>/spec/</tt>
    #   directories /lib/, /spec/ { |dir| ... }
    #
    # @param [Array] patterns Limit the yielded directory paths only to those matching the provided pattern(s)
    # @yield [path] Full, absolute directory path
    # @raise ArgumentError When no block provided
    def directory(*patterns, &block)
      raise ArgumentError, "a block is required" unless block_given?
      @directory_blocks << {:pattern => patterns.flatten, :block => block}
    end

    # Define a block to be called when a file of a certain extension is encountered
    #
    # @example All <tt>.rb</tt> files
    #   extension '.rb' { |file| ... }
    # @example All <tt>.rb</tt> or <tt>.erb</tt> files
    #   extensions :rb, :erb { |file| ... }
    # @example All video files
    #   extensions %w(mpeg mpeg wmv avi mkv) { |file| ... }
    #
    # @param [Array] extensions Limit the yielded file paths to the provided extensions
    # @yield [path] Full, absolute file path
    # @raise ArgumentError When no block provided
    # @raise ArgumentError When no extension argument provided
    def extension(*extensions, &block)
      raise ArgumentError, "a block is required" unless block_given?
      raise ArgumentError, "at least one extension is required" unless extensions.length > 0
      @extension_blocks << {:ext => extensions.flatten, :block => block}
    end

    alias_method :files,       :file
    alias_method :directories, :directory
    alias_method :extensions,  :extension

    private

    # Yields <tt>self</tt> to allow the user to define file/directory blocks, and then
    # crawl the root directory, dispatching the user's defined blocks as each
    # file type is encountered
    def crawl(&block)
      yield self

      Find.find(@root) do |current|
        if File.file?(current)
          dispatch_file(current)
        elsif File.directory?(current)
          dispatch_directory(current)
        end
      end
    end

    # Called whenever <tt>crawl</tt> encounters a file
    #
    # Handles both <tt>file_blocks</tt> and <tt>extension_blocks</tt>.
    def dispatch_file(path)
      extension = File.extname(path)

      @file_blocks.each do |group|
        if group[:names].empty?
          group[:block].call(path)
        else
          filename = File.basename(path)
          if group[:names].any? { |v| (v.is_a?(String) and filename == v) or (v.is_a?(Regexp) and filename =~ v) }
            group[:block].call(path)
          end
        end
      end

      @extension_blocks.each do |group|
        # Check if any of the extensions match the current file's extension (with or without the period)
        if group[:ext].any? { |v| v.to_s == extension or v.to_s == extension[1..-1] }
          group[:block].call(path)
        end
      end
    end

    # Called whenever <tt>crawl</tt> encounters a directory
    def dispatch_directory(path)
      @directory_blocks.each do |group|
        if group[:pattern].empty?
          group[:block].call(path)
        else
          # User requested only directories matching a certain pattern
          # Check if any of the patterns match the directory name
          base = File.basename(path)
          if group[:pattern].any? { |v| base =~ v }
            group[:block].call(path)
          end
        end
      end
    end
  end
end

self.send(:include, Wriggle)
