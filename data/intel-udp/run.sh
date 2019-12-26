./client | tr "\n" , >> result.csv
#openssl dgst -verify ecdsa.pub.pem -keyform pem -sha256 -signature data.out.signed data.in.raw | tr "\n" , >> result.csv
#openssl asn1parse -dump -inform der -in data.out.signed  | tail -n 2 | awk -F ":" '{print $NF}' | tr '\n' , >> result.csv
echo >> result.csv
