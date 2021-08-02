# frozen_string_literal: true

require 'smart_hash/callbacks'
require 'smart_hash/configuration'
require 'smart_hash/mixins'
require 'smart_hash/version'

module SmartHash
  def self.enabled?
    SmartHash.configuration.enabled
  end
end
