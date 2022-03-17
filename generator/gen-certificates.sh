#!/bin/bash

DIRTMPCERT=./certificates
VOLAPACHE=../volume-apache
VOLIRIS=../volume-iris

# clean previous execution.
rm -vfr ${DIRTMPCERT} ${VOLIRIS} ${VOLAPACHE}

mkdir ${DIRTMPCERT} ${VOLIRIS} ${VOLAPACHE}
chmod 777 ${DIRTMPCERT}/

docker run \
 --entrypoint /external/irisrun.sh \
 --name cert_generator \
 --volume $(pwd):/external \
 intersystemsdc/iris-community:latest

docker container rm cert_generator

# chmod to avoid a permission denied for the copy
chmod 777 ${DIRTMPCERT}/*

cp ${DIRTMPCERT}/CA_Server.cer ${VOLIRIS}/CA_Server.cer
cp ${DIRTMPCERT}/CA_Server.cer ${VOLAPACHE}/CA_Server.cer

cp ${DIRTMPCERT}/master_server.* ${VOLIRIS}/
cp ${DIRTMPCERT}/backup_server.* ${VOLIRIS}/
cp ${DIRTMPCERT}/report_server.* ${VOLIRIS}/

cp ${DIRTMPCERT}/apache_webgateway.cer ${VOLAPACHE}/apache_webgateway.cer
cp ${DIRTMPCERT}/apache_webgateway.key ${VOLAPACHE}/apache_webgateway.key
cp ${DIRTMPCERT}/webgateway_client.cer ${VOLAPACHE}/webgateway_client.cer
cp ${DIRTMPCERT}/webgateway_client.key ${VOLAPACHE}/webgateway_client.key

# change permissions

chown irisowner ${VOLIRIS}/*
chgrp irisowner ${VOLIRIS}/*
chmod 640 ${VOLIRIS}/*.cer

# chmod for private key should be 600, but we have permissions denied with IRIS
# Maybe irisowner is not the good owner for these files ... to analyse...
chmod 644 ${VOLIRIS}/*.key

chown www-data ${VOLAPACHE}/*.key
chgrp www-data ${VOLAPACHE}/*.key
chmod 600 ${VOLAPACHE}/*.key
chown root ${VOLAPACHE}/*.cer
chgrp root ${VOLAPACHE}/*.cer
chmod 644 ${VOLAPACHE}/*.cer

rm -vfr ${DIRTMPCERT}