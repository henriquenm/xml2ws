require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"
require 'savon'

################################################################################
private_key_file = File.join(File.dirname(__FILE__), '/cert/1234567890001_priKEY.pem')
cert_file        = File.join(File.dirname(__FILE__), '/cert/1234567890001_certKEY.pem')
# test = '<infNFe xmlns="http://www.portalfiscal.inf.br/nfe" Id="NFe51150501882109000162650010000000011064552485" versao="3.10"><ide><cUF>51</cUF><cNF>06455248</cNF><natOp>Venda</natOp><indPag>0</indPag><mod>65</mod><serie>1</serie><nNF>1</nNF><dhEmi>2015-05-14T10:32:03-04:00</dhEmi><tpNF>1</tpNF><idDest>1</idDest><cMunFG>5103403</cMunFG><tpImp>4</tpImp><tpEmis>1</tpEmis><cDV>5</cDV><tpAmb>2</tpAmb><finNFe>1</finNFe><indFinal>1</indFinal><indPres>1</indPres><procEmi>0</procEmi><verProc>1.0</verProc></ide><emit><CNPJ>01882109000162</CNPJ><xNome>COXIPO COM PROD PAPELARIA IMP EXPORTACAO LTDA EPP</xNome><xFant>COXIPO</xFant><enderEmit><xLgr>AVENIDA TENENTE-CORONEL DUARTE</xLgr><nro>191</nro><xBairro>CENTRO NORTE</xBairro><cMun>5103403</cMun><xMun>Cuiaba</xMun><UF>MT</UF><CEP>78005500</CEP><cPais>1058</cPais><xPais>Brasil</xPais><fone>6533171500</fone></enderEmit><IE>130333573</IE><CRT>3</CRT></emit><dest><CNPJ>46248310000120</CNPJ><xNome>NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xNome><enderDest><xLgr>AVENIDA TENENTE-CORONEL DUARTE</xLgr><nro>123</nro><xBairro>CENTRO NORTE</xBairro><cMun>5103403</cMun><xMun>Cuiaba</xMun><UF>MT</UF><CEP>78005500</CEP><cPais>1058</cPais><xPais>Brasil</xPais><fone>6533171555</fone></enderDest><indIEDest>9</indIEDest><email>henrique@rdscodes.com.br</email></dest><det nItem="1"><prod><cProd>1</cProd><cEAN>7891000315507</cEAN><xProd>produto qualquer</xProd><NCM>85176130</NCM><CFOP>5102</CFOP><uCom>kg</uCom><qCom>1.0000</qCom><vUnCom>10.00</vUnCom><vProd>10.00</vProd><cEANTrib>7891000315507</cEANTrib><uTrib>kg</uTrib><qTrib>1.0000</qTrib><vUnTrib>10.00</vUnTrib><indTot>1</indTot></prod><imposto><ICMS><ICMS00><orig>0</orig><CST>00</CST><modBC>3</modBC><vBC>10.00</vBC><pICMS>17.00</pICMS><vICMS>1.70</vICMS></ICMS00></ICMS></imposto></det><total><ICMSTot><vBC>10.00</vBC><vICMS>1.70</vICMS><vICMSDeson>0.00</vICMSDeson><vBCST>0.00</vBCST><vST>0.00</vST><vProd>10.00</vProd><vFrete>0.00</vFrete><vSeg>0.00</vSeg><vDesc>0.00</vDesc><vII>0.00</vII><vIPI>0.00</vIPI><vPIS>0.00</vPIS><vCOFINS>0.00</vCOFINS><vOutro>0.00</vOutro><vNF>10.00</vNF></ICMSTot></total><transp><modFrete>9</modFrete></transp><pag><tPag>01</tPag><vPag>10.00</vPag></pag><infAdic><infCpl>test</infCpl></infAdic></infNFe>'

signer = Signer.new(Nokogiri::XML(File.open('fazer_igual.xml')))
signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
signer.private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))
signer.security_node = signer.document.root
a = signer.document.xpath("/*[name()='NFe']/*[name()='infNFe']")
a = a.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
signer.digest!(a, :id => "NFe51150501882109000162650010000000011064552485", :enveloped => true)
signer.sign!(:issuer_serial => true)
signed_xml = signer.to_xml

doc = Nokogiri::XML(File.read("soapMessage.xml"))
test = Nokogiri::XML(signed_xml)
doc.xpath("/soap12:Envelope/soap12:Body/*[name()='nfeDadosMsg']/*[name()='enviNFe']").each do |node|
  node.add_child(test.root)
end

certo = doc.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)

File.open("xml_to_sign_signed.xml", 'w') {|f| f.write(signed_xml) }

################################################################################
WSDL_URL = 'https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeAutorizacao?wsdl'

# # Tem que pegar de uma pasta public na aplicação
ssl_ca_cert_file = File.expand_path("../cert/1234567890001_certKEY.pem", __FILE__)

# # Tem que pegar do model Company
ssl_cert_file = File.expand_path("../cert/1234567890001_pubKEY.pem", __FILE__)
ssl_cert_key_file = File.expand_path("../cert/1234567890001_priKEY.pem", __FILE__)

client = Savon.client(
  wsdl: WSDL_URL,
  ssl_cert: OpenSSL::X509::Certificate.new(File.read(ssl_cert_file)),
  ssl_ca_cert_file: ssl_ca_cert_file,
  ssl_cert_key: OpenSSL::PKey.read(File.read(ssl_cert_key_file)),
  ssl_cert_key_password: '12345678',
  soap_version: 2,
)
p client.operations

response = client.call(:nfe_autorizacao_lote, xml: certo )
p response.to_hash