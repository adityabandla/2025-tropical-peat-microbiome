## Author: Aditya Bandla
#!/bin/bash
#PBS -N metabat2
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=96G
#PBS -l walltime=24:00:00
#PBS -J 1-14
#PBS -j oe
#PBS -m abe

## set PATH to binaries
PATH=${HOME}/3_miniforge3/envs/metabat2/bin:${PATH}

## set input and output directories
dataset=6_2024_sarawak_oil_palm
project=${HOME}/2_scratch/1_datasets/${dataset}
data=${PROJECT}/1_data/2_processed

input=${data}/3_assembly/1_single_sample
depth=${data}/4_coverage/1_single_sample/3_depth_metabat2
output=${data}/5_binning/1_single_sample

## sample and build bin directory
sample=$(find ${input} -maxdepth 1 -type f -printf '%f\n' | sed 's/\(.*\)_.*/\1/' | sort -u | sed -n ${PBS_ARRAY_INDEX}p)
bin=${output}/${sample}/1_metabat2 && mkdir -p ${bin}

## pick all the necessary files
contig=$(find ${input} -maxdepth 1 | grep '_contigs.fa'| grep ${sample})
coverage=$(find ${depth} -maxdepth 1 | grep '_depth_metabat2' | grep ${sample})

# Run metabat2
metabat2 --seed 11001712 -i ${contig} -a ${coverage} -o ${bin}/${sample}_metabat2
