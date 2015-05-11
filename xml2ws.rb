require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"
require 'savon'
require 'base64'

require 'digest'

################################################################################
# private_key_file = File.join(File.dirname(__FILE__), '/cert/1234567890001_priKEY.pem')
# cert_file        = File.join(File.dirname(__FILE__), '/cert/1234567890001_certKEY.pem')

signer = Signer.new(Nokogiri::XML(File.open('nosso_test.xml')))
# signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
# signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))
# signer.security_node = signer.document.root
# signer.digest!(signer.document.root, :id => "NFe51150401882109000162550010000000041784051633", :enveloped => true)
# signer.sign!(:issuer_serial => true)
# signed_xml = signer.to_xml

# puts signer.document

# to_sign_xml = File.read 'nosso_test.xml'
test = signer.document.root.xpath("/*[name()='nfeProc']/*[name()='NFe']").first
# digest = OpenSSL::Digest::SHA1.digest(test)
# digest = Base64.encode64(digest.to_s).gsub(/\n/, '')
# digest = Digest::SHA1.hexdigest(test)
# digest = Digest::SHA256.base64digest(test)
digest = Digest::MD5.new
digest.update(test)
digest.hexdigest

puts digest

# File.open("xml_to_sign_signed.xml", 'w') {|f| f.write(signed_xml) }

# # ################################################################################
# WSDL_URL = 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl'

# # Tem que pegar de uma pasta public na aplicação
# ssl_ca_cert_file = File.expand_path("../cert/1234567890001_certKEY.pem", __FILE__)

# # Tem que pegar do model Company
# ssl_cert_file = File.expand_path("../cert/1234567890001_pubKEY.pem", __FILE__)
# ssl_cert_key_file = File.expand_path("../cert/1234567890001_priKEY.pem", __FILE__)

# client = Savon.client(
#   wsdl: WSDL_URL,
#   ssl_cert: OpenSSL::X509::Certificate.new(File.read(ssl_cert_file)),
#   ssl_ca_cert_file: ssl_ca_cert_file,
#   ssl_cert_key: OpenSSL::PKey.read(File.read(ssl_cert_key_file), '12345678'),
#   ssl_cert_key_password: '12345678',
#   soap_version: 2,
# )
# p client.operations

# response = client.call(:nfe_autorizacao_lote, xml: signed_xml )
# p response.to_hash