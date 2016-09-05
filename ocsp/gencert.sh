#!/bin/bash

newcert()
{
    local host=$1
    openssl genrsa -out intermediate/private/${host}.key.pem 4096
    chmod 400 intermediate/private/${host}.key.pem
    openssl req -config intermediate/openssl.cnf -key intermediate/private/${host}.key.pem -new -sha256 -out intermediate/csr/${host}.csr.pem
    openssl ca -config intermediate/openssl.cnf -extensions server_cert -days 3750 -notext -md sha256 -in intermediate/csr/${host}.csr.pem -out intermediate/certs/${host}.cert.pem
    chmod 444 intermediate/certs/${host}.cert.pem
    openssl x509 -noout -text -in intermediate/certs/${host}.cert.pem
}

if [[ -z ${1+x} ]]; then
    echo "Hostname required"
    exit 1
else
    newcert $1
fi
