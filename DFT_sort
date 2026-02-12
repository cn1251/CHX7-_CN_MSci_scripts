#!/bin/bash
# Cassandra Noorman 2026

DatDir="$HOME/Project/Data"

batches=("batch1" "batch2" "batch3" "batch4")
optlvls=("opta" "optb" "optc" "optd" "opte" "optf" "optg" "opth" "opti" "optj" "optk" "optl")

optindex () {
	#!/bin/bash
	for i in "${!optlvls[@]}"; do
		if [[ "${optlvls[$i]}" = $1 ]]; then
			echo "$i"
		fi
	done
}

# Create the target directories
mkdir -p $DatDir/Analysis
mkdir -p $DatDir/Analysis/CHX7-_mol
mkdir -p $DatDir/Analysis/CHX7-_xyz
mkdir -p $DatDir/Analysis/CHX7-_out
mkdir -p $DatDir/Analysis/CHX7-_freq
mkdir -p $DatDir/Analysis/tmp

# Clear the target directories
#rm $DatDir/Analysis/CHX7-_mol/*
rm $DatDir/Analysis/CHX7-_xyz/* 2>/dev/null
rm $DatDir/Analysis/CHX7-_out/* 2>/dev/null
rm $DatDir/Analysis/CHX7-_freq/* 2>/dev/null
rm -r $DatDir/Analysis/tmp/* 2>/dev/null

# This loop goes through each batch specified above
for batch in ${batches[@]}; do
	echo "==== $batch ===="
        printf "Creating temp files for $batch..."
        cp -r /home/pcytb13/Project/Data/Optimisation-Batches/$batch/optimised/ $DatDir/Analysis/tmp/$batch/
        printf "Done\n"
	# This loop goes through each folder in each batch
	for optfolder in ${optlvls[@]}; do
                echo "= $optfolder =" 
                
                printf "Removing unneeded temp files from $batch/$optfolder..."
                rm $DatDir/Analysis/tmp/$batch/$optfolder/*.gbw 2>/dev/null
                rm $DatDir/Analysis/tmp/$batch/$optfolder/*.inp 2>/dev/null
                rm $DatDir/Analysis/tmp/$batch/$optfolder/*.engrad 2>/dev/null
                rm $DatDir/Analysis/tmp/$batch/$optfolder/*.densities 2>/dev/null
                rm $DatDir/Analysis/tmp/$batch/$optfolder/*.hess 2>/dev/null
                rm $DatDir/Analysis/tmp/$batch/$optfolder/*.txt 2>/dev/null
                rm $DatDir/Analysis/tmp/$batch/$optfolder/*_trj.xyz 2>/dev/null
                rm $DatDir/Analysis/tmp/$batch/$optfolder/*.opt 2>/dev/null
                printf "Done\n"
                
                printf "Moving all freq.out and .mol from $batch/$optfolder to final directory..."
                mv $DatDir/Analysis/tmp/$batch/$optfolder/*freq.out $DatDir/Analysis/CHX7-_freq/ 2>/dev/null
                mv $DatDir/Analysis/tmp/$batch/$optfolder/*.mol $DatDir/Analysis/CHX7-_mol/ 2>/dev/null
                printf "Done\n"
                
                # This loop goes through each optimisation level in each folder, up to and excluding the current one.
		x=0
                printf "Removing unneeded opt.out and .xyz from $batch/$optfolder..."
		while [[ $x -lt $(optindex "$optfolder") ]]; do
			y=${optlvls[$x]}
			rm $DatDir/Analysis/tmp/$batch/$optfolder/*$y.out 2>/dev/null
			rm $DatDir/Analysis/tmp/$batch/$optfolder/*$y.xyz 2>/dev/null 
			x=$((x + 1))
		done
                printf "Done\n"
                
                printf "Moving all opt.out  and .xyz from $batch/$optfolder to final directory..."
                mv $DatDir/Analysis/tmp/$batch/$optfolder/*.out $DatDir/Analysis/CHX7-_out/ 2>/dev/null
                mv $DatDir/Analysis/tmp/$batch/$optfolder/*.xyz $DatDir/Analysis/CHX7-_xyz/ 2>/dev/null
                printf "Done\n"
	done
done
                
printf "Cleaning up temp files..."
rm -r $DatDir/Analysis/tmp/ 2>/dev/null
printf "Done\n"

cd $DatDir/Analysis/CHX7-_freq
bash /home/pcytb13/Project/post_processing_scripts/batch_status.sh "$DatDir/Analysis/CHX7-_out/*.out"
