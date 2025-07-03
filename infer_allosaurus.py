import os
import sys
import pickle
import glob
from pathlib import Path

from tqdm import tqdm

from allosaurus.app import read_recognizer


DATA_DIR = sys.argv[1]
OUT_FILE = sys.argv[2]
INVENTORY = sys.argv[3] if len(sys.argv) > 3 else "ipa"

data = []

audio_paths = glob.glob(os.path.join(DATA_DIR, "*.wav"))
print(f"Found {len(audio_paths)} audio files.")

# load your model by the <model name>, will use 'latest' if left empty
# You can tell the model to emit more phones or less phones by changing the --emit or -e argument.
# See: https://github.com/xinjli/allosaurus
model = read_recognizer()

# files_example = sorted(
#     [f for f in audio_paths if re.search(r"/predatory_|/pen_", f)]
# ) 

out = {}
for f in tqdm(audio_paths, desc="Processing", unit="file"):
    wav_name = Path(f).name
    try:
        res = model.recognize(f, INVENTORY, timestamp=True, topk=5, emit=1)
    except Exception as e:
        print(f"Error processing {wav_name}: {e}")
    else:
        out[wav_name] = res
    # print(model.recognize(f, "eng", timestamp=True, topk=1, emit=1))

print(f"Saving results to {OUT_FILE}")
with open(OUT_FILE, "wb") as f:
    pickle.dump(out, f)

print(f"DONE")
