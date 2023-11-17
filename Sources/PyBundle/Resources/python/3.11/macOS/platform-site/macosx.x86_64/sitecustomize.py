# A site customization that can be used to trick pip into installing
# packages cross-platform. If the folder containing this file is on
# your PYTHONPATH when you invoke pip, pip will behave as if it were
# running on x86_64.
import platform

# Make platform.mac_ver() return x86_64
orig_mac_ver = platform.mac_ver

def custom_mac_ver():
    orig = orig_mac_ver()
    return orig[0], orig[1], "x86_64"

platform.mac_ver = custom_mac_ver
