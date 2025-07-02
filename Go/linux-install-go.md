# instalar go en linux deb:


1. obtener
wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz 

2. borrar instalaciones anteriores
sudo rm -rf /usr/local/go 

3. instalar
sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz && export PATH=$PATH:/usr/local/go/bin

4. verificar
go version