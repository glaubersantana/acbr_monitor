require "acbr_monitor/command"
require "acbr_monitor/config"
require "acbr_monitor/connection"
require "acbr_monitor/version"
require "logger"

module AcbrMonitor

  DEFAULT_LOGGER_FILENAME = 'acbr_monitor.log'

  class << self

    attr_accessor :configuration

    # Configuration
    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end

    # Success and errors
    def success?
      errors.empty?
    end

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    # Logger
    def logger
      @logger ||= create_logger
    end

    def create_logger
      logger = Logger.new(logger_path)
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime.strftime('%y.%m.%d %H:%M:%S')} [#{'%5s' % severity}] #{msg}\n"
      end
      logger
    end

    def logger_path
      defined?(Rails) && defined?(Rails.root) ?
        Rails.root.join('log', DEFAULT_LOGGER_FILENAME) :
        File.join(Dir.pwd, DEFAULT_LOGGER_FILENAME)
    end
  end

end
