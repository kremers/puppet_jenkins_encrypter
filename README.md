# puppet_jenkins_encrypter #

This puppet module provides an encoding and decoding mechanism for jenkins passwords.
Some things can be done easily with the jenkins module and ::credentials, but for things like the ad-auth no credential plugins are supported.
So if you want to bootstrap a jenkins without the need of manually changing a lot of things, this module provides a generic way to deal with that case.

# Functions #

encrypt_string
---------
Encrypts from string to jenkins password

    encrypt_string('/var/lib/jenkins/secrets/master.key','/var/lib/jenkins/secrets/hudson.util.Secret', "key")

would result in

    4mScpuAZY+3uXUXvV26faWpQ9MPhUuMLsJTyO0MEfRI=


