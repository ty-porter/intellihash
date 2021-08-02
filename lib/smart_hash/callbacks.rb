# frozen_string_literal: true

module SmartHash
  module Callbacks
    # https://ruby-doc.org/core-3.0.1/Hash.html
    #
    # Methods that return a copy of :self: need this callback to populate :smart: from :self:
    AFTER_CALLBACK_TARGETS = %i[
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

    # Callback registration happens as soon as SmartHash::Callbacks is prepended
    AFTER_CALLBACK_TARGETS.each do |instance_method|
      define_method(instance_method) do |*args, &block|
        # Call original method
        result = super(*args, &block)

        # Register :after: callbacks
        result.is_smart = smart if result.respond_to?(:is_smart=) && !result.frozen?

        result
      end
    end
  end
end
