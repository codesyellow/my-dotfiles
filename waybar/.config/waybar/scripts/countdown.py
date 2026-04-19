#!/usr/bin/env python3

import argparse
import sys
import fcntl
import signal
import subprocess
import os
from time import sleep
from pathlib import Path

parser = argparse.ArgumentParser(description="A countdown cli tool.")

parser.add_argument(
    "-t",
    "--time",
    type=int,
    required=True,
    help="Set the countdown time. This is required.",
)

parser.add_argument(
    "-r",
    "--repeat",
    type=int,
    default=1,
    help="Set how many times the countdown should repeat (0 to disable)",
)

parser.add_argument(
    "-R",
    "--repeat_time",
    type=int,
    default=2,
    help="Set how many minutes are between each repetition (default is 0)",
)

args = parser.parse_args()

SLEEP_TIME = 1
COUNTDOWN_TIME = args.time
COUNTDOWN_REP = args.repeat
COUNTDOWN_REP_TIME = args.repeat_time
COUNTDOWN_PATH = "/tmp/countdown_time"
COUNTDOWN_HALF_PATH = "/tmp/countdown_half"
COUNTDOWN_PERC_PATH = "/tmp/countdown_perc"
PID_PATH = "/tmp/countdown_pid.pid"
# if this file exist, self.countdown will have its value
COUNTDOWN_VALUE_PATH = "/tmp/countdown_value"


class Countdown:
    def __init__(self) -> None:
        self._ensure_single_instance()
        self.countdown = COUNTDOWN_TIME * 60
        signal.signal(signal.SIGINT, self._exit_now)
        signal.signal(signal.SIGTERM, self._exit_now)

    def run(self) -> None:
        print(f"{COUNTDOWN_REP}")
        self._cleanup()
        for _ in range(COUNTDOWN_REP):
            self._send_notification(title="Countdown", message="Coundown started.")
            self._start_countdown()
            sleep(COUNTDOWN_REP_TIME)
            self._cleanup()
            self._send_notification(title="Countdown", message="Coundown was finished.")
        self._update_waybar()

    def _send_notification(self, title: str, message: str) -> None:
        subprocess.run(
            ["notify-send", "-i", "alarm-clock", "-u", "normal", title, message]
        )

    def _exit_now(self, signum, frame) -> None:
        print("Leaving! Have a great time!")
        self._send_notification(title="Countdown", message="Script was stopped!")
        self._cleanup()
        self._update_waybar()
        sys.exit(0)

    def _ensure_single_instance(self) -> None:
        self._lock_file = open("/tmp/countdown.lock", "w")
        try:
            fcntl.lockf(self._lock_file, fcntl.LOCK_EX | fcntl.LOCK_NB)
            self._lock_file.write(str(os.getpid()))
            self._lock_file.flush()
        except IOError:
            self._send_notification(
                title="Countdown", message="Another Countdown is already running!"
            )
            print("Script is already running. Exiting...")
            sys.exit(1)

    def _write_pid(self) -> None:
        with open(PID_PATH, "w") as f:
            f.write(str(os.getpid()))

    def _create_file(self, file_path: str) -> None:
        open(file_path, "a").close()

    def _write_to_file(self, file_path: str, text: str) -> None:
        with open(file_path, "w") as f:
            f.write(text)

    def _cleanup(self) -> None:
        path_list = [COUNTDOWN_HALF_PATH, COUNTDOWN_PATH, COUNTDOWN_PERC_PATH]

        for file in path_list:
            Path(file).unlink(missing_ok=True)

    def _convert_number(self, number: int) -> str:
        minutes = number // 60
        seconds = number % 60
        return f"{minutes:02d}:{seconds:02d}"

    def _update_waybar(self) -> None:
        subprocess.run(["pkill", "-RTMIN+5", "waybar"])

    def _start_countdown(self) -> None:
        half = self.countdown // 2
        ten_perc = self.countdown // 10
        time = self.countdown
        while time >= 1:
            print(time)
            if half == time:
                self._create_file(COUNTDOWN_HALF_PATH)
            elif ten_perc == time:
                self._create_file(COUNTDOWN_PERC_PATH)

            self._write_to_file(
                file_path=COUNTDOWN_PATH, text=self._convert_number(time)
            )
            time -= 1
            self._update_waybar()
            sleep(SLEEP_TIME)


if __name__ == "__main__":
    countdown = Countdown()
    countdown.run()
