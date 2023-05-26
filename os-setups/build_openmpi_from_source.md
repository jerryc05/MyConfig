# Download
```sh
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.bz2
tar -xf openmpi-4.1.5.tar.bz2
cd openmpi-4.1.5
```


# Install
```sh
./configure --prefix=$(pwd)/_install --enable-mpi-cxx --with-cuda=$(dirname $(dirname $(which nvcc)))
make -j$(nproc) install

cat <<EOF >>~/.bashrc

# openmpi
export MPI_HOME=$(pwd)/_install/bin  # for cmake
export PATH=\$MPI_HOME:\$PATH
export CPATH=\$MPI_HOME/../include:\$CPATH
export LIBRARY_PATH=\$MPI_HOME/../lib:\$LIBRARY_PATH 

EOF
```


# Arch Linux
```sh
export __VERSION=$(grep '#define OMPI_VERSION' ./ompi/include/ompi/version.h | grep -oE '[0-9.]+')

if command -v makepkg &>/dev/null; then
    export _TMPDIR=$(mktemp -d)
    cat <<EOF >"$_TMPDIR/PKGBUILD"
    pkgname='openmpi_dummy'
    pkgver=$__VERSION
    pkgrel=1
    arch=(any)
    provides=('openmpi=$__VERSION')
    depends=(make)
    optdepends=(gcc)
EOF
    (cd $_TMPDIR && makepkg -si)
fi
```
