all: install_packages data-preparation analysis

install_packages:
	make -C install_packages
	
analysis:
	make -C src/analysis 

data-preparation:
	make -C src/data-preparation

clean:
	R -e "unlink('gen/temp/*.tsv*')"