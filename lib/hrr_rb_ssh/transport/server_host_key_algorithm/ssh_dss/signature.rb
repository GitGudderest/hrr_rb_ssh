# coding: utf-8
# vim: et ts=2 sw=2

require 'hrr_rb_ssh/data_type'
require 'hrr_rb_ssh/message/codable'

module HrrRbSsh
  class Transport
    class ServerHostKeyAlgorithm
      class SshDss
        module Signature
          class << self
            include Message::Codable
          end
          DEFINITION = [
            [DataType::String, 'ssh-dss'],
            [DataType::String, 'dss_signature_blob'],
          ]
        end
      end
    end
  end
end
