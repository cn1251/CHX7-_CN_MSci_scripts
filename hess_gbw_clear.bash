#!/bin/bash
# Cassandra Noorman 2026

batches=("batch1" "batch2" "batch3" "batch4")
optlvls=("otpa" "optb" "optc" "optd" "opte" "optf" "optg" "opth" "opti")

optindex () {
	#!/bin/bash
	for i in "${!optlvls[@]}"; do
		if [[ "${optlvls[$i]}" = $1 ]]; then
			echo "$i"
		fi
	done
}

# A directory containing no important files, in case a cd fails.
mkdir -p /home/pcytb13/Project/Data/Optimisation-Batches/sandbag

# This loop goes through each batch specified above
for batch in ${batches[@]}; do
	echo "==== $batch ===="
	# This loop goes through each folder in each batch
	for optfolder in ${optlvls[@]}; do 
		echo "  ## Clearing stale hessians and old GBWs from: $optfolder ##"
		x=0
		cd $HOME/Project/Data/Optimisation-Batches/sandbag
		cd $HOME/home/pcytb13/Project/Data/Optimisation-Batches/$batch/optimised/$optfolder
		# This loop goes through each optimisation level in each folder, up to and excluding the current one.
		while [[ $x -lt $(optindex "$optfolder") ]]; do
			y=${optlvls[$x]}
			echo "~$y:"
			ls *$y.gbw 2>/dev/null | wc -l
			ls *$y*hess 2>/dev/null | wc -l
			x=$((x + 1))
		done
		echo "nothing more to cull in this folder"
	done
done
