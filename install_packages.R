# find all source code files in (sub)folders
files <- list.files(pattern='[.](R|rmd)$', all.files=T, recursive=T, full.names = T, ignore.case=T)

# read in source code
code=unlist(sapply(files, scan, what = 'character', quiet = TRUE))

# retain only source code starting with library
code <- code[grepl('^library', code, ignore.case=T)]
code <- gsub('^library[(]', '', code)
code <- gsub('[)]', '', code)
code <- gsub('^library$', '', code)

# retain unique packages
uniq_packages <- unique(code)

# kick out "empty" package names
uniq_packages <- uniq_packages[!uniq_packages == ''] 

# order alphabetically
uniq_packages <- uniq_packages[order(uniq_packages)] 

cat('Required packages: \n')
cat(paste0(uniq_packages, collapse= ', '),fill=T)
cat('\n\n\n')

# retrieve list of already installed packages
installed_packages <- installed.packages()[, 'Package']

# identify missing packages
to_be_installed <- setdiff(uniq_packages, installed_packages)

if (length(to_be_installed)==length(uniq_packages)) cat('All packages need to be installed.\n')
if (length(to_be_installed)>0) cat('Some packages already exist; installing remaining packages.\n')
if (length(to_be_installed)==0) cat('All packages installed already!\n')

# install missing packages
if (length(to_be_installed)>0) install.packages(to_be_installed, repos = 'https://cloud.r-project.org')

cat('\nDone!\n\n')

# tested