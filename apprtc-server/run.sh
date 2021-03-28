#PUBLIC_IP=`hostname`

sed -i "s/SERVER_PUBLIC_IP/${PUBLIC_IP}/g" /ice.js
sed -i "s/SERVER_PUBLIC_IP/${PUBLIC_IP}/g" /apprtc/out/app_engine/constants.py

# vsilva
# Generate ssl certs for domain
echo "Generating SSL certs for domain $PUBLIC_IP"
domain=$PUBLIC_IP
openssl req -subj "/CN=$domain/O=C1AS/C=US" -newkey rsa:2048 -sha256 -nodes -keyout $domain-key.pem -out $domain.csr -outform PEM
openssl req -in $domain.csr -text -noout -verify
openssl x509 -req -in $domain.csr -CA /cert/cert-pebble.pem -CAkey /cert/key-pebble.pem -CAcreateserial -text -out $domain.pem -days 1024 -sha256

# copy to proper place (collider WS server)
mv $domain.pem /cert/cert.pem
mv $domain-key.pem /cert/key.pem

# apache2 SSL (deprecated)
#cp /cert/key.pem  /etc/ssl/private/ssl-cert-snakeoil.key
#cp /cert/cert.pem /etc/ssl/certs/ssl-cert-snakeoil.pem

#echo Starting apache server
#service apache2 start

echo "************ STARTUP ******************"
echo "* PUBLIC_IP=${PUBLIC_IP}"
echo "* Open https://${PUBLIC_IP}"
echo "***************************************"
supervisord -c /apprtc_supervisord.conf

