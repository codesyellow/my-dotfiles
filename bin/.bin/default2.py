#!/usr/bin/env python
import subprocess
import json
import os

HOME = os.path.expanduser("~/")
CURRENT_WINDOW = json.loads(subprocess.check_output([
    "hyprctl",
    "activewindow",
    "-j"
]).decode("utf-8"))

CURRENT_WORKSPACE = json.loads(subprocess.check_output([
    "hyprctl",
    "activeworkspace",
    "-j"
]).decode("utf-8"))

HYPR_RULES_PATH = f"{HOME}.config/hypr/configs/rules.conf"

window_class = CURRENT_WINDOW["class"]
workspace_id = CURRENT_WORKSPACE["id"]


def exists(rule):
    """Return true if the rule already exists"""
    with open(HYPR_RULES_PATH) as hypr_rule:
        if rule in hypr_rule.read():
            return True
        else:
            return False


def write_rule(rule):
    with open(HYPR_RULES_PATH, mode="a") as rule_file:
        rule_file.write(rule)


new_rule = f"windowrulev2 = workspace {workspace_id} silent,class:^({
    window_class})$"

if exists(new_rule):
    pass
else:
    write_rule(new_rule)
