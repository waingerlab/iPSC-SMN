#!/bin/bash
#SBATCH -c 1                               # Request four cores
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-00:02                         # Runtime in D-HH:MM format
#SBATCH -p short                          # Partition to run in
#SBATCH --mem=4G                          # Memory total in MB (for all cores)
#SBATCH -o /home/ah390/logs/%j.out                 # File to which STDOUT will be written, including job ID
#SBATCH -e /home/ah390/logs/%j.err                 # File to which STDERR will be written, including job ID

cd /n/scratch3/users/a/ah390/krach2018

module load gcc/6.2.0
module load samtools/1.13
module load bedtools/2.27.1

for ((n=74;n<=94;n++)); do
	filename1=SRX14943${n}
	filename2=${filename1}Aligned.sortedByCoord.out.bam
	samtools view -h $filename2 chr7:44222109-44224043 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/camk2b.bed -b stdin>${filename1}.txt
	samtools view -h $filename2 chr12:88086641-88086850 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/cep290.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr3:124700976-124701256 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/kalrn.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr20:63442406-63442531 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/kcnq2.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr14:60817918-60817950 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/mnat1.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr1:21598717-21599118 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/rap1gap.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr7:45735602-45735680 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/sept7p2.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr3:9468576-9468639 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/setd5.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr8:79616821-79617032 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/stmn2.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr6:152247823-152247946 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/syne1.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr11:61547530-61547623 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/syt7.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr2:3457793-3458514 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/trappc12.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr7:98881695-98881736 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/trrap.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr19:17642414-17642591 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/unc13a.bed -b stdin>>${filename1}.txt
done

cd /n/scratch3/users/a/ah390/brown2022/star_out/

for var in ERR*; do
	filename1=${var}
	filename2=${filename1}/${filename1}Aligned.sortedByCoord.out.bam
	samtools view -h $filename2 chr7:44222109-44224043 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/camk2b.bed -b stdin>${filename1}.txt
	samtools view -h $filename2 chr12:88086641-88086850 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/cep290.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr3:124700976-124701256 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/kalrn.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr20:63442406-63442531 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/kcnq2.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr14:60817918-60817950 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/mnat1.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr1:21598717-21599118 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/rap1gap.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr7:45735602-45735680 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/sept7p2.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr3:9468576-9468639 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/setd5.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr8:79616821-79617032 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/stmn2.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr6:152247823-152247946 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/syne1.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr11:61547530-61547623 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/syt7.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr2:3457793-3458514 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/trappc12.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr7:98881695-98881736 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/trrap.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr19:17642414-17642591 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/unc13a.bed -b stdin>>${filename1}.txt
done

cd /n/scratch3/users/a/ah390/Genewiz2021/star_out/

for var in *; do
	filename1=${var}
	filename2=${filename1}/${filename1}Aligned.sortedByCoord.out.bam
	samtools view -h $filename2 chr7:44222109-44224043 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/camk2b.bed -b stdin>${filename1}.txt
	samtools view -h $filename2 chr12:88086641-88086850 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/cep290.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr3:124700976-124701256 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/kalrn.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr20:63442406-63442531 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/kcnq2.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr14:60817918-60817950 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/mnat1.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr1:21598717-21599118 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/rap1gap.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr7:45735602-45735680 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/sept7p2.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr3:9468576-9468639 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/setd5.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr8:79616821-79617032 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/stmn2.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr6:152247823-152247946 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/syne1.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr11:61547530-61547623 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/syt7.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr2:3457793-3458514 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/trappc12.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr7:98881695-98881736 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/trrap.bed -b stdin>>${filename1}.txt
	samtools view -h $filename2 chr19:17642414-17642591 | samtools sort | bedtools coverage -F 0.5 -counts -a /n/scratch3/users/a/ah390/bed_files/unc13a.bed -b stdin>>${filename1}.txt
done
