import random
import os
import subprocess
import time

count = 0
while True:
    time.sleep(0.2)
    os.system(f'nats pub data "{(random.randint(0, 10000)) / 100}"')
    # os.system(f'nats pub data "88"')
    # os.system(f'nats pub risk "{(random.randint(0, 2))}"')
    os.system("nats pub risk 2")
    count += 1
    if count != 15:
        os.system('nats pub notify "FALSE"')
    else:
        os.system('nats pub notify "TRUE"')
        count = 0
