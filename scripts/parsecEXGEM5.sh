# -- Script genérico para ejecución de GEM5 utilizando el benchmark de parsec --
# -- Dirección donde GEM5 fue construído --
export GEM5_DIR=/code/GEM5/gem5 # Relativo al contenedor
export OPT=$GEM5_DIR/build/X86/gem5.opt
export PY=$GEM5_DIR/configs/example/se.py
export BENCHMARK=/code/parsec-2.1/pkgs/apps/blackscholes/src/blackscholes # Relativo al contenedor
export ARGUMENT=/code/parsec-2.1/pkgs/apps/blackscholes/inputs/in_4.txt
# -- Ejecución del ambiente --
time $OPT -d m5out/ $PY -c $BENCHMARK -o $ARGUMENT