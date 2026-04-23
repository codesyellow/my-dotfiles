#!/usr/bin/env python
import os 
import subprocess
import re
from pathlib import Path



# check if current window name = a name that exist inside Gramaire\ Gamer.md file
HOME=os.path.expanduser('~')
FILE_PATH = f"{HOME}/.vimwiki/Gramaire Gamer.md"
# get focused window name
try:
    process = subprocess.run(
        ["niri", "msg", "focused-window"],
        capture_output=True,
        text=True,
        check=True
    )
    match = re.search(r'Title: "(.*?)"', process.stdout)
    if match:
        WINDOW_TITLE = match.group(1)
    else:
        WINDOW_TITLE = "" 
except subprocess.CalledProcessError as e:
    WINDOW_TITLE = f"Error: {e.stderr.strip()}"
except FileNotFoundError:
    WINDOW_TITLE = "Error: 'niri' command not found."

def check_string_in_vimwiki_list(md_file_path, target_string):
    path = Path(md_file_path).expanduser()
    
    if not path.exists():
        return False

    pattern = rf'\[\[{re.escape(target_string)}\]\]'
    
    with path.open('r', encoding='utf-8') as f:
        return bool(re.search(pattern, f.read()))

WINDOW_TITLE="Blasphemous"
if check_string_in_vimwiki_list(FILE_PATH, WINDOW_TITLE):
    print(f"'{WINDOW_TITLE}' está na lista.")
    subprocess.run(
            [
                "vim",
                "--remote-send",
                f":e {HOME}/.vimwiki/{WINDOW_TITLE}.md<CR>",
                "--servername",
                "MEU_VIM"
                ])

else:
    print(f"'{WINDOW_TITLE}' NÃO está na lista.")
# if name exist, go to the file using the server command in vim, else, just open index.md file if there's not an history file with content.
# if there's a history file with the last content that was opened before, restore to that file insted of going to index.md

