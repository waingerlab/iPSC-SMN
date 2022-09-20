#!/bin/bash
#SBATCH -c 1                               # Request four cores
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 1-00:00                         # Runtime in D-HH:MM format
#SBATCH -p medium                           # Partition to run in
#SBATCH --mem=4G                          # Memory total in MB (for all cores)
#SBATCH -o /home/ah390/logs/%j.out                 # File to which STDOUT will be written, including job ID
#SBATCH -e /home/ah390/logs/%j.err                 # File to which STDERR will be written, including job ID

cd /n/scratch3/users/a/ah390/krach2018

module load gcc/6.2.0
module load sratoolkit/2.9.0

#this takes about 15-20 mins per 2GB file
fastq-dump --split-files --bzip2 SRX1494374
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494375
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494376
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494377
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494378
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494379
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494380
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494381
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494382
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494383
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494384
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494385
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494386
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494387
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494388
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494389
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494390
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494391
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494392
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494393
rm /home/ah390/ncbi/public/sra/*.sra
fastq-dump --split-files --bzip2 SRX1494394
rm /home/ah390/ncbi/public/sra/*.sra


