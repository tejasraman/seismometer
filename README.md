# Vertical-Pendulum Seismometer (Science Fair)

## Warning:

This is a project in progress and, as such, will not work correctly in its current state. This disclaimer will be updated once the code on this repo can be considered usable in a production environment without manual modifications not otherwise stated here.

## Introduction

This project uses induction to build a functioning seismometer using the classic vertical-pendulum method. Data is generated using magnets and an induction coil, and passed through an ADC (Microchip MCP3208) into an SBC with an SPI-over-GPIO interface.

The Python was tested on a Raspberry Pi 5; the mobile client app was tested on a Pixel 6a, and the display app was tested on a Samsung Galaxy Tab A (2019).

Data is transferred to these devices over the NATS protocol, with the risk and data values being assigned "risk" and "data" on the NATS server. The NATS and SSH servers is forwarded to the display device over adb using these commands:

```bash
adb reverse tcp:5001 tcp:4222 # forward NATS server 
adb reverse tcp:4222 tcp:22 # forward SSH for remote commands and debugging
```

## Building the Flutter apps:

2 cloud IoT services are used to facilitate the usage of the remote client applications: Blynk and OneSignal.

In your Blynk dashboard, create a new device and set up two Virtual Pins: DATA (V0) and RISK (V1). To obtain your Blynk device authentication token, click the "Developer tools" icon in your Blynk dashboard, then click the "Testing" tab, click "HTTP", and copy the value between `?token=` and the `&` symbol. An example is provided below (in your dashboard the token will be in the same location as the word APIKEY).

```
https://ny3.blynk.cloud/external/api/get?token=APIKEY&v0
```

In OneSignal, set up Firebase Cloud Messaging. After that, set up an [Android notification channel](https://documentation.onesignal.com/docs/android-notification-categories) and a subgroup. Set the subgroup importance to Urgent and copy the Channel ID, as well as your [App ID and REST API key](https://documentation.onesignal.com/docs/keys-and-ids)

in the file `apikeys.dart` for BOTH apps, add all required keys where placeholders are present and build apps.~~~~
