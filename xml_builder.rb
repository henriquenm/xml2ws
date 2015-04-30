require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'signer'
require 'br_danfe'

# cert_file = File.join(File.dirname(__FILE__), 'cert/certificado.pem')
# signer = Signer.new(xml)
# signer.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
# signer.private_key = OpenSSL::PKey::RSA.new(File.read(cert_file), "")
# signer.security_node = signer.document.root
# signer.security_token_id = ""
# signer.digest!(signer.document.root, :id => "", :enveloped => true)
# signer.sign!(:issuer_serial => true)
# signed_xml = signer.to_xml

# File.open("xmlassinado.xml", 'w') {|f| f.write(signed_xml) }

builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
  xml['soap12'].Envelope('xmlns:soap12' => "http://www.w3.org/2003/05/soap-envelope") {
    xml['soap12'].Header {
      xml.nfeCabecMsg('xmlns' => 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2') {
        xml.cUF(51)
        xml.versaoDados(2.00)
      }
    }
    xml['soap12'].Body {
      xml.nfeDadosMsg('xmlns' => "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2") {
        xml.consStatServ("versao" =>"2.00", "xmlns" => "http://www.portalfiscal.inf.br/nfe") {
          xml.tpAmb(2)
          xml.cUF(51)
          xml.xServ("STATUS")
        }
      }
    }
  }
end

builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
  xml.nfeProc("xmlns" => "http://www.portalfiscal.inf.br/nfe", "versao" => "3.00") {
    xml.Nfe {
      xml.infNFe("Id" => "NFe131311188353120001806500200000063915929078898", "versao" => "3.00") {
        xml.ide {
          xml.UF(51)
          xml.cNF("59290096")
          xml.natOp("VENDA DE MERCADORIA")
          xml.indPag(0)
          xml.mod(65)
          xml.serie(2)
          xml.nNF(639)
          xml.dhEmi("2013-11-29T16:29:02-04:00")
          xml.tpNF(1)
          xml.idDest(1)
          xml.cMunFG("1302603")
          xml.tpImp(4)
          xml.tpEmis(1)
          xml.cDV(8)
          xml.tpAmb(1)
          xml.finNFe(1)
          xml.indFinal(1)
          xml.indPres(1)
          xml.procEmi(0)
          xml.verProc("ATXOne - 1.0.0.22")
        }
        xml.emit {
          xml.CNPJ("02547812000112")
          xml.xNome("EMPRESA DE TESTE")
          xml.xFant("TRES ELEFANTES")
          xml.enderEmit {
            xml.xLgr("AV CORONEL TEIXEIRA")
            xml.nro(5705)
            xml.xCpl("LOJA 83/84.1 1 PISO SHOPPING PONTA NEGRA")
            xml.xBairro("Ponta Negra")
            xml.cMun("1302603")
            xml.xMun("MANAUS")
            xml.UF("AM")
            xml.CEP("69037000")
            xml.cPais(1058)
            xml.xPais("BRASIL")
            xml.fone("9236677413")
          }
          xml.IE("053429737")
          xml.CRT(1)
          xml.det("nItem" => "1") {
            xml.prod {
              xml.cProd(940)
              xml.cEAN("9000000009400")
              xml.xProd("BRINCO VANIA VARIADOS 10")
              xml.NCM("71171900")
              xml.CFOP(5102)
              xml.uCom("UN")
              xml.qCom(1.0000)
              xml.vUnCom("15.9000000000")
              xml.vProd("15.90")
              xml.cEANTrib("9000000009400")
              xml.uTrib("UN")
              xml.qTrib("1.0000")
              xml.vUnTrib("15.9000000000")
              xml.indTot(1)
            }
            xml.imposto {
              xml.ICMS {
                xml.ICMSSN102 {
                  xml.orig(2)
                  xml.CSOSN(102)
                }
              }
              xml.PIS {
                xml.PISAliq {
                  xml.CST(01)
                  xml.vBC(0.00)
                  xml.pPIS(0.00)
                  xml.vPIS(0.00)
                }
              }
              xml.COFINS {
                xml.COFINSAliq {
                  xml.CST(01)
                  xml.vBC(0.00)
                  xml.pCOFINS(0.00)
                  xml.vCOFINS(0.00)
                }
              }
            }
            xml.total {
              xml.ICMSTot {
                xml.vBC(0.00)
                xml.vICMS(0.00)
                xml.vBCST(0.00)
                xml.vST(0.00)
                xml.vProd(15.90)
                xml.vFrete(0.00)
                xml.vSeg(0.00)
                xml.vDesc(0.00)
                xml.vII(0.00)
                xml.vIPI(0.00)
                xml.vPIS(0.00)
                xml.vCOFINS(0.00)
                xml.vOutro(0.00)
                xml.vNF(15.90)
              }
            }
            xml.transp {
              xml.modFrete(9)
            }
            xml.pag {
              xml.tPag(01)
              xml.vPag(15.90)
            }
          }
        }
      }
    }
  }
end

File.open("xmlassinado.xml", 'w') {|f| f.write(builder) }