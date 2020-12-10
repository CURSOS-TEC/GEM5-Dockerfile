# Este script de python toma como parámetro un archivo de resultados 
# y genera una gráfica con los datos obtenidos. La leyenda del gŕafico es tomado 
# del archivo metadatas.txt. Genera un archivo vectorial con el gráfico generado.

import sys
import matplotlib.pyplot as plt

if(len(sys.argv)< 2):
    print('Usage: python3 viewer.py path/to/test/folder ')
else:
    # se obtiene el nombre del archivo
    with open("{}/plotResult".format(sys.argv[1])) as f:
        lines = f.readlines()
        x = lines[0].split(' ') # se obtiene los valores de la primera línea x
        x = list(map(int,x)) 
        y = lines[1].split(' ') # se obtiene los valores de la segunda línea y
        y = list(map(int,y)) 
        plt.plot(x, y, color="#6c3376", linewidth=3)  
        plt.xlabel('XAxis')  
        plt.ylabel('yAxis')
        plt.xscale('log', base=2)  
        plt.yscale('linear')  
        plt.savefig("plot.svg")