# Auto Work Logger

## Dependences

- xorg
- xprop
- xprintidle

## Config

The config file is saved in `~/.awl/awl.config

settings variables:
- _max\_idle\_file_: set(in milliseconds) the amout of time to consider the user afk


## TODO and ideas

- _get all time grouped by type_ awk 'NR==1{old = $2; next}{ print $3 "\t" $2 - old; old= $2}' ~/.awl/awl.log | awk '{arr[$1]+=$2}END{for (a in arr) print a, int(arr[a]/3600)":"int(arr[a]/60)%60":"arr[a]%60}'
- _get all time grouped from last start_ awk '/^start/ { t = $0 "\n"; next } { t = t $0 "\n"; } END { printf "%s", t; }' ~/.awl/awl.log|awk 'NR==1{old = $2; next}{ print $3 "\t" $2 - old; old= $2}' | awk '{arr[$1]+=$2}END{for (a in arr) print a, int(arr[a]/3600)":"int(arr[a]/60)%60":"arr[a]%60}'
- _get all time from last start_ awk '/^start/ { t = $0 "\n"; next } { t = t $0 "\n"; } END { printf "%s", t; }' ~/.awl/awl.log
