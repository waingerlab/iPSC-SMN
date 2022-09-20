#!/bin/bash
#SBATCH -c 16                               # Request four cores
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-10:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=55G                          # Memory total in MB (for all cores)
#SBATCH -o /home/ah390/logs/%j.out                 # File to which STDOUT will be written, including job ID
#SBATCH -e /home/ah390/logs/%j.err                 # File to which STDERR will be written, including job ID

module load gcc/6.2.0
module load star/2.7.3a
module load samtools/1.13

cd /n/scratch3/users/a/ah390/MN_datasets
mkdir star_out_gff3

for var in PFN1G118V-MN-R1_R1_001.fastq.bz2 PFN1G118V-MN-R2_R1_001.fastq.bz2 PFN1G118V-MN-R3_R1_001.fastq.bz2 PFN1WT-MN-R1_R1_001.fastq.bz2 PFN1WT-MN-R2_R1_001.fastq.bz2 PFN1WT-MN-R3_R1_001.fastq.bz2 SOD1G85R-MN-R1_R1_001.fastq.bz2 SOD1G85R-MN-R2_R1_001.fastq.bz2 SOD1G85R-MN-R3_R1_001.fastq.bz2 SOD1WT-MN-R1_R1_001.fastq.bz2 SOD1WT-MN-R2_R1_001.fastq.bz2 SOD1WT-MN-R3_R1_001.fastq.bz2 TARDBPG298S-MN-R1_R1_001.fastq.bz2 TARDBPG298S-MN-R2_R1_001.fastq.bz2 TARDBPG298S-MN-R3_R1_001.fastq.bz2 TARDBPWT-MN-R1_R1_001.fastq.bz2 TARDBPWT-MN-R2_R1_001.fastq.bz2 TARDBPWT-MN-R3_R1_001.fastq.bz2
do
	filename1=${var}
	filename2=${var:0:end-16}R2_001.fastq.bz2
	filename3=${var:0:end-17}
	mkdir star_out_gff3/$filename3
	
	STAR --runThreadN 16 \
	--genomeDir /home/ah390/hg38_gencode/assembly100 \
	--readFilesIn reads/$filename1 reads/$filename2 \
	--readFilesCommand bunzip2 -c \
	--outFileNamePrefix star_out_gff3/$filename3/$filename3 \
	--quantMode GeneCounts \
	--outSAMtype BAM SortedByCoordinate \
	--limitBAMsortRAM 10000000000 \
	--sjdbGTFtagExonParentTranscript Parent \
	--genomeLoad LoadAndKeep
	
	cd star_out_gff3/$filename3
	samtools index ${var:0:end-17}Aligned.sortedByCoord.out.bam
	cd ../..
done

#load majiq stuff
cd /home/ah390/env
export PATH=/home/ah390/env/bin:$PATH
module load gcc/9.2.0
module load python/3.8.12
module load htslib/1.14

#Majiq analysis PFN1
cd /n/scratch3/users/a/ah390/MN_datasets/majiq_PFN1
cp /n/scratch3/users/a/ah390/MN_datasets/star_out_gff3/*/PFN1*bam* .

majiq build gencode.v40.annotation.gff3 --conf PFN1.ini --output ./build

mkdir psi
majiq psi -o psi -n ctrl build/PFN1WT*majiq
majiq psi -o psi -n pfn1g118v build/PFN1G118V*majiq

mkdir deltapsi
majiq deltapsi -o deltapsi -n ctrl pfn1g118v -grp1 build/PFN1WT*majiq -grp2 build/PFN1G118V*majiq

#Majiq analysis SOD1
cd /n/scratch3/users/a/ah390/MN_datasets/majiq_SOD1
cp /n/scratch3/users/a/ah390/MN_datasets/star_out_gff3/*/SOD1*bam* .

majiq build gencode.v40.annotation.gff3 --conf SOD1.ini --output ./build

mkdir psi
majiq psi -o psi -n ctrl build/SOD1WT*majiq
majiq psi -o psi -n sod1g85r build/SOD1G85R*majiq

mkdir deltapsi
majiq deltapsi -o deltapsi -n ctrl sod1g85r -grp1 build/SOD1WT*majiq -grp2 build/SOD1G85R*majiq

#Majiq analysis TARDBP
cd /n/scratch3/users/a/ah390/MN_datasets/majiq_TARDBP
cp /n/scratch3/users/a/ah390/MN_datasets/star_out_gff3/*/TARDBP*bam* .

majiq build gencode.v40.annotation.gff3 --conf TARDBP.ini --output ./build

mkdir psi
majiq psi -o psi -n ctrl build/TARDBPWT*majiq
majiq psi -o psi -n tardbpg298s build/TARDBPG298S*majiq

mkdir deltapsi
majiq deltapsi -o deltapsi -n ctrl tardbpg298s -grp1 build/TARDBPWT*majiq -grp2 build/TARDBPG298S*majiq