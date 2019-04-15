#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
for asm_file in src/*.asm ;
do
    basename="$(basename ${asm_file} .asm)"
    echo "Building $asm_file as bin/$basename ..."
    nasm -f bin -o bin/${basename} $asm_file
    chmod +x bin/${basename}
done
