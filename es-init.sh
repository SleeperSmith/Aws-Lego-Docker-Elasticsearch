#!/bin/bash

EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
PVT_IP=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`

echo Cluster Name: $1
echo AWS Region: $EC2_REGION
echo AWS Discovery Group: $2
echo Is Master: $3
echo Is Data: $4
echo Rack Id: $5
echo Replica Count: $6
echo Shard Count: $7

sed -i "s/{{cluster-name}}/$1/g" ./config/elasticsearch.yml
sed -i "s/{{aws-region}}/$EC2_REGION/g" ./config/elasticsearch.yml
sed -i "s/{{aws-sec-group}}/$2/g" ./config/elasticsearch.yml
sed -i "s/{{is-master}}/$3/g" ./config/elasticsearch.yml
sed -i "s/{{is-data}}/$4/g" ./config/elasticsearch.yml
sed -i "s/{{rack-id}}/$5/g" ./config/elasticsearch.yml
sed -i "s/{{replica-count}}/$6/g" ./config/elasticsearch.yml
sed -i "s/{{shard-count}}/$7/g" ./config/elasticsearch.yml
sed -i "s/{{pvt-ip}}/$PVT_IP/g" ./config/elasticsearch.yml

chown -R elasticsearch /mnt/xvdk

runuser -l elasticsearch -c "ulimit -n 40000 && export ES_HEAP_SIZE=$8m && /home/local/bin/elasticsearch"
