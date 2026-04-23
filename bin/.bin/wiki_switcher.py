#!/usr/bin/env python3
import json
import pynvim
import subprocess
import signal
import os
import sys
import fcntl
from typing import Optional
from time import sleep

PID_FILE = "/tmp/wiki_switcher.pid"
LOCK_FILE = "/tmp/wiki_switcher.lock"
WIKI_PATH = "/home/digo/.config/wiki_switcher/wiki.json"


class WikiSwitcher:
    def __init__(self, file_path: str, socket_path: str = "/tmp/neorg_server") -> None:
        self.file_path = file_path
        self.data: list[dict[str, str]] = self._load_data()
        self.socket_path = socket_path
        self.nvim: Optional[pynvim.Nvim] = self._nvim_status()
        self.last_file: str = ""
        self.last_wiki_filepath: str = ""
        self.was_restored: bool = False
        self.switch_status: bool = False
        signal.signal(signal.SIGUSR1, self._add_to_wiki)
        self._check_single_instance()

    def run(self) -> None:
        self._create_pid()
        self._handle_logic()

    def _handle_logic(self) -> None:
        try:
            while True:
                window = self._get_window_info()
                wiki = self._get_wiki_info(window=window)
                if wiki:
                    if not self.switch_status:
                        self.switch_to_file(wiki["file_path"])
                        self.last_wiki_filepath = wiki["file_path"]
                        self.switch_status = True
                else:
                    if window:
                        if not window["floating"] and self.switch_status:
                            print("Restoring file")
                            self.switch_to_file(self.last_file)
                            self._close_buffer(path=self.last_wiki_filepath)
                            self.switch_status = False
                sleep(1)
        except KeyboardInterrupt:
            print("Exiting...")

    def _create_pid(self) -> None:
        pid = str(os.getpid())
        with open(PID_FILE, "w") as f:
            f.write(pid)

    def _check_single_instance(self) -> None:
        self._lock_file = open(LOCK_FILE, "w")
        try:
            fcntl.lockf(self._lock_file, fcntl.LOCK_EX | fcntl.LOCK_NB)
            self._lock_file.write(str(os.getpid()))
            self._lock_file.flush()
        except IOError:
            print("Script is already running. Exiting...")
            sys.exit(1)

    def _add_to_wiki(self, signum, frame) -> None:
        window = self._get_window_info()
        wiki = self._get_wiki_info(window=window)

        window["file_path"] = f"/home/digo/.neorg/notes/{window['name']}.norg"
        if wiki:
            print("Already in wiki")
            return
        try:
            with open(WIKI_PATH, "r") as f:
                data = json.load(f)
        except (FileNotFoundError, json.JSONDecodeError):
            data = []

        data.append(window)

        with open(WIKI_PATH, "w") as f:
            print("Adding window to wiki")
            json.dump(data, f, indent=4)

    def _get_wiki_info(self, window: dict[str, str]) -> dict[str, str]:
        try:
            name = window.get("name")
            app_id = window.get("app_id")

            if not name and not app_id:
                return {}

            for item in self.data:
                if item.get("name") == name or item.get("app_id") == app_id:
                    return item
        except Exception as e:
            print(f"Err: {e}")
            return {}
        return {}

    def _get_window_info(self) -> dict:
        try:
            window = self._nirimsg("focused-window")
            if window is None:
                return {}
            name = window["title"]
            app_id = window["app_id"]
            is_floating = window["is_floating"]
            return {"name": name, "app_id": app_id, "floating": is_floating}
        except (IndexError, KeyError):
            return {}

    def _load_data(self) -> list:
        try:
            with open(self.file_path, "r") as f:
                return json.load(f)
        except FileNotFoundError:
            return []

    def _nvim_status(self):
        try:
            nvim = pynvim.attach("socket", path=self.socket_path)
            return nvim
        except FileNotFoundError:
            return None

    def _close_buffer(self, path: str) -> None:
        if self.nvim:
            self.nvim.command(f"w! | bd {path}")

    def switch_to_file(self, target_norg_path: str):
        if not self.nvim:
            return

        try:
            if self.nvim:
                current_file = self.nvim.funcs.expand("%:p")

                if current_file != target_norg_path:
                    self.last_file = current_file
                    self.nvim.command(f"edit {target_norg_path}")
        except Exception as e:
            print(f"Error changing to file: {e}")

    def _nirimsg(self, command: str):
        try:
            return json.loads(
                subprocess.run(
                    ["niri", "msg", "--json", f"{command}"],
                    capture_output=True,
                    text=True,
                    check=True,
                ).stdout
            )
        except Exception:
            print("Is Niri running?")
            return None


if __name__ == "__main__":
    wiki_switcher = WikiSwitcher(file_path="/home/digo/.config/wiki_switcher/wiki.json")
    wiki_switcher.run()
