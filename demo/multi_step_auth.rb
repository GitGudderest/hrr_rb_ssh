# coding: utf-8
# vim: et ts=2 sw=2

require 'logger'
require 'socket'


def start_service io, logger=nil
  require 'etc'

  begin
    require 'hrr_rb_ssh'
  rescue LoadError
    $:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
    require 'hrr_rb_ssh'
  end

  HrrRbSsh::Logger.initialize logger if logger

  auth_publickey = HrrRbSsh::Authentication::Authenticator.new { |context|
    users = ['user1', 'user2']
    is_verified = users.any?{ |username|
      passwd = Etc.getpwnam(username)
      homedir = passwd.dir
      authorized_keys = HrrRbSsh::Compat::OpenSSH::AuthorizedKeys.new(File.read(File.join(homedir, '.ssh', 'authorized_keys')))
      authorized_keys.any?{ |public_key| context.verify username, public_key.algorithm_name, public_key.to_pem }
    }
    if is_verified
      HrrRbSsh::Authentication::PARTIAL_SUCCESS
    else
      HrrRbSsh::Authentication::FAILURE
    end
  }
  auth_password = HrrRbSsh::Authentication::Authenticator.new { |context|
    user_and_pass = [
      ['user1',  'password1'],
      ['user2',  'password2'],
    ]
    is_verified = user_and_pass.any? { |user, pass| context.verify user, pass }
    if is_verified
      HrrRbSsh::Authentication::PARTIAL_SUCCESS
    else
      HrrRbSsh::Authentication::FAILURE
    end
  }

  auth_preferred_authentication_methods = ["publickey", "password"]


  options = {}

  options['authentication_publickey_authenticator'] = auth_publickey
  options['authentication_password_authenticator']  = auth_password

  options['authentication_preferred_authentication_methods'] = auth_preferred_authentication_methods

  options['connection_channel_request_pty_req']       = HrrRbSsh::Connection::RequestHandler::ReferencePtyReqRequestHandler.new
  options['connection_channel_request_env']           = HrrRbSsh::Connection::RequestHandler::ReferenceEnvRequestHandler.new
  options['connection_channel_request_shell']         = HrrRbSsh::Connection::RequestHandler::ReferenceShellRequestHandler.new
  options['connection_channel_request_exec']          = HrrRbSsh::Connection::RequestHandler::ReferenceExecRequestHandler.new
  options['connection_channel_request_window_change'] = HrrRbSsh::Connection::RequestHandler::ReferenceWindowChangeRequestHandler.new

  server = HrrRbSsh::Server.new options
  server.start io
end


logger = Logger.new STDOUT
logger.level = Logger::INFO

server = TCPServer.new 10022
loop do
  Thread.new(server.accept) do |io|
    begin
      pid = fork do
        begin
          start_service io, logger
        rescue => e
          logger.error { [e.backtrace[0], ": ", e.message, " (", e.class.to_s, ")\n\t", e.backtrace[1..-1].join("\n\t")].join }
          exit false
        end
      end
      logger.info { "process #{pid} started" }
      io.close rescue nil
      pid, status = Process.waitpid2 pid
    rescue => e
      logger.error { [e.backtrace[0], ": ", e.message, " (", e.class.to_s, ")\n\t", e.backtrace[1..-1].join("\n\t")].join }
    ensure
      status ||= nil
      logger.info { "process #{pid} finished with status #{status.inspect}" }
    end
  end
end
