#!/bin/bash
# Cassandra Noorman 2026

# Paths (include trailing /)
data_path="$HOME/Project/Data/"
# data_path sub paths
map_path="Analysis_CHX7/CHX7_anion_map.txt"
unsat_path="Analysis_CHX7/CHX7_freq/"
ani_path="Analysis_CHX7-/CHX7-_freq/"

# freq.out grep search terms
grep_H="Total Enthalpy"
grep_G="Final Gibbs free energy"
grep_T="Temperature"
grep_P="Pressure"

# Read the map into an array
readarray -t hc_map < $data_path$map_path

freq_grep () {
  local i=$(grep "$1" "$data_path$2$3freq.out" 2>/dev/null)
  local i=${i% *}
  local i=${i##* }
  if [[ $4 -ne 1 ]]; then i=$(echo "$i*2625" | bc 2>/dev/null); fi # Convert Eh to kJ mol^-1
  echo "$i"
}

R=0.008314 # kJ K^-1 mol^-1

S_H="0.108784" # kJ K^-1 mol^-1
H_H=$(echo "2.5*$R*298.15" | bc 2>/dev/null)
G_H=$(echo "$H_H- (298.15*$S_H)" | bc 2>/dev/null)

for i in "${hc_map[@]}"; do

  unsat=${i##* }
  unsat=${unsat:0:-8 } # Remove freq.out from unsat
  ani=${i%% *}
  
  #T_ani=$(freq_grep "$grep_T" $ani_path $ani 1) # Kelvin

  H_unsat=$(freq_grep "$grep_H" $unsat_path $unsat)
  H_ani=$(freq_grep "$grep_H" $ani_path $ani)
  
  G_unsat=$(freq_grep "$grep_G" $unsat_path $unsat)
  G_ani=$(freq_grep "$grep_G" $ani_path $ani)
  
  # Should be the same every time but freq.out can be grepped for temperature each time anyway. Anion temperature is used for the proton.
  #H_H=$(echo "2.5*$R*$T_ani" | bc 2>/dev/null)
  #G_H=$(echo "$H_H- ($T_ani*$S_H)" | bc 2>/dev/null)

  PA=$(echo "$H_ani+$H_H- $H_unsat" | bc 2>/dev/null)
  GPA=$(echo "$G_ani+$G_H- $G_unsat" | bc 2>/dev/null)

  if [ -n "$PA" ]; then echo "$ani $unsat ... PA = $PA kJ mol^-1 ... GPA = $GPA kJ mol^-1"; fi

done
