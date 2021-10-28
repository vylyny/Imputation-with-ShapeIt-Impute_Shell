#!/bin/bash
#SBATCH --nodes=1
#SBATCH --tasks-per-node=4
#SBATCH --mem=32GB
#SBATCH --time=20:00:00
#SBATCH --output=chr_prephase.%j.out
module load plink/1.90b4.4 

CHR=${SLURM_ARRAY_TASK_ID}

#Directories
Data_Dir=/scratch/kirchhoff/Project-IT-GWAS-CLUSTER/B37_Imputation/Imputation_11148
Result_Dir=$Data_Dir/prephase_results
 
# executable
SHAPEIT_EXEC=/scratch/kirchhoff/tools/shapeit

 
# reference data files
GENMAP_FILE=/scratch/kirchhoff/Project-IT-GWAS-CLUSTER/B37_Imputation/1000GP_Phase3_Ref.Panel/genetic_map_chr${CHR}_combined_b37.txt

#Cut the original files into chr
plink \
--bfile ${Data_Dir}/original_data_plink/final_plink_imputation \
--chr ${CHR} \
--make-bed \
--out $Data_Dir/original_data_plink/gwas_data_prephase_chr${CHR}
 
## phase GWAS genotypes
$SHAPEIT_EXEC \
-B $Data_Dir/original_data_plink/gwas_data_prephase_chr${CHR} \
-M $GENMAP_FILE \
-O $Result_Dir/chr${CHR}.phased \
#-T 8 \ #this option should only be used if you have a lot of samples like thousands
--output-log $Data_Dir/chr${CHR}.log 
