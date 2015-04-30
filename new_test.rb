require 'rubygems'
require 'bundler/setup'

require 'chilkat'


certStore = Chilkat::CkCertStore.new()

#  Load the PFX file into a certificate store object

password = "2308612609"
success = certStore.LoadPfxFile("cert/certificado_000001005867992.pfx", password)
if (success != true)
    print certStore.lastErrorText() + "\n"
    exit
end

numCerts = certStore.get_NumCertificates()

#  Loop over each certificate in the PFX.

for i in 0 .. numCerts - 1

    cert = certStore.GetCertificate(i)

    print cert.subjectDN() + "\n";
    print "---" + "\n";

    encodedCert = cert.getEncoded()

    #  This string may now be stored in a relational database string field.
    #  To re-create the cert, do this:
    cert2 = Chilkat::CkCert.new()
    cert2.SetFromEncoded(encodedCert)

    #  Does this cert have a private key?
    if (cert.HasPrivateKey() == true)

        #  Get the private key.

        pvkey = cert.ExportPrivateKey()

        #  The private key can be exported into
        #  a string in PKCS8, RSA PEM, or XML format:

        pemPvKey = pvkey.getRsaPem()
        pkcs8PvKey = pvkey.getPkcs8Pem()
        xmlPvKey = pvkey.getXml()

        print pemPvKey + "\n";
        print pkcs8PvKey + "\n";
        print xmlPvKey + "\n";

        #  Any of these formatted strings may
        #  be stored in a relational database field.
        #  to restore, call LoadPem or LoadXml
        #  LoadPem accepts either RSA PEM or
        #  PKCS8 PEM:
        pvKey2 = Chilkat::CkPrivateKey.new()

        pvKey2.LoadPem(pemPvKey)
        pvKey2.LoadPem(pkcs8PvKey)
        pvKey2.LoadXml(xmlPvKey)

    end

    #  Now for the public key:

    pubkey = cert.ExportPublicKey()

    #  It can be exported to a string as OpenSSL PEM
    #  or XML:

    pubKeyPem = pubkey.getOpenSslPem()
    pubKeyXml = pubkey.getXml()

    print pubKeyPem + "\n";
    print pubKeyXml + "\n";

    #  To re-load a PublicKey object, call LoadXml
    #  or LoadOpenSslPem:
    pubKey2 = Chilkat::CkPublicKey.new()

    pubKey2.LoadOpenSslPem(pubKeyPem)
    pubKey2.LoadXml(pubKeyXml)
    fname = "pubkey" + i.to_s() + "_openSsl.der"
    pubkey.SaveOpenSslDerFile(fname)

end

#  The Chilkat Certificate, Certificate Store, Private Key,
#  Public Key, and Key Container classes / objects are freeware.

#  They are used by and included with the Chilkat Email,
#  Crypt, S/MIME, and other commercial Chilkat components.
