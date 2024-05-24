import random
import os
import subprocess

while True:
    os.system(
        f'~/nats pub seismometer.raw_data " Norris-control {(random.randint(1, 10000)) / 100}"')
    os.system(f'~/nats pub seismometer.risk "Norris {(random.randint(0, 2))}"')
