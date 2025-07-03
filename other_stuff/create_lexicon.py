# import glob
# from g2p_en import G2p

# # Initialize g2p model
# g2p = G2p()

# # Collect unique words from transcripts
# txt_files = glob.glob("$CORPUS_DIR/text/*.txt")
# words = set()
# for tf in txt_files:
#     w = open(tf).read().strip().lower()
#     words.add(w)

# # Write lexicon: UPPERCASE word mapped to ARPABET phones
# with open("$CORPUS_DIR/lexicon.txt", "w") as lex:
#     for w in sorted(words):
#         phones = [p for p in g2p(w) if p != ' ']
#         lex.write(f"{w.upper()} {' '.join(phones)}\n")
