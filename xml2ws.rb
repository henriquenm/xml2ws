require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"

require 'net/http'
require "uri"

# signer = Signer.new(File.read("test.xml"))
# signer.cert = OpenSSL::X509::Certificate.new(File.read("certificado_000001005867992.pem"))
# signer.private_key = OpenSSL::PKey::RSA.new(File.read("privateKey.key"), "")

# signer.document.xpath("//u:Timestamp", { "u" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" }).each do |node|
#   signer.digest!(node)
# end

# signer.document.xpath("//a:To", { "a" => "http://www.w3.org/2005/08/addressing" }).each do |node|
#   signer.digest!(node)
# end

# signer.sign!(:security_token => true)

# signer.to_xml

input_xml_file   = File.join(File.dirname(__FILE__), 'test.xml')
cert_file        = File.join(File.dirname(__FILE__), 'certificado_000001005867992.pem')
private_key_file = File.join(File.dirname(__FILE__), 'privateKey.key')

signer = Signer.new(File.read(input_xml_file))
signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file), "")
signer.security_node = signer.document.root
signer.security_token_id = ""
signer.digest!(signer.document.root, :id => "", :enveloped => true)
signer.sign!(:issuer_serial => true)

signed_xml = signer.to_xml

# Token used to terminate the file in the post body. Make sure it is not
# present in the file you're uploading.
BOUNDARY = "AaB03x"

uri = URI.parse('https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl')
file = "test.xml"

post_body = []
post_body << "--#{BOUNDARY}rn"
post_body << "Content-Disposition: form-data; name='datafile'; filename='#{File.basename(file)}'rn"
post_body << "Content-Type: text/plainrn"
post_body << "rn"
post_body << signed_xml
post_body << "rn--#{BOUNDARY}--rn"

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri.request_uri)
request.body = post_body.join
request["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"

http.request(request)