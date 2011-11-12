module Vimius
  # Errors
  VimiusError = Class.new Exception
  BlockNotGivenError = Class.new VimiusError
  RubyGemsNotFoundError = Class.new VimiusError
  ConfigNotReadableError = Class.new VimiusError
  ConfigNotDefinedError = Class.new VimiusError
  ConfigNotValidError = Class.new VimiusError
  SubmodulesNotValidError = Class.new VimiusError
end
