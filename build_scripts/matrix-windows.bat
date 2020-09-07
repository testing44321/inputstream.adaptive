git clone https://github.com/xbmc/xbmc -b master --depth=1 kodi
git clone https://github.com/johnny5-is-alive/inputstream.adaptive.testing inputstream.adaptive

cd inputstream.adaptive
set /p DUMMY=Set the matrix version number then hit enter
mkdir build
cd build

cmake -T host=x64 -G "Visual Studio 15 2017 Win64" -DADDONS_TO_BUILD=inputstream.adaptive -DCMAKE_BUILD_TYPE=Release -DADDON_SRC_PREFIX=../.. -DPACKAGE_ZIP=1 ../../kodi/cmake/addons
cmake --build . --config Release --target package-inputstream.adaptive
move %temp%\addon-inputstream.adaptive.testing-*-windows-x86_64.zip ../..
