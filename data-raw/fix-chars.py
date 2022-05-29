import os
from os.path import join
from os import path

def replaceChars(filepath):
    lyrics = ""
    with open(filepath, 'r') as f:
        lyrics = f.read()

        lyrics = lyrics.replace("е", "e")
        # lyrics = lyrics.replace("”", "\"")
        # lyrics = lyrics.replace("“", "\"")
        # lyrics = lyrics.replace("’", "\'")
        lyrics = lyrics.replace("\u2005", " ")
        lyrics = lyrics.replace("\u205f", " ")
        lyrics = lyrics.replace("\u200b", " ")
        lyrics = lyrics.replace("—", "-") # this is a long dash
        lyrics = lyrics.replace("–", "-") # this is a different long dash
        # lyrics = lyrics.replace("…", "...")

    with open(filepath, 'w') as f:
        f.write(lyrics)



working_dir = path.dirname(__file__)
raw_lyric_dir = "data-raw/lyrics"

os.chdir(raw_lyric_dir)
album_titles = [name for name in os.listdir(".") if os.path.isdir(name)]


for album in album_titles:
	os.chdir(join(working_dir, raw_lyric_dir, album))
	for path in os.listdir("."):
		if not os.path.isfile(path):
			continue
		replaceChars(path)
