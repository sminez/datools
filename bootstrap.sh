#! /bin/bash

# TODO:: look at the following
# https://github.com/google/crush-tools
# http://search.cpan.org/~dkogan/feedgnuplot-1.41/bin/feedgnuplot

# Install useful utilities
sudo apt-get install npm python3-pip docker.io

#######################
# .: Install tools :. #
#######################
# Binary :: jq
# Use    :: awk for json
# Docs   :: https://stedolan.github.io/jq/manual/
sudo apt-get install jq


# Binary :: j2v    (Changed from default)
# Use    :: convert json to csv format (can flatten nested structures)
# Docs   :: https://github.com/zemirco/json2csv#command-line-interface
sudo npm install json2csv --save -g
# Need to edit the shebang to point at /usr/bin/nodejs
sed -i 's:#! /usr/bin/env node:#! /usr/bin/nodejs:' /usr/local/bin/json2csv
mv /usr/local/bin/json2csv /usr/local/bin/j2v


# Binaries :: in2csv, sql2csv, csvclean, csvcut, csvgrep, csvsql, csvjson,
#             csvstat, csvjoin, csvstack, csvformat, csvpy, csvlook
# Use      :: General data munging with csv files
# Docs     :: https://csvkit.readthedocs.io/en/1.0.1/
sudo python3 -m pip install csvkit


# Binary :: docker, sen
# Use    :: monitor and manage Docker
# Docs   :: https://github.com/TomasTomecek/sen
sudo python3 -m pip install urwid
sudo python3 -m pip install sen


# Binary :: pv
# Use    :: cat with a progress bar (monitor progress in a pipeline)
# Docs   :: http://www.ivarch.com/programs/pv.shtml
sudo apt-get install pv


# Binary :: gnuplot
# Use    :: quick plotting of data (see 'plot' in /scripts)
# Docs   :: http://www.gnuplot.info/
sudo apt-get install gnuplot
