import random
import os
import subprocess
import time

while True:
    time.sleep(0.2)
    os.system(
        f'nats pub data "{(random.randint(0, 10000)) / 100}"')
    os.system(f'nats pub risk "{(random.randint(0, 2))}"')
