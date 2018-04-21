# coding: utf-8
# vim: et ts=2 sw=2

require 'io/console'
require 'hrr_rb_ssh/logger'
require 'hrr_rb_ssh/connection/request_handler'

module HrrRbSsh
  class Connection
    class RequestHandler
      class ReferenceWindowChangeRequestHandler < RequestHandler
        def initialize
          @logger = HrrRbSsh::Logger.new self.class.name
          @proc = Proc.new { |context|
            context.vars[:ptm].winsize = [context.terminal_height_rows, context.terminal_width_columns]
          }
        end
      end
    end
  end
end