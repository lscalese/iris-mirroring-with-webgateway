#!/bin/bash

# clean previous execution.
rm -vfr ./certificates ../certificates

mkdir -v ./certificates
chmod 777 ./certificates

docker run \
 --entrypoint /external/irisrun.sh \
 --name cert_generator \
 --volume $(pwd):/external \
 intersystemsdc/iris-community:latest

docker container rm cert_generator

# chmod to avoid a permission denied for the copy
# chmod 777 ${DIRTMPCERT}/*

# change permissions

chown irisowner ./certificates/*_server.cer ./certificates/*_server.key
chgrp irisowner ./certificates/*_server.cer ./certificates/*_server.key
chmod 644 ./certificates/*_server.cer

# chmod for private key should be 600, but we have permissions denied with IRIS
# Maybe irisowner is not the good owner for these files ... to analyse...
chmod 640 ./certificates/*.key
chgrp irisuser ./certificates/*_server.key

chown www-data ./certificates/apache_webgateway.cer
chgrp www-data ./certificates/apache_webgateway.key
chmod 644 ./certificates/apache_*.cer
chmod 600 ./certificates/apache_webgateway.key

chown root ./certificates/webgateway_client.cer ./certificates/webgateway_client.key
chgrp www-data ./certificates/webgateway_client.cer ./certificates/webgateway_client.key
chmod 640 ./certificates/webgateway_*.cer 

rm -vfr ../certificates
mkdir -vp ~/webgateway-apache-certificates/
mv -vn ./certificates/apache_webgateway.cer ~/webgateway-apache-certificates/apache_webgateway.cer
mv -vn ./certificates/apache_webgateway.key ~/webgateway-apache-certificates/apache_webgateway.key

mv -v ./certificates ../certificates

