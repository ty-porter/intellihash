# frozen_string_literal: true

module Intellihash
  class << self
    attr_reader :configuration

    def configure
      yield(@configuration)

      inject_dependencies! if Intellihash.enabled?
    end

    def configuration=(config)
      raise InvalidConfiguration, config.class unless config.is_a?(Intellihash::Configuration)

      @configuration = config
    end

    private

    def inject_dependencies!
      Hash.include Intellihash::Mixins
      Hash.prepend Intellihash::Callbacks
    end
  end

  class Configuration
    attr_accessor :enabled, :intelligent_by_default
    attr_reader   :default_format

    def initialize
      @default_format          = :symbol
      @enabled                 = false
      @intelligent_by_default  = false
    end

    def default_format=(other)
      @default_format = Intellihash::Mixins::FORMATTER.member?(other) ? other : :symbol
    end
  end

  class InvalidConfiguration < StandardError; end

  @configuration = Intellihash::Configuration.new
end
