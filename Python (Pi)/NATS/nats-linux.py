# Imports
# import os
# import asyncio
# import nats
import random
# import time
# from nats.errors import ConnectionClosedError, TimeoutError, NoServersError

import os


# async def main():
#     nc = await nats.connect(servers="nats://172.29.143.172:4222")
#     sub = await nc.subscribe("seismometer.*")
#     while True:
#         await nc.publish("seismometer.raw_data", f"{(random.randint(1, 10000)) / 100}".encode('utf-8'))
#         await nc.publish("seismometer.risk", f"{random.randint(0, 2)}".encode('utf-8'))
#         print("Broadcasted")
#         time.sleep(0.1)
#     await sub.unsubscribe()
#     await nc.drain()

# asyncio.run(main())

while True:
    os.system(
        f'~/nats pub seismometer.raw_data "{(random.randint(1, 10000)) / 100}"')
    os.system(f'~/nats pub seismometer.risk "{(random.randint(0, 2))}"')
