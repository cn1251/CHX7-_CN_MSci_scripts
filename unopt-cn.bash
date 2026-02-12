#!/bin/bash
# Cassandra Noorman 2026

# Usage: bash cn-unopt.sh "optMAX"
# All opt*.out files at the max optimisation level will be checked for HURRAY, then all files associated with that structure will be moved.
# If unoptimised files remain, try running the script a second time.
# Erroneous unopt moves from substring are already moved back, but moving the opts back is fine 99% of the time. Check you aren't in the 1%.

rm ./*slurm*
mkdir -p unopt

echo "Number of unoptimised structures: $(grep -L "HURRAY" *$1.out | wc -l)"
grep -L "HURRAY" *$1.out | while read i; do
	name="${i%$1.out}"
	echo "=== Moving files for $name ==="
	ls | grep "$name" | while read j; do
		mv "$j" unopt
		echo "- moving $j"
	done
done
echo "Excess structures to be moved back: $(grep -l "HURRAY" unopt/*$1.out | wc -l)"
grep -l "HURRAY" unopt/*$1.out | while read x; do
	z="${x%$1.out}"
	name="${z#unopt/}"
	echo "=== Moving files for $name ==="
	ls unopt | grep "$name" | while read y; do
		mv unopt/$y .
		echo "- moving $y back to working directory"
	done
done

