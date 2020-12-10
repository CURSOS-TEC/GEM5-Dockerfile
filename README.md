## Uso del marco de trabajo

1. Construir la imagen definida en el archivo Dockerfile. 
Esta imagen requiere que se pase como parámetro las llaves ssh asociadas al repositorio de github/gitlab. La imagen construida tiene tanto la configuración de GEM5 como la de PARSEC.
``` bash 
docker build -t gem5 --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"  .
```
2.  Crear un directorio que estára enlazado al volumen y que a su vez reflejará los cambios realizados dentro del contenedor en ejecución. Este directorio se llamará *sharedfolder*.
``` bash
mkdir <route>/sharedFolder
``` 
3. Ejecutar la imagen de forma interactiva creando un vínculo entre la carpeta creada y el sistema de archivos.
```bash
docker run -ti --rm -v  /home/junavarro/projects/tec/arqui1/p2/sharedData:/home/SharedData gem5 
```
4. Con el paso anterior se tendrá acceso a los archivos generados por las pruebas definidas en [parsecEXGEM5.sh](./scripts/parsecEXGEM5.sh)

5. Las carpetas *m5out<index>* tendran los resultados de cada prueba ejecutada.

## Comandos útiles: 

Estos comandos aplican para la imagen de gem5 en docker.

Listado de los procesadores disponibles:
```bash 
/code/GEM5/gem5/build/X86/gem5.opt /code/GEM5/gem5/configs/example/se.py -c /code/GEM5/gem5/tests/test-progs/hello/bin/x86/linux/hello --list-cpu-types
```

Listar los tipos de branch predictor disponibles:
``` bash 
/code/GEM5/gem5/build/X86/gem5.opt -d out_timing/ /code/GEM5/gem5/configs/example/se.py --list-bp-types
/code/GEM5/gem5/build/X86/gem5.opt -d out_timing/ /code/GEM5/gem5/configs/example/se.py --list-indirect-bp-types
```
Para establecer una branch predictor:

```bash 
build/X86/gem5.opt -d out_timing/ configs/example/se.py -c tests/test-progs/hello/bin/x86/linux/hello --cpu-type=TimingSimpleCPU --caches --bp-type=TournamentBP
```

Si se desea leer una línea de un archivo *stats.txt*, y que además dicha línea contenga parte del texto como consulta: i.e 
*system.cpu.dcache.overall_misses::total*

```bash
 cat  ./m5out/stats.txt  |  awk -F "=" '/system.cpu.dcache.overall_misses::total/ {print $0}'
``` 

Si se desea leer una línea del archivo de resultado *stats.txt*
``` bash 
sed -n 235p ./m5out4/stats.txt
``` 
Con 235 el número de línea a leer.


## Referencia de Body track y GEM5
1. [Parsec and GEM5 Tutorial](https://gem5art.readthedocs.io/en/latest/tutorials/parsec-tutorial.html)
2. [Caracterización de Parsec](https://parsec.cs.princeton.edu/doc/parsec-report.pdf)
3. [Respositorio de Parsec 1](https://github.com/cirosantilli/parsec-benchmark)
4. [Tipos de CPU disponibles en GEM5](https://www.gem5.org/documentation/general_docs/cpu_models/SimpleCPU)
5. [The PARSEC Benchmark Suite Tutorial](https://parsec.cs.princeton.edu/tutorial/)
6. [The PARSEC Benchmark Suite Tutorial PARSEC 3.0 -](https://parsec.cs.princeton.edu/download/tutorial/3.0/parsec-tutorial.pdf)
7. [A Characterization of the PARSEC Benchmark Suite for CMP Design](https://parsec.cs.princeton.edu/doc/cornell-report.pdf)
8. [Ocultar la salida de un output](https://askubuntu.com/questions/474556/hiding-output-of-a-command)
9. [Ciclo for en bash](https://www.cyberciti.biz/faq/bash-for-loop/)
10. [Guardar los datos de una gráfica de Python](https://futurestud.io/tutorials/matplotlib-save-plots-as-file)
11. [Exponenciación en Bash](https://stackoverflow.com/questions/13111967/raise-to-the-power-in-shell)
12. [Exponenciación en Bash 2](https://unix.stackexchange.com/questions/299321/bash-multiplication-and-addition)
13. [Agregar elementos en una array (bash)](https://linuxhint.com/bash_append_array/)
14. [Escribir un array en un archivo](https://unix.stackexchange.com/questions/220692/store-array-to-file-and-load-array-from-file-in-bash)
15. [Lectura de líneas a datos para graficar](https://stackoverflow.com/questions/38532298/how-can-you-plot-data-from-a-txt-file-using-matplotlib)
16. [Adjuntar líneas a un archivo](https://linuxize.com/post/bash-append-to-file/#:~:text=In%20Linux%2C%20to%20append%20text,operator%20or%20the%20tee%20command.)
17. [Colores al realizar un echo](https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux)
18. [Limpiar un archivo](https://superuser.com/questions/90008/how-to-clear-the-contents-of-a-file-from-the-command-line)
19. [Paso de Argumentos en python](https://www.datacamp.com/community/tutorials/argument-parsing-in-python?utm_source=adwords_ppc&utm_campaignid=1455363063&utm_adgroupid=65083631748&utm_device=c&utm_keyword=&utm_matchtype=b&utm_network=g&utm_adpostion=&utm_creative=332602034364&utm_targetid=dsa-429603003980&utm_loc_interest_ms=&utm_loc_physical_ms=1003674&gclid=CjwKCAiAq8f-BRBtEiwAGr3DgeljBg4CobDuam1_ojp_8vi5S33jyximOGDNVnXWpzbCgpKvbk1axhoCU0oQAvD_BwE)
20. [Esclas en matplot lib](https://matplotlib.org/3.1.1/gallery/pyplots/pyplot_scales.html)
21. [Escala del n-ésimo logaritmo para un eje en matplotlib](https://stackoverflow.com/questions/8887544/making-square-axes-plot-with-log2-scales-in-matplotlib)
22. [Array de strings to array of integer](https://www.codegrepper.com/code-examples/delphi/convert+string+array+to+int+array+python)
