## Author: Aditya Bandla
#!/bin/bash
#PBS -N vamb
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=120G:ngpus=1
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -m abe

## set PATH to binaries
PATH=${HOME}/3_miniforge3/envs/vamb/bin:${PATH}

## set input and output directories
dataset=6_2024_sarawak_oil_palm
project=${HOME}/2_scratch/1_datasets/${dataset}
data=${project}/1_data/2_processed

input=${data}/3_assembly
coverage=${data}/4_coverage/1_single_sample
output=${data}/5_binning/1_single_sample

## run vamb
vamb bin default \
  --outdir ${output}/2_vamb --fasta ${input}/swkopp_ssa_contigs.fa \
  --bamdir ${coverage}/2_alignments/ \
  -o "_contig" \
  --minfasta 500000 \
  -z 0.95 \
  -p 48 \
  --cuda
