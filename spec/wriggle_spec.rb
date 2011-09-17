require 'spec_helper'

describe "wriggle" do
  it "should be included in self" do
    expect { wriggle('.') {} }.to_not raise_error
  end
end
