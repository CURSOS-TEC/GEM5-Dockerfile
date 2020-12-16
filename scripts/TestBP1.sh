# -- Benchmark: freqmine
# -- Variable independiente: Parámetros del Branch predictor
# -- Variable dependiente:  system.cpu.branchPred.BTBLookups 
# -- Tipo de CPU: TimingSimpleCPU

export META_BENCHMARK=freqmine
export META_XAXIS="Tamaño de memoria de cache L1 de datos"
export META_YAXIS="system.cpu.branchPred.BTBLookups"
export META_CPU_TYPE=TimingSimpleCPU
export META_FOLDER_NAME=testBP1
export META_WORK_DIR=/home/SharedData/testBP1



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
for testIndex in 1 2 4
do
    echo "Iteración BTB entries $((testIndex*256))"
    sed -i "62s/.*/    localPredictorSize = Param.Unsigned($((testIndex*256)), \"Size of local predictor\"), \"Number of BTB entries\")/" /code/GEM5/gem5/src/cpu/pred/BranchPredictor.py
    (time $OPT -d "./${META_FOLDER_NAME}/m5out${testIndex}/"  $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=$META_CPU_TYPE --caches --l2cache --l1d_size=256kB --l1i_size=256kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64 --bp-type=LocalBP) &> /dev/null 2>&1
    xAxis[${#xAxis[@]}]="$((256**testIndex))"
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.BTBLookups/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done





{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}"
#---------------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------------#


#Otras gráficas
xAxis=()
yAxis=()
export META_XAXIS="Tamaño de memoria de cache L1 de datos"
export META_YAXIS="system.cpu.branchPred.lookups"
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 1 2 4
do
    xAxis[${#xAxis[@]}]="$((256**testIndex))"
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.lookups/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer2.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot2"

#---------------------------------------------------------------------------------------------------------------------------------------------#
xAxis=()
yAxis=()
export META_XAXIS="Tamaño de memoria de cache L1 de datos"
export META_YAXIS="system.cpu.branchPred.BTBHitPct"
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 1 2 4
do
    xAxis[${#xAxis[@]}]="$((256**testIndex))"
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.BTBHitPct/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer2.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot3"

#---------------------------------------------------------------------------------------------------------------------------------------------#
xAxis=()
yAxis=()
export META_XAXIS="Tamaño de memoria de cache L1 de datos"
export META_YAXIS="system.cpu.branchPred.BTBHits"
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 1 2 4
do
    xAxis[${#xAxis[@]}]="$((256**testIndex))"
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.BTBHits/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer2.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot4"



#---------------------------------------------------------------------------------------------------------------------------------------------#
xAxis=()
yAxis=()
export META_XAXIS="Tamaño de memoria de cache L1 de datos"
export META_YAXIS="system.cpu.dcache.overall_misses::total "
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 1 2 4
do
    xAxis[${#xAxis[@]}]="$((256**testIndex))"
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.dcache.overall_misses::total / {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer2.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot5"