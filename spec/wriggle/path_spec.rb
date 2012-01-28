require 'spec_helper'

module Wriggle
  describe Path do
    it "inherits from Pathname" do
      described_class.ancestors.should include(Pathname)
    end
  end
end
