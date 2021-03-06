#!/bin/sh

export FULL_VERSION=`grep '^version: ' leksah.cabal | sed 's|version: ||'`
export SHORT_VERSION=`echo $FULL_VERSION | sed 's|\.[0-9]*\.[0-9]*$||'`
export LEKSAH_X_X_X_X=leksah-$FULL_VERSION
export LEKSAH_X_X=leksah-$SHORT_VERSION

export GTK_PREFIX=`pkg-config --libs-only-L gtk+-2.0 | sed 's|^-L||' | sed 's|/lib *$||'`
echo Staging Leksah in $GTK_PREFIX

# Only used by OS X
export DYLD_LIBRARY_PATH="/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources:$GTK_PREFIX/lib:$DYLD_LIBRARY_PATH"

cd ../yi/yi || exit
cabal clean || exit
cabal configure --flags="pango -vte" --constraint='parsec<2.2' --prefix=$GTK_PREFIX --extra-lib-dirs="$GTK_PREFIX/lib" || exit
cabal build || exit
runhaskell Setup install || exit
cd ..

cd ../ltk || exit
cabal clean || exit
cabal configure || exit
cabal build || exit
runhaskell Setup install || exit

cd ../leksah-server || exit
cabal clean || exit
cabal configure --flags="curl" --prefix="$GTK_PREFIX" --datadir="$GTK_PREFIX/share" --extra-lib-dirs="$GTK_PREFIX/lib" --datasubdir="$LEKSAH_X_X" || exit
cabal build || exit
runhaskell Setup install || exit

cd ../leksah || exit
cabal clean || exit
cabal configure --flags="yi -dyre" --prefix="$GTK_PREFIX" --datadir="$GTK_PREFIX/share" --extra-lib-dirs="$GTK_PREFIX/lib" --datasubdir="$LEKSAH_X_X" || exit
cabal build || exit
runhaskell Setup install || exit
