require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"
require 'savon'

################################################################################
private_key_file = File.join(File.dirname(__FILE__), '/cert/1234567890001_priKEY.pem')
cert_file        = File.join(File.dirname(__FILE__), '/cert/1234567890001_certKEY.pem')
test = '<infNFe Id="NFe51150401882109000162550010000000041784051633" versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe"><ide><cUF>51</cUF><cNF>78405163</cNF><natOp>Venda de mercadoria</natOp><indPag>0</indPag><mod>55</mod><serie>1</serie><nNF>4</nNF><dhEmi>2015-04-30T12:10:00-03:00</dhEmi><dhSaiEnt>2015-04-30T12:10:00-03:00</dhSaiEnt><tpNF>1</tpNF><idDest>1</idDest><cMunFG>5103403</cMunFG><tpImp>1</tpImp><tpEmis>1</tpEmis><cDV>3</cDV><tpAmb>2</tpAmb><finNFe>1</finNFe><indFinal>1</indFinal><indPres>1</indPres><procEmi>0</procEmi><verProc>nfemais.com.br v3</verProc></ide><emit><CNPJ>01882109000162</CNPJ><xNome>COXIPO COM PROD PAPELARIA IMP EXPORTACAO LTDA EPP</xNome><xFant>COXIPO</xFant><enderEmit><xLgr>AVENIDA TENENTE-CORONEL DUARTE</xLgr><nro>191</nro><xBairro>CENTRO NORTE</xBairro><cMun>5103403</cMun><xMun>Cuiaba</xMun><UF>MT</UF><CEP>78005500</CEP><cPais>1058</cPais><xPais>Brasil</xPais><fone>6533171500</fone></enderEmit><IE>130333573</IE><CRT>3</CRT></emit><dest><CNPJ>99999999000191</CNPJ><xNome>NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xNome><enderDest><xLgr>Rua Test</xLgr><nro>80</nro><xBairro>Vila Test</xBairro><cMun>5103403</cMun><xMun>Cuiaba</xMun><UF>MT</UF><CEP>03978300</CEP><cPais>1058</cPais><xPais>Brasil</xPais><fone>91095751</fone></enderDest><indIEDest>9</indIEDest><email>marculo.henrique@gmail.com</email></dest><det nItem="1"><prod><cProd>008</cProd><cEAN/><xProd>Test</xProd><NCM>85176130</NCM><EXTIPI>00</EXTIPI><CFOP>5102</CFOP><uCom>UN</uCom><qCom>1.0000</qCom><vUnCom>600.0000000000</vUnCom><vProd>600.00</vProd><cEANTrib/><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vUnTrib>600.0000000000</vUnTrib><indTot>1</indTot><xPed>2</xPed><nItemPed>1</nItemPed></prod><imposto><vTotTrib>185.82</vTotTrib><ICMS><ICMS00><orig>0</orig><CST>00</CST><modBC>0</modBC><vBC>600.00</vBC><pICMS>0.00</pICMS><vICMS>0.00</vICMS></ICMS00></ICMS><PIS><PISAliq><CST>01</CST><vBC>600.00</vBC><pPIS>0.00</pPIS><vPIS>0.00</vPIS></PISAliq></PIS><COFINS><COFINSAliq><CST>01</CST><vBC>600.00</vBC><pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS></imposto></det><total><ICMSTot><vBC>600.00</vBC><vICMS>0.00</vICMS><vICMSDeson>0.00</vICMSDeson><vBCST>0.00</vBCST><vST>0.00</vST><vProd>600.00</vProd><vFrete>0.00</vFrete><vSeg>0.00</vSeg><vDesc>0.00</vDesc><vII>0.00</vII><vIPI>0.00</vIPI><vPIS>0.00</vPIS><vCOFINS>0.00</vCOFINS><vOutro>0.00</vOutro><vNF>600.00</vNF><vTotTrib>185.82</vTotTrib></ICMSTot></total><transp><modFrete>9</modFrete></transp><infAdic><infCpl>description</infCpl></infAdic></infNFe>'

signer = Signer.new(Nokogiri::XML(File.open('faze_igual.xml')))
signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))
# signer.security_node = signer.document.root
# signer.digest!(test, :id => "NFe51150501882109000162650010000000011064552485", :enveloped => true)
# signer.sign!(:issuer_serial => true)
# signed_xml = signer.to_xml

# a = signer.document.xpath("/*[name()='NFe']/*[name()='infNFe']")
# a = a.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)

target_digest = OpenSSL::Digest::SHA1.digest(test)
target_digest = Base64.encode64(target_digest.to_s).gsub(/\n/, '')
puts target_digest

# puts signer.document

# doc = Nokogiri::XML(File.read("soapMessage.xml"))
# test = Nokogiri::XML(signed_xml)
# doc.xpath("/soap12:Envelope/soap12:Body/*[name()='nfeDadosMsg']/*[name()='enviNFe']").each do |node|
#   node.add_child(test.root)
# end

# certo = doc.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)

# # # File.open("xml_to_sign_signed.xml", 'w') {|f| f.write(signed_xml) }

# # # ################################################################################
# # WSDL_URL = 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl'
# WSDL_URL = 'https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeAutorizacao?wsdl'

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

# response = client.call(:nfe_autorizacao_lote, xml: certo )
# p response.to_hash