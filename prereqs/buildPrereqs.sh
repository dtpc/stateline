#!/bin/bash

# Script to build stateline prerequisites
# MUST HAVE TAR and UNZIP installed.

mkdir src
mkdir include
mkdir lib
mkdir bin
export PREREQ_DIR=$(pwd)
cd src

echo $(pwd)

NPROC=$(($(nproc)>4?4:$(nproc)))
 
# Boost 1.55
wget --quiet -c http://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.gz
[ -d boost_1_55_0 ] || tar -xf boost_1_55_0.tar.gz
cd boost_1_55_0
./bootstrap.sh > bootstrap.log &&
./b2 -j $NPROC --layout=versioned variant=debug,release threading=multi link=static runtime-link=static toolset=gcc address-model=64 install --prefix=$PREREQ_DIR > b2.log && echo "Boost installed" || echo "Boost install failed"
cd ..

# Eigen 3.2.0
wget --quiet -c http://bitbucket.org/eigen/eigen/get/3.2.0.tar.gz -O eigen_3.2.0.tar.gz
[ -d eigen-eigen-ffa86ffb5570 ] || tar -xf eigen_3.2.0.tar.gz
cd eigen-eigen-ffa86ffb5570
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$PREREQ_DIR > configure.log &&
make install > build.log && echo "Eigen installed"
cd ../..

# google-log (glog) 0.3.3
wget --quiet -c http://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
[ -d glog-0.3.3 ] || tar -xf glog-0.3.3.tar.gz
cd glog-0.3.3
./configure --prefix=$PREREQ_DIR  > configure.log &&
make install > build.log && echo "google-log installed"
cd ..

# google-test (gtest) 1.7.0
wget --quiet -c http://googletest.googlecode.com/files/gtest-1.7.0.zip
[ -d gtest-1.7.0 ] || unzip -qqo gtest-1.7.0.zip  && echo "google-test installed"

# zeromq 4.0.3
wget --quiet -c http://download.zeromq.org/zeromq-4.0.3.tar.gz
[ -d zeromq-4.0.3 ] || tar -xf zeromq-4.0.3.tar.gz
cd zeromq-4.0.3
./configure --prefix=$PREREQ_DIR > configure.log &&
make -j$(nproc) > build.log &&
make install  > install.log && echo "zeromq installed"
cd ..

# cppzeromq 2358037407 (commit hash)
wget --quiet -c https://github.com/zeromq/cppzmq/archive/master.zip -O cppzmq-master.zip
[ -d cppzmq-master ] || unzip -qqo cppzmq-master.zip
cp cppzmq-master/zmq.hpp $PREREQ_DIR/include  && echo "cppzeromq installed"

# json
wget --quiet -c https://github.com/nlohmann/json/archive/master.zip -O json-master.zip
[ -d json-master ] || unzip -qqo json-master.zip
cp json-master/src/json.hpp $PREREQ_DIR/include && echo "json installed"

