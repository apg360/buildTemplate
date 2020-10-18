#!/bin/zsh

#Pre-requisite, must be installed in the system :
# (*) Cmake
# (*) Ninja
# (*) LLVM + Clang
# (*) Vulkan SDK from LunarG
# (*) GLFW
# (*) Command_Line_Tools_for_Xcode_12.dmg

export PATH=~/MyProjects/clang+llvm-10.0.0-x86_64-apple-darwin/bin:~/MyProjects/Ninja1.10.1/ninja:$PATH
export CC=clang
export CXX=clang++
export SDKROOT='/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk'
export CPATH='/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk:/opt/local/include'
export LIBRARY_PATH='/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib:/opt/local/lib'

#Use cmake to perform OS operation
cmake -E rm -rf build           #delete directory build
cmake -E make_directory build   #create directory build

#Use cmake to run the generator
#cmake -E chdir build cmake -E time cmake ../   #run cmake to configure in directory 'build"
cmake -E time cmake -G Ninja . -B build         #Use Ninja as generator on the CMakeLists in current directory, and generate under directory 'build'

#Use cmake to run the build
#ninja -j 4 -C build
#ninja -j 4 install
cmake -E time cmake --build build #--target Hello --config Release --clean-first

echo -e "\n********* STARTING ********\n"
build/./Hello
echo -e "\n\n"



#####################################################
#Testing command
#####################################################
#VALUE='-isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk'
#VALUE='/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk'
#export CFLAGS+=$VALUE
#export CCFLAGS+=$VALUE
#export CXXFLAGS+=$VALUE
#export CPPFLAGS+=$VALUE
#export CPATH=$VALUE

#rm -rf build; mkdir build && cd build && rm Hello
#clang++ -std=c++17 -stdlib=libc++ -Wall -Wextra -pedantic hello.cpp -o Hello
#clang++ -std=c++17 hello.cpp -o Hello
#./Hello

#rm -rf build && mkdir build && cd build
#cmake -G Ninja ../src -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DLLVM_BUILD_TESTS=ON # Enable tests; default is off.

#cmake -E env LDFLAGS="-std=c++17" PATH="/usr/local/Cellar/ninja/1.10.1_1/bin/ninja:$PATH" cmake -G Ninja src -B build -DCMAKE_C_COMPILER:PATH="~/MyProjects/clang+llvm-10.0.0-x86_64-apple-darwin/bin/clang" -DCMAKE_CXX_COMPILER:PATH="~/MyProjects/clang+llvm-10.0.0-x86_64-apple-darwin/bin/clang++" -DCMAKE_C_COMPILER_ID="Clang" -DCMAKE_CXX_COMPILER_ID="Clang" -DCMAKE_SYSTEM_NAME="Generic"

#cmake -E env PATH="~/MyProjects/Ninja1.10.1/ninja:$PATH" cmake -G Ninja . -B build -DCMAKE_C_COMPILER:PATH="~/MyProjects/clang+llvm-10.0.0-x86_64-apple-darwin/bin/clang" -DCMAKE_CXX_COMPILER:PATH="~/MyProjects/clang+llvm-10.0.0-x86_64-apple-darwin/bin/clang++"
#-DCMAKE_C_COMPILER_ID="Clang" -DCMAKE_CXX_COMPILER_ID="Clang"
#-DCMAKE_C_COMPILER:PATH="~/MyProjects/clang+llvm-10.0.0-x86_64-apple-darwin/bin/clang" -DCMAKE_CXX_COMPILER:PATH="~/MyProjects/clang+llvm-10.0.0-x86_64-apple-darwin/bin/clang++"
#Do not use #-DCMAKE_SYSTEM_NAME="Generic" because cmake intelligency to find dependancies will be disabled

#export PATH=~/MyProjects/clang+llvm-10.0.0-x86_64-apple-darwin/bin/:$PATH
#export CC=clang
#export CXX=clang++

#####################################################
