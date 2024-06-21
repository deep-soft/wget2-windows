#
# wget2 build script for Windows environment
# Author: rzhy1
# 2024/6/16

# 设置环境变量
export PREFIX="x86_64-w64-mingw32"
export INSTALLDIR="$HOME/usr/local/$PREFIX"
export PKG_CONFIG_PATH="$INSTALLDIR/lib/pkgconfig:/usr/$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_LIBDIR="$INSTALLDIR/lib/pkgconfig"
export PKG_CONFIG="/usr/bin/${PREFIX}-pkg-config"
export CPPFLAGS="-I$INSTALLDIR/include"
export LDFLAGS="-L$INSTALLDIR/lib"
export CFLAGS="-O2 -g"
export WINEPATH="$INSTALLDIR/bin;$INSTALLDIR/lib;/usr/$PREFIX/bin;/usr/$PREFIX/lib"
# export LZMA_CFLAGS="-I/usr/include"
# export LZMA_LIBS="-L/usr/lib/x86_64-linux-gnu -llzma"
# export ZSTD_CFLAGS="-I/usr/include"
# export ZSTD_LIBS="-L/usr/lib/x86_64-linux-gnu -lzstd"
# export LZIP_CFLAGS="-I/usr/include"
# export LZIP_LIBS="-L/usr/lib/x86_64-linux-gnu -llz"
# export BZ2_CFLAGS="-I/usr/include"
# export BZ2_LIBS="-L/usr/lib/x86_64-linux-gnu -lbz2"
# export BROTLIDEC_CFLAGS="-I$INSTALLDIR/include"
# export BROTLIDEC_LIBS="-L$INSTALLDIR/lib -lbrotlidec"
mkdir -p $INSTALLDIR
cd $INSTALLDIR

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build xz⭐⭐⭐⭐⭐⭐" 
#wget -O- https://github.com/tukaani-project/xz/releases/download/v5.6.2/xz-5.6.2.tar.gz | tar xz || exit 1
#cd xz-* || exit 1
#./configure --host=$PREFIX --prefix=$INSTALLDIR --enable-silent-rules --enable-static --disable-shared || exit 1
#make -j$(nproc) && make install || exit 1
#cd .. && rm -rf xz-*

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build gnulib-mirror⭐⭐⭐⭐⭐⭐" 
git clone --recursive https://gitlab.com/gnuwget/gnulib-mirror.git gnulib  || exit 1
export GNULIB_REFDIR=$INSTALLDIR/gnulib

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build brotli⭐⭐⭐⭐⭐⭐" 
#git clone https://github.com/google/brotli.git
#cd brotli  || exit 1
#CMAKE_SYSTEM_NAME=Windows CMAKE_C_COMPILER=x86_64-w64-mingw32-gcc CMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ cmake . -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DBUILD_SHARED_LIBS=OFF  || exit 1
#make install  || exit 1
#cd .. && rm -rf brotli
echo $PKG_CONFIG_PATH
dpkg -l | grep libbrotli
pkg-config --libs libbrotli
pkg-config --cflags --libs libbrotlidec
pkg-config --variable pc_path pkg-config
find / -name "libbrotli.pc" 2>/dev/null
find / -name "libbrotli*" 2>/dev/null
find / -name "lzma.h" 2>/dev/null


echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build libiconv⭐⭐⭐⭐⭐⭐" 
wget -O- https://ftp.gnu.org/gnu/libiconv/libiconv-1.17.tar.gz | tar xz  || exit 1
cd libiconv-*  || exit 1
./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --disable-shared --enable-static --prefix=$INSTALLDIR  || exit 1
make -j$(nproc) && make install  || exit 1
cd .. && rm -rf libiconv-*

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build libunistring⭐⭐⭐⭐⭐⭐" 
wget -O- https://ftp.gnu.org/gnu/libunistring/libunistring-1.2.tar.gz | tar xz  || exit 1
cd libunistring-*  || exit 1
./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --disable-shared --enable-static --prefix=$INSTALLDIR || exit 1
make -j$(nproc) && make install || exit 1
cd .. && rm -rf libunistring-*

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build libidn2⭐⭐⭐⭐⭐⭐" 
wget -O- https://mirrors.ustc.edu.cn/gnu/libidn/libidn2-2.3.7.tar.gz | tar xz || exit 1
cd libidn2-* || exit 1
./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --disable-shared --enable-static --disable-doc --disable-gcc-warnings --prefix=$INSTALLDIR || exit 1
make -j$(nproc) && make install || exit 1
cd .. && rm -rf libidn2-*

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build libpsl⭐⭐⭐⭐⭐⭐" 
git clone --recursive https://github.com/rockdaboot/libpsl.git || exit 1
cd libpsl || exit 1
./autogen.sh || exit 1
./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --disable-shared --enable-static --enable-runtime=libidn2 --enable-builtin --prefix=$INSTALLDIR || exit 1
make -j$(nproc) && make install || exit 1
cd .. && rm -rf libpsl

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build nettle⭐⭐⭐⭐⭐⭐" 
git clone https://git.lysator.liu.se/nettle/nettle.git || exit 1
cd nettle || exit 1
bash .bootstrap || exit 1
./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --enable-mini-gmp --disable-shared --enable-static --disable-documentation --prefix=$INSTALLDIR || exit 1
make -j$(nproc) && make install || exit 1
cd .. && rm -rf nettle

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build gnutls⭐⭐⭐⭐⭐⭐" 
wget -O- https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.3.tar.xz | tar x --xz || exit 1
cd gnutls-* || exit 1
./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --prefix=$INSTALLDIR --with-nettle-mini --disable-shared --enable-static --with-included-libtasn1 --with-included-unistring --without-p11-kit --disable-doc --disable-tests --disable-full-test-suite --disable-tools --disable-cxx --disable-maintainer-mode --disable-libdane --disable-hardware-acceleration --disable-guile || exit 1
make -j$(nproc) && make install || exit 1
cd .. && rm -rf gnutls-*

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build zlib-ng⭐⭐⭐⭐⭐⭐" 
git clone https://github.com/zlib-ng/zlib-ng || exit 1
cd zlib-ng || exit 1
CROSS_PREFIX="x86_64-w64-mingw32-" ARCH="x86_64" CFLAGS="-O2" CC=x86_64-w64-mingw32-gcc ./configure --prefix=$INSTALLDIR --static --64 --zlib-compat || exit 1
make -j$(nproc) && make install || exit 1
cd .. && rm -rf zlib-ng

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build PCRE2⭐⭐⭐⭐⭐⭐" 
git clone https://github.com/PCRE2Project/pcre2 || exit 1
cd pcre2 || exit 1
./autogen.sh || exit 1
./configure --host=$PREFIX --prefix=$INSTALLDIR --disable-shared --enable-static || exit 1
make -j$(nproc) && make install || exit 1
cd .. && rm -rf pcre2

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build nghttp2⭐⭐⭐⭐⭐⭐" 
wget -O- https://github.com/nghttp2/nghttp2/releases/download/v1.62.1/nghttp2-1.62.1.tar.gz | tar xz || exit 1
cd nghttp2-* || exit 1
./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --prefix=$INSTALLDIR --disable-shared --enable-static --disable-python-bindings --disable-examples --disable-app --disable-failmalloc --disable-hpack-tools || exit 1
make -j$(nproc) && make install || exit 1
cd .. && rm -rf nghttp2-*

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build dlfcn-win32⭐⭐⭐⭐⭐⭐" 
git clone --depth=1 https://github.com/dlfcn-win32/dlfcn-win32.git || exit 1
cd dlfcn-win32 || exit 1
./configure --prefix=$PREFIX --cc=$PREFIX-gcc || exit 1
make -j$(nproc) || exit 1
cp -p libdl.a $INSTALLDIR/lib/ || exit 1
cp -p src/dlfcn.h $INSTALLDIR/include/ || exit 1
cd .. && rm -rf dlfcn-win32

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build libmicrohttpd⭐⭐⭐⭐⭐⭐" 
wget -O- https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-latest.tar.gz | tar xz || exit 1
cd libmicrohttpd-* || exit 1
./configure --build=x86_64-pc-linux-gnu --host=$PREFIX --prefix=$INSTALLDIR --disable-doc --disable-examples --disable-shared --enable-static || exit 1
make -j$(nproc) && make install || exit 1
cd .. && rm -rf libmicrohttpd-*

echo "⭐⭐⭐⭐⭐⭐$(date '+%Y/%m/%d %a %H:%M:%S.%N') - build wget2⭐⭐⭐⭐⭐⭐" 
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH"
export CPPFLAGS="$CPPFLAGS -I$INSTALLDIR/include -I/usr/include"
export LDFLAGS="$LDFLAGS -L$INSTALLDIR/lib -L/usr/lib"
git clone https://github.com/rockdaboot/wget2.git || exit 1
cd wget2 || exit 1
./bootstrap --skip-po || exit 1
LDFLAGS="-Wl,-Bstatic,--whole-archive -Wl,--no-whole-archive -lwinpthread" CFLAGS="-O2 -DNGHTTP2_STATICLIB" ./configure $CONFIGURE_BASE_FLAGS --build=x86_64-pc-linux-gnu --host=$PREFIX --disable-shared --enable-static --with-lzma --with-zstd --with-bzip2 --with-lzip --without-brotlidec --without-gpgme  --enable-threads=windows  || exit 1
make -j$(nproc) || exit 1
strip $INSTALLDIR/wget2/src/wget2.exe || exit 1
cp -fv "$INSTALLDIR/wget2/src/wget2.exe" "${GITHUB_WORKSPACE}" || exit 1
