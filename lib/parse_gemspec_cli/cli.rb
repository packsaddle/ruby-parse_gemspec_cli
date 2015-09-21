require 'thor'

module ParseGemspecCli
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'version', 'Show the ParseGemspecCli version'
    map %w(-v --version) => :version

    def version
      puts "ParseGemspecCli version #{VERSION}"
    end

    desc 'parse', 'Parse *.gemspec'
    option :debug, type: :boolean, default: false
    option :verbose, type: :boolean, default: false
    option :load, type: :string
    def parse
      setup_logger(options)
    rescue StandardError => e
      suggest_messages(options)
      raise e
    end

    no_commands do
      def logger
        ::ParseGemspecCli.logger
      end

      def setup_logger(options)
        if options[:debug]
          logger.level = Logger::DEBUG
        elsif options[:verbose]
          logger.level = Logger::INFO
        end
        logger.debug(options)
      end

      def suggest_messages(options)
        logger.error 'Please report an issue here:'
        logger.error ISSUE_URL
        logger.error 'options:'
        logger.error options
      end
    end
  end
end