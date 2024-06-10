# This script moves api key files around - FOR DEVELOPMENT PURPOSES ONLY
import sys
import os

MOBILE_LOC = "/home/tejas/OneDrive/ScienceFairAPI/MobileClient/apikeys.dart"
TABLET_LOC = "/home/tejas/OneDrive/ScienceFairAPI/DisplayDevice/apikeys.dart"

if len(sys.argv) > 1:
    if sys.argv[1].lower() == "commit":
        os.system("mv Flutter/earthquake_detection_tablet_sfcharts/lib/apikeys_demo.dart Flutter/earthquake_detection_tablet_sfcharts/lib/apikeys.dart")
        os.system(
            "mv Flutter/seismometer_mobileclient/lib/apikeys_demo.dart Flutter/seismometer_mobileclient/lib/apikeys.dart")
        sys.exit()
    elif sys.argv[1].lower() == "prepare":
        os.system("mv Flutter/earthquake_detection_tablet_sfcharts/lib/apikeys.dart Flutter/earthquake_detection_tablet_sfcharts/lib/apikeys_demo.dart")
        os.system(
            "mv Flutter/seismometer_mobileclient/lib/apikeys.dart Flutter/seismometer_mobileclient/lib/apikeys_demo.dart")
        os.system(
            f"cp {TABLET_LOC} ./Flutter/earthquake_detection_tablet_sfcharts/lib")
        os.system(
            f"cp {MOBILE_LOC} ./Flutter/seismometer_mobileclient/lib")
        sys.exit()

print(f"""
API Key Script
{f"Invalid argument: {sys.argv[1]}" if len(
    sys.argv) > 1 else "Please provide an argument"}
--------------
Options:
commit: prepares folders for git commit
prepare: prepares folders for development
""")
