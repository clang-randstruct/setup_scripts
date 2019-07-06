#!/bin/bash
sudo apt-get update

#we need python, python-dev, tcl, and tcl-dev for the test-suite. ninja-build is used for a faster build system
sudo apt install -y cmake build-essential python python-dev python3-distutils tcl tcl-dev ninja-build

#this does a shallow clone of the repo. Saves disk space and clone time
git clone --depth=1 https://github.com/llvm/llvm-project.git

cd llvm-project

mkdir build

cd build

#need compiler-rt for test-suite
cmake -G Ninja -DLLVM_ENABLE_PROJECTS="clang;compiler-rt" ../llvm

#edit the number of threads you want
ninja -j <number of threads>

cd ~

git clone --depth=1 https://github.com/llvm/llvm-test-suite.git test-suite

mkdir test-suite-build

cd test-suite-build

#you should edit the $USER variable, since if you use SSH apparently it will use the one on your host machine (whoami will work fine apparently)
#full path is required! no " ~ " allowed!
cmake -DCMAKE_BUILD_TYPE=DEBUG -DCMAKE_C_COMPILER=/home/$USER/llvm-project/bin/clang -C../test-suite/cmake/caches/O3.cmake ../test-suite

#edit the number of threads you want
make -j <number of threads>

#run the test suite
/home/$USER/llvm-project/build/bin/llvm-lit -v -j -o results.json .