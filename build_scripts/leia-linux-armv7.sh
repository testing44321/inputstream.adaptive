#Ubuntu 18.04.4 LTS

cd $HOME

rm -r kodi
rm -r tools
rm -r addon-inputstream.adaptive*.zip

apt-get update
apt install -y --no-install-recommends build-essential git cmake crossbuild-essential-armhf
​
### CONFIRE KODI BUILD TOOLS ###
git clone https://github.com/xbmc/xbmc --branch Leia --depth 1 $HOME/kodi
cd $HOME/kodi/tools/depends
./bootstrap
./configure --host=arm-linux-gnueabihf --disable-debug --prefix=$HOME/tools/kodi-depends

### ADD-ON SOURCE ###
git clone https://github.com/johnny5-is-alive/inputstream.adaptive.testing $HOME/kodi/tools/depends/target/binary-addons/inputstream.adaptive

### LEIA ###
git -C $HOME/kodi/tools/depends/target/binary-addons/inputstream.adaptive apply Leia.patch

### Clean ###
cd $HOME/kodi/cmake/addons && (git clean -xfd || rm -rf CMakeCache.txt CMakeFiles cmake_install.cmake build/*)

### CONFIGURE & BUILD ###
mkdir -p $HOME/kodi/cmake/addons/inputstream.adaptive/build/depends/share
cp -f $HOME/kodi/tools/depends/target/config-binaddons.site $HOME/kodi/cmake/addons/inputstream.adaptive/build/depends/share/config.site
sed "s|@CMAKE_FIND_ROOT_PATH@|$HOME/kodi/cmake/addons/inputstream.adaptive/build/depends|g" $HOME/kodi/tools/depends/target/Toolchain_binaddons.cmake > $HOME/kodi/cmake/addons/inputstream.adaptive/build/depends/share/Toolchain_binaddons.cmake

cd $HOME/kodi/cmake/addons/inputstream.adaptive

cmake -DOVERRIDE_PATHS=ON -DCMAKE_TOOLCHAIN_FILE=$HOME/kodi/cmake/addons/inputstream.adaptive/build/depends/share/Toolchain_binaddons.cmake -DADDONS_TO_BUILD=inputstream.adaptive -DADDON_SRC_PREFIX=$HOME/kodi/tools/depends/target/binary-addons -DADDONS_DEFINITION_DIR=$HOME/kodi/tools/depends/target/binary-addons/addons -DPACKAGE_ZIP=1 $HOME/kodi/cmake/addons
make package-inputstream.adaptive

### COPY ZIP ###
mv $HOME/kodi/cmake/addons/inputstream.adaptive/inputstream.adaptive-prefix/src/inputstream.adaptive-build/addon-inputstream.adaptive*.zip $HOME && cd $HOME && ls addon-inputstream.adaptive*.zip
