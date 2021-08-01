# frozen_string_literal: true

module SmartHash
  module Extensions
    def smart
      @smart ||= false
    end

    def is_smart=(value)
      # Ensure this is a boolean
      @smart = value == true
    end

    def to_smart_hash
      @smart = true
    end

    def is_smart?
      smart
    end

    def default_format
      @default_format ||= :symbol
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
      super unless is_smart?

      if method_name[-1] == '='
        format_method = key_store_as(kwargs)
        send(:store, method_name[0, method_name.size - 1].send(format_method), args.first)
      else
        format_method = key_retrieve_from(kwargs)
        case format_method
        when :any then fetch_where_present(method_name)
        else send(:[], method_name.send(format_method))
        end
      end
    end

    def respond_to_missing?(_method_name)
      true
    end

    def key_store_as(_kwargs)
      default_format == :any ? FORMATTER[:symbol] : FORMATTER[default_format]
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
