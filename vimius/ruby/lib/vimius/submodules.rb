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
      res = []
      res << submodules[name.to_s].merge("name" => name.to_s)
      dependencies(name).each do |dependency|
        res << submodule(dependency)
      end

      res.flatten.uniq
    end

    # Return an array of active submodules
    #
    # @return [Array]
    def active

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

      submodules["submodules"]
    end

    # Return a list of all dependencies of a submodule (recursive)
    #
    # @param [String] name
    # @return [Array]
    def dependencies(name)
      dependencies = []
      submodule = submodules[name.to_s]
      if submodule.has_key?("dependencies")
        submodule["dependencies"].each do |dependency|
          dependencies << dependency
          dependencies << dependencies(dependency)
        end
      end

      dependencies.flatten.uniq.sort
    end
  end
end
