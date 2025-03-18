## Author: Aditya Bandla
#!/bin/bash
#PBS -N filter
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=96G
#PBS -l walltime=06:00:00
#PBS -j oe 
#PBS -m abe 
#PBS -M abandla@nus.edu.sg

## binaries
dataset=6_2024_sarawak_oil_palm
project=${HOME}/2_scratch/1_datasets/${dataset}
PATH=${PATH}:${HOME}/miniforge3/envs/bbmap/bin

## input and metadata directories
input=${project}/1_data/2_processed/3_assembly/1_single_sample

## filter and rename
for directory in $(find ${input} -mindepth 1 -maxdepth 1 | sort) ; do
sample=$(basename  $directory)

prefix=SWKOPP
rename.sh in=${directory}/final.contigs.fa out=${input}/${sample}_contigs.fa \
prefix=${prefix}_${sample}_contig minscaf=2500
done
