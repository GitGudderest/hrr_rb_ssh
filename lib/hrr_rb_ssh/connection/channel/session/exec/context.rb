# coding: utf-8
# vim: et ts=2 sw=2

require 'hrr_rb_ssh/logger'

module HrrRbSsh
  class Connection
    class Channel
      module Session
        class Exec
          class Context
            attr_reader \
              :logger,
              :io,
              :variables,
              :vars,
              :command

            def initialize proc_chain, io, variables, message
              @logger = HrrRbSsh::Logger.new self.class.name

              @proc_chain = proc_chain
              @io         = io
              @variables  = variables
              @vars       = variables

              @command = message['command']
            end

            def chain_proc &block
              @proc = block || @proc
            end
          end
        end
      end
    end
  end
end
