#!/bin/bash
# Cassandra Noorman 2026

if [[ "$(echo $(gnuplot --version) | grep -o "command not found" | wc -l)" -eq 1 ]]; 
  then echo "Could not find GNUplot. Try running apt install gnuplot or pacman -S gnuplot" && exit
  else echo "gnuplot.bash: found $(gnuplot --version) ... Continuing script"
fi 

# Paths (include trailing /)
data_path="$HOME/Project/Data/"
# data_path sub paths
pa_gpa_path="Analysis_CHX7-/CHX7-_PA_GPA.txt"
unsat_path="Analysis_CHX7/CHX7_freq/"
ani_path="Analysis_CHX7-/CHX7-_freq/"

# freq.out grep search terms
grep_H="Total Enthalpy"
grep_G="Final Gibbs free energy"
grep_T="Temperature"
grep_P="Pressure"

# Read the map into an array
readarray -t pa_gpa_map < $data_path$pa_gpa_path
anis=()
unsats=()
PAs=()

freq_grep () {
  local i=$(grep "$1" "$data_path$2$3freq.out" 2>/dev/null)
  local i=${i% * }
  local i=${i##* }
  if [[ $4 -ne 1 ]]; then i=$(echo "$i*2625" | bc 2>/dev/null); fi # Convert Eh to kJ mol^-1
  echo "$i"
}

ethane_GPAs=()
propane_GPAs=()
butane_GPAs=()
pentane_GPAs=()
hexane_GPAs=()
heptane_GPAs=()

Cx_array () {
  case $carbons in
    2) ethane_GPAs+=($GPA) ;;
    3) propane_GPAs+=($GPA) ;;
    4) butane_GPAs+=($GPA) ;;
    5) pentane_GPAs+=($GPA) ;;
    6) hexane_GPAs+=($GPA) ;;
    7) heptane_GPAs+=($GPA) ;;
  esac
}

mean_avg () {
  local sum=0
  local count=0
  local k
  for k in "$@"; do
    sum=$(echo "$sum + $k" | bc -l)
    ((count++))
  done
  (( count == 0 )) && { echo 0; return; }
  echo "$(echo "$sum / $count" | bc -l)"
}

std_dev () {
    local sumsq=0
    local n=$#
    ((n--))
    (( n == 0 )) && { echo 0; return; }
    for x in "$@"; do
        sumsq=$(awk -v s="$sumsq" -v v="$x" -v m="$xhat" 'BEGIN {print s + (v-m)^2}')
    done
    awk -v ss="$sumsq" -v n="$n" 'BEGIN {print sqrt(ss/n)}'
}


GPA_Cx_makedata () {
  mkdir -p $data_path/gnuplot-tmp/
  for i in "${pa_gpa_map[@]}"; do
    # Grab information from map file
    ani=${i%% *}
    unsat=${i#* }    ; unsat=${unsat%% *}
    PA=${i#*PA = }   ;    PA=${PA%% *}
    GPA=${i#*GPA = } ;   GPA=${GPA%% *}
    # Grab information from freq.out files
    local loewdin=$(grep -A 20 "LOEWDIN ATOMIC CHARGES" "$data_path$unsat_path${unsat}freq.out" 2>/dev/null)
    protons=$(echo "$loewdin" | grep "H :" 2>/dev/null | wc -l)
    carbons=$(echo "$loewdin" | grep "C :" 2>/dev/null | wc -l)
    # Populate arrays for a GPA vs Cx plot
    Cx_array  
    echo "$ani"
  done
  printf "Calculating averages: [......]\033[7D"
  ethane_GPA_avg=$(  mean_avg "${ethane_GPAs[@]}"  ) ; printf "#"
  propane_GPA_avg=$( mean_avg "${propane_GPAs[@]}" ) ; printf "#"
  butane_GPA_avg=$(  mean_avg "${butane_GPAs[@]}"  ) ; printf "#"
  pentane_GPA_avg=$( mean_avg "${pentane_GPAs[@]}" ) ; printf "#"
  hexane_GPA_avg=$(  mean_avg "${hexane_GPAs[@]}"  ) ; printf "#"
  heptane_GPA_avg=$( mean_avg "${heptane_GPAs[@]}" ) ; printf "#"
  sleep 0.1 ; printf "\nCalculating Standard Deviation: [......]\033[7D"
  xhat=$ethane_GPA_avg  ; ethane_GPA_stddev=$(  std_dev "${ethane_GPAs[@]}"  ) ; printf "#"
  xhat=$propane_GPA_avg ; propane_GPA_stddev=$( std_dev "${propane_GPAs[@]}" ) ; printf "#"
  xhat=$butane_GPA_avg  ; butane_GPA_stddev=$(  std_dev "${butane_GPAs[@]}"  ) ; printf "#"
  xhat=$pentane_GPA_avg ; pentane_GPA_stddev=$( std_dev "${pentane_GPAs[@]}" ) ; printf "#"
  xhat=$hexane_GPA_avg  ; hexane_GPA_stddev=$(  std_dev "${hexane_GPAs[@]}"  ) ; printf "#"
  xhat=$heptane_GPA_avg ; heptane_GPA_stddev=$( std_dev "${heptane_GPAs[@]}" ) ; printf "#"
  sleep 0.1 ; printf "\nWriting averages to tmp\n"
  mkdir -p $data_path/gnuplot-tmp/
  rm $data_path/gnuplot-tmp/*.txt  
  echo "$ethane_GPA_avg" >> $data_path/gnuplot-tmp/GPA_avg.txt
  echo "$propane_GPA_avg" >> $data_path/gnuplot-tmp/GPA_avg.txt
  echo "$butane_GPA_avg" >> $data_path/gnuplot-tmp/GPA_avg.txt
  echo "$pentane_GPA_avg" >> $data_path/gnuplot-tmp/GPA_avg.txt
  echo "$hexane_GPA_avg" >> $data_path/gnuplot-tmp/GPA_avg.txt
  echo "$heptane_GPA_avg" >> $data_path/gnuplot-tmp/GPA_avg.txt
  echo "Writing standard deviations to tmp"
  echo "$ethane_GPA_stddev" >> $data_path/gnuplot-tmp/GPA_stddev.txt
  echo "$propane_GPA_stddev" >> $data_path/gnuplot-tmp/GPA_stddev.txt
  echo "$butane_GPA_stddev" >> $data_path/gnuplot-tmp/GPA_stddev.txt
  echo "$pentane_GPA_stddev" >> $data_path/gnuplot-tmp/GPA_stddev.txt
  echo "$hexane_GPA_stddev" >> $data_path/gnuplot-tmp/GPA_stddev.txt
  echo "$heptane_GPA_stddev" >> $data_path/gnuplot-tmp/GPA_stddev.txt
  echo "makedata done!"
}

#GPA_Cx_makedata

