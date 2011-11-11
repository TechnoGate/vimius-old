module Vimius
  class Submodules

    MODULES_FILE = File.join(VIMIUS_PATH, 'submodules.yaml')

    # Return the submodules
    #
    # @return [Hash]
    def submodules
      @submodules ||= parse_submodules_yaml_file
    end

    # Return a submodule along with all its dependencies
    #
    # @return [Array]
    def submodule(name)
      submodules["submodules"][name.to_s]
    end

    protected
    # Parse and return the submodules yaml file
    #
    # @return [Hash]
    def parse_submodules_yaml_file
      begin
        parsed_yaml = YAML.parse_file MODULES_FILE
      rescue Psych::SyntaxError => e
        raise SubmodulesNotValidError,
          "Not valid YAML file: #{e.message}."
      end
      raise SubmodulesNotValidError,
        "Not valid YAML file: The YAML does not respond_to to_ruby." unless parsed_yaml.respond_to?(:to_ruby)
      submodules = parsed_yaml.to_ruby
      raise SubmodulesNotValidError,
        "Not valid YAML file: It doesn't contain submodules root key." unless submodules.has_key?("submodules")

      submodules
    end
  end
end
