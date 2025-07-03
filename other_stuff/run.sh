
# Download audio files from WordReference for a list of words in Spanish and English.
nohup python -u download_wordreference_words_v2.py --outdir output/wordreference_words/es --lang es > output/wordreference_words/es.log 2>&1 &
nohup python -u download_wordreference_words_v2.py --outdir output/wordreference_words/en --lang en --random > output/wordreference_words/en.log 2>&1 &

# Convert mp3 to wav.
./mp3towav.sh es 16000
./mp3towav.sh en 16000
ls "output/words_wav/es/sr16000" | wc -l

# To zip:
zip -r output/words_wav/es_sr16000.zip output/words_wav/es/sr16000
zip -r output/words_wav/en_sr16000.zip output/words_wav/en/sr16000


# phone recognition (allosaurus)
# TODO build a specific conda env with allosaurus.
conda activate py313
nohup python infer_allosaurus.py "output/words_wav/en/sr16000" "output/allosaurus_en_sr16000_ipa.pkl" "ipa" > output/allosaurus_en_sr16000_ipa.log 2>&1 &
tail -f output/allosaurus_en_sr16000_ipa.log
nohup python infer_allosaurus.py "output/words_wav/es/sr16000" "output/allosaurus_es_sr16000_ipa.pkl" "ipa" > output/allosaurus_es_sr16000_ipa.log 2>&1 &
tail -f output/allosaurus_es_sr16000_ipa.log
# See allosaurus.ipynb


### phone alignment in english (FAILED) ##########################################################

# Conda env:
conda create -n psaha python=3.11 -y &&
conda activate psaha &&
conda install -c conda-forge montreal-forced-aligner
pip install spacy-pkuseg==0.0.33 # https://github.com/MontrealCorpusTools/Montreal-Forced-Aligner/issues/843
pip install textgrid  #ipykernel ipywidgets


# 1st build examples dir with wavs containing "ordinary", "literature":
mkdir -p output/words_wav/en_examples/sr16000
for w in ordinary literature; do
    cp output/words_wav/en/sr16000/*"$w"* output/words_wav/en_examples/sr16000
done


# Prepare data:
WAV_SRC_DIR="output/words_wav/en_examples/sr16000"
CORPUS_DIR="output/en_corpus_example"
ALIGNED_OUT="${CORPUS_DIR}_phones"

# WORDLIST="$CORPUS_DIR/words.txt"
# LEXICON="$CORPUS_DIR/lexicon.txt"
# WAV_OUT="$CORPUS_DIR/wav_files"
# TXT_OUT="$CORPUS_DIR/transcripts"

# Make corpus with wav and and transcriptions:
for f in "$WAV_SRC_DIR"/*.wav; do
    base=$(basename "$f" .wav)
    word=${base%%_*}
    cp "$f" "$CORPUS_DIR/$base.wav"
    echo "$word" > "$CORPUS_DIR/$base.txt"
done

# # Create lexicon/pronunciation dictionary???
# mfa model download g2p english_mfa # ??
# grep -h -oE '^[^ ]+' "$TXT_OUT"/*.txt | tr '[:upper:]' '[:lower:]' | sort -u > "$WORDLIST" # Collect unique words and write to WORDLIST
# mfa g2p $WORDLIST english_us_arpa $LEXICON

# make sure that the dataset is in the proper format for MFA:
# mfa model download g2p english_mfa # ??
mfa model download acoustic english_mfa
mfa model download dictionary english_mfa
mfa validate --clean --single_speaker "$CORPUS_DIR" english_mfa english_mfa
# mfa validate  --single_speaker "$CORPUS_DIR" "$LEXICON" 

# Align:
mfa align --clean --single_speaker "$CORPUS_DIR" english_mfa english_mfa "$ALIGNED_OUT"



# Maybe use https://github.com/xinjli/allosaurus????
# Try in collab!!!



# NOTE  english_us_arpa return the same for each word...

# # OJO:
#  WARNING  8 OOV word types                                                                                                                                                    
#  WARNING  90total OOV tokens 



# mfa model download acoustic english_mfa # ???
# mfa align "$CORPUS_DIR" "$LEXICON" english_us_arpa "$ALIGNED_OUT" --clean --single_speaker





### OLD ##############################################################################

# To zip:
zip -r output/words_wav/es.zip output/words_wav/es
# To zip specific examples:
cd output/words_wav/es
zip ../../words_wav/es_examples.zip *hola* *parte* *estribillo* *pala* *alma* *almohada*

cd output/words_wav/en/sr16000
zip ../../../words_wav/en_examples.zip *ordinary* *literature* *car*

# # conda env:
# conda create -n psaha python=3.12.9 -y &&
# conda activate psaha &&
# pip install phonet

# # pip install -r requirements.txt
# # git clone https://github.com/jcvasquezc/phonet
# # cd phonet
# # python setup.py install
# # # conda remove -n psaha --all -y  # to remove the environment

# $ ls output/wordreference_words/en/hello
# audio.en.Irish.en042667.mp3    audio.en.scot.en042667.mp3        audio.en.uk.rp.en042667.mp3            audio.en.us.south.en042667.mp3
# audio.en.Jamaica.en042667.mp3  audio.en.uk.general.en042667.mp3  audio.en.uk.Yorkshire.en042667-55.mp3  audio.en.us.us.en042667.mp3


# conda install -c conda-forge montreal-forced-aligner
# mfa align data/wavs data/texts english output/ --clean
