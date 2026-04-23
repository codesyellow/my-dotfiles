#!/usr/bin/env python
import subprocess
import tempfile
import os
import sys

def process_anki_note(deck_name):
    deck_path = os.path.expanduser(f"~/.ankivim/decks/{deck_name}")
    template = "Question:\n\n\nAnswer:\n\n"
    
    with tempfile.NamedTemporaryFile(suffix=".txt", delete=False, mode='w', encoding='utf-8') as tf:
        tf.write(template)
        temp_path = tf.name

    try:
        # Abre o Vim e foca na linha 2
        subprocess.call(['vim', '+2', temp_path])

        with open(temp_path, 'r', encoding='utf-8') as f:
            content = f.read()

        if "Question:" in content and "Answer:" in content:
            # Divide e limpa as strings
            parts = content.split("Answer:")
            question = parts[0].replace("Question:", "").strip().replace("\n", " ")
            answer = parts[1].strip().replace("\n", " ")

            if question and answer:
                with open(deck_path, 'a', encoding='utf-8') as f_deck:
                    f_deck.write(f"{question};{answer}\n")
                return True
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)
    return False

if __name__ == "__main__":
    if len(sys.argv) > 1:
        process_anki_note(sys.argv[1])
