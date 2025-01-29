cd ~/oatpp
mkdir -p build && cd build
cmake ..
sudo make install

cd ~/oatpp-swagger
mkdir -p build && cd build
cmake ..
sudo make install

cd ~/SMBR-api-server
git submodule update --init --recursive
mkdir -p build && cd build
cmake ..
make
sudo make install
