#!/bin/bash
adb wait-for-device
adb reverse tcp:5002 tcp:22
adb reverse tcp:5001 tcp:4222
