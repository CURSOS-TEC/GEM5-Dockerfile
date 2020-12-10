# -- Benchmark: blackscholes
# -- Variable independiente: Asociatividad de cache L1 de datos e insturcciones 
# -- Variable dependiente: system.cpu.dcache.overall_hits::total
# -- Tipo de CPU: TimingSimpleCPU
export GEM5_DIR=/code/GEM5/gem5 # Relativo al contenedor
export OPT=$GEM5_DIR/build/X86/gem5.opt
export PY=$GEM5_DIR/configs/example/se.py
export BENCHMARK=/code/parsec-2.1/pkgs/apps/blackscholes/src/blackscholes # Relativo al contenedor
export ARGUMENT=/code/parsec-2.1/pkgs/apps/blackscholes/inputs/in_4.txt

xAxis=()
yAxis=()
echo "system.cpu.dcache.overall_hits::total"
for testIndex in 0 1 2 3 4 5 6 7 8 9
do
    echo "Iteración ${testIndex}"
    (time $OPT -d "./test2/m5out${testIndex}/"  $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=TimingSimpleCPU --caches --l2cache --l1d_size=256kB --l1i_size=256kB --l2_size=1MB "--l1d_assoc=$((2**testIndex))" "--l1i_assoc=$((2**testIndex))" --l2_assoc=1 --cacheline_size=64) &> /dev/null 2>&1
    xAxis[${#xAxis[@]}]="$((2**testIndex))"
    yValue=$(cat "./test2/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.dcache.overall_hits::total/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done

{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./test2/plotResult
cat ./test2/plotResult