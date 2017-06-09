#!/bin/bash
# set -x
## USAGE: run.sh "/path/to/demultiplexing_output_dir" ["project_ID"]
## EXAMPLE: run.sh "/data/molecpathlab/170602_NB501073_0012_AHCKYCBGX2/Data/Intensities/BaseCalls/Unaligned"
## DESCRIPTION: This script will set up and create a report for NextSeq demultiplexing output


# ~~~~~ CHECK SCRIPT ARGS ~~~~~ #
if (( "$#" < "1" )); then
    echo "ERROR: Wrong number of arguments supplied"
    grep '^##' $0
    exit
fi


# ~~~~~ GET SCRIPT ARGS ~~~~~ #
demult_outdir="$1"
demult_outdir_linkname="Unaligned"
stats_dir="${demult_outdir}/Stats"
reports_dir="${demult_outdir}/Reports"

project_ID="${2:-""}"
demult_stat_file="Demultiplex_Stats.htm"
demult_report_template="demultiplexing_report.Rmd"


# ~~~~~ SET ENVIRONMENT ~~~~~ #
module unload pandoc
module load pandoc/1.13.1

compile_report () {
    local report_template="$1"
    local project_ID="$2"
    local compile_script="compile_RMD_report.R"

    if [ "$project_ID" != "" ]; then
        /bin/cp "${report_template}" "${project_ID}_${report_template}"
        local report_template="${project_ID}_${report_template}"
    fi

    ./${compile_script} $report_template
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
[ ! -L "$demult_outdir_linkname" ] && ln -s "$demult_outdir" "$demult_outdir_linkname"

# make sure it worked...
if [ ! -L "$demult_outdir_linkname" ]; then
    printf "ERROR: Item does not exists: %s\nExiting...\n\n" "$demult_outdir_linkname" && exit
elif [ ! -d "$demult_outdir_linkname" ]; then
    printf "ERROR: Item does not exists: %s\nExiting...\n\n" "$demult_outdir_linkname" && exit
fi

# check for existing Demultiplex_Stats.htm, and run
if [ -f "$demult_stat_file" ]; then
    compile_report "$demult_report_template" "$project_ID"
    exit
elif [ -L "$demult_stat_file" ]; then
    compile_report "$demult_report_template" "$project_ID"
    exit
elif [ -f "${demult_outdir_linkname}/${demult_stat_file}" ]; then
    # ln -fs "${demult_outdir_linkname}/${demult_stat_file}" "${demult_stat_file}"
    /bin/cp "${demult_outdir_linkname}/${demult_stat_file}" "${demult_stat_file}"
    compile_report "$demult_report_template" "$project_ID"
    exit
elif [ ! -f "${demult_outdir_linkname}/${demult_stat_file}" ]; then
    make_demult_html "$reports_dir" "${demult_outdir_linkname}/${demult_stat_file}"
    /bin/cp "${demult_outdir_linkname}/${demult_stat_file}" "${demult_stat_file}"
    compile_report "$demult_report_template" "$project_ID"
    exit
else
    printf "ERROR: Item could not be found: %s\n\n" "$demult_stat_file"
fi
