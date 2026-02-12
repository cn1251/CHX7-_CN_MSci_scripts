#!/bin/bash
# Cassandra Noorman 2026

jarpath="$HOME/Jmol/Jmol.jar"

jmol_open () {
  java -Xmx512m -jar $jarpath $@
}

jmol_show () {
    clear
    echo
    echo "${1:2:-8} - Structure $i of $j - $(grep -h "hexane" Jauto-*.txt | wc -l) labels applied to $(grep -h "hexane" Jauto-*.txt | sort -u | wc -l) structures."
    grep "xyz" $freqout
    echo "----------------------"
    grep -A 1 "LOEWDIN ATOMIC CHARGES" $1
    grep -A 20 "LOEWDIN ATOMIC CHARGES" $1 | grep "C :"
    #grep -A 20 "LOEWDIN ATOMIC CHARGES" $1 | grep "H :"
    echo
    echo "Mayer bond orders larger than 0.100000"
    grep -A 10 "Mayer bond orders larger" $1 | grep "B("
    echo
    printf "Opening Jmol - Use Ctrl+C to continue\n"
    jmol_open $1
}

i=0
j=$(ls hexaneani*freq.out | wc -l)
for freqout in ./hexaneani*freq.out ; do 
  (( i++ ))
  if [[ "$(grep -xh ${freqout:2:-8} Jauto-*.txt )" != "${freqout:2:-8}" ]]; then

    if [[ 1 -eq 2 ]]; then echo > /dev/null # Comment this out if using any of the automatic if statements below

### BLOB FINDER ###
#   if [[ $(grep -A 20 "LOEWDIN ATOMIC CHARGES" $freqout | grep "H :" | wc -l) -lt $(grep -A 20 "LOEWDIN ATOMIC CHARGES" $freqout | grep "C :" | wc -l) ]]; then
#     echo "${freqout:2:-8}" >> ./Jauto-blobca.txt
#			echo "marked $freqout as a blob"
  
### OBVIOUS TETRAHEDRON FINDER ###
#   if [[ $(grep -A 20 "LOEWDIN ATOMIC CHARGES" $freqout | grep "C :   -0.6" | wc -l) -eq 1 ]]; then
#     echo "${freqout:2:-8}" >> ./Jauto-ca001-probable.txt
#			echo "marked $freqout as a probable tetrahedron"
 

    else # Comment/uncomment this line depending on if the line below is in use
		#elif [[ 1 -eq 2 ]]; then # this line makes the script skip all structures, so as to do automatic processing

      jmol_show $freqout
		  x=1
      while [ $x -eq 1 ]; do 
        x=0

        # Edit the UI Here
        printf "\n\nContinue by...\n c) Do nothing (Pressing any unset key also does nothing)\n q) Exit this program\n m) More details\n r) Reload JMOL\n\n t) Mark as tetrahedral\n a) Mark as allylic\n r) Mark as aromatic\n v) Mark as vinyl\n n) Mark as anionic allene\n y) Mark as sp hybridised\n f) Mark as 5C 6e- linear pi system\n\n h) Mark as insufficient protons\n d) Mark as two molecules\n\n 0) Mark as generic NCA\n 1) Mark as homoaromatic NCA\n 2) Mark as bishomoaromatic NCA\n" 

        read -n 1 -s -r reply
        case $reply in
          c) sleep 0.01 ;;
          m) x=1 && clear && echo "$(cat $freqout)" && jmol_open $freqout ;;
          r) x=1 && jmol_show $freqout ;;
          q) exit ;;

#         Key here :)
#         |                                    txt filename here. Must be Jauto-*.txt
#         |                                    |
#         v                                    v
          t) echo "${freqout:2:-8}" >> ./Jauto-ca001.txt ;;
          a) echo "${freqout:2:-8}" >> ./Jauto-ca002.txt ;;
          r) echo "${freqout:2:-8}" >> ./Jauto-ca003.txt ;;
          v) echo "${freqout:2:-8}" >> ./Jauto-ca004.txt ;;
          y) echo "${freqout:2:-8}" >> ./Jauto-ca005.txt ;;
          n) echo "${freqout:2:-8}" >> ./Jauto-ca006.txt ;;
          f) echo "${freqout:2:-8}" >> ./Jauto-ca007.txt ;;
          h) echo "${freqout:2:-8}" >> ./Jauto-blobca.txt ;;
          d) echo "${freqout:2:-8}" >> ./Jauto-doubleca.txt ;;
          0) echo "${freqout:2:-8}" >> ./Jauto-nca.txt ;;
          1) echo "${freqout:2:-8}" >> ./Jauto-nca-homoaro.txt ;;
          2) echo "${freqout:2:-8}" >> ./Jauto-nca-bishomoaro.txt ;;
        esac
		  done
		#else echo "did nothing to $freqout" # Comment this line out if doing structures manually
		fi
  fi
done

