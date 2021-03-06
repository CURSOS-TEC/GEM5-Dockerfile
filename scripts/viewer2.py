# Este script de python toma como parámetro un archivo de resultados 
# y genera una gráfica con los datos obtenidos. La leyenda del gŕafico es tomado 
# del archivo metadatas.txt. Genera un archivo vectorial con el gráfico generado.

import sys
import getopt
import matplotlib.pyplot as plt



def main(argv):
    try:
        opts, args = getopt.getopt(argv,"hxt:yt:xs:ys:xb:yb:if:g",["xtitle=","ytitle=","xscale=", "yscale=","xbase=", "ybase=", "inputfolder=", "graphName="]) 
    except getopt.GetoptError:
        print('python3 viewer.py --xtitle <xAxis>  --ytitle <yAxis> --xscale <linear|log> --yscale <linear|log> --xbase <10|2> --ybase <10|2> --inputfolder <./test1/> ')
        sys.exit(2)
    xAxisTitle = 'xAxis'
    yAxisTitle = 'yAxis'
    xScale = 'log'
    xScaleBase = 2
    yScale = 'linear'
    yScaleBase = 10
    resultFile = ""
    svgPlotFile = ""
    filePrefix = ""
    graphName = ""
    pathFolder= ""
    for opt, arg in opts:
        #print(opt,arg)
        if opt in ("-xt", "--xtitle"):
            xAxisTitle = arg
        elif opt in ("-yt", "--ytitle"):
            yAxisTitle = arg
        elif opt in ("-g", "--graphName"):
            print(arg)
            graphName = arg
        elif opt in ("-xs", "--xscale"):
            xScale = arg
        elif opt in ("-ys", "--xbase"):
            xScaleBase = int(arg)
        
        elif opt in ("-xb", "--yscale"):
            yScale = arg
        elif opt in ("-yb", "--ybase"):
            yScaleBase = int(arg)

        elif opt in ("-if", "--inputfolder"):
            pathFolder = arg
            resultFile = "{}/plotResult".format(arg)
        else:
            print('Unknown param')
            sys.exit(1)
    svgPlotFile = "{}/{}.svg".format(pathFolder,graphName)
    print(svgPlotFile)
    print(resultFile)
    # se obtiene el nombre del archivo y demás variables
  
    with open(resultFile) as f:
        lines = f.readlines()
        x = lines[0].split(' ') # se obtiene los valores de la primera línea x
        x = list(map(float,x)) 
        y = lines[1].split(' ') # se obtiene los valores de la segunda línea y
        y = list(map(float,y)) 
        plt.plot(x, y, color="#6c3376", linewidth=3)  
        plt.xlabel(xAxisTitle)  
        plt.ylabel(yAxisTitle)
        plt.tight_layout()
        if(xScale != 'linear' ):
            plt.xscale(xScale, base=int(xScaleBase))
        else:   
            plt.xscale('linear')

        if(yScale != 'linear' ):
            plt.yscale(yScale, base=int(yScaleBase))
        else:   
            plt.yscale('linear') 

        plt.savefig(svgPlotFile)
        print(x)
        print(y)
if __name__ == "__main__":
   main(sys.argv[1:])