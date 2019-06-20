# coding: utf-8
# vim: et ts=2 sw=2

require 'hrr_rb_ssh/logger'

module HrrRbSsh
  class Authentication
    class Method
      class Password
        class Context
          attr_reader \
            :username,
            :password,
            :variables,
            :vars

          def initialize username, password, variables
            @username = username
            @password = password
            @variables = variables
            @vars = variables

            @logger = Logger.new self.class.name
          end

          def verify username, password
            @logger.info { "verify username and password" }
            @logger.debug { "username is #{username}, @username is #{@username}, and password is #{password}, @password is #{@password}" }
            username == @username and password == @password
          end
        end
      end
    end
  end
end
