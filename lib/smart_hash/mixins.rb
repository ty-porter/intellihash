# frozen_string_literal: true

module SmartHash
  module Mixins
    def smart
      @smart = @smart.nil? ? SmartHash.configuration.smart_by_default : @smart
    end

    def is_smart=(value)
      # Ensure this is a boolean
      @smart = value == true
    end

    def to_smart_hash
      @smart = true
      self
    end

    def is_smart?
      smart
    end

    def default_format
      @default_format ||= SmartHash.configuration.default_format
    end

    def default_format=(other)
      @default_format = FORMATTER.member?(other) ? other : FORMATTER[:symbol]
    end

    private

    FORMATTER = {
      str: :to_s,
      string: :to_s,
      sym: :to_sym,
      symbol: :to_sym,
      any: :any
    }.freeze

    def method_missing(method_name, *args, **kwargs, &block)
      super unless respond_to?(:is_smart?) && is_smart?

      if method_name[-1] == '='
        send(:store, method_name[0, method_name.size - 1].send(key_store_as), args.first)
      else
        format_method = key_retrieve_from(kwargs)
        case format_method
        when :any then fetch_where_present(method_name)
        else send(:[], method_name.send(format_method))
        end
      end
    end

    def respond_to_missing?(*)
      is_smart? ? true : super
    end

    def key_store_as
      default_format == :any ? FORMATTER[:symbol] : FORMATTER[default_format]
      default_format || FORMATTER[:symbol]
    end

    def key_retrieve_from(options)
      from_option = options.fetch(:from) { default_format }
      format(from_option)
    end

    def format(value)
      FORMATTER.include?(value) ? FORMATTER[value] : FORMATTER[:symbol]
    end

    def fetch_where_present(method_name)
      return send(:[], method_name.to_sym) if member?(method_name.to_sym)
      return send(:[], method_name.to_s) if member?(method_name.to_s)
    end
  end
end
