import calibration
from statistics import *
import datetime
from colorama import Fore, Back, Style

values = calibration.BaselineCalibration()

# scale data to 1000:

mval = 4096/1000

newdata = [(x+1)*mval for x in values]
mean = median(newdata)
stdev = stdev(newdata)
max_real = max(newdata)
min_real = min(newdata)

warning = stdev+(stdev/6)


def process(datapoint):
    datapoint = (datapoint+1)*mval
    if datapoint < mean+stdev:
        return [datapoint, 0]
    elif datapoint < mean+warning:
        return [datapoint, 1]
    else:
        return [datapoint, 2]
