# -- Benchmark: swaptions
# -- Variable independiente: Asociatividad de cache L1 de datos e insturcciones 
# -- Variable dependiente: system.cpu.dcache.overall_hits::total
# -- Tipo de CPU: TimingSimpleCPU

export META_BENCHMARK=swaptions
export META_XAXIS="Asociatividad de cache L1 de datos e insturcciones"
export META_YAXIS="system.cpu.dcache.overall_hits::total"
export META_CPU_TYPE=TimingSimpleCPU
export META_FOLDER_NAME=test33
export META_WORK_DIR=/home/SharedData/test33/



export GEM5_DIR=/code/GEM5/gem5 # Relativo al contenedor
export OPT=$GEM5_DIR/build/X86/gem5.opt
export PY=$GEM5_DIR/configs/example/se.py
export BENCHMARK=/code/parsec-2.1/pkgs/apps/$META_BENCHMARK/src/$META_BENCHMARK # Relativo al contenedor
export ARGUMENT=/code/parsec-2.1/pkgs/apps/$META_BENCHMARK/inputs/in_4.txt

# creación de archivo de metadatos que describe los resultados obtenidos.
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
> ./$META_FOLDER_NAME/metadatas.txt
echo -e "${YELLOW}benchmark${NC}=${META_BENCHMARK}" | tee -a ./$META_FOLDER_NAME/metadatas.txt
echo -e "${YELLOW}xVar${NC}=${META_XAXIS} " | tee -a ./$META_FOLDER_NAME/metadatas.txt
echo -e "${YELLOW}yVar${NC}=${META_YAXIS} " | tee -a ./$META_FOLDER_NAME/metadatas.txt
echo -e "${YELLOW}cpu${NC}=${META_CPU_TYPE}" | tee -a ./$META_FOLDER_NAME/metadatas.txt
echo ""
xAxis=()
yAxis=()
for testIndex in 0 1 2 3 4 5 6 7 8 9
do
    #echo "Iteración ${testIndex}"
    (time $OPT -d "./${META_FOLDER_NAME}/m5out${testIndex}/"  $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=$META_CPU_TYPE --caches --l2cache --l1d_size=256kB --l1i_size=256kB --l2_size=1MB "--l1d_assoc=$((2**testIndex))" "--l1i_assoc=$((2**testIndex))" --l2_assoc=1 --cacheline_size=64) &> /dev/null 2>&1
    xAxis[${#xAxis[@]}]="$((2**testIndex))"
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.dcache.overall_hits::total/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done

{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}"
# cat ./test33/plotResult
