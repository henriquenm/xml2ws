require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"
require 'savon'

################################################################################

# Tem que pegar do model Company
private_key_file = File.join(File.dirname(__FILE__), '/cert/1234567890001_priKEY.pem')

# Tem que pegar de uma pasta public na aplicação
cert_file        = File.join(File.dirname(__FILE__), '/cert/1234567890001_certKEY.pem')

input_xml_file   = File.join(File.dirname(__FILE__), 'nfce_xml.xml')
signer = Signer.new(File.read(input_xml_file))
signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file), "")
signer.security_node = signer.document.root
# signer.digest!(signer.document.root, :id => "NFe51150501882109000162650010000000011064552496", :enveloped => true)
# signer.sign!(:issuer_serial => true)
# signed_xml = signer.to_xml

signature_node = Nokogiri::XML::Node.new("Signature", signer.document.root)
signature_node["xmlns"] = "http://www.w3.org/2000/09/xmldsig#"

signed_info_node = Nokogiri::XML::Node.new("SignedInfo", signer.document.root)

canonicalization_method_node = Nokogiri::XML::Node.new("CanonicalizationMethod", signer.document.root)
canonicalization_method_node["Algorithm"] = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"
signed_info_node.add_child(canonicalization_method_node)

signature_method_node = Nokogiri::XML::Node.new("SignatureMethod", signer.document.root)
signature_method_node["Algorithm"] = "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
signed_info_node.add_child(signature_method_node)

reference_node = Nokogiri::XML::Node.new("Reference", signer.document.root)
reference_node["URI"] = "#NFe51150501882109000162650010000000011064552496"

transforms_node = Nokogiri::XML::Node.new('Transforms', signer.document.root)
transform_node_1 = Nokogiri::XML::Node.new('Transform', signer.document.root)
transform_node_2 = Nokogiri::XML::Node.new('Transform', signer.document.root)
transform_node_1['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
transform_node_2['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
transforms_node.add_child(transform_node_1)
transforms_node.add_child(transform_node_2)
reference_node.add_child(transforms_node)

digest_method_node = Nokogiri::XML::Node.new("DigestMethod", signer.document.root)
digest_method_node["Algorithm"] = "http://www.w3.org/2000/09/xmldsig#sha1"
reference_node.add_child(digest_method_node)

digest_value_node = Nokogiri::XML::Node.new("DigestValue", signer.document.root)
reference_node.add_child(digest_value_node)

signed_info_node.add_child(reference_node)
signature_node.add_child(signed_info_node)

signature_value_node = Nokogiri::XML::Node.new("SignatureValue", signer.document.root)
signature_node.add_child(signature_value_node)

key_info_node = Nokogiri::XML::Node.new("KeyInfo", signer.document.root)
x509_data_node = Nokogiri::XML::Node.new("X509Data", signer.document.root)
x509_certificate_node = Nokogiri::XML::Node.new("X509Certificate", signer.document.root)
x509_data_node.add_child(x509_certificate_node)
key_info_node.add_child(x509_data_node)
signature_node.add_child(key_info_node)

puts signature_node

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