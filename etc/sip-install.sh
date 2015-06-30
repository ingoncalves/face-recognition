#!/bin/sh

#uninstall previous installation
sudo apt-get remove imagemagick

#install dependencies
sudo apt-get update
sudo apt-get install autoconf libtool libjpeg-dev libpng++-dev libtiff5-dev

#install Imagemagick
wget http://www.imagemagick.org/download/ImageMagick.tar.gz
tar xvzf ImageMagick.tar.gz
cd ImageMagick-6.9.1
./configure
make
sudo make install
sudo ldconfig /usr/local/lib

#install Animal
git clone git://siptoolbox.git.sourceforge.net/gitroot/siptoolbox/animal
cd animal
./autogen.sh
./configure
make
sudo make install
sudo ldconfig


#install SIP
git clone git://siptoolbox.git.sourceforge.net/gitroot/siptoolbox/siptoolbox
cd ../siptoolbox
./autogen.sh
./configure
make
sudo make install
make autoload
