# frozen_string_literal: true

require 'intellihash/callbacks'
require 'intellihash/configuration'
require 'intellihash/mixins'
require 'intellihash/version'

module Intellihash
  def self.enabled?
    Intellihash.configuration.enabled
  end
end
