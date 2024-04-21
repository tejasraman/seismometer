# Imports
from nats.errors import TimeoutError
import os
import asyncio
import nats
import time
from nats.errors import ConnectionClosedError, TimeoutError, NoServersError

# WEBURL = os.environ.get("NATS_URL", "nats://172.29.143.172:4222").split(",")


async def main():

    nc = await nats.connect(servers="nats://172.29.143.172:4222")

    sub = await nc.subscribe("seismometer.*")

    while True:
        try:
            global msg
            msg = await sub.next_msg(timeout=0.1)
            print(f"{msg.data} - {msg.subject}")
        except TimeoutError:
            print("Fail")
            pass
    time.sleep(0.15)
    await sub.unsubscribe()
    await nc.drain()


if __name__ == '__main__':
    asyncio.run(main())
