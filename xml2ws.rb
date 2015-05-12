require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"
require 'savon'
require 'base64'

require 'digest'

################################################################################
private_key_file = File.join(File.dirname(__FILE__), '/cert/1234567890001_priKEY.pem')
cert_file        = File.join(File.dirname(__FILE__), '/cert/1234567890001_certKEY.pem')

# signer = Signer.new(Nokogiri::XML(File.open('nosso_test.xml')))
# signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
# signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))
# signer.security_node = signer.document.root
# signer.digest!(signer.document.root, :id => "NFe51150401882109000162550010000000041784051633", :enveloped => true)
# signer.sign!(:issuer_serial => true)
# signed_xml = signer.to_xml

# puts signer.document

test = '<infNFe xmlns="http://www.portalfiscal.inf.br/nfe" Id="NFe51150401882109000162550010000000041784051633" versao="3.10"><ide><cUF>51</cUF><cNF>78405163</cNF><natOp>Venda de mercadoria</natOp><indPag>0</indPag><mod>55</mod><serie>1</serie><nNF>4</nNF><dhEmi>2015-04-30T12:10:00-03:00</dhEmi><dhSaiEnt>2015-04-30T12:10:00-03:00</dhSaiEnt><tpNF>1</tpNF><idDest>1</idDest><cMunFG>5103403</cMunFG><tpImp>1</tpImp><tpEmis>1</tpEmis><cDV>3</cDV><tpAmb>2</tpAmb><finNFe>1</finNFe><indFinal>1</indFinal><indPres>1</indPres><procEmi>0</procEmi><verProc>nfemais.com.br v3</verProc></ide><emit><CNPJ>01882109000162</CNPJ><xNome>COXIPO COM PROD PAPELARIA IMP EXPORTACAO LTDA EPP</xNome><xFant>COXIPO</xFant><enderEmit><xLgr>AVENIDA TENENTE-CORONEL DUARTE</xLgr><nro>191</nro><xBairro>CENTRO NORTE</xBairro><cMun>5103403</cMun><xMun>Cuiaba</xMun><UF>MT</UF><CEP>78005500</CEP><cPais>1058</cPais><xPais>Brasil</xPais><fone>6533171500</fone></enderEmit><IE>130333573</IE><CRT>3</CRT></emit><dest><CNPJ>99999999000191</CNPJ><xNome>NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xNome><enderDest><xLgr>Rua Test</xLgr><nro>80</nro><xBairro>Vila Test</xBairro><cMun>5103403</cMun><xMun>Cuiaba</xMun><UF>MT</UF><CEP>03978300</CEP><cPais>1058</cPais><xPais>Brasil</xPais><fone>91095751</fone></enderDest><indIEDest>9</indIEDest><email>marculo.henrique@gmail.com</email></dest><det nItem="1"><prod><cProd>008</cProd><cEAN></cEAN><xProd>Test</xProd><NCM>85176130</NCM><EXTIPI>00</EXTIPI><CFOP>5102</CFOP><uCom>UN</uCom><qCom>1.0000</qCom><vUnCom>600.0000000000</vUnCom><vProd>600.00</vProd><cEANTrib></cEANTrib><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vUnTrib>600.0000000000</vUnTrib><indTot>1</indTot><xPed>2</xPed><nItemPed>1</nItemPed></prod><imposto><vTotTrib>185.82</vTotTrib><ICMS><ICMS00><orig>0</orig><CST>00</CST><modBC>0</modBC><vBC>600.00</vBC><pICMS>0.00</pICMS><vICMS>0.00</vICMS></ICMS00></ICMS><PIS><PISAliq><CST>01</CST><vBC>600.00</vBC><pPIS>0.00</pPIS><vPIS>0.00</vPIS></PISAliq></PIS><COFINS><COFINSAliq><CST>01</CST><vBC>600.00</vBC><pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS></imposto></det><total><ICMSTot><vBC>600.00</vBC><vICMS>0.00</vICMS><vICMSDeson>0.00</vICMSDeson><vBCST>0.00</vBCST><vST>0.00</vST><vProd>600.00</vProd><vFrete>0.00</vFrete><vSeg>0.00</vSeg><vDesc>0.00</vDesc><vII>0.00</vII><vIPI>0.00</vIPI><vPIS>0.00</vPIS><vCOFINS>0.00</vCOFINS><vOutro>0.00</vOutro><vNF>600.00</vNF><vTotTrib>185.82</vTotTrib></ICMSTot></total><transp><modFrete>9</modFrete></transp><infAdic><infCpl>[Trib aprox: Fed R$ 83,82 (13,97%), Est R$ 102,00 (17,00%). Fonte: IBPT/MT - 9oi3aC]</infCpl></infAdic></infNFe>'
test = '<infNFe xmlns="http://www.portalfiscal.inf.br/nfe" Id="NFe51150401882109000162550010000000041784051633" versao="3.10"><ide><cUF>51</cUF><cNF>78405163</cNF><natOp>Venda de mercadoria</natOp><indPag>0</indPag><mod>55</mod><serie>1</serie><nNF>4</nNF><dhEmi>2015-04-30T12:10:00-03:00</dhEmi><dhSaiEnt>2015-04-30T12:10:00-03:00</dhSaiEnt><tpNF>1</tpNF><idDest>1</idDest><cMunFG>5103403</cMunFG><tpImp>1</tpImp><tpEmis>1</tpEmis><cDV>3</cDV><tpAmb>2</tpAmb><finNFe>1</finNFe><indFinal>1</indFinal><indPres>1</indPres><procEmi>0</procEmi><verProc>nfemais.com.br v3</verProc></ide><emit><CNPJ>01882109000162</CNPJ><xNome>COXIPO COM PROD PAPELARIA IMP EXPORTACAO LTDA EPP</xNome><xFant>COXIPO</xFant><enderEmit><xLgr>AVENIDA TENENTE-CORONEL DUARTE</xLgr><nro>191</nro><xBairro>CENTRO NORTE</xBairro><cMun>5103403</cMun><xMun>Cuiaba</xMun><UF>MT</UF><CEP>78005500</CEP><cPais>1058</cPais><xPais>Brasil</xPais><fone>6533171500</fone></enderEmit><IE>130333573</IE><CRT>3</CRT></emit><dest><CNPJ>99999999000191</CNPJ><xNome>NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xNome><enderDest><xLgr>Rua Test</xLgr><nro>80</nro><xBairro>Vila Test</xBairro><cMun>5103403</cMun><xMun>Cuiaba</xMun><UF>MT</UF><CEP>03978300</CEP><cPais>1058</cPais><xPais>Brasil</xPais><fone>91095751</fone></enderDest><indIEDest>9</indIEDest><email>marculo.henrique@gmail.com</email></dest><det nItem="1"><prod><cProd>008</cProd><cEAN/><xProd>Test</xProd><NCM>85176130</NCM><EXTIPI>00</EXTIPI><CFOP>5102</CFOP><uCom>UN</uCom><qCom>1.0000</qCom><vUnCom>600.0000000000</vUnCom><vProd>600.00</vProd><cEANTrib/><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vUnTrib>600.0000000000</vUnTrib><indTot>1</indTot><xPed>2</xPed><nItemPed>1</nItemPed></prod><imposto><vTotTrib>185.82</vTotTrib><ICMS><ICMS00><orig>0</orig><CST>00</CST><modBC>0</modBC><vBC>600.00</vBC><pICMS>0.00</pICMS><vICMS>0.00</vICMS></ICMS00></ICMS><PIS><PISAliq><CST>01</CST><vBC>600.00</vBC><pPIS>0.00</pPIS><vPIS>0.00</vPIS></PISAliq></PIS><COFINS><COFINSAliq><CST>01</CST><vBC>600.00</vBC><pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS></imposto></det><total><ICMSTot><vBC>600.00</vBC><vICMS>0.00</vICMS><vICMSDeson>0.00</vICMSDeson><vBCST>0.00</vBCST><vST>0.00</vST><vProd>600.00</vProd><vFrete>0.00</vFrete><vSeg>0.00</vSeg><vDesc>0.00</vDesc><vII>0.00</vII><vIPI>0.00</vIPI><vPIS>0.00</vPIS><vCOFINS>0.00</vCOFINS><vOutro>0.00</vOutro><vNF>600.00</vNF><vTotTrib>185.82</vTotTrib></ICMSTot></total><transp><modFrete>9</modFrete></transp><infAdic><infCpl>description</infCpl></infAdic></infNFe>'
test = File.read("string")
doc = Nokogiri::XML(test)

