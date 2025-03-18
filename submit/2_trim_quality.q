# Author: Aditya Bandla
#!/bin/bash
#PBS -N bbduk
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=96G
#PBS -l walltime=02:00:00
#PBS -j oe 
#PBS -J 1-14
#PBS -m abe 

## binaries
PATH=${HOME}/3_miniforge3/envs/bbmap/bin:${PATH}

## set project identifier and PATH to binaries
project=${HOME}/2_scratch/1_datasets/6_2024_sarawak_oil_palm
input=${PROJECT}/1_data/2_processed/1_adapter_trimmed

## adapter trimming
## set input and output directories
output=${project}/1_data/2_processed/2_quality_trimmed
mkdir -p ${output}

## loop through files and trim adapters
R1=$(find ${input} -mindepth 1 -maxdepth 1 | grep '_1_AT.fastq.gz' | sort | sed -n ${PBS_ARRAY_INDEX}p) 
R2=${R1/_1_AT/_2_AT}

bbduk.sh in=${R1} in2=${R2} out=${OUT}/$(basename ${R1/_1_AT/_1_QT}) out2=${OUT}/$(basename ${R2/_2_AT/_2_QT}) \
trimq=20 qtrim=rl minlen=75
