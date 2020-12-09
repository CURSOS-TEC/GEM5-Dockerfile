# -- Script genérico para ejecución de GEM5 utilizando el benchmark de parsec --
# -- Dirección donde GEM5 fue construído --
export GEM5_DIR=/code/GEM5/gem5 # Relativo al contenedor
export OPT=$GEM5_DIR/build/X86/gem5.opt
export PY=$GEM5_DIR/configs/example/se.py
export BENCHMARK=/code/parsec-2.1/pkgs/apps/blackscholes/src/blackscholes # Relativo al contenedor
export BENCHMARK2=/code/parsec-2.1/pkgs/apps/freqmine/src/freqmine # Relativo al contenedor
export ARGUMENT=/code/parsec-2.1/pkgs/apps/blackscholes/inputs/in_4.txt
# -- Ejecución del ambiente --
time $OPT -d m5out/  $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=TimingSimpleCPU --caches --caches --l2cache --l1d_size=256kB --l1i_size=256kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64
time $OPT -d m5out1/ $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=DerivO3CPU --caches --caches --l2cache --l1d_size=256kB --l1i_size=256kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64
time $OPT -d m5out2/ $PY -c $BENCHMARK2 --cpu-type=DerivO3CPU --caches --caches --l2cache --l1d_size=256kB --l1i_size=256kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64


#time $OPT -d m5out2/ $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=AtomicSimpleCPU --caches --bp-type=TournamentBP
#time $OPT -d m5out3/ $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=TimingSimpleCPU --caches
#time $OPT -d m5out4/ $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=TimingSimpleCPU --caches