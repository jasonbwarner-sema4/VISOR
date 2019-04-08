# VISOR

![alt text](VISOR.png)


VISOR is a tool written in python for haplotype-specific variants simulations.

## Requirements

VISOR requires a working python 3.6 environment and depends on the following python packages:

- pyfaidx (v 0.5.5.2)
- pybedtools (v 0.8.0)

Moreover, for simulations, VISOR requires working installations of:

- samtools (https://github.com/samtools/samtools)
- wgsim (https://github.com/lh3/wgsim)
- pbsim (https://github.com/pfaucon/PBSIM-PacBio-Simulator)
- bwa (https://github.com/lh3/bwa)
- minimap2 (https://github.com/lh3/minimap2)

They can all be installed in a python 3.6 environment using anaconda


## Install VISOR

```sh

git clone https://github.com/davidebolo1993/VISOR.git
cd VISOR
python setup.py install

```

## VISOR Submodules

VISOR is built on 3 submodules:

- __VISOR HACk__: generates .fa haplotypes with user-defined variants
- __VISOR SHORtS__: simulate double-strand or single-strand short-reads .bam files with variants
- __VISOR LASeR__: simulate long-reads .bam files with variants


## VISOR HACk

```sh
VISOR HACk -h #print help

VISOR HACk -g genome.fa -h1b bedh1.bed -O pathout #.bed file just for haplotype 1

VISOR HACk -g genome.fa -h1b bedh1.bed -h2b bedh2.bed -O pathout #.bed file for haplotype 1 and for haplotype 2

```

Inputs to VISOR HACk are:

- genome.fa is the reference genome in .fasta format
- bedh1.bed is the .bed file containing variants to insert in haplotype 1 (required), like the one in _Examples/HACk.h1.bed_
- bedh2.bed is the .bed file containing variants to insert in on haplotype 2 (optional), like the one in _Examples/HACk.h2.bed_

VISOR HACk outputs a fasta (.fa) file with specified variants for each haplotype in the output folder (pathout/haplotype1/h1.fa and pathout/haplotype2/h2.fa) 

#### Construct the .bed files

.bed files must contain 5 columns without header: __CHROMOSOME__, __START__, __END__, __ALT__, __INFO__

- __CHROMOSOME__: is the chromosome, in the format 'chrN'. Accepted chromosomes are chr1-chr22, chrX, chrY and chrM
- __START__: where the variant starts
- __END__: where the variant ends
- __ALT__: alt type. Possible alt types are 'deletion', 'insertion', 'inversion', 'duplication', 'snp', 'tr expansion', 'tr contraction', 'ptr', 'atr', 'translocation cut-paste', 'translocation copy-paste' (more details below)
- __INFO__: info for the alteration (more details below)


##### ALT FIELD

VISOR HACk allows users to generate different type of variants specified in the ALT field of the .bed files:

- __'deletion'__. Deletes from start (included) to end (included)
- __'insertion'__. Inserts a specific sequence immediately after end
- __'inversion'__. Inverts from start (included) to end (included)
- __'duplication'__. Duplicates from start (included) to end (included) immediately after end
- __'snp'__. Introduces a single nucleotide polimorphism in end
- __'tr expansion'__. Expands an existent tandem repetition. tr is meant to be one of the repetitions in microsatellites regions with START-END pair specified as in the _Examples/GRCh38.microsatellites.bed_ file of this repository (this example is for GRCh38)
- __'tr contraction'__. Contracts an existent tandem repetition. Works as described before
- __'ptr'__. Inserts a perfect tandem repetition immediately after end
- __'atr'__ Inserts a approximate tandem repetition immediately after end
- __'translocation cut-paste'__. Translocates from start (included) to end (included) to another region. Translocated region is deleted from original position
- __'translocation copy-paste'__. Translocates from start (included) to end (included) to another region. Translocated region is not deleted from original position
- __'reciprocal translocation'__. Translocates from start (included) to end (included) to another region and translocates the destination region back to the first one.


##### INFO FIELD

VISOR HACk requires some users-defined parameteres in the INFO field of the .bed files:

- INFO for __'deletion'__ must be __None__
- INFO for __'insertion'__ must be a valid DNA sequence of any length. Allowed chars are A,C,T,G,N
- INFO for __'inversion'__ must be __None__
- INFO for __'duplication'__ must be __number__; number is the number of time segment appears
- INFO for __'snp'__ must be __nuc__; nuc is the nucleotide that will be used to introduce the variant
- INFO for __'tr expansion'__ must be __motif:number__ motif is a valid DNA motif, number is number of motif to insert
- INFO for __'tr contraction'__ must be __motif:number__; motif is a valid DNA motif, number is number of motif to delete
- INFO for __'ptr'__ must be __motif:number__; motif motif is a valid DNA motif, number is number of motif to insert
- INFO for __'atr'__ must be __motif:number:altnum__; motif is a valid DNA motif, number is number of motif to insert, altnum is the number of alterations; alterations are randomly chosen from 'insertion','deletion','substitution' and each involves one nucleotide only
- INFO for __'translocation cut-paste'__ must be __haplotype:chromosome:breakpoint:orientation__; haplotype is the haplotype in which region will be translocated ('h1' or 'h2'), chromosome is the chromosome in which region will be translocated (chr1-22, chrX, chrY and chrM are allowed), breakpoint is the number of the base immediately after which translocated region will be put and orientation is the orientation of the sequence ('forward', if the orientation should be the same of the original region, or 'reverse', if the orientation should be inverted).
- INFO for __'translocation copy-paste'__ is the __same for 'translocation cut-paste'__
- INFO for __'reciprocal translocation'__ is the __haplotype:chromosome:start2:end2:orientation1:orientation2__; haplotype is the haplotype in which region will be translocated ('h1' or 'h2'), chromosome is the chromosome in which region will be translocated (chr1-22, chrX, chrY and chrM are allowed); start2 is the region start of the second translocated region; end2 is the region end of the second translocated region; orientation1 is the orientation of the first region ('forward', if the orientation should be the same of the original region, or 'reverse', if the orientation should be inverted) and orientation2 is the orientation of the second region.


## VISOR SHORtS and VISOR LASeR

```sh

VISOR SHORtS -h #print help

VISOR SHORtS -g genome.fa -h1f h1.fa -h2f h2.fa -h1b bedh1.bed -h2b bedh2.bed -O pathout #default double-strand sequencing simulations

VISOR LASeR -h #print help

VISOR LASeR -g genome.fa -h1f h1.fa -h2f h2.fa -h1b bedh1.bed -h2b bedh2.bed -O pathout #long-reads sequencing simulations

```

Inputs to VISOR SHORtS and VISOR LASeR are:

- genome.fa is the reference genome in .fasta format
- h1.fa is the haplotype 1 .fasta file generated by _VISOR HACk_
- h2.fa is the haplotype 2 .fasta file generated by _VISOR HACk_
- bedh1.bed is the .bed file containing regions to simulate from h1.fa, like the one in _Examples/SHORtS.LASeR.h1.h2.bed_
- bedh2.bed is the .bed file containing regions to simulate from h2.fa, like the one in _Examples/SHORtS.LASeR.h1.h2.bed_

.bed file must contain 4 columns without header: __CHROMOSOME__, __START__, __END__, __LABEL__

- __CHROMOSOME__: is the chromosome, in the format 'chrN'. Accepted chromosomes are chr1-chr22, chrX, chrY and chrM
- __START__: start position for the region that will be simulated
- __END__: end position for the region that will be simulated
- __LABEL__: label to identify the simulation results

VISOR SHORtS and VISOR LASeR outputs a .srt.bam file (and its index) for each region in the haplotype-specific .bed files. 


#### VISOR SHORtS and VISOR LASeR Simulations

Simulations for short-reads data are run using wgsim, most of which parameters can be specified by the user, bwa and samtools. Simulations for long-reads data are run using pbsim, most of which parameters can be specified by the user (the model_qc_clr file required is included in VISOR), minimap2 and samtools.


## VISOR SHORtS for single-strand (strand-seq) simulations

VISOR SHORtS can simulate single-strand (strand-seq) .bam files

```sh

VISOR SHORtS -h #print help

VISOR SHORtS -g genome.fa -h1f h1.fa -h2f h2.fa -h1b bedh1.bed -h2b bedh2.bed -t single-strand -c 2 -O pathout #single-strand simulations without noise

VISOR SHORtS -g genome.fa -h1f h1.fa -h2f h2.fa -h1b bedh1.bed -h2b bedh2.bed -t single-strand -c 2 -n 0.10 -O pathout #single-strand simulations with 0.10 % of read pairs with incorrect orientation

```

When working in single-strand mode (-t single-strand), for each region specified in the  haplotype-specific .bed files, VISOR outputs 2 .bam files: in the 'watson' .bam file, read 1 and read 2 pairs have all forward and reverse orientation respectively; in the 'crick' .bam file, read 1 and read 2 pairs have all reverse and forward orientation respectively. It is also possible to specify a percentage of noise (pairs with incorrect orientation) that will be included in the crick and watson .bam files using the -n parameter.

#### Plot read pairs count

When simulating haplotype-specific variants in single-strand simulations, one can re-create the possible inherited template strands in daughter cells by combining the watson or crick .bam file for haplotype 1 (W1 or C1) with  the watson or crick  one from haplotype 2 (W2 or C2):

- W1 and W2
- W1 and C2
- C1 and W2
- C1 and C2

VISOR/scripts/sscounter.py offers the possibility to plot an interactive visualization of the read pairs count for each strand from one or more of these combined .bam files:

```sh

python VISOR/scripts/sscounter.py -h #print help

python VISOR/scripts/sscounter.py -g genome.fa -bam .bam1 .bam2 .bam3 -O pathout #generate an .html that, for each chromosome,  compares read pairs count for watson and crick strands of the given .bam files
```
