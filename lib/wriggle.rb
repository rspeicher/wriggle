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
#     # Build an array of Ruby code files
#     ruby_files = []
#     w.file :rb do |path|
#       ruby_files << path
#     end
#
#     # Build an array of video files
#     video_files = []
#     w.files %w(mpg mpeg wmv avi mkv) do |path|
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
#     w.directory /foo/ do |path|
#       puts path
#     end
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
    attr_accessor :root, :file_blocks, :directory_blocks

    def initialize(root, &block)
      @root             = root
      @file_blocks      = []
      @directory_blocks = []

      crawl(&block)
    end

    def crawl(&block)
      yield self

      Find.find(root) do |current|
        if File.file?(current)
          dispatch_file(current)
        elsif File.directory?(current)
          dispatch_directory(current)
        end
      end
    end

    # Define a block to be called when a file is encountered
    #
    # Provide one or more extensions to limit the files yielded.
    #
    # == Examples:
    #   file :rb { |file| ... }
    #   file :rb, :rdoc { |file| ... }
    #   file %w(mpeg mpeg wmv avi mkv) { |file| ... }
    #
    # @raise ArgumentError When no block provided
    def file(*extensions, &block)
      raise ArgumentError, "a block is required" unless block_given?
      file_blocks << {:ext => extensions.flatten, :block => block}
    end

    # Define a block to be called when a directory is encountered
    #
    # @raise ArgumentError When no block provided
    def directory(*patterns, &block)
      raise ArgumentError, "a block is required" unless block_given?
      directory_blocks << {:pattern => patterns.flatten, :block => block}
    end

    alias_method :files, :file
    alias_method :directories, :directory

    private

    def dispatch_file(path)
      extension = File.extname(path)

      file_blocks.each do |group|
        if group[:ext].empty?
          group[:block].call(path)
        else
          # Requested specific extensions only
          # Check if any of the extensions match the current file's extension (with or without the period)
          if group[:ext].any? { |v| v.to_s == extension or v.to_s == extension[1..-1] }
            group[:block].call(path)
          end
        end
      end
    end

    def dispatch_directory(path)
      directory_blocks.each do |group|
        if group[:pattern].empty?
          group[:block].call(path)
        else
          # Requested only directories matching a certain pattern
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
