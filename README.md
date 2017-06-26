# demultiplexing-stats

Demultiplexing stats report designed for NextSeq output.

__[[ A full HTML version of the report can be previewed [here](https://cdn.rawgit.com/NYU-Molecular-Pathology/demultiplexing-stats/b473a6a1b0a1b5a59b667495f39c8bb8fbae43bb/SampleRun_demultiplexing_report.html) or [here](http://htmlpreview.github.io/?https://github.com/NYU-Molecular-Pathology/demultiplexing-stats/blob/b473a6a1b0a1b5a59b667495f39c8bb8fbae43bb/SampleRun_demultiplexing_report.html). ]]__

# Usage

Clone this repository:

```bash
git clone https://github.com/NYU-Molecular-Pathology/demultiplexing-stats.git
```

Change to the repo directory:

```bash
cd demultiplexing-stats/
```

Run the `run.sh` script:
```bash
./run.sh /path/to/demultiplexing_output_dir
```

- Example command:
```bash
./run.sh /production/170526_NB501073_0011_AHCJTYBGX2/Data/Intensities/BaseCalls/Unaligned/
```

## Example Output

A full demonstration of the report template usage can be found in the `demo` branch [here](https://github.com/NYU-Molecular-Pathology/demultiplexing-stats/tree/demo); you can try it by running the following commands:

- Clone this repo if you haven't already, and switch to the `demo` branch

```bash
git clone https://github.com/NYU-Molecular-Pathology/demultiplexing-stats.git
cd demultiplexing-stats
git checkout demo
```

- Demo data is in the `test` directory. Compile the script with it:
```bash
./run.sh test/ SampleReport
```

- Report output can be found in the `SampleReport_demultiplexing_report.html` file, and can be previewed [here](https://cdn.rawgit.com/NYU-Molecular-Pathology/demultiplexing-stats/b473a6a1b0a1b5a59b667495f39c8bb8fbae43bb/SampleRun_demultiplexing_report.html) or [here](http://htmlpreview.github.io/?https://github.com/NYU-Molecular-Pathology/demultiplexing-stats/blob/b473a6a1b0a1b5a59b667495f39c8bb8fbae43bb/SampleRun_demultiplexing_report.html)



# Software
- `R` (tested on version 3.3)
  - `ggplot2`
  - `XML`
  - `plyr`
  - `knitr`
- pandoc version 1.13+
- bash (test on version 4.1.2)
