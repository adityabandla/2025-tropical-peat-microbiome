## Author: Aditya Bandla
#!/bin/bash
#PBS -N cutadapt
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=96G
#PBS -l walltime=02:00:00
#PBS -j oe 
#PBS -J 1-14
#PBS -m abe 

## binaries
PATH=${HOME}/3_miniforge3/envs/cutadapt/bin:${PATH}

## set project identifier and PATH to binaries
PROJECT=${HOME}/2_scratch/1_datasets/6_2024_sarawak_oil_palm
INP=${PROJECT}/1_data/1_raw

## adapter trimming
## set input and output directories
OUT=${PROJECT}/1_data/2_processed/1_adapter_trimmed
mkdir -p ${OUT}

## loop through files and trim adapters
R1=$(find ${INP} -mindepth 1 -maxdepth 1 | grep '_1.fastq.gz' | sort | sed -n ${PBS_ARRAY_INDEX}p) 
R2=${R1/_1/_2}

cutadapt -a AGATCGGAAGAGC -A AGATCGGAAGAGC -e 0.2 -O 3 -n 1 -m 75 --max-n 0 --no-indels -j 24 \
-o ${OUT}/$(basename ${R1/_1/_1_AT}) \
-p ${OUT}/$(basename ${R2/_2/_2_AT}) \
${R1} ${R2}
