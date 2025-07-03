#!/usr/bin/env bash

# set -e

LANG="${1:-en}"  # Default to 'en' if no argument is provided
SR="${2:-48000}"  # Default sample rate to 48000 if no argument is provided

SRC_DIR="output/wordreference_words/$LANG"
OUT_DIR="output/words_wav/$LANG/sr${SR}"

mkdir -p "$OUT_DIR"

find "$SRC_DIR" -type f -name "audio.*.mp3" -print0 | while IFS= read -r -d '' mp3file; do

    word="$(basename "$(dirname "$mp3file")")"
    fname="$(basename "$mp3file" .mp3)"      # e.g. audio.en.uk.Yorkshire.en042667
    rest="${fname#audio.}"               # en.uk.Yorkshire.en042667
    wordid="${rest##*.}"                     # en042667
    accent="${rest%.*}"                  # en.uk.Yorkshire

    out="$OUT_DIR/${word}_${wordid}_${accent}.wav"    # "clean/hello_en042667_en.uk.Yorkshire.wav"

    if [[ -f "$out" ]]; then
        echo "[bash] Skipping existing: $out"
        continue
    fi
    
    # infile=$mp3file 
    infile="$(realpath "$mp3file")"  # Get the absolute path of the mp3 file

    echo "[bash] Converting: $infile → $out"
    ffmpeg -hide_banner -loglevel error -nostdin -i "$infile" -ac 1 -ar $SR -acodec pcm_s16le "$out"
    # pcm_s16le: 16-bit
    # ac 1: mono
done

echo "[bash] DONE"
