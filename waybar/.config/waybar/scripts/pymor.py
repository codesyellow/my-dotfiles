#!/usr/bin/env python3

from time import sleep
import argparse
import fcntl
import signal
import os
import sys
import subprocess
from pathlib import Path

PID_PATH = "/tmp/pymor_pid.pid"
POMO_TIME_PATH = "/tmp/pomo_time"
PATH_POMO_REST = "/tmp/pomo_rest"
PATH_POMO_HALF = "/tmp/pomo_half"

parser = argparse.ArgumentParser(description="A pomodoro cli tool called Pymor.")

parser.add_argument(
    "-t",
    "--time",
    type=int,
    default=25,
    help="Set pomodoro time(default is 25 minutes)",
)

parser.add_argument(
    "-l",
    "--leisure",
    type=int,
    default=0,
    help="Set pomodoro leisure time(default is 0)",
)

parser.add_argument(
    "-p",
    "--pause",
    type=int,
    default=5,
    help="Set pomodoro pause time(default is 5 minutes)",
)

parser.add_argument(
    "-P",
    "--long_pause",
    type=int,
    default=15,
    help="Set pomodoro long pause time(default is 15 minutes)",
)

parser.add_argument(
    "-T",
    "--times",
    type=int,
    default=4,
    help="Set how cycles it will have(default is 4)",
)

args = parser.parse_args()


class Pymor:
    def __init__(self) -> None:
        self._ensure_single_instance()
        self.pomodoro_time: int = args.time * 60
        self.pomodoro_break_time: int = args.pause * 60
        self.pomodoro_long_break_time: int = args.long_pause * 60
        self.pomodoro_cycles: int = args.times
        self.leisure_time: int = args.leisure * 60
        self.timer_status: int = 0
        self.pause_status: int = 0
        self.should_exit: bool = False
        signal.signal(signal.SIGINT, self._exit_now)
        signal.signal(signal.SIGTERM, self._exit_now)

    def _write_pid(self) -> None:
        with open(PID_PATH, "w") as f:
            f.write(str(os.getpid()))

    def _exit_now(self, signum: int, frame) -> None:
        print("Leaving! Have a great time!")
        self.should_exit = True

    def _ensure_single_instance(self) -> None:
        self._lock_file = open("/tmp/pomodoro.lock", "w")
        try:
            fcntl.lockf(self._lock_file, fcntl.LOCK_EX | fcntl.LOCK_NB)
            self._lock_file.write(str(os.getpid()))
            self._lock_file.flush()
        except IOError:
            print("Script is already running. Exiting...")
            sys.exit(1)

    def _set_status(self, status: str, value: str = "") -> None:
        if len(value) >= 0:
            with open(status, "w") as f:
                f.write(value)
        else:
            open(status, "a").close()

    def _cleanup(self):
        files = [PID_PATH, POMO_TIME_PATH, PATH_POMO_HALF, PATH_POMO_REST]

        for file in files:
            Path(file).unlink(missing_ok=True)

    def _update_waybar(self) -> None:
        subprocess.run(["pkill", "-RTMIN+25", "waybar"])

    def _handle_logic(self, name: str, value: int) -> None:
        print(f"starting {name}")
        last_minute: int = 0
        half = (value // 60) // 2
        self._set_status(PATH_POMO_HALF, str(half))
        self.timer_status: int = value
        with open(POMO_TIME_PATH, "w") as f:
            while not self.should_exit:
                if self.timer_status > 0:
                    remaining_minutes = self.timer_status // 60
                    if remaining_minutes != last_minute:
                        f.seek(0)
                        f.write(f"{remaining_minutes:02d}|{self.pause_status}")
                        f.truncate()
                        f.flush()
                        last_minute = remaining_minutes
                        print(f"time: {remaining_minutes:02d}")
                        self._update_waybar()
                    self.timer_status -= 1
                    sleep(1)
                else:
                    break

    def _send_notification(self, title: str, message: str) -> None:
        subprocess.run(
            ["notify-send", "-i", "alarm-clock", "-u", "normal", title, message]
        )

    def _start_focus(self) -> None:
        self._send_notification(
            title="Time to focus!",
            message=f"You can do it! Just {self.pomodoro_time // 60} minutes.",
        )
        if os.path.isfile(PATH_POMO_REST):
            os.remove(PATH_POMO_REST)
        self._handle_logic(name="pomo", value=self.pomodoro_time)
        self.pause_status += 1

    def _start_pause(self) -> None:
        self._send_notification(
            title="Time to rest!",
            message=f"Enjoy your {self.pomodoro_break_time // 60} minutes gracefully.",
        )
        self._set_status(PATH_POMO_REST)
        self._handle_logic(name="pause", value=self.pomodoro_break_time)
        self.pause_status += 1

    def _end_session(self) -> None:
        self._send_notification(
            title="Time to rest even more!",
            message=f"Go do something for {self.pomodoro_long_break_time // 60} minutes, anything!",
        )
        self._set_status(PATH_POMO_REST)
        self._handle_logic(name="long", value=self.pomodoro_long_break_time)

    def run(self) -> None:
        self._write_pid()
        while not self.should_exit:
            should_break = self.pause_status > self.pomodoro_cycles

            if should_break:
                self._end_session()
                break
            if self.pause_status % 2 == 0:
                self._start_focus()
            else:
                self._start_pause()
                # send notification at the end

        self._cleanup()
        self._update_waybar()


if __name__ == "__main__":
    pymor = Pymor()
    pymor.run()
