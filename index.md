---
layout: default
---

![IoT For Public Good](/assets/img/IoT.png)

# Overview

---

As a part of the 2019-2020 Masters of Science in Data Science ([MSDS](https://datascience.virginia.edu/degrees/msds-degree)) program at the University of Virginia (UVA) School of Data Science (SDS), all students complete a capstone project. Our project was in collaboration with the [UVA Link Lab](https://engineering.virginia.edu/link-lab-0) and a local non-profit, [Smart Cville](https://www.smartcville.com/). Our overarching goal was to implement an air quality sensor network throughout Charlottesville that would provide citizens with access to open data about their air. Together, we established 4 major goals:

1. Expand the LoRa network throughout Charlottesville
2. Design an air quality sensor kit
3. Provide open access to our collected data
4. Analyze our collected data

# The LoRa Network

---

![TTN Gateway](/assets/img/sensors/Gateway.png)
[LoRa](https://en.wikipedia.org/wiki/LoRa) is a spread-spectrum modulation technique that allows low density data to be transmitted over long distances using low power. Our collaborators had already begun implementing the LoRa network throughout Charlottesville by distributing The Things Network ([TTN](https://www.thethingsnetwork.org/)) Gateways. These provide up to 10km radius of LoRa coverage and connect to standard WiFi or ethernet to transport packets to the internet.

![LoRa Gateway Distribution](/assets/img/sensors/gatewaydistn.png)
_LoRa Gateway Distribution in Charlottesville 04/2020_

# Sensor Kit Assembly

---

## Hardware

### [Adafruit Feather M0 RFM95 LoRa Radio](https://github.com/adafruit/Adafruit-Feather-M0-RFM-LoRa-PCB)

![Adafruit Feather M0 RFM95 LoRa Radio](/assets/img/sensors/m0.webp)

This MCU comes in a small form-factor, allows us to provide both 3.3v and 5v source voltage to our sensors, and includes an on-board LoRa Radio. While more expensive than more custom options, it greatly simplifies our design.

### [Plantower PMS7003](sensorboxes/hardware/datasheets/pms7003-datasheet.pdf)

![Plantower PMS7003](/assets/img/sensors/pms7003-front-view.png)

The PMS7003 is a state-of-the-art particulate matter (PM) sensor, sensing PM 1.0, 2.5, and 10. Its small form-factor, low power-consumption, and high accuracy make it a great choice for our sensor kits. It does not come with US-standard pins so you will need [an adapter](https://kamami.pl/en/other-connectors/564553-adapter-from-127mm-pitch-to-254mm-for-pms7003.html) to standardize the pins.

### [Sensirion SCD30](https://www.sensirion.com/en/environmental-sensors/carbon-dioxide-sensors/carbon-dioxide-sensors-co2/)

![Sensirion SCD30](/assets/img/sensors/scd30-1.jpg)

The SCD30 is an indoor NDIR CO2 sensor with an onboard temperature and humidity sensor. It provides high accuracy readings but consumes more power than is ideal for these applications. Future iterations should focus on reducing the power consumption of this part or replace it with an alternative.

## Firmware

Our firmware code is freely available on [Github](https://github.com/thejimster82/CvilleAQ/tree/master/sensorboxes/sbox0) along with the requisite libraries. The ttn-credentials.h file will need to be filled out with the credentials for the TTN application to which you wish to send data. The application must also be set up to [decode](https://learn.adafruit.com/the-things-network-for-feather/payload-decoding) the packets sent by the sensor kits, this code can be copied from Decoder.js in our repo.

## Circuit Diagram

![Circuit Diagram](assets/img/sensors/fritzing.png)

## Housing Assembly

Our pilot prototype was assembled using plastic containers which we do not recommend for future users. We recommend to use one of our [3D-printed enclosures](https://github.com/thejimster82/CvilleAQ/tree/master/3D-design) instead, they include in-built supports for both the PMS7003 and the SCD30. In the event that you must use a plastic container, we recommend at least printing the supports for the sensors as it makes attaching them to the container much easier.

# Open Data

---

All of the data collected for this project can be downloaded and visualized at the following locations:

## Grafana

Grafana provides realtime timeseries plots of our data and allows csv downloads. You can access the full site [here](https://sensors.unixjazz.org/d/xUrC1m8Zz/sbox-all?from=now-7d&to=now&orgId=1).

<iframe src="https://sensors.unixjazz.org/d-solo/xUrC1m8Zz/sbox-all?from=1587077252684&to=1587682052684&orgId=1&theme=light&panelId=4" width="450" height="200" frameborder="0"></iframe>
<iframe src="https://sensors.unixjazz.org/d-solo/xUrC1m8Zz/sbox-all?from=1587077272477&to=1587682072478&orgId=1&theme=light&panelId=6" width="450" height="200" frameborder="0"></iframe>
<iframe src="https://sensors.unixjazz.org/d-solo/xUrC1m8Zz/sbox-all?from=1587077057930&to=1587681857930&orgId=1&theme=light&panelId=11" width="450" height="200" frameborder="0"></iframe>

## Realtime Map

Our realtime map lets you see the air quality right now at locations around Charlottesville. You can view it [here](https://data.unixjazz.org/).

## API

Our API is currently in the works and will make our data machine-readable.

# Analysis

---

## Heatmaps

The largest result of our analysis was a comparison of the air quality in Charlottesville before and after the announcement by UVA that classes would move online. We used this as a breakpoint for the beginning of social distancing in Charlottesville. Using data from our sensors we were able to visualize the decrease in CO2 levels across Charlottesville.

![Mean CO2 Change Before and After March 11th](assets/img/analysis/final_heatmap.png)
_Mean CO2 (ppm) Change Before and After March 11th_

Along with heatmaps for the change in CO2, we were able to generate general heatmaps to show the average values of various metrics across the city. One of our future goals is to implement a realtime-version of this analysis and host it so Charlottesville citizens can have easy access to a simple visual of the air quality across the city.

![Average PM2.5 February 03 to April 15 2020](assets/img/analysis/final_heatmap_pm25.png)
_Average PM2.5 (ug/m3) February 03 to April 15 2020_

# Related Projects

---

### [Air Quality Egg](https://airqualityegg.com/home)

### [Safecast Air](https://safecast.org/)

### [Publiclab](https://publiclab.org/)

### [Smart Citizen](https://smartcitizen.me/)

### [AirCasting](https://www.habitatmap.org/aircasting)

### [HackAIR](https://www.hackair.eu/)

### [Luftdaten](https://luftdaten.info/en/home-en/)

### [PurpleAir](https://www2.purpleair.com/)

### [The Air Quality Data Commons](https://aqdatacommons.org/)

# Team

---

## James Howerton

![Jimmy Howerton](assets/img/contact/HowertonJ.jpg)
email: **jh3df@virginia.edu**

[LinkedIn](https://www.linkedin.com/in/james-howerton/)

[Resume](https://www.jameshowerton.dev)

## Ben Schenck

![Ben Schenck](assets/img/contact/SchenkB.jpg)
email: **bls7cc@virginia.edu**

[LinkedIn](https://www.linkedin.com/in/benjamin-schenck-a08248141/)
