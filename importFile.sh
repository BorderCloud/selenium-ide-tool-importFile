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

cp -p $input $output

 while : ; do
    cp -p $output "$output.tmp"
    datafile=$(jq -r 'first(.tests[].commands[].value | select(startswith("{{<"))| select(endswith(">}}"))  | ltrimstr("{{<") | rtrimstr(">}}"))' "$output.tmp")
    echo "datafile $datafile"
    if [ -z "$datafile" ]; then
        # echo NOT FOUND
        break
    elif [ -f "$datafile" ]; then
       # echo FOUND
       jq --arg data "$(cat "$datafile")" '(first(.tests[].commands[].value | select(startswith("{{<"))| select(endswith(">}}")))) |= $data' "$output.tmp" > $output
    else
        printf 'Could not find "%s" referenced by "%s"\n' "$datafile" $input >&2
        exit 1
    fi
done
rm "$output.tmp"
echo DONE
