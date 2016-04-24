#!/usr/bin/env bash

set -ex

rm -rf deps/install
mkdir deps || true
cd deps
osmo-deps.sh libosmocore

cd libosmocore
autoreconf --install --force
./configure --prefix=$PWD/../install
$MAKE $PARALLEL_MAKE install

cd ../../
autoreconf --install --force
PKG_CONFIG_PATH=$PWD/deps/install/lib/pkgconfig ./configure --enable-vty-tests --enable-external-tests
PKG_CONFIG_PATH=$PWD/deps/install/lib/pkgconfig $MAKE $PARALLEL_MAKE
PKG_CONFIG_PATH=$PWD/deps/install/lib/pkgconfig LD_LIBRARY_PATH=$PWD/deps/install/lib $MAKE distcheck

