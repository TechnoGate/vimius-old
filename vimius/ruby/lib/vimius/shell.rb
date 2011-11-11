module Vimius
  module Shell
    extend self

    def shell(command, debug = false)
      if debug
        `#{command}`
      else
        `#{command} 2> /dev/null`
      end
    end
  end

  include Shell
end
