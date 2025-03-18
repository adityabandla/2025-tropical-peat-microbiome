## Author: Aditya Bandla
#!/bin/bash
#PBS -N semibin2
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=96G:ngpus=1
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -J 1-14
#PBS -m abe

## set PATH to binaries
export OPENBLAS_NUM_THREADS=64
PATH=${HOME}/3_miniforge3/envs/semibin2/bin:${PATH}

## set input and output directories
dataset=6_2024_sarawak_oil_palm
project=${HOME}/2_scratch/1_datasets/${dataset}
data=${project}/1_data/2_processed

assembly=${data}/3_assembly
coverage=${data}/4_coverage/1_single_sample/2_alignments
results=${data}/5_binning/1_single_sample/3_semibin2

## run semibin2
SemiBin2 generate_sequence_features_multi \
    -i ${assembly}/swkopp_ssa_contigs.fa \
    -b ${coverage}/*.bam \
    -o ${results} \
    --separator _contig

sample=$(find ${INP}/1_single_sample -maxdepth 1 -type f -printf '%f\n' | sed 's/\(.*\)_.*/\1/' | sort -u | sed -n ${PBS_ARRAY_INDEX}p)
SemiBin2 train_self \
    --data ${results}/samples/SWKOPP_${sample}/data.csv \
    --data-split ${results}/samples/SWKOPP_${sample}/data_split.csv \
    --output ${results}/train/${sample} \
    --engine GPU \
    --tmpdir ${results}/tmp 

SemiBin2 bin_short \
  -i ${results}/samples/SWKOPP_${sample}.fa \
  --model ${results}/train/${sample}/model.pt \
  --data ${results}/samples/SWKOPP_${sample}/data.csv \
  -o ${results}/bins/${sample} \
  --tmpdir ${results}/bins/tmp \
  --tag-output ${sample}_semibin2 \
  --compression none \
  --verbose
