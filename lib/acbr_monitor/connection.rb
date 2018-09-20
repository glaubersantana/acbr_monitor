module AcbrMonitor
  class Connection

    EOM = 3.chr # End Of Message

    attr_accessor :client

    def initialize
      AcbrMonitor.logger.debug = "Trying to connecting to AcbrMonitor at #{hostname}:#{port}..."

      Timeout.timeout(AcbrMonitor.config.connection_timeout.to_i) do
        client = TCPSocket.open(AcbrMonitor.config.hostname, AcbrMonitor.config.port.to_i)
      end

      welcome_message = client.gets(EOM).chomp(EOM)

      if welcome_message.blank?
        AcbrMonitor.errors.add(:connection, I18n.t('connection.blank_welcome_message'))
        AcbrMonitor.logger.error "Blank welcome message from AcbrMonitor!"
        return
      end

      welcome_message.gsub!("\r", "")
      AcbrMonitor.logger.debug welcome_message
    rescue Timeout::Error => e
      AcbrMonitor.errors.add :connection, I18n.t('connection.timeout')
      AcbrMonitor.logger.error e
    end

  end
end
