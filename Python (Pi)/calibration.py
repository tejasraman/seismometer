import gpiozero

import time
import datetime
import threading


def BaselineCalibration(externalizeAverages):
    # Variables - calibration, values to avg, and access variable for MCP3208
    calibrationmode = 0
    values = ()
    seismometer = gpiozero.MCP3208(channel=0, max_voltage=3.3)

    # Function for threading timer
    def setVal():
        calibrationmode = 1  # sets value to stop while loop after 30s elapses

    # timer functions
    timer = threading.Timer(1.0, setVal)
    timer.start()
    print("Time started")
    iters = 1
    # while loop to read data for calibration
    while calibrationmode == 0:
        values.append(seismometer.voltage)
        print(f"Iteration {iters}")
        iters += 1
    if externalizeAverages == True:
        # returns values to another script if exiernalizeAverages is True
        return values
