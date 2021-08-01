# frozen_string_literal: true

require 'smart_hash/version'
require 'smart_hash/extensions'
require 'smart_hash/callbacks'

module SmartHash
  Hash.include SmartHash::Extensions
  Hash.prepend SmartHash::Callbacks
end
