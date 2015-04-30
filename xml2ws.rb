require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"
require 'savon'

################################################################################

# Tem que pegar do model Company
private_key_file = File.join(File.dirname(__FILE__), '/cert/1234567890001_priKEY.pem')

# # Tem que pegar de uma pasta public na aplicação
cert_file        = File.join(File.dirname(__FILE__), '/cert/1234567890001_certKEY.pem')

input_xml_file   = File.join(File.dirname(__FILE__), 'nfe_mais_certo.xml')
signer = Signer.new(File.read(input_xml_file))
signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file), "")
signer.security_node = signer.document.root
signer.security_token_id = ""
signer.digest!(signer.document.root, :id => "", :enveloped => true)
signer.sign!(:issuer_serial => true)
signed_xml = signer.to_xml
File.open("assinado.xml", 'w') {|f| f.write(signed_xml) }


################################################################################
WSDL_URL = 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl'

# Tem que pegar de uma pasta public na aplicação
ssl_ca_cert_file = File.expand_path("../cert/1234567890001_certKEY.pem", __FILE__)

# Tem que pegar do model Company
ssl_cert_file = File.expand_path("../cert/1234567890001_pubKEY.pem", __FILE__)
ssl_cert_key_file = File.expand_path("../cert/1234567890001_priKEY.pem", __FILE__)

client = Savon.client(
  wsdl: WSDL_URL,
  ssl_cert: OpenSSL::X509::Certificate.new(File.read(ssl_cert_file)),
  ssl_ca_cert_file: ssl_ca_cert_file,
  ssl_cert_key: OpenSSL::PKey.read(File.read(ssl_cert_key_file), '12345678'),
  ssl_cert_key_password: '12345678',
  soap_version: 2,
)
p client.operations

response = client.call(:nfe_recepcao_lote2, xml: signed_xml )
p response.to_hash