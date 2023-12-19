# Vertical-Pendulum Seismometer (Science Fair Project, 8th Grade, 2023)

### Don't trust ANY of the code or documentation used here.

### Although all examples presented here work correctly, they are prone to instability and should not be used in production environments.



This project uses induction to build a functioning seismometer using the classic vertical-pendulum method. Data is generated using magnets and an induction coil, and passed through an ADC (Microchip MCP3208) into an SBC with an SPI-over-GPIO interface.



The Python was tested on a Raspberry Pi 3; the app was tested on a Pixel 6a. The app uses a hardcoded address for the device, so remember to change the addresses before compilation.
