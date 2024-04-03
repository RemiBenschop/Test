TEMP = ../../gen/temp/

$(TEMP)movies_data.tsv: $(TEMP)Basics.tsv.gz $(TEMP)Ratings.tsv.gz
	R --vanilla < Cleaning_data.R

$(TEMP)Basics.tsv.gz $(TEMP)Ratings.tsv.gz: Download_data.R
	R --vanilla < Download_data.R

clean:
	R -e "unlink('$(TEMP)*.tsv*')"