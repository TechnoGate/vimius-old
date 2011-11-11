module Vimius
  class Modules

    MODULES_FILE = File.join(VIMIUS_PATH, 'modules.yaml')

    # Return the modules
    #
    # @return [Hash]
    def modules
      parse_modules_yaml_file
    end

    protected
    # Parse and return the modules yaml file
    #
    # @return [Hash]
    def parse_modules_yaml_file
      begin
        parsed_yaml = YAML.parse_file MODULES_FILE
      rescue Psych::SyntaxError => e
        raise ModulesNotValidError,
          "Not valid YAML file: #{e.message}."
      end
      raise ModulesNotValidError,
        "Not valid YAML file: The YAML does not respond_to to_ruby." unless parsed_yaml.respond_to?(:to_ruby)
      modules = parsed_yaml.to_ruby
      raise ModulesNotValidError,
        "Not valid YAML file: It doesn't contain modules root key." unless modules.has_key?("modules")

      modules
    end
  end
end
