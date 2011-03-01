require 'spec_helper'

describe Wriggle do
  it "should require a path argument" do
    expect { wriggle() {} }.to raise_error(ArgumentError)
  end

  it "should raise an ArgumentError when given an invalid path" do
    expect { wriggle('/path/to/nothing') {} }.to raise_error(ArgumentError, /does not exist/)
  end

  it "should raise an ArgumentError when given a non-directory" do
    expect { wriggle(__FILE__) {} }.to raise_error(ArgumentError, /is not a directory/)
  end

  it "should alias 'files' to 'file'" do
    expect { wriggle(TemporaryFiles.path) { |w| w.files } }.to_not raise_error(NoMethodError)
  end

  it "should alias 'directories' to 'directory'" do
    expect { wriggle(TemporaryFiles.path) { |w| w.directories } }.to_not raise_error(NoMethodError)
  end
end

describe Wriggle, "#file" do
  it "should raise an ArgumentError when not given a block" do
    expect { wriggle(TemporaryFiles.path) { |w| w.file } }.to raise_error(ArgumentError, /a block is required/)
  end

  it "should not include directories when only a file block is provided" do
    actual = []
    wriggle(TemporaryFiles.path) do |w|
      w.file do |path|
        actual << path
      end
    end

    actual.should include("#{TemporaryFiles.path}/app/controllers/members_controller.rb")
    actual.should include("#{TemporaryFiles.path}/app/models/item.rb")
    actual.should include("#{TemporaryFiles.path}/app/views/layouts/application.lua.erb")
    actual.should include("#{TemporaryFiles.path}/app/views/layouts/application.html.haml")
    actual.should include("#{TemporaryFiles.path}/app/views/members/wishlists/create.js.rjs")
    actual.should_not include("#{TemporaryFiles.path}/app/views/")
  end

  it "should only include files of the type specified" do
    ruby, view = [], []
    wriggle(TemporaryFiles.path) do |w|
      w.file :rb, :erb do |path|
        ruby << path
      end

      w.file %w(rjs haml) do |path|
        view << path
      end
    end

    ruby.should include("#{TemporaryFiles.path}/app/controllers/members_controller.rb")
    ruby.should include("#{TemporaryFiles.path}/app/models/item.rb")
    ruby.should include("#{TemporaryFiles.path}/app/views/layouts/application.lua.erb")
    ruby.should_not include("#{TemporaryFiles.path}/app/views/layouts/application.html.haml")
    ruby.should_not include("#{TemporaryFiles.path}/app/views/members/wishlists/create.js.rjs")
    ruby.should_not include("#{TemporaryFiles.path}/app/views/")

    view.should_not include("#{TemporaryFiles.path}/app/controllers/members_controller.rb")
    view.should_not include("#{TemporaryFiles.path}/app/models/item.rb")
    view.should_not include("#{TemporaryFiles.path}/app/views/layouts/application.lua.erb")
    view.should include("#{TemporaryFiles.path}/app/views/layouts/application.html.haml")
    view.should include("#{TemporaryFiles.path}/app/views/members/wishlists/create.js.rjs")
    view.should_not include("#{TemporaryFiles.path}/app/views/")
  end
end

describe Wriggle, "#directory" do
  it "should raise an ArgumentError when not given a block" do
    expect { wriggle(TemporaryFiles.path) { |w| w.directory } }.to raise_error(ArgumentError, /a block is required/)
  end

  it "should not include files when only a directory block is provided" do
    actual = []
    wriggle(TemporaryFiles.path) do |w|
      w.directory do |path|
        actual << path
      end
    end

    actual.should include("#{TemporaryFiles.path}")
    actual.should include("#{TemporaryFiles.path}/app")
    actual.should include("#{TemporaryFiles.path}/app/models")
    actual.should_not include("#{TemporaryFiles.path}/models/member.rb")
  end

  it "should only include directories matching a pattern when given an argument" do
    actual = []
    wriggle(TemporaryFiles.path) do |w|
      w.directory /member/, /model/ do |path|
        actual << path
      end
    end

    actual.should include("#{TemporaryFiles.path}/app/controllers/members")
    actual.should include("#{TemporaryFiles.path}/app/helpers/members")
    actual.should include("#{TemporaryFiles.path}/app/views/members")
    actual.should include("#{TemporaryFiles.path}/app/views/members/wishlists")
    actual.should include("#{TemporaryFiles.path}/app/models")
    actual.should_not include("#{TemporaryFiles.path}/app/views/items")
    actual.should_not include("#{TemporaryFiles.path}/app/views/layouts")
  end
end
