## This script loads, analyzes, and plots RNAseq differential expression

setwd("C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons")

library(readxl) #loads library for reading excel files
library(tidyverse) #loads tidyverse library
library(DESeq2) #loads DESeq2

#import dataset
genecounts <- read_excel("C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/All_MNs.xlsx", sheet =1, col_names = TRUE) #loads data from excel
genecounts <- as.data.frame(genecounts) #turns tibble output from above into data.frame
rownames(genecounts) <- genecounts[,1] #makes first column into rownames
genecounts$Gene_Name <- NULL #removes the Gene_name column (rownames have this info)

#make DESeqDataSet, needs matrix of conditions to organize comparisons
condition <- read_excel("C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/All_MNs.xlsx", sheet =2, col_names = TRUE) #loads data from excel
condition <-as.data.frame(condition)
rownames(condition) <- condition[,1] #makes first column into rownames
condition$Library <- NULL #removes the Gene_name column (rownames have this info)

dds <- DESeqDataSetFromMatrix(countData = genecounts, colData = condition, design = ~Gene+Disease)

#differential expression
de <- DESeq(dds)
res <- results(de)

write.csv(as.data.frame(res),file='C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/All_MN_DE.csv')

rlogcounts = rlog(dds,blind=FALSE) #DESeq2 normalization that log2 transforms and scales for library size
rlogcountstable = assay(rlogcounts)

write.csv(rlogcountstable, file="F:/Wainger_Lab/RNA_seq/RNASeq Tutorial/Kiskinis_rlog.csv")

#PCA
plotPCA(rlogcounts, intgroup='Gene') #plotting using plotPCA

## volcano plot of data (from https://www.biostars.org/p/282295/)
topT <- as.data.frame(res)
editedtopT = topT %>% mutate(correctfc = log2FoldChange*-1)

with(editedtopT,plot(correctfc, -log10(padj),pch=20,xlab="log2(fold change)",ylab="-log10(padj)",xlim=c(-8,8),ylim=c(0,50)))
with(subset(editedtopT, padj<0.05 & abs(correctfc)>1), points(correctfc, -log10(padj), pch=20, col='red',cex=0.5))
points(editedtopT["UNC13A","correctfc"],-log10(editedtopT["UNC13A","padj"]),pch=20,col='blue',cex=1.2)
points(editedtopT["STMN2","correctfc"],-log10(editedtopT["STMN2","padj"]),pch=20,col='green',cex=1.2)
points(editedtopT["KCNQ2","correctfc"],-log10(editedtopT["KCNQ2","padj"]),pch=20,col='yellow',cex=1.2)

#Adding lines for thresholds
abline(v=0,col='black',lty=3,lwd=1.0)
abline(v=-1,col='black',lty=4,lwd=2.0)
abline(v=1,col='black',lty=4,lwd=2.0)
abline(h=-log10(max(topT$padj[topT$padj<0.05], na.rm=TRUE)),col='black', lty=4, lwd=2)

xtick<-seq(-8,8, by=2)
axis(side=1, at=xtick,labels = TRUE)

#adds labels to selected genes
gn.selected <- abs(res$log2FoldChange) > 2 & res$padj < 1e-7 #above fold change, below padj value
text(res$log2FoldChange[gn.selected], -log10(res$padj)[gn.selected],lab=rownames(res)[gn.selected], cex=0.6)

## heatmap plot of matrix counts (in part from https://bioinformatics-core-shared-training.github.io/cruk-summer-school-2018/RNASeq2018/html/02_Preprocessing_Data.nb.html)
library(pheatmap)

countVar <- apply(rlogcountstable, 1, var) #get variance of each row
highVar <- order(countVar, decreasing=TRUE)[1:250] #find top 250 most variable genes
hmDat <- rlogcountstable[highVar,] #pull top 250 most variable genes

pheatmap(hmDat, cluster_rows=TRUE, show_rownames = FALSE, cluster_cols=TRUE)

## heatmap of differentially expressed genes
degenes <- read_excel("C:/Data/Wainger_Lab/RNA/RNAseq2021/All_Astro.xlsx", sheet =4, col_names = TRUE) #loads data from excel
degenes <- as.data.frame(degenes) #turns tibble output from above into data.frame
rownames(degenes) <- degenes[,1] #makes first column into rownames
degenes$Gene_Name <- NULL #removes the Gene_name column (rownames have this info)

degenes = degenes[1:2982,]

pheatmap(degenes, cluster_rows=TRUE, show_rownames = FALSE, cluster_cols=TRUE)

## looking at individual pairs
#PFN1
genecounts <- read_excel("C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/MN_Pairs.xlsx", sheet =2, col_names = TRUE) #loads data from excel
genecounts <- as.data.frame(genecounts) #turns tibble output from above into data.frame
rownames(genecounts) <- genecounts[,1] #makes first column into rownames
genecounts$Gene_Name <- NULL #removes the Gene_name column (rownames have this info)

#make DESeqDataSet, needs matrix of conditions to organize comparisons
condition <- read_excel("C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/MN_Pairs.xlsx", sheet =3, col_names = TRUE) #loads data from excel
condition <-as.data.frame(condition)
rownames(condition) <- condition[,1] #makes first column into rownames
condition$Library <- NULL #removes the Gene_name column (rownames have this info)

dds <- DESeqDataSetFromMatrix(countData = genecounts, colData = condition, design = ~Genotype)

#differential expression
de <- DESeq(dds)
res <- results(de)

write.csv(as.data.frame(res),file='C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/PFN1_DE.csv')

#TARDBP
genecounts <- read_excel("C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/MN_Pairs.xlsx", sheet =4, col_names = TRUE) #loads data from excel
genecounts <- as.data.frame(genecounts) #turns tibble output from above into data.frame
rownames(genecounts) <- genecounts[,1] #makes first column into rownames
genecounts$Gene_Name <- NULL #removes the Gene_name column (rownames have this info)

#make DESeqDataSet, needs matrix of conditions to organize comparisons
condition <- read_excel("C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/MN_Pairs.xlsx", sheet =5, col_names = TRUE) #loads data from excel
condition <-as.data.frame(condition)
rownames(condition) <- condition[,1] #makes first column into rownames
condition$Library <- NULL #removes the Gene_name column (rownames have this info)

dds <- DESeqDataSetFromMatrix(countData = genecounts, colData = condition, design = ~Genotype)

#differential expression
de <- DESeq(dds)
res <- results(de)

write.csv(as.data.frame(res),file='C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/TARDBP_DE.csv')

#SOD1
genecounts <- read_excel("C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/MN_Pairs.xlsx", sheet =6, col_names = TRUE) #loads data from excel
genecounts <- as.data.frame(genecounts) #turns tibble output from above into data.frame
rownames(genecounts) <- genecounts[,1] #makes first column into rownames
genecounts$Gene_Name <- NULL #removes the Gene_name column (rownames have this info)

#make DESeqDataSet, needs matrix of conditions to organize comparisons
condition <- read_excel("C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/MN_Pairs.xlsx", sheet =7, col_names = TRUE) #loads data from excel
condition <-as.data.frame(condition)
rownames(condition) <- condition[,1] #makes first column into rownames
condition$Library <- NULL #removes the Gene_name column (rownames have this info)

dds <- DESeqDataSetFromMatrix(countData = genecounts, colData = condition, design = ~Genotype)

#differential expression
de <- DESeq(dds)
res <- results(de)

write.csv(as.data.frame(res),file='C:/Data/Wainger_Lab/RNA/RNAseq2021/Motor Neurons/SOD1_DE.csv')