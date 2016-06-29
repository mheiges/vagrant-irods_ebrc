
Following general instructions at https://wiki.apidb.org/index.php/SelfSignedSSLCert

        CERTHOST=ies
        CERTFQDN=ies.irods.vm

        openssl genrsa -out ssl.key/$CERTHOST-rsa.key 2048

        openssl req -new \
          -sha256 \
          -key ssl.key/$CERTHOST-rsa.key \
          -subj "/C=US/ST=Georgia/L=Athens/O=EuPathDB Bioinformatics Resource Center/CN=$CERTFQDN" \
          -out ssl.csr/$CERTHOST-rsa.csr


        openssl x509 -req                       \
           -sha256                              \
           -days 1825                           \
           -in ssl.csr/$CERTHOST-rsa.csr        \
           -CA ssl.crt/apidb-ca-rsa.crt         \
           -CAkey ssl.key/apidb-ca-rsa.key      \
           -CAserial etc/CAserial               \
           -out ssl.crt/$CERTHOST-rsa.crt


        openssl x509  -subject -fingerprint \
            -issuer -dates -text -noout  \
            -in ssl.crt/$CERTHOST-rsa.crt


        subject= /C=US/ST=Georgia/L=Athens/O=EuPathDB Bioinformatics Resource Center/CN=ies.irods.vm
        SHA1 Fingerprint=2E:F3:68:90:27:40:46:D9:86:58:15:18:98:C2:25:BB:69:E5:FB:88
        issuer= /C=US/ST=Pennsylvania/L=Philadelphia/O=ApiDB Bioinformatics Resource Center/CN=ApiDB/emailAddress=help@apidb.org
        notBefore=Jun 21 18:21:34 2016 GMT
        notAfter=Jun 20 18:21:34 2021 GMT
        Certificate:
            Data:
                Version: 1 (0x0)
                Serial Number: 102 (0x66)
            Signature Algorithm: sha256WithRSAEncryption
                Issuer: C=US, ST=Pennsylvania, L=Philadelphia, O=ApiDB Bioinformatics Resource Center, CN=ApiDB/emailAddress=help@apidb.org
                Validity
                    Not Before: Jun 21 18:21:34 2016 GMT
                    Not After : Jun 20 18:21:34 2021 GMT
                Subject: C=US, ST=Georgia, L=Athens, O=EuPathDB Bioinformatics Resource Center, CN=ies.irods.vm
                Subject Public Key Info:
                    Public Key Algorithm: rsaEncryption
                        Public-Key: (2048 bit)
                        Modulus:
                            00:c3:77:d5:0b:4c:e5:9b:78:34:1d:ef:84:10:e0:
                            c5:19:9f:1d:13:25:f3:8f:03:22:46:64:6a:82:34:
                            cd:5f:19:b4:5e:bf:28:f0:0f:c5:f7:42:71:7a:95:
                            07:69:0d:ac:fb:2e:d7:b5:ae:d2:db:6d:68:a3:6f:
                            41:76:cc:1b:93:e9:e2:c4:43:37:37:2a:ca:13:a4:
                            68:b9:f8:9d:30:67:83:84:98:3b:d8:e4:78:b0:69:
                            25:6e:5f:d6:64:e3:64:9b:3a:ff:ca:b1:5d:e4:a8:
                            fe:b3:d4:77:e3:14:fe:d3:9b:23:93:29:55:87:39:
                            b4:86:47:1f:42:5b:b9:38:f4:54:63:68:a9:f1:c2:
                            23:68:a5:29:c0:53:b1:23:8e:3e:5c:17:fe:d6:84:
                            a9:19:0f:dd:35:a3:00:66:8c:ed:d4:bd:21:72:32:
                            3b:51:49:ab:9e:86:4c:76:0b:b9:07:90:a9:2b:f9:
                            62:17:8b:ba:72:30:06:6b:f9:23:3d:bd:b2:86:4e:
                            78:28:64:15:1c:e6:93:4b:33:22:48:f5:4b:b9:5d:
                            99:8a:af:a7:fc:01:ba:f2:be:ed:7f:96:ed:36:a3:
                            8d:df:52:4d:f1:40:d7:03:34:cc:53:38:c4:10:88:
                            9d:bd:21:df:36:b3:ad:42:99:1a:8d:09:81:4b:6b:
                            fa:af
                        Exponent: 65537 (0x10001)
            Signature Algorithm: sha256WithRSAEncryption
                 15:e0:89:54:6c:bd:34:55:20:f9:27:0e:bd:1e:f8:04:98:2e:
                 ca:1d:fe:50:19:b0:20:b8:9b:b0:7f:d8:fa:77:21:32:73:bc:
                 f1:5a:1e:38:98:d6:f0:f6:93:c2:16:e7:ec:0c:56:cb:ec:91:
                 86:ef:4b:6f:db:e5:77:d1:f8:16:67:2f:35:c6:1c:5c:32:1d:
                 2f:31:11:96:94:db:8a:4c:2e:c9:da:b6:fc:2f:7c:eb:d1:fe:
                 ce:7f:69:f4:25:22:2e:7f:5a:2d:6f:c2:64:c9:96:7c:d2:34:
                 82:4d:68:c0:19:ad:a5:f0:29:9f:29:3f:fe:7e:25:53:3a:63:
                 a1:f6:cf:59:43:3c:54:45:44:45:a3:ec:bf:7f:b3:03:a4:9d:
                 81:c7:20:d6:4e:28:e3:aa:16:cb:51:43:84:f8:d3:33:83:74:
                 26:9c:26:31:72:c3:af:5b:81:62:34:c7:33:ac:b3:e8:34:e9:
                 46:59:2f:69:04:1c:ab:1f:33:ab:c8:c1:e7:3c:af:d3:39:db:
                 cf:cd:e2:3b:ce:d1:52:87:45:ac:6e:bc:18:9b:58:fa:a2:82:
                 ff:54:29:a4:02:03:67:28:20:97:a4:30:e7:d7:42:b9:cd:6b:
                 2b:c7:ca:c2:89:be:15:e2:4b:a1:e0:f4:cc:7c:a3:0d:02:4c:
                 58:39:77:92:4f:3d:d2:da:3b:b1:ec:fa:19:3f:e3:52:58:42:
                 36:ec:1a:83:76:f0:18:5f:af:7c:c0:2d:44:d7:fb:06:a3:ef:
                 12:67:eb:dc:24:32:e5:de:69:d0:a6:15:97:20:e7:36:e4:73:
                 7f:35:8b:87:49:ce:c7:dd:aa:6f:8e:a9:0c:00:1f:db:77:9e:
                 a6:fc:46:5f:44:7b:81:06:0e:fb:30:b6:1f:7b:fa:3b:74:81:
                 38:fb:db:4a:49:4d:dc:20:01:ca:39:40:7e:09:c7:81:3e:1a:
                 a0:89:d4:a7:80:d0:25:c7:b1:97:ef:a9:77:7a:09:cd:69:5c:
                 d4:6e:ac:be:64:b6:e6:06:98:a9:51:60:79:bf:6f:be:31:70:
                 3e:2e:07:57:82:d9:7b:d2:8c:a7:af:d9:d8:04:c3:c5:40:94:
                 82:5b:f3:24:3f:9f:01:0e:dc:34:02:52:f5:e3:4c:39:46:fe:
                 42:a0:2b:58:89:a5:5c:c2:7c:51:0f:fa:dc:71:40:12:bf:e6:
                 51:34:b5:73:43:fa:8e:d6:a0:b4:f3:a1:d4:5a:1c:c6:c7:97:
                 d6:07:60:f6:13:62:9b:c6:7a:f2:13:b9:94:90:7f:d5:bf:58:
                 45:9b:cb:18:df:09:a3:19:f4:39:89:1c:eb:ef:7b:82:25:a3:
                 59:78:1c:ee:0e:39:a9:08
