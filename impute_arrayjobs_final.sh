#!/bin/bash
#SBATCH --nodes=1
#SBATCH --tasks-per-node=4
#SBATCH --mem=16GB
#SBATCH --time=01:00:00
#SBATCH --output=chr12_impute.%j.%A.%a.out
#SBATCH --array=26

CHUNK_END=$((SLURM_ARRAY_TASK_ID*5000000))
CHUNK_START=$((CHUNK_END-4999999))

echo This is chunk start  $CHUNK_START
echo This is chunk end $CHUNK_END

#Directories
Root=/scratch/kirchhoff/Project-IT-GWAS-CLUSTER/B37_Imputation 
Data_Ref=$Root/1000GP_Phase3_Ref.Panel
Data_Dir=$Root/Imputation_11148/prephase_results
Result=$Root/Imputation_11148/imputation_results
 
# executable (must be IMPUTE version 2.2.0 or later)
IMPUTE2_EXEC=/scratch/kirchhoff/tools/impute2

#Imputation_buffer 350kb
	
$IMPUTE2_EXEC \
-use_prephased_g \
-m $Data_Ref/genetic_map_chr12_combined_b37.txt \
-known_haps_g $Data_Dir/chr12.phased.haps \
-h $Data_Ref/1000GP_Phase3_chr12.hap \
-l $Data_Ref/1000GP_Phase3_chr12.legend \
-Ne 20000 \
-int $CHUNK_START $CHUNK_END \
-buffer 350 kb \
-o $Result/gwas_impute_chr12.pos${CHUNK_START}-${CHUNK_END}.${SLURM_ARRAY_TASK_ID}.impute2 \
-seed 123456789

