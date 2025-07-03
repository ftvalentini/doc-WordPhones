
# Download audio files from WordReference for a list of words in Spanish and English.
nohup python -u download_wordreference_words.py --outdir output/wordreference_words/es --lang es > output/wordreference_words/es.log 2>&1 &
nohup python -u download_wordreference_words.py --outdir output/wordreference_words/en --lang en --random > output/wordreference_words/en.log 2>&1 &

# Convert mp3 to 16khz wav.
./mp3towav.sh es 16000
./mp3towav.sh en 16000
ls "output/words_wav/es/sr16000" | wc -l
ls "output/words_wav/en/sr16000" | wc -l

# To zip:
zip -r output/words_wav/es_sr16000.zip output/words_wav/es/sr16000
zip -r output/words_wav/en_sr16000.zip output/words_wav/en/sr16000

# Upload zips to drive and run `run_allophant.ipynb` in colab.

# Download pickle results and run the full_analysis.ipynb.
