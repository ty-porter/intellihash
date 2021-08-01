# frozen_string_literal: true

module SmartHash
  module Callbacks
    # https://ruby-doc.org/core-3.0.1/Hash.html
    #
    # Methods that return a copy of :self: need this callback to populate :smart: from :self:
    CALLBACK_TARGETS = %i[
      compact
      invert
      merge
      reject
      select
      slice
      to_h
      transform_keys
      transform_values
    ].freeze

    CALLBACK_TARGETS.each do |instance_method|
      define_method(instance_method) do |*args, &block|
        result = super(*args, &block)
        result.is_smart = @smart if result.respond_to?(:is_smart=) && !result.frozen?

        result
      end
    end
  end
end
