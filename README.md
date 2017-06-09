# demultiplexing-stats

Demultiplexing stats report designed for NextSeq output.

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

- Example:
```bash
./run.sh /production/170526_NB501073_0011_AHCJTYBGX2/Data/Intensities/BaseCalls/Unaligned/
```

# Software
- `R` (tested on version 3.3)
  - `ggplot2`
  - `XML`
  - `plyr`
  - `knitr`
- pandoc version 1.13+
- bash (test on version 4.1.2)
