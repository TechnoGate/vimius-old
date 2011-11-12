module Vimius
  module Config
    extend self

    # Define the config class variable
    @@config = nil

    # Return a particular config variable from the parsed config file
    #
    # @param [String|Symbol] config
    # @return mixed
    # @raise [Void]
    def [](config)
      if @@config.nil?
        check_config_file
        @@config ||= parse_config_file
      end

      @@config[:vimius].send(:[], config)
    end

    # Get the config file
    #
    # @return [String] Absolute path to the config file
    def config_file
      File.join(ENV["HOME"], 'vimius.yml')
    end

    protected
      # Initialize the configuration file
      def initialize_config_file
        File.open(config_file, 'w') do |f|
          f.write ""
        end
      end

      # Check the config file
      def check_config_file
        # Check that config_file is defined
        raise ConfigNotDefinedError unless config_file
        # Check that the config file exists
        initialize_config_file unless ::File.exists?(config_file)
        # Check that the config file is readable?
        raise ConfigNotReadableError unless ::File.readable?(config_file)
      end

      # Parse the config file
      #
      # @return [HashWithIndifferentAccess] The config
      def parse_config_file
        begin
          parsed_yaml = YAML.parse_file config_file
        rescue Psych::SyntaxError => e
          raise ConfigNotValidError,
            "Not valid YAML file: #{e.message}."
        end
        raise ConfigNotValidError,
          "Not valid YAML file: The YAML does not respond_to to_ruby." unless parsed_yaml.respond_to?(:to_ruby)
        config = parsed_yaml.to_ruby
        raise ConfigNotValidError,
          "Not valid YAML file: It doesn't contain vimius root key." unless config.has_key?(:vimius)

        config
      end
  end
end
