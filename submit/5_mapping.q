## Author: Aditya Bandla
#!/bin/bash
#PBS -N map
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=96G
#PBS -l walltime=24:00:00
#PBS -J 1-14
#PBS -j oe
#PBS -m abe

## binaries
PATH=${HOME}/3_miniforge3/envs/bowtie2/bin:${PATH}

## input and output directories
dataset=6_2024_sarawak_oil_palm
project=${HOME}/2_scratch/1_datasets/${dataset}
input=${project}/1_data/2_processed/2_quality_trimmed

output=${project}/1_data/2_processed/4_coverage/1_single_sample/2_alignments
index=${project}/1_data/2_processed/4_coverage/1_single_sample/1_index/swkopp_ssa_contigs

## create sample output directory
sample=$(find ${input} -type f -printf '%f\n' | cut -d '_' -f 1 | sort -u | sed -n ${PBS_ARRAY_INDEX}p)

## libraries
R1=$(find ${input} -type f | grep -E ${sample} | grep -e '_1.' )
R2=${R1/_1/_2}

## map reads
bowtie2 -x ${IDX} -1 ${R1} -2 ${R2} -X 1000 --seed 11001712 \
    --no-unal -p 24 2> ${output}/${sample}_stats.txt | \
    samtools sort -o ${output}/${sample}.bam -@ 24
