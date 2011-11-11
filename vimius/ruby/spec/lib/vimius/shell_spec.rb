require 'spec_helper'

describe Shell do
  it { should respond_to :shell }

  it "should include the shell method into the Vimius module" do
    Vimius.should respond_to :shell
  end
end
