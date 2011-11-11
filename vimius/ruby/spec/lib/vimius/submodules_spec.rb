require 'spec_helper'

describe Submodules do
  let(:submodules) do
    {
      "submodules" => {
        "pathogen" => {
          "path"  => "vimius/vim/core/pathogen",
          "group" => "core",
        },
        "tlib" => {
          "path"  => "vimius/vim/tools/tlib",
          "group" => "tools",
          "dependencies" => ["pathogen"],
        },
        "command-t" => {
          "path"  => "vimius/vim/tools/command-t",
          "group" => "tools",
          "dependencies" => ["tlib"],
        },
      },
    }
  end

  before(:each) do
    @yaml = mock "YAML"
    @yaml.stubs(:to_ruby).returns(submodules)
    Psych.stubs(:parse_file).returns(@yaml)
  end

  describe '#parse_submodules_yaml_file' do
    it { should respond_to :parse_submodules_yaml_file }

    it "should parse the submodules file and returns a hash" do
      subject.send(:parse_submodules_yaml_file).should be_instance_of Hash
    end

    it "should handle the case where submodules is not a valid YAML file." do
      Psych.stubs(:parse_file).raises(Psych::SyntaxError)

      -> { subject.send :parse_submodules_yaml_file }.should raise_error SubmodulesNotValidError
    end

    it "should handle the case where Psych returns nil." do
      Psych.stubs(:parse_file).returns(nil)

      -> { subject.send :parse_submodules_yaml_file }.should raise_error SubmodulesNotValidError
    end

    it "should handle the case where :submodules key does not exist" do
      config = {}
      yaml = mock
      yaml.stubs(:to_ruby).returns(config)
      Psych.stubs(:parse_file).returns(yaml)

      -> { subject.send :parse_submodules_yaml_file }.should raise_error SubmodulesNotValidError
    end
  end

  describe "#submodules" do
    it { should respond_to :submodules }

    it "should return submodules" do
      subject.submodules.should == submodules
    end

    it "should be cached" do
      subject.submodules.should == submodules
      Psych.stubs(:parse_file).returns(nil)
      subject.submodules.should == submodules
    end
  end

  describe "#submodule" do
    it { should respond_to :submodule }

    it "should return the correct module from the submodules hash" do
      subject.submodule("pathogen").should == submodules["submodules"]["pathogen"]
    end
  end
end
