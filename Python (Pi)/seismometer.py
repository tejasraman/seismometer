import gpiozero
import numpy as np
# import threading
import time
# from statistics import mean, median, stdev

class Seismometer:
    def __init__(self, calib_sample_size=240, buffer_size=4, output_interval=12):
        self.buffer = np.zeros(buffer_size)
        self.output_interval = output_interval
        self.calib_samples = np.zeros(calib_sample_size)
        self.num_samples = 0
        self.calib_done = False

        self.hw = gpiozero.MCP3208(channel=0, max_voltage=5)

    def sample(self):
        # copy new value into buffer and shift left
        self.buffer[:-1] = self.buffer[1:]
        self.buffer[-1] = self.hw.raw_value

        # apply filter to remove 60Hz:
        filtered_value = np.mean(self.buffer)

        # buffer filtered samples
        self.calib_samples[:-1] = self.calib_samples[1:]
        self.calib_samples[-1] = filtered_value

        self.num_samples += 1
        if self.num_samples == len(self.calib_samples):
            self.calibrate()

        if self.calib_done and self.num_samples % self.output_interval == 0:
            self.output()

    def calibrate(self):
        self.stats = {
            "stdev": np.std(self.calib_samples),
            "mean": np.mean(self.calib_samples)
        }
        self.calib_done = True

    def output(self):
        normalized = (self.calib_samples - self.stats['mean']) / self.stats['stdev']
        energy = np.mean(normalized ** 2)
        if energy < 2:
            risk = 0
        elif energy < 4:
            risk = 1
        else:
            risk = 2
        plot_value = np.mean(normalized[-self.output_interval:] ** 2)

        with open("datapoint.txt", "w") as dp:
            dp.write(f'{plot_value}\n{risk}')

if __name__ == '__main':
    seis = Seismometer()

    # start sampling: call seis.sample 120 times per second:
    delay = 1/120 # 120 samples per second
    while True:
        start = time.time()
        seis.sample()

        # wait until time.time() is start + delay
        while time.time() < start + delay:
            pass