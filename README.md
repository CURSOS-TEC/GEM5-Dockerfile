## Referencia de Body track y GEM5

[Parsec Tutorial](https://gem5art.readthedocs.io/en/latest/tutorials/parsec-tutorial.html)
[Caracterización de Parsec](https://parsec.cs.princeton.edu/doc/parsec-report.pdf)
[Respositorio de Parsec 1](https://github.com/cirosantilli/parsec-benchmark)
## Comandos útiles: 

Estos comandos aplican para la imagen de gem5 en docker.

Listar los tipos de branch predictor disponibles:
``` bash 
/code/GEM5/gem5/build/X86/gem5.opt -d out_timing/ configs/example/se.py --list-bp-types
/code/GEM5/gem5/build/X86/gem5.opt -d out_timing/ configs/example/se.py --list-indirect-bp-types
```
Para establecer una branch predictor:

```bash 
build/X86/gem5.opt -d out_timing/ configs/example/se.py -c tests/test-progs/hello/bin/x86/linux/hello --cpu-type=TimingSimpleCPU --caches --bp-type=TournamentBP
```
