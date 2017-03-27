Data Tools, scripts and notes
-----------------------------

#### Because things like this get out of hand...
```bash
cat *.raw |
grep -E "STREAM_REQUEST.*signature" |
grep "sign_playlist" |
sed -e "s/u\?'/\"/g" -e "s/\"{/{/g" -e "s/}\"/}/g"|
jq '.message.message' |
sed -e "s/\"//g" -e "s/INFO.\+mvp-user\///g" -e "s/\/.\+.m3u8//g" -e "s/...$//" |
awk 'BEGIN { OFS = "\t" } { print $1, $4, $6 }' |
sort -k 1,3
```

##### Or in English...
For all .raw log files,  
filter for playlist hashes of live streams,  
convert the Python non-JSON to JSON,  
extract the message field,  
remove the human readable line noise,  
extract the id, hash and timestamp  
and then sort by guid and timestamp.  


## Here be dragons!
_s/dragons/useful day to day utilities/_

- _bootstrap.sh_ will install a bunch of general tools used in the scripts.
- _envstrap.sh_ installs other utilities that I use on a day to day bases (ymmv).
  - _dots_ contains the public parts of my system dotfiles.
- _bin_ contains reuable utilites.
- _scripts_ contains scripts that may/may not be composable.
- _notes_ contains some examples and thoughts on how I use this stuff.