digest = OpenSSL::Digest::SHA1.digest(test)
digest = Base64.encode64(digest.to_s).gsub(/\n/, '')
puts digest

# signature_node = Nokogiri::XML::Node.new("Signature", doc)
# signature_node["xmlns"] = "http://www.w3.org/2000/09/xmldsig#"

# signed_info_node = Nokogiri::XML::Node.new("SignedInfo", doc)

# canonicalization_method_node = Nokogiri::XML::Node.new("CanonicalizationMethod", doc)
# canonicalization_method_node["Algorithm"] = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"
# signed_info_node.add_child(canonicalization_method_node)

# signature_method_node = Nokogiri::XML::Node.new("SignatureMethod", doc)
# signature_method_node["Algorithm"] = "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
# signed_info_node.add_child(signature_method_node)

# reference_node = Nokogiri::XML::Node.new("Reference", doc)
# reference_node["URI"] = "#NFe51150501882109000162650010000000011064552496"

# transforms_node = Nokogiri::XML::Node.new('Transforms', doc)
# transform_node_1 = Nokogiri::XML::Node.new('Transform', doc)
# transform_node_2 = Nokogiri::XML::Node.new('Transform', doc)
# transform_node_1['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
# transform_node_2['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
# transforms_node.add_child(transform_node_1)
# transforms_node.add_child(transform_node_2)
# reference_node.add_child(transforms_node)

