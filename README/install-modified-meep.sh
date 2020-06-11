# Ensure that guile-2.0-11 is installed on the machine. It must be this version!

# Load Open MPI and create a work area for the build.
module purge
module load openmpi
mkdir -p ~/meep_work/src 
cd ~/meep_work/src

# Download modified MEEP and local dependencies.
git clone https://github.com/alexfriman/offidiagonal-meep.git
wget https://github.com/NanoComp/libctl/releases/download/v4.4.0/libctl-4.4.0.tar.gz
wget https://github.com/NanoComp/harminv/releases/download/v1.4.1/harminv-1.4.1.tar.gz
wget https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_10_6/source/hdf5-1.10.6.tar.gz
git clone http://github.com/HomerReid/libGDSII
git clone https://github.com/NanoComp/h5utils.git 
tar x -vf libctl-4.4.0.tar.gz
tar x -vf harminv-1.4.1.tar.gz
tar x -vf hdf5-1.10.6.tar.gz
rm -f *.tar.gz

# Build libctl.
cd libctl-4.4.0
./configure --prefix=$HOME/meep_work CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make -j 6 CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make install

# Build harminv.
cd ../harminv-1.4.1
./configure --prefix=$HOME/meep_work --with-pic CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make -j 6 CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make install

# Build libGDSII.
cd ../libGDSII
sh autogen.sh
./configure --prefix=$HOME/meep_work CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make -j 6 CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make install

# Build parallel HDF5.
cd ../hdf5-1.10.6
./configure --prefix=$HOME/meep_work --enable-parallel CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make -j 6 CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make install

# Build h5utils.
cd ../h5utils
sh autogen.sh
./configure --prefix=$HOME/meep_work CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make -j 6 CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make install

# Build Meep.
cd ../offidiagonal-meep
sh autogen.sh 
./configure --prefix=$HOME/meep_work --enable-maintainer-mode --without-python --with-mpi --with-libctl=$HOME/meep_work/share/libctl CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make -j 6 CPPFLAGS="-I$HOME/meep_work/include -I/usr/include/guile/2.0" LDFLAGS="-L$HOME/meep_work/lib" PATH=$HOME/meep_work/bin:$PATH
make install

# Confirm installation.
cd
~/meep_work/bin/meep --version