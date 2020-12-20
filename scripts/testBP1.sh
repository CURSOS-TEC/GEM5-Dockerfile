# -- Benchmark: blackscholes
# -- Variable independiente: Branch predictor 
# -- Variable dependiente: system.cpu.predictedBranches
# -- Tipo de CPU: TimingSimpleCPU

export META_BENCHMARK=blackscholes
export META_XAXIS="Branch predictor"
export META_YAXIS="system.cpu.predictedBranches"
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
xAxis=(LocalBP BiModeBP TournamentBP)
#xAxis=(BiModeBP LTAGE LocalBP MultiperspectivePerceptron64KB MultiperspectivePerceptron8KB MultiperspectivePerceptronTAGE64KB MultiperspectivePerceptronTAGE8KB TAGE TAGE_SC_L_64KB TAGE_SC_L_8KB TournamentBP)

yAxis=()
for testIndex in 0 1 2
do
    echo "Iteración ${xAxis[testIndex]}"
    (time $OPT -d "./${META_FOLDER_NAME}/m5out${testIndex}/"  $PY -c $BENCHMARK -o $ARGUMENT --cpu-type=$META_CPU_TYPE  --bp-type=${xAxis[testIndex]}  --caches --l2cache --l1d_size=256kB --l1i_size=256kB --l2_size=1MB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64) &> /dev/null 2>&1
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.predictedBranches/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done

{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer3.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}"
# cat ./testBP1/plotResult
#---------------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------------#

#Otras gráficas

yAxis=()
export META_XAXIS="Branch predictor"
export META_YAXIS="system.cpu.branchPred.condPredicted"
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 0 1 2
do
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.condPredicted/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer3.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot1"

#---------------------------------------------------------------------------------------------------------------------------------------------#
#Test2

yAxis=()
export META_XAXIS="Branch predictor"
export META_YAXIS="system.cpu.branchPred.condIncorrect"
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 0 1 2
do
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.condIncorrect/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer3.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot2"

#---------------------------------------------------------------------------------------------------------------------------------------------#
#Test3

yAxis=()
export META_XAXIS="Branch predictor"
export META_YAXIS="system.cpu.branchPred.indirectMisses"
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 0 1 2
do
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.indirectMisses/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer3.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot3"

#---------------------------------------------------------------------------------------------------------------------------------------------#
#Test4

yAxis=()
export META_XAXIS="Branch predictor"
export META_YAXIS="system.cpu.branchPred.indirectMispredicted"
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 0 1 2
do
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.indirectMispredicted/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer3.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot4"

#---------------------------------------------------------------------------------------------------------------------------------------------#
#Test5

yAxis=()
export META_XAXIS="Branch predictor"
export META_YAXIS="system.cpu.branchPred.BTBLookups"
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 0 1 2
do
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.BTBLookups/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer3.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot5"

#---------------------------------------------------------------------------------------------------------------------------------------------#
#Test6

yAxis=()
export META_XAXIS="Branch predictor"
export META_YAXIS="system.cpu.branchPred.BTBHits"
echo -e "${YELLOW}Iteración gráfica${NC}: ${META_YAXIS}"
for testIndex in 0 1 2
do
    yValue=$(cat "./${META_FOLDER_NAME}/m5out${testIndex}/stats.txt" | awk -F "=" '/system.cpu.branchPred.BTBHits/ {print $0}' | awk -F " " '{print $2}')
    yAxis[${#yAxis[@]}]="${yValue}"
done


{ echo "${xAxis[*]}"; echo "${yAxis[*]}"; } >./$META_FOLDER_NAME/plotResult
echo "Generando gráfico de prueba ${META_FOLDER_NAME}"
python3 viewer3.py --xtitle "${META_XAXIS}"  --ytitle "${META_YAXIS}" --xscale "log" --yscale "linear" --xbase 2 --ybase 10 --inputfolder "${META_WORK_DIR}" --graphName "plot6"

