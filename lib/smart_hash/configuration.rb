# frozen_string_literal: true

module SmartHash
  class << self
    attr_reader :configuration

    def configure
      yield(@configuration)

      inject_dependencies! if SmartHash.enabled?
    end

    def configuration=(config)
      raise InvalidConfiguration, config.class unless config.is_a?(SmartHash::Configuration)

      @configuration = config
    end

    private

    def inject_dependencies!
      Hash.include SmartHash::Mixins
      Hash.prepend SmartHash::Callbacks
    end
  end

  class Configuration
    attr_accessor :enabled, :smart_by_default
    attr_reader   :default_format

    def initialize
      @default_format    = :symbol
      @enabled           = false
      @smart_by_default  = false
    end

    def default_format=(other)
      @default_format = SmartHash::Mixins::FORMATTER.member?(other) ? other : :symbol
    end
  end

  class InvalidConfiguration < StandardError; end

  @configuration = SmartHash::Configuration.new
end
