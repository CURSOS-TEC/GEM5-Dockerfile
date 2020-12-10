# Este comando instala todos los script de pruebas de  parsec. 
# make install sharedDataDir=/home/junavarro/projects/tec/arqui1/p2/sharedData
all: 

install:
		cp ./scripts/*.sh $(sharedDataDir)
		cp ./scripts/*.py $(sharedDataDir)