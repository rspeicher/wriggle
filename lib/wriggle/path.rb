require 'pathname'

module Wriggle
  # = Path
  #
  # A simple wrapper around Ruby's <tt>Pathname</tt> that doesn't break
  # backwards compatibility with the previous String-based paths returned by
  # Wriggle.
  #
  # == Examples
  #
  #   >> Pathname.new("lib/wriggle.rb") == "lib/wriggle.rb"
  #   => false
  #   >> Path.new("lib/wriggle.rb") == "lib/wriggle.rb"
  #   => true
  #
  #   >> Pathname.new("lib/wriggle.rb").inspect
  #   => "#<Pathname:lib/wriggle.rb>"
  #   >> Path.new("lib/wriggle.rb").inspect
  #   => "lib/wriggle.rb"
  class Path < Pathname
    def ==(other)
      if other.is_a?(String)
        self.to_s == other
      else
        super
      end
    end

    def inspect
      self.to_s
    end
  end
end
