require 'spec_helper'

describe Modules do
  let(:modules) do
    {
      "modules" => {
        "pathogen" => {
          "path"  => "vimius/vim/core/pathogen",
          "group" => "core",
        },
        "command-t" => {
          "path"  => "vimius/vim/tools/command-t",
          "group" => "tools",
          "dependencies" => ["pathogen"],
        },
      },
    }
  end

  before(:each) do
    @yaml = mock "YAML"
    @yaml.stubs(:to_ruby).returns(modules)
    Psych.stubs(:parse_file).returns(@yaml)
  end

  describe '#parse_modules_yaml_file' do
    it { should respond_to :parse_modules_yaml_file }

    it "should parse the modules file and returns a hash" do
      subject.send(:parse_modules_yaml_file).should be_instance_of Hash
    end

    it "should handle the case where modules is not a valid YAML file." do
      Psych.stubs(:parse_file).raises(Psych::SyntaxError)

      -> { subject.send :parse_modules_yaml_file }.should raise_error ModulesNotValidError
    end

    it "should handle the case where Psych returns nil." do
      Psych.stubs(:parse_file).returns(nil)

      -> { subject.send :parse_modules_yaml_file }.should raise_error ModulesNotValidError
    end

    it "should handle the case where :modules key does not exist" do
      config = {}
      yaml = mock
      yaml.stubs(:to_ruby).returns(config)
      Psych.stubs(:parse_file).returns(yaml)

      -> { subject.send :parse_modules_yaml_file }.should raise_error ModulesNotValidError
    end
  end
end
