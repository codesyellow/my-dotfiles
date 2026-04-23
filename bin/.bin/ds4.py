#!/usr/bin/env python
import subprocess
import time


class DS4():
    def __init__(self) -> None:
        self.connected = False
        self.ds4 = subprocess.check_output([
            "dsbattery"
        ]).decode("utf-8").strip()

    def get_battery(self):
        """Get the battery info and return"""
        print(self.ds4)

    def run(self):
        print(self.ds4.split()[1])


if __name__ == "__main__":
    ds4 = DS4()
    ds4.run()
