#!/bin/sh

git submodule update --init
pushd ./deps/squoosh
    git reset --hard HEAD
    git clean -xdf
    # patch -p1 < ../../scripts/build-squoosh/squoosh-changes-for-fast-iteration.patch
    patch -p1 < ../../scripts/build-squoosh/squoosh-changes.patch
    mkdir -p ../../generated/squoosh/
    cp ./emscripten-types.d.ts ../../generated/squoosh/
    find ./codecs \
           -name "webp_*.js" -delete \
        -o -name "webp_*.wasm" -delete
    pushd ./codecs/webp
        npm run build
    popd
    find ./codecs -name "webp_node_*.js" -delete
    find ./codecs \
           -name "webp_*.js" -exec cp {} ../../generated/squoosh \; \
        -o -name "webp_*.ts" -exec cp {} ../../generated/squoosh \;
popd
