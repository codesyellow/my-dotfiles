#!/usr/bin/env python
import subprocess
import json
from time import sleep

SLEEP_TIME = 1


class Caffeine:
    """Prevents the systemd from going to sleep while focused window is fullscrened or an audio is being played."""

    def __init__(self) -> None:
        self.inhibit_proc = None

    def run(self) -> None:
        try:
            self._handle_logic()
        except KeyboardInterrupt:
            print("Exiting...")

    def _handle_logic(self) -> None:
        while True:
            should_inhibit = (
                self._check_playerctl()
                or self._is_fullscreen()
                and not self.is_window_floating()
            )
            if should_inhibit and not self._is_caffeine_on():
                self._set_caffeine_status("start")
            elif not should_inhibit and self._is_caffeine_on():
                self._set_caffeine_status("stop")

            sleep(SLEEP_TIME)

    def _is_fullscreen(self) -> bool:
        return self.monitor_size() == self.window_size()

    def _check_playerctl(self) -> bool:
        try:
            output = subprocess.check_output(
                ["playerctl", "-a", "status", "-f", "{{name}} {{status}}"], text=True
            ).strip()

            status_list = [item.strip() for item in output.splitlines()]
            is_playing = "Playing" in status_list
            return is_playing

        except (subprocess.CalledProcessError, FileNotFoundError):
            print("Was unable to check for playerctl status")
            return False

    def _set_caffeine_status(self, status) -> None:
        if status == "start" and self.inhibit_proc is None:
            # Bloqueia idle, sleep e lide (tampa do note) enquanto o processo sleep durar
            self.inhibit_proc = subprocess.Popen(
                [
                    "systemd-inhibit",
                    "--what=idle:sleep:handle-lid-switch",
                    "--who=Caffeine-Script",
                    "--why=Fullscreen/Audio",
                    "sleep",
                    "infinity",
                ]
            )
            print("Caffeine ativado")

        elif status == "stop" and self.inhibit_proc is not None:
            self.inhibit_proc.terminate()
            self.inhibit_proc = None
            print("Caffeine desativado")

    def _is_caffeine_on(self) -> bool:
        """Checks the ActiveState of a systemd service."""
        return self.inhibit_proc is not None

    def window_size(self) -> str:
        data = self.nirimsg("focused-window")
        if data is None:
            return "0x0"

        try:
            win_size = data["layout"]["window_size"]
            return f"{win_size[0]}x{win_size[1]}"
        except (KeyError, TypeError):
            return "0x0"

    def is_window_floating(self) -> bool:
        data = self.nirimsg("focused-window")
        if data is None:
            return False

        try:
            floating = data["is_floating"]
            return floating
        except (KeyError, TypeError):
            return False

    def monitor_size(self) -> str:
        data = self.nirimsg("focused-output")
        if data is None:
            return "0x0"

        try:
            width = data["logical"]["width"]
            height = data["logical"]["height"]
            return f"{width}x{height}"
        except (TypeError, KeyError):
            return "0x0"

    def nirimsg(self, command: str):
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
            print("Is niri running?")
            return None


if __name__ == "__main__":
    caf = Caffeine()
    caf.run()
