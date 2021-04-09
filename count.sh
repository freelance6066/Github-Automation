#!/bin/bash

count=(abc  bcd def)
count1=$(printf '%s\n' "${count[@]}" | wc -w)
echo -e "aslajjajslajlja -> $count1"