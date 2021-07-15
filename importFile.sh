#!/bin/bash

if [ $# -eq 0 ]; then
    printf "Utilization:\n"
    printf "$0 <FILE_INPUT> [[--output|-o] <FILE_OUTPUT>]\n"
    printf "example : ./importFile.sh test/testImportFile.side -o aeff.side"
    exit 1
fi

while [ $# -gt 0 ]; do
  case $1 in
     --output|-o)
       output="${2}"
       shift
       ;;
    *)
       input="${1}"
  esac
    shift
done

sed -E "s/\{\{<([^>]+)>\}\}/{r \1}/" $input > $output

