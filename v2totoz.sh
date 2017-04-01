#!/usr/bin/env bash

for prg in 'ffmpeg' 'convert'; do

    [ -x "$(which $prg)" ] || { echo "$prg not found!"; exit 1; }

done;

[ -z "$1" ] && { echo "Usage: $0 <file> [size] [name]"; exit 2; }

INPUT_FILE="$1"
SCALE=${2:-140}
OUTPUT_FILE="${3:-$(basename $1)}.gif"
TMP_DIR=/tmp/frames-$$

echo -e "Input:\t$INPUT_FILE"
echo -e "Scale:\t$SCALE"
echo -e "Tmpdir:\t$TMP_DIR"

mkdir $TMP_DIR

ffmpeg -v 0 -i "$INPUT_FILE" -vf scale=$SCALE:-1:flags=lanczos,fps=10 "$TMP_DIR/ffout%03d.png"

convert -loop 0 "$TMP_DIR/ffout*.png" "$OUTPUT_FILE" || { rm -rf $TMP_DIR; exit 3; }

rm -rf $TMP_DIR

KBSIZE=$(( $(stat -c "%s" $OUTPUT_FILE) / 1024 ))

echo -e "Output:\t$OUTPUT_FILE"
echo -e "Type:\t$(file -b $OUTPUT_FILE)"
echo -e "Size:\t$KBSIZE kB"



