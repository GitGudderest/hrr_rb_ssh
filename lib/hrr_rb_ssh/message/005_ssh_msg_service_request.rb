# coding: utf-8
# vim: et ts=2 sw=2

require 'hrr_rb_ssh/logger'
require 'hrr_rb_ssh/message/codable'

module HrrRbSsh
  module Message
    module SSH_MSG_SERVICE_REQUEST
      class << self
        include Codable
      end

      ID    = self.name.split('::').last
      VALUE = 5

      DEFINITION = [
        # [Data Type, Field Name]
        ['byte',      'message number'],
        ['string',    'service name'],
      ]
    end
  end
end
