require 'rubygems'
require 'bundler/setup'

require "signer"
require "openssl"

require 'net/http'
require "uri"

# url = URI.parse('https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl')
# request = Net::HTTP::Post.new(url.path)
# request.use_ssl = true
# request.content_type = 'application/xml'
# request.body =
# response = Net::HTTP.start(url.host, url.port) {|http| http.request(request) }

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
post_body << File.read(file)
post_body << "rn--#{BOUNDARY}--rn"

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri.request_uri)
request.body = post_body.join
request["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"

http.request(request)

# url = URI.parse('https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl')
# req = Net::HTTP::Post.new(url.request_uri)
# req.set_form_data('<?xml version="1.0" encoding="utf-8"?><NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe Id="NFe43120103987283000133550010000006241607910981" versao="2.00"><ide><cUF>43</cUF><cNF>60791098</cNF><natOp>5.101 - VENDA</natOp><indPag>1</indPag><mod>55</mod><serie>1</serie><nNF>624</nNF><dEmi>2012-01-25</dEmi><tpNF>1</tpNF><cMunFG>4313409</cMunFG><tpImp>1</tpImp><tpEmis>1</tpEmis><cDV>1</cDV><tpAmb>2</tpAmb><finNFe>1</finNFe><procEmi>0</procEmi><verProc>2.02</verProc></ide><emit><CNPJ>03987283000133</CNPJ><xNome>MINHA EMPRESA TESTE LTDA.</xNome><xFant>MINHA EMPRESA FANTASIA TESTE</xFant><enderEmit><xLgr>RUA TESTE</xLgr><nro>123</nro><xBairro>CENTRO</xBairro><cMun>4312345</cMun><xMun>PORTO ALEGRE</xMun><UF>RS</UF><CEP>93000000</CEP><cPais>1058</cPais><xPais>BRASIL</xPais><fone>5111223344</fone></enderEmit><IE>0868689965</IE><CRT>1</CRT></emit><dest><CNPJ>99999999000191</CNPJ><xNome>NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xNome><enderDest><xLgr>AV. DOS TESTES</xLgr><nro>202</nro><xBairro>CENTRO</xBairro><cMun>4369854</cMun><xMun>PORTO ALEGRE</xMun><UF>RS</UF><CEP>93000000</CEP><cPais>1058</cPais><xPais>BRASIL</xPais></enderDest><IE>ISENTO</IE></dest><det nItem="1"><prod><cProd>15036</cProd><cEAN/><xProd>PRODUTO TESTE REF 123123</xProd><NCM>84123123</NCM><CFOP>5101</CFOP><uCom>UN</uCom><qCom>1.0000</qCom><vUnCom>590.0000</vUnCom><vProd>590.00</vProd><cEANTrib/><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vUnTrib>590.0000</vUnTrib><indTot>1</indTot></prod><imposto><ICMS><ICMSSN101><orig>0</orig><CSOSN>101</CSOSN><pCredSN>2.82</pCredSN><vCredICMSSN>16.64</vCredICMSSN></ICMSSN101></ICMS><PIS><PISOutr><CST>99</CST><vBC>0.00</vBC><pPIS>0.00</pPIS><vPIS>0.00</vPIS></PISOutr></PIS><COFINS><COFINSOutr><CST>99</CST><vBC>0.00</vBC><pCOFINS>0.00</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSOutr></COFINS></imposto></det><total><ICMSTot><vBC>0.00</vBC><vICMS>0.00</vICMS><vBCST>0.00</vBCST><vST>0.00</vST><vProd>590.00</vProd><vFrete>0.00</vFrete><vSeg>0.00</vSeg><vDesc>0.00</vDesc><vII>0.00</vII><vIPI>0.00</vIPI><vPIS>0.00</vPIS><vCOFINS>0.00</vCOFINS><vOutro>0.00</vOutro><vNF>590.00</vNF></ICMSTot></total><transp><modFrete>1</modFrete></transp><cobr><dup><nDup>624</nDup><dVenc>2013-02-08</dVenc><vDup>590.00</vDup></dup></cobr><infAdic><infCpl>TESTE DE INFORMACOES ADICIONAIS</infCpl></infAdic></infNFe><Signature xmlns="http://www.w3.org/2000/09/xmldsig#"><SignedInfo><CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/><SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><Reference URI="#NFe43120101951363000175550010000006241607910981"><Transforms><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/><Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/></Transforms><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><DigestValue>w9ST4BFe2YG5i/ifHycd4fBMQ=</DigestValue></Reference></SignedInfo><SignatureValue>El98tgmZRnakzzbLqjzuLDlWzL5cZJc8Xg8BOnffj5SIfqhuSvq/v7UOy6Sz80u4dV1GCFuycOV4wHdIfitzlmnfiDJkjIpjrrYOwOpiL5DCXgPWcbRwAVjIA04T/d6AL/dErwKvpS1GBAySz/Ds6KX03jtheFNgCpyeg=</SignatureValue><KeyInfo><X509Data><X509Certificate>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</X509Certificate></X509Data></KeyInfo></Signature></NFe>')
# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = (url.scheme == "https")
# response = http.request(req)

# signer = Signer.new(File.read("test_xxxml.xml"))
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