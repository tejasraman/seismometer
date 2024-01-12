# Vertical-Pendulum Seismometer (Science Fair Project, 8th Grade, 2023)

### Don't trust ANY of the code or documentation used here.

### Although all examples presented here work correctly, they are (somewhat) prone to instability and should not be used in production environments. This is mainly due to the usage of a web server in production on a somewhat unstable WiFi-N network, but if you want reliable, try something like SSH-over-USB.



This project uses induction to build a functioning seismometer using the classic vertical-pendulum method. Data is generated using magnets and an induction coil, and passed through an ADC (Microchip MCP3208) into an SBC with an SPI-over-GPIO interface.



The Python was tested on a Raspberry Pi 3; the app was tested on a Pixel 6a. The app uses a hardcoded address for the device, so remember to change the addresses before compilation.

I'm currently working on making this a kiosk app over USB (for a Tab A 2019), as well as integrating a cloud component for notifications and real-time viewing on any network.
