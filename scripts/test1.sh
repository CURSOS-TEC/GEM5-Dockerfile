# -- Benchmark: blackscholes
# -- Variable independiente: Asociatividad de cache L1 de datos e insturcciones 
# -- Variable dependiente: system.cpu.dcache.overall_misses::total
# -- Tipo de CPU: TimingSimpleCPU
export GEM5_DIR=/code/GEM5/gem5 # Relativo al contenedor
export OPT=$GEM5_DIR/build/X86/gem5.opt
export PY=$GEM5_DIR/configs/example/se.py
export BENCHMARK=/code/parsec-2.1/pkgs/apps/blackscholes/src/blackscholes # Relativo al contenedor
export ARGUMENT=/code/parsec-2.1/pkgs/apps/blackscholes/inputs/in_4.txt

# creación de archivo de metadatos que describe los resultados obtenidos.
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
> ./test1/metadatas.txt
echo -e "${YELLOW}benchmark${NC}=blackscholes" | tee -a ./test1/metadatas.txt
echo -e "${YELLOW}xVar${NC}=Asociatividad de cache L1 de datos e insturcciones " | tee -a ./test1/metadatas.txt
echo -e "${YELLOW}yVar${NC}=system.cpu.dcache.overall_misses::total " | tee -a ./test1/metadatas.txt
echo -e "${YELLOW}cpu${NC}=TimingSimpleCPU" | tee -a ./test1/metadatas.txt
echo ""
xAxis=()
yAxis=()
for testIndex in 0 1 2 3 4 5 6 7 8 9
do
    #echo "Iteración ${testIndex}"
    (time $OPT -d "./test1/m5out${testIndex}/"  $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=TimingSimpleCPU --caches --l2cache --l1d_size=256kB --l1i_size=256kB --l2_size=1MB "--l1d_assoc=$((2**testIndex))" "--l1i_assoc=$((2**testIndex))" --l2_assoc=1 --cacheline_size=64) &> /dev/null 2>&1
    xAxis[${#xAxis[@]}]="$((2**testIndex))"
    yValue=$(cat "./test1/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.dcache.overall_misses::total/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done

{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./test1/plotResult
cat ./test1/plotResult
