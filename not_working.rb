require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"

require 'net/http'
require "uri"
require 'savon'

require 'rest-client'

require 'httpclient'

# client = HTTPClient.new
# url = "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl"
# user_cert_file = 'cert/cert.pem'
# user_key_file = 'cert/private_key.pem'
# client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_PEER
# client.ssl_config.set_client_cert_file(user_cert_file, user_key_file)
# client.get_content(url)
# client.get(url)

######################################################################################################################
# input_xml_file   = File.join(File.dirname(__FILE__), 'consStatServ.xml')
# cert_file        = File.join(File.dirname(__FILE__), 'certificado.pem')
# private_key_file = File.join(File.dirname(__FILE__), 'privateKey.key')
# signer = Signer.new(File.read(input_xml_file))
# signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
# signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file), "")
# signer.security_node = signer.document.root
# signer.security_token_id = ""
# signer.digest!(signer.document.root, :id => "", :enveloped => true)
# signer.sign!(:issuer_serial => true)
# signed_xml = signer.to_xml

# File.open("xmlassinado.xml", 'w') {|f| f.write(signed_xml) }
######################################################################################################################
# uri = URI.parse('https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl')
# pem = File.read("cert/cert.pem")
# key = File.read("cert/private_key.pem")
# # certificado = OpenSSL::PKCS12.new(File.read("cert/certificado_000001005867992.pfx"), "2308612609") 
# http = Net::HTTP.new(uri.host, uri.port)
# http.use_ssl = true
# http.cert = OpenSSL::X509::Certificate.new(pem)
# http.key = OpenSSL::PKey::RSA.new(key, "123456789")
# # http.key = OpenSSL::PKey::RSA.new(pem)
# http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# http.start
######################################################################################################################
# rest_client = RestClient::Resource.new(
#   'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl',
#   :ssl_client_cert  =>  OpenSSL::X509::Certificate.new(File.read("cert/cert.pem")),
#   :ssl_client_key   =>  OpenSSL::PKey::RSA.new(File.read("cert/cert.pem")),
#   :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER
# ).get

# p rest_client
######################################################################################################################

######################################################################################################################
# WSDL_URL = 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl'
# # WSDL_URL = 'http://www.webservicex.net/uszip.asmx?WSDL'

# client = Savon.client(
#   wsdl: WSDL_URL,
#   ssl_version: :SSLv3,
#   ssl_verify_mode: :peer,
#   ssl_cert_file: 'cert/11945567000157_certKEY.pem',
#   ssl_cert_key_file: 'cert/11945567000157_priKEY.pem',
#   ssl_cert_key_password: '',
#   env_namespace: :soap, 
#   namespace_identifier: nil
# )

# response = client.call(:nfeStatusServicoNF2, message: "test")
######################################################################################################################

######################################################################################################################
# uri = URI.parse('https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl')
# file = "consStatServ.xml"
# post_body = []
# post_body << "Content-Disposition: form-data; filename='#{File.basename(file)}'\r\n"
# post_body << "Content-Type: text/xml"
# post_body << "\r\n"
# post_body << File.read(file)
# http = Net::HTTP.new(uri.host, 443)
# http.use_ssl = true
# http.ca_file = 'cert/cert.pem'
# http.cert = OpenSSL::X509::Certificate.new(File.read("cert/cert.pem"))
# http.key = OpenSSL::PKey::RSA.new(File.read("cert/cert.pem"))
# request = Net::HTTP::Post.new(uri.request_uri)
# request.body = post_body.join
# request["Content-Type"] = "multipart/form-data"
# http.request(request)
######################################################################################################################