module AcbrMonitor
  class Config
    DEFAULT_HOSTNAME            = '127.0.0.1'
    DEFAULT_PORT                = 3436
    DEFAULT_CONNECTION_TIMEOUT  = 10
    DEFAULT_COMMAND_TIMEOUT     = 20

    attr_accessor :hostname,
                  :port,
                  :connection_timeout,
                  :command_timeout

    def initialize
      @hostname           = DEFAULT_HOSTNAME
      @port               = DEFAULT_PORT
      @connection_timeout = DEFAULT_CONNECTION_TIMEOUT
      @command_timeout    = DEFAULT_COMMAND_TIMEOUT
    end
  end
end
