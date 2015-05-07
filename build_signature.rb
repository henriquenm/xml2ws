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
digest = OpenSSL::Digest::SHA1.digest(signer.document.root)
digest = Base64.encode64(digest.to_s).gsub(/\n/, '')
digest_value_node.content = digest

reference_node.add_child(digest_value_node)

signed_info_node.add_child(reference_node)
signature_node.add_child(signed_info_node)

signature_value_node = Nokogiri::XML::Node.new("SignatureValue", signer.document.root)
signature_value_node.content = Base64.encode64(signer.private_key.to_der).gsub("\n", '')
signature_node.add_child(signature_value_node)

key_info_node = Nokogiri::XML::Node.new("KeyInfo", signer.document.root)
x509_data_node = Nokogiri::XML::Node.new("X509Data", signer.document.root)
x509_certificate_node = Nokogiri::XML::Node.new("X509Certificate", signer.document.root)
x509_certificate_node.content = Base64.encode64(signer.cert.to_der).gsub("\n", '')
x509_data_node.add_child(x509_certificate_node)
key_info_node.add_child(x509_data_node)
signature_node.add_child(key_info_node)

puts signature_node