# digest_method_node = Nokogiri::XML::Node.new("DigestMethod", doc)
# digest_method_node["Algorithm"] = "http://www.w3.org/2000/09/xmldsig#sha1"
# reference_node.add_child(digest_method_node)

# digest_value_node = Nokogiri::XML::Node.new("DigestValue", doc)
# digest = OpenSSL::Digest::SHA1.digest(test)
# digest = Base64.encode64(digest.to_s).gsub(/\n/, '')
# digest_value_node.content = digest
# reference_node.add_child(digest_value_node)
# signed_info_node.add_child(reference_node)

# pkey = OpenSSL::PKey::read(File.read('cert/1234567890001_priKEY.pem'))
# signature_value_node = Nokogiri::XML::Node.new("SignatureValue", doc)
# signature = pkey.sign(OpenSSL::Digest::SHA1.new, digest_value_node.content)
# signature_value_node.content = Base64.encode64(signature).gsub("\n", '')

# signature_node.add_child(signed_info_node)
# signature_node.add_child(signature_value_node)

# key_info_node = Nokogiri::XML::Node.new("KeyInfo", doc)
# x509_data_node = Nokogiri::XML::Node.new("X509Data", doc)
# x509_certificate_node = Nokogiri::XML::Node.new("X509Certificate", doc)
# x509_certificate_node.content = Base64.encode64(OpenSSL::X509::Certificate.new(File.read(cert_file)).to_der).gsub("\n", '')
# x509_data_node.add_child(x509_certificate_node)
# key_info_node.add_child(x509_data_node)
# signature_node.add_child(key_info_node)

# puts signature_node

# builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
#   xml["soap"].Envelope("xmlns:soap" => "http://www.w3.org/2003/05/soap-envelope", "xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema", "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance") {
#     xml["soap"].Header {
#       xml.nfeCabecMsg("xmlns" => "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao") {
#         xml.cUF(51)
#         xml.versaoDados("3.10")
#       }
#     }
#     xml['soap'].Body {
#       xml.nfeDadosMsg('xmlns' => "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao") {
#         xml.NFe("versao" =>"3.00", "xmlns" => "http://www.portalfiscal.inf.br/nfe") {
          
#         }
#       }
#     }
#   }
# end

# puts builder.to_xml

# File.open("xml_to_sign_signed.xml", 'w') {|f| f.write(signed_xml) }

# # ################################################################################
WSDL_URL = 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl'

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

response = client.call(:nfe_autorizacao_lote, xml: File.read("FUNFOU.xml") )
p response.to_hash