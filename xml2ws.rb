require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"

require 'net/http'
require "uri"
require 'savon'

# input_xml_file   = File.join(File.dirname(__FILE__), 'consStatServ.xml')
# cert_file        = File.join(File.dirname(__FILE__), 'certificado_000001005867992.pem')
# private_key_file = File.join(File.dirname(__FILE__), 'privateKey.key')

# signer = Signer.new(File.read(input_xml_file))
# signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
# signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file), "")
# signer.security_node = signer.document.root
# signer.security_token_id = ""
# signer.digest!(signer.document.root, :id => "", :enveloped => true)
# signer.sign!(:issuer_serial => true)

# signed_xml = signer.to_xml

############## SAVON
# client = Savon.client do
#   endpoint signed_xml
#   namespace "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl"
# end
# p client.operations
# client = Savon.client(wsdl: "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl")
# p client

# Token used to terminate the file in the post body. Make sure it is not
# present in the file you're uploading.
# BOUNDARY = "AaB03x"

# uri = URI.parse('https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl')
# file = "consStatServ.xml"

# post_body = []
# post_body << "--#{BOUNDARY}rn"
# post_body << "Content-Disposition: form-data; name='datafile'; filename='#{File.basename(file)}'rn"
# post_body << "Content-Type: text/plainrn"
# post_body << "rn"
# post_body << signed_xml
# post_body << "rn--#{BOUNDARY}--rn"

# http = Net::HTTP.new(uri.host, uri.port)
# http.use_ssl = true
# request = Net::HTTP::Post.new(uri.request_uri)
# request.body = post_body.join
# request["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"

# http.request(request)

require 'pp'
require 'pry'

WSDL_URL = 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl'
# WSDL_URL = 'http://localhost:3000/'


client = Savon.client(
  :wsdl => WSDL_URL,
  :log_level => :debug,
  :log => true,
  :ssl_verify_mode => :none,
  :ssl_cert_file => 'certificado_000001005867992.pem',
  :ssl_cert_key_file => 'privateKey.key',
  :ssl_cert_key_password => '',
  :open_timeout => 600,
  :read_timeout => 600
)

p client.operations

# zip = ARGV[0] || "98052"

# response = client.call(:get_info_by_zip,
#                        message: { "USZip" => zip }
#                       )

# pp response.to_hash