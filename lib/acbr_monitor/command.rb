module AcbrMonitor
  class Command

    EOC = "\r\n.\r\n" # End Of Command
    EOM = 3.chr # End Of Message

    attr_accessor :command, :response

    def initialize(module_name, command_name, *parameters)
      @command = "#{module_name}.#{command_name}"

      unless parameters.empty?
        @command << '('
        @command << parameters.map{ |p| p.class == String ? "\"#{p}\"" : p }.join(', ')
        @command << ')'
      end

      AcbrMonitor.logger.debug "Command: #{command}"
    end

    def send_command
      return if connection && !success?

      AcbrMonitor.logger.debug "Sending command..."

      connection.client.puts @command
      connection.client.puts EOC

      Timeout.timeout(AcbrMonitor.config.command_timeout.to_i) do
        AcbrMonitor.logger.debug "Waiting for response..."

        @response = connection.client.gets(EOM).chomp(EOM)

        if @response.blank?
          AcbrMonitor.errors.add(:command, I18n.t('command.blank_response')) and
          AcbrMonitor.logger.error "Blank response from AcbrMonitor!"
          return
        end

        @response.force_encoding('UTF-8').gsub!("\r", "")
        AcbrMonitor.logger.debug "Response: #{@response}"
      end
    rescue Timeout::Error => e
      AcbrMonitor.errors.add :command, I18n.t('command.timeout')
      AcbrMonitor.logger.error e
    end

    def connection
      @connection ||= Connection.new
    end
  end
end
