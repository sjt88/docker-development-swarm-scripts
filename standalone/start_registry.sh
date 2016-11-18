docker-machine create -d virtualbox registry
eval $(docker-machine env registry)
# remove any previous stuff
rm -r ./registry
# build folder structure & copy docker machines ca certs
mkdir ./registry
mkdir ./registry/certs
mkdir ./registry/ca
cp ~/.docker/machine/certs/ca*.pem ./registry/ca/
cp ./openssl.cnf ./registry/ca/

echo "-------------------------------------------------------"
echo "     building openssl.cnf"
echo "-------------------------------------------------------"
# add valid IP SANS to openssl.cnf
export IP=$(docker-machine ip registry)
echo "IP.1=$IP" >> ./registry/ca/openssl.cnf
echo "DNS.1=localhost" >> ./registry/ca/openssl.cnf
echo "DNS.2=development_registry" >> ./registry/ca/openssl.cnf

# generate registry key
echo "-------------------------------------------------------"
echo "     generating registry key"
echo "-------------------------------------------------------"
openssl genrsa -out ./registry/certs/registry.key.pem 2048

# create CSR
echo "-------------------------------------------------------"
echo "     generating registry CSR"
echo "-------------------------------------------------------"
openssl req \
-new \
-key ./registry/certs/registry.key.pem -out ./registry/certs/registry.csr \
-subj "/CN=$(docker-machine ip registry)" \
-config ./registry/ca/openssl.cnf

# sign the CSR
echo "-------------------------------------------------------"
echo "     signing registry CSR"
echo "-------------------------------------------------------"
openssl x509 \
-req \
-in ./registry/certs/registry.csr -CA "./registry/ca/ca.pem" \
-CAkey "./registry/ca/ca-key.pem" \
-CAcreateserial \
-out "./registry/certs/registry.cert.pem" \
-days 365 \
-extensions v3_req \
-extfile ./registry/ca/openssl.cnf

echo "-------------------------------------------------------"
echo "     copying TLS certs to registry machine"
echo "-------------------------------------------------------"
# copy new TLS certs/key to registry machine
docker-machine ssh registry "sudo mkdir /certs; sudo mkdir /home/docker/registry_certs; sudo chown docker /certs /home/docker/registry_certs"
docker-machine scp ./registry/certs/registry.cert.pem registry:/home/docker/registry_certs/registry.cert.pem
docker-machine scp ./registry/certs/registry.key.pem registry:/home/docker/registry_certs/registry.key.pem
docker-machine scp ./registry/ca/ca.pem registry:/home/docker/registry_certs/ca.pem
docker-machine ssh registry "sudo cp /home/docker/registry_certs/* /certs"
echo "-------------------------------------------------------"
echo "     certs copied to /certs on registry machine"
echo "-------------------------------------------------------"
echo "     setting up registry machine daemon"
echo "-------------------------------------------------------"
# set up daemon on registry machines to allow it to use its own registry & add development_registry to hosts files
docker-machine ssh registry "sudo mkdir /etc/docker/certs.d; sudo mkdir /etc/docker/certs.d/development_registry:5000"
docker-machine ssh registry "sudo cp /certs/ca.pem /etc/docker/certs.d/development_registry:5000/ca.crt"
docker-machine ssh registry "sudo cat /etc/hosts > /home/docker/hosts"
docker-machine ssh registry "echo $(docker-machine ip registry) development_registry >> /home/docker/hosts"
docker-machine ssh registry "sudo mv /home/docker/hosts /etc/hosts"
echo "-------------------------------------------------------"
echo "     registry daemon set up complete"
echo "-------------------------------------------------------"
echo "     starting docker registry container..."
echo "-------------------------------------------------------"
docker run -d \
-p 5000:5000 \
--name registry \
--restart=always \
-v /home/docker/registry_certs:/certs:ro \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.cert.pem \
-e REGISTRY_HTTP_TLS_KEY=/certs/registry.key.pem \
registry:2

echo "-------------------------------------------------------"
echo "     copying ca to all machines"
echo "-------------------------------------------------------"
bash setup_registry.sh

echo "     "
echo "     "
echo "-------------------------------------------------------"
echo "     Your registry is now ready for use."
echo "     "
echo "     To push to the registry you will need to install the ca cert by doing the following:"
echo "       $ sudo mkdir /etc/docker/certs.d/   # not necessary if the folder already exists"
echo "     "
echo "       $ sudo mkdir /etc/docker/certs.d/$(docker-machine ip registry):5000"
echo "       $ sudo cp registry/ca/ca.pem /etc/docker/certs.d/$(docker-machine ip registry):5000/ca.crt"
echo "     "
echo "     You should then be able to push to your registry:"
echo "       $ docker pull nginx && docker tag nginx $(docker-machine ip registry):5000/nginx"
echo "       $ docker push $(docker-machine ip registry):5000/nginx"
echo "-------------------------------------------------------"


