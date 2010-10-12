require 'spec_helper'

describe Wriggle do
  # 1.8.7's Find uses relative paths, while 1.9.2's uses absolutes,
  # so we'll call expand_path and make sure our specs use this method
  def valid_dir
    File.expand_path(File.dirname(__FILE__))
  end

  it "should require a path argument" do
    lambda { wriggle() {} }.should raise_error(ArgumentError)
  end

  it "should raise an ArgumentError when given an invalid path" do
    lambda { wriggle('/path/to/nothing') {} }.should raise_error(ArgumentError, /does not exist/)
  end

  it "should raise an ArgumentError when given a non-directory" do
    lambda { wriggle(__FILE__) {} }.should raise_error(ArgumentError, /is not a directory/)
  end

  context "given a valid path" do
    describe "#file" do
      it "should raise an ArgumentError when not given a block" do
        lambda { wriggle(valid_dir) { |w| w.file } }.should raise_error(ArgumentError, /a block is required/)
      end

      it "should not include directories when only a file block is provided" do
        actual = []
        wriggle(valid_dir) do |w|
          w.file do |path|
            actual << path
          end
        end

        actual.should include("#{valid_dir}/empty.txt")
        actual.should include("#{valid_dir}/wriggle_spec.rb")
        actual.should_not include("#{valid_dir}/spec")
      end

      it "should only include files of the type specified" do
        actual = []
        wriggle(valid_dir) do |w|
          w.file :rb do |path|
            actual << path
          end
        end

        actual.should include("#{valid_dir}/wriggle_spec.rb")
        actual.should_not include("#{valid_dir}/empty.txt")
        actual.should_not include("#{valid_dir}")
      end
    end

    describe "#directory" do
      it "should raise an ArgumentError when not given a block" do
        lambda { wriggle(valid_dir) { |w| w.directory } }.should raise_error(ArgumentError, /a block is required/)
      end

      it "should not include files when only a directory block is provided" do
        actual = []
        wriggle(valid_dir) do |w|
          w.directory do |path|
            actual << path
          end
        end

        actual.should include("#{valid_dir}")
        actual.should_not include("#{valid_dir}/wriggle_spec.rb")
      end
    end
  end
end
