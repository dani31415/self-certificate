export COMPANY='My Company'
export DOMAIN=example.com
export DOMAINS=DNS:${DOMAIN},DNS:www.example.org

# Root certificate
openssl req -sha256 -new -x509 -days 1826 -key rootca.key -out rootca.crt -subj "/C=ES/ST=Barcelona/L=Barcelona/O=${COMPANY}/OU=IT Department/CN=CA Root ${COMPANY}"

# Intermediate
openssl req -new -sha256 -key intermediate.key -out intermediate.csr -subj "/C=ES/ST=Barcelona/L=Barcelona/O=${COMPANY}/OU=IT Department/CN=CA Intermediate ${COMPANY}"
openssl x509 -req -in intermediate.csr -CA rootca.crt -CAkey rootca.key -CAcreateserial -out intermediate.crt -days 1826 -sha256 -extfile ext.ca

# Domain
openssl req -new -sha256 -key example.com.key -out ${DOMAIN}.csr -subj "/C=ES/ST=Barcelona/L=Barcelona/O=${COMPANY}/OU=IT Department/CN=${DOMAIN}"
echo subjectAltName=${DOMAINS} > ext.tmp
openssl x509 -req -in ${DOMAIN}.csr -CA intermediate.crt -CAkey intermediate.key -CAcreateserial -out ${DOMAIN}.crt -days 1826 -sha256 -extfile ext.tmp

cp rootca.crt chain.crt
cat intermediate.crt >> chain.crt
