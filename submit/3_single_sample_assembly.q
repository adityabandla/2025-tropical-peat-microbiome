# Author: Aditya Bandla
#!/bin/bash
#PBS -N megahit
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=120G
#PBS -l walltime=24:00:00
#PBS -j oe 
#PBS -m abe 
#PBS -M abandla@nus.edu.sg

## binaries
PATH=${HOME}/3_miniforge3/envs/megahit/bin:${PATH}

## set project identifier and PATH to binaries
dataset=6_2024_sarawak_oil_palm
project=${HOME}/2_scratch/1_datasets/${dataset}
input=${project}/1_data/2_processed/2_quality_trimmed

## adapter trimming
## set input and output directories
output=${project}/1_data/2_processed/3_assembly/1_single_sample
mkdir -p ${output}

## loop through files and trim adapters
R1=$(find ${input} -mindepth 1 -maxdepth 1 | grep '_1_QT.fastq.gz' | sort | sed -n ${PBS_ARRAY_INDEX}p) 
R2=${R1/_1_QT/_2_QT}
SAMPLE=$(basename ${R1} _1_QT.fastq.gz)

## assemble
megahit -1 ${R1} -2 ${R2} -o ${OUT}/${SAMPLE} --presets meta-large
