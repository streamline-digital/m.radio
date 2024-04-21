#!/usr/bin/env bash

# Global variables

playlist=()

directories=""

depth=2

IFS=$'\n'

light_blue='\033[1;36m' 
reset_color='\033[0m' 

# Display usage

usage() {

  echo "sh radio.sh <library_path> <number_of_tracks> <genre> <year> <release_type>"
  echo "sh radio.sh -r <release>"
  echo "sh radio.sh -p <playlist>"
  echo
  echo "The parameters <library_path> and <number_of_tracks> are optional and trailing parameters can be omitted also"
  echo
  echo -e "One hundred random songs: ${light_blue}sh radio.sh 100${reset_color}"
  echo -e "90s brutal death metal demos: ${light_blue}sh radio.sh brutal 19.. demo${reset_color}"
  echo -e "LPs from any genre and year: ${light_blue}sh radio.sh % % lp${reset_color}"

  exit $1

}

[ "$1" = -h ] && usage 0

# Stylize output to terminal

display_track() {

  local filename="$1"
  local dir="$2"

  # Use parameter expansion to remove characters preceding any two-digit sequence in the filename

  local regex='[^0-9]([0-9]{2}[^0-9]*\.(mp3|wav|flac))'

  if [[ $filename =~ $regex ]]; then

    local display_name="${BASH_REMATCH[1]}"

  else

    local display_name="$filename"

  fi

  echo -e "${dir}/${light_blue}${display_name,,}${reset_color}"

}

# Detect optional path parameter or default to current directory

library="."

if [[ "$1" == *"/"* ]]; then

  library="$1"

  shift

fi

# Handle the --playlist option flag

if [[ "$1" == "-p" || "$1" == "--playlist"  ]]; then

  directories=$(cat $2)

  shift; shift

fi

# Handle the --release option flag

if [[ "$1" == "-r" || "$1" == "--release" ]]; then

  release_pattern=$(printf "%q" "$2")

  releases=$(find $library -maxdepth $depth -type d | grep -P "^$library/$release_pattern.*" | sort)

  for release in $releases; do

    tracks=$(find $release -maxdepth $depth -type f | grep -P ".(mp3|flac|wav)" | sort)

    for track in $tracks; do

      playlist+=("$track")

    done

  done

  shift; shift

fi

# Handle the optional `number_of_tracks` parameter or default to 100

number_of_tracks="100"

if [[ "$1" =~ ^[0-9]+$ ]]; then

  number_of_tracks="$1"

  shift

fi

# Assign parameters to variables

genre=$1
year=$2
format=$3

echo $genre $year $format

if [ "$genre" = "%" ]; then genre=".*"; fi
if [ "$year" = "%" ]; then year=".*"; fi
if [ "$format" = "%" ]; then format=".*"; fi

# Get list of directories matching genre and year

if [ ${#playlist[@]} -ne 0 ]; then

  continue

elif [ "$#" -eq 3 ]; then

  directories=$(find $library -maxdepth $depth -type d | grep -P "\[.*$genre.*\]" | grep "\- $year -" | grep "($format," | shuf -n $number_of_tracks)

elif [ "$#" -eq 2 ]; then

  directories=$(find $library -maxdepth $depth -type d | grep -P "\[.*$genre.*\]" | grep "\- $year -" | shuf -n $number_of_tracks)

elif [ "$#" -eq 1 ]; then

  directories=$(find $library -maxdepth $depth -type d | grep -P "\[.*$genre.*\]" | shuf -n $number_of_tracks)

elif [ "$#" -eq 0 ]; then

  directories=$(find $library -maxdepth $depth -type d | shuf -n $number_of_tracks)

fi

# Store a random audio file from each directory in an array

for dir in $directories; do

  audio_file=$(find "$dir" -maxdepth 1 -type f -iname "*.mp3" -o -iname "*.wav" -o -iname "*.ogg" | shuf -n 1)

  if [ -n "$audio_file" ]; then

    playlist+=("$audio_file")

  fi

done

# Save the playlist to a file

playlist_id=1
playlist_file=".playlists/${genre}-${format}-${year}-${playlist_id}.txt"

while [ -e "$playlist_file" ]; do

  ((playlist_id++))

  playlist_file="${library}/.playlists/${genre}-${format}-${year}-${playlist_id}.txt"

done

printf "%s\n" "${playlist[@]}" > "${library}/$playlist_file"

# Play each audio file using mplayer

#clear

for audio_file in "${playlist[@]}"; do

  # Extract the directory path and filename

  filename="${audio_file##*/}"

  dir="${audio_file%/*}"
  dir="${dir##*/}"

  # Play the track

  display_track "$filename" "$dir"

  mplayer -really-quiet "$audio_file" 

  # Save to favorites if "s" is pressed

  read -s -n 1 -t 2 key

  if [ "$key" == "s" ]; then

    echo "${dir}/${filename}" >> $library/.favorites.txt

  fi
  
done




