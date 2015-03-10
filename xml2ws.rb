require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"

require 'net/http'
require "uri"
require 'savon'

require 'rest-client'

######################################################################################################################
input_xml_file   = File.join(File.dirname(__FILE__), 'consStatServ.xml')
cert_file        = File.join(File.dirname(__FILE__), 'certificado.pem')
private_key_file = File.join(File.dirname(__FILE__), 'privateKey.key')
signer = Signer.new(File.read(input_xml_file))
signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file), "")
signer.security_node = signer.document.root
signer.security_token_id = ""
signer.digest!(signer.document.root, :id => "", :enveloped => true)
signer.sign!(:issuer_serial => true)
signed_xml = signer.to_xml

# File.open("xmlassinado.xml", 'w') {|f| f.write(signed_xml) }
######################################################################################################################

######################################################################################################################
rest_client = RestClient::Resource.new(
  'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl',
  :ssl_client_cert  =>  OpenSSL::X509::Certificate.new(File.read("certificate_file.crt")),
  :ssl_client_key   =>  OpenSSL::PKey::RSA.new(File.read("private_key.pem")),
  :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER
).get
######################################################################################################################

######################################################################################################################
# WSDL_URL = 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl'
# # WSDL_URL = 'http://www.webservicex.net/uszip.asmx?WSDL'

# client = Savon.client(
#   wsdl: WSDL_URL,
#   ssl_version: :SSLv3,
#   ssl_verify_mode: :none,
#   ssl_cert_file: 'certificate_file.crt',
#   ssl_cert_key_file: 'private_key.pem',
#   ssl_cert_key_password: ''
# )

# p client.operations

# response = client.call(:nfeStatusServicoNF2, xml: signed_xml )

# p response.to_hash
######################################################################################################################

######################################################################################################################
# Token used to terminate the file in the post body. Make sure it is not
# present in the file you're uploading.
# uri = URI.parse('https://homologacao'.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl')
# file = "consStatServ.xml"
# post_body = []
# post_body << "Content-Disposition: form-data; name='datafile'; filename='#{File.basename(file)}'rn"
# post_body << "Content-Type: text/xml"
# post_body << "rn"
# post_body << signed_xml
# http = Net::HTTP.new(uri.host, 443)
# http.use_ssl = true
# http.ca_file = 'certificado.pem'
# http.key = OpenSSL::PKey::RSA.new(File.read('privateKey.key'), "")
# request = Net::HTTP::Post.new(uri.request_uri)
# request.body = post_body.join
# request["Content-Type"] = "multipart/form-data"
# http.request(request)'
######################################################################################################################