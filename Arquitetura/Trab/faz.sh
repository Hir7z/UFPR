!bin/bash

cd gera_rom/ ;
./generate_rom.py prog.asm ;
cp rom32.vhd .. ;
cd .. ;
make sim ;
