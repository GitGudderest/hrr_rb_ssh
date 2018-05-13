# coding: utf-8
# vim: et ts=2 sw=2

require 'hrr_rb_ssh/logger'
require 'hrr_rb_ssh/data_type'

module HrrRbSsh
  class Authentication
    class Method
      class Publickey
        class Algorithm
          class SshRsa < Algorithm
            NAME = 'ssh-rsa'
            PREFERENCE = 20
            DIGEST = 'sha1'

            def initialize
              @logger = Logger.new(self.class.name)
            end

            def verify_public_key public_key_algorithm_name, public_key, public_key_blob
              public_key = case public_key
                           when String
                             OpenSSL::PKey::RSA.new(public_key)
                           when OpenSSL::PKey::RSA
                             public_key
                           else
                             return false
                           end
              public_key_message = {
                :'public key algorithm name' => public_key_algorithm_name,
                :'e'                         => public_key.e.to_i,
                :'n'                         => public_key.n.to_i,
              }
              public_key_blob == PublicKeyBlob.encode(public_key_message)
            end

            def verify_signature session_id, message
              signature_message   = Signature.decode message[:'signature']
              signature_algorithm = signature_message[:'public key algorithm name']
              signature_blob      = signature_message[:'signature blob']

              public_key = PublicKeyBlob.decode message[:'public key blob']
              algorithm = OpenSSL::PKey::RSA.new
              if algorithm.respond_to?(:set_key)
                algorithm.set_key public_key[:'n'], public_key[:'e'], nil
              else
                algorithm.e = public_key[:'e']
                algorithm.n = public_key[:'n']
              end

              data_message = {
                :'session identifier'        => session_id,
                :'message number'            => message[:'message number'],
                :'user name'                 => message[:'user name'],
                :'service name'              => message[:'service name'],
                :'method name'               => message[:'method name'],
                :'with signature'            => message[:'with signature'],
                :'public key algorithm name' => message[:'public key algorithm name'],
                :'public key blob'           => message[:'public key blob'],
              }
              data_blob = SignatureBlob.encode data_message

              (signature_algorithm == message[:'public key algorithm name']) && algorithm.verify(DIGEST, signature_blob, data_blob)
            end
          end
        end
      end
    end
  end
end

require 'hrr_rb_ssh/authentication/method/publickey/algorithm/ssh_rsa/public_key_blob'
require 'hrr_rb_ssh/authentication/method/publickey/algorithm/ssh_rsa/signature_blob'
require 'hrr_rb_ssh/authentication/method/publickey/algorithm/ssh_rsa/signature'
