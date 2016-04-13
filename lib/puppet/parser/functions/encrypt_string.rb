require 'digest'
require 'openssl'
require 'base64'

module Puppet::Parser::Functions

    newfunction(:encrypt_string, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|

Encrypts from string to jenkins password

    encrypt_string('/var/lib/jenkins/secrets/master.key','/var/lib/jenkins/secrets/hudson.util.Secret', "key")

would result in

    4mScpuAZY+3uXUXvV26faWpQ9MPhUuMLsJTyO0MEfRI=

   ENDHEREDOC

    res = ""
    if args.length != 3
      raise Puppet::ParseError, ("parse_url(): wrong number of arguments (#{args.length}: must be 3")
    end

    begin
      magic = "::::MAGIC::::"
      master_key = File.read(args[0])
      hudson_secret_key = File.read(args[1])
      input_plain = args[2]

      # Decrypt secret key with master key
      hashed_master_key =  Digest::SHA256.digest(master_key).byteslice(0..15)
      cypher = OpenSSL::Cipher.new('aes-128-ecb')
      cypher.decrypt
      cypher.key = hashed_master_key
      decrypted_secret_key = cypher.update(hudson_secret_key) + cypher.final

      # Encrypt plain password
      cypher.encrypt
      cypher.key = decrypted_secret_key.byteslice(0..15)
      res = Base64.encode64 cypher.update(input_plain+magic) + cypher.final
    end
    res
  end
end
