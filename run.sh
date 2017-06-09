#!/bin/bash

## USAGE: run.sh "/path/to/demultiplexing_output_dir"
## EXAMPLE: run.sh "/data/molecpathlab/170602_NB501073_0012_AHCKYCBGX2/Data/Intensities/BaseCalls/Unaligned"
## DESCRIPTION: This script will set up and create a report for NextSeq demultiplexing output


# ~~~~~ CHECK SCRIPT ARGS ~~~~~ #
if (( "$#" != "1" )); then
    echo "ERROR: Wrong number of arguments supplied"
    grep '^##' $0
    exit
fi


# ~~~~~ GET SCRIPT ARGS ~~~~~ #
demult_outdir="$1" 
demult_outdir_linkname="Unaligned"
stats_dir="${demult_outdir}/Stats"
reports_dir="${demult_outdir}/Reports"
demult_stat_file="Demultiplex_Stats.htm"


# ~~~~~ SET ENVIRONMENT ~~~~~ #
module unload pandoc
module load pandoc/1.13.1

compile_report () {
    local compile_script="compile_RMD_report.R"
    local report_template="demultiplexing_report.Rmd"
    $compile_script $report_template
}

make_demult_html () {
    local reports_dir="$1"
    local demult_stat_file="$2"
    cat ${reports_dir}/html/*/all/all/all/laneBarcode.html | grep -v "href=" > "${demult_stat_file}"
    
}




# ~~~~~ FIND REQUIRED ITEMS ~~~~~ #
# check for dirs
[ ! -e "$demult_outdir" ] && printf "ERROR: Item does not exists: %s\nExiting...\n\n" "$$demult_outdir" && exit
[ ! -d "$stats_dir" ] && printf "ERROR: Item does not exists: %s\nExiting...\n\n" "$stats_dir" && exit
[ ! -d "$reports_dir" ] && printf "ERROR: Item does not exists: %s\nExiting...\n\n" "$reports_dir" && exit

# link to the demult outdir
[ ! -l "$demult_outdir_linkname" ] && ln -s "$demult_outdir" "$demult_outdir_linkname"

# make sure it worked...
if [ ! -l "$demult_outdir_linkname" ]; then
    printf "ERROR: Item does not exists: %s\nExiting...\n\n" "$demult_outdir_linkname" && exit
elif [ ! -d "$demult_outdir_linkname" ]; then
    printf "ERROR: Item does not exists: %s\nExiting...\n\n" "$demult_outdir_linkname" && exit
fi

# check for existing Demultiplex_Stats.htm, and run
if [ -f "$demult_stat_file" ]; then
    compile_report
    exit
elif [ -l "$demult_stat_file" ]; then
    compile_report
    exit
elif [ -f "${demult_outdir_linkname}/${demult_stat_file}" ]; then
    # ln -fs "${demult_outdir_linkname}/${demult_stat_file}" "${demult_stat_file}"
    /bin/cp "${demult_outdir_linkname}/${demult_stat_file}" "${demult_stat_file}"
    compile_report
    exit
elif [ ! -f "${demult_outdir_linkname}/${demult_stat_file}" ]; then
    make_demult_html "$reports_dir" "${demult_outdir_linkname}/${demult_stat_file}"
    /bin/cp "${demult_outdir_linkname}/${demult_stat_file}" "${demult_stat_file}"
    compile_report
    exit
else
    printf "ERROR: Item could not be found: %s\n\n" "$demult_stat_file"
fi