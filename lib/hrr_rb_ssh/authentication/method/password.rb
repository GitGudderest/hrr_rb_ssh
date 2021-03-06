# coding: utf-8
# vim: et ts=2 sw=2

require 'hrr_rb_ssh/loggable'

module HrrRbSsh
  class Authentication
    class Method
      class Password < Method
        include Loggable

        NAME = 'password'
        PREFERENCE = 10

        def initialize transport, options, variables, authentication_methods, logger: nil
          self.logger = logger
          @transport = transport
          @authenticator = options.fetch( 'authentication_password_authenticator', Authenticator.new{ false } )
          @options = options
          @variables = variables
          @authentication_methods = authentication_methods
        end

        def authenticate userauth_request_message
          log_info { "authenticate" }
          username = userauth_request_message[:'user name']
          password = userauth_request_message[:'plaintext password']
          context = Context.new(username, password, @variables, @authentication_methods, logger: logger)
          @authenticator.authenticate context
        end

        def request_authentication username, service_name
          password = @options['client_authentication_password']
          message = {
            :'message number'     => Message::SSH_MSG_USERAUTH_REQUEST::VALUE,
            :"user name"          => username,
            :"service name"       => service_name,
            :"method name"        => NAME,
            :"FALSE"              => false,
            :"plaintext password" => password,
          }
          payload = Message::SSH_MSG_USERAUTH_REQUEST.new(logger: logger).encode message
          @transport.send payload

          payload = @transport.receive
        end
      end
    end
  end
end

require 'hrr_rb_ssh/authentication/method/password/context'
