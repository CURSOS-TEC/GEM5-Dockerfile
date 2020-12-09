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



## Referencia de Body track y GEM5

1. [Parsec Tutorial](https://gem5art.readthedocs.io/en/latest/tutorials/parsec-tutorial.html)
2. [Caracterización de Parsec](https://parsec.cs.princeton.edu/doc/parsec-report.pdf)
3. [Respositorio de Parsec 1](https://github.com/cirosantilli/parsec-benchmark)
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


