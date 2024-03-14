---
layout: static
title: ESPHome on Shelly RGB Duo
parent: ESPHome
excerpt: Adding Shelly RGB Duo bulbs to Home Assistant
---
## Getting ESPHome onto Shelly RGBW GU-10 Bulbs 

{: .ps-5 .mt-2 .space-y-1 .list-decimal .list-outside }

* Follow the Shelly instructions to connect the bulb to your network in the normal way.

* Open the IP address of the bulb in the browser *shellyip*.

* Check list at https://github.com/arendst/mgos-to-tasmota for link to software version

* For RGB Duo Bulbs it is http://*shellyip*/ota?url=http://ota.tasmota.com/tasmota/shelly/mg2tasmota-ShellyDuoRGBW.zip

    eg http://192.168.1.177/ota?url=http://ota.tasmota.com/tasmota/shelly/mg2tasmota-ShellyDuoRGBW.zip

* Type that address into the browser. it will return some JSON. Wait 5 minutes for it to finish the install and let it will reboot itself.

* Using your phone, connect to the devices captive portal called Tasmota-[random]. Connect the new device to the network (same as step 1).

* Connect to the device using the IP address from above.

* In ESPHome add a new ESP8266 device, give it a name, but **skip** installing it.

* Use the bare minimum code from [here]({% link _pages/esphome/bare_minimum.md %}) for the first install to make sure all the keys are correct, but change the name and friendly name to match what you want the final name to be.

* Create a new firmware for the bulb. Download it locally, and then GZIP it so it will upload successfully. 
```shell
gzip filename.bin
```

* Using the Tasmota web update install the new firmware.

* Add the new found device to Home Assistant when prompted.

* You can now update the YAML to add the rest of the config.


```yaml
substitutions:
  name: shellyrgb-bedroom-01
  friendly_name: ShellyRGB Bedroom 01
  id: shellyrgb_bedroom_01
  project_name: "Bedroom.RGBW"
  project_version: "0.1"

esp8266:                            # change me
  board: esp01_1m                   # change me

packages:
  base: !include common/base.yaml
  #common: !include common/common.yaml
  shelly_rgb_duo: !include common/shellyrgb_bedroom.yaml

wifi:
  #manual_ip:
  #  static_ip: 192.168.1.84
  #  gateway: 192.168.1.1
  #  dns1: 192.168.1.3
  #  subnet: 255.255.255.0


```

common/shellyrgb_bedroom.yaml is:

```yaml



  
light:
  - platform: cwww
    id: ${id}_cwww
    name: ${friendly_name}_cwww
    warm_white: warm_white
    cold_white: brightness
    cold_white_color_temperature: 6500 K
    warm_white_color_temperature: 2700 K
  
  - platform: rgb
    id: ${id}_rgb
    name: ${friendly_name}_rgb
    restore_mode: RESTORE_DEFAULT_ON
    red: pwm_r
    green: pwm_g
    blue: pwm_b
    effects:
      - random:
      
output:
  - platform: esp8266_pwm
    id: warm_white
    pin: GPIO4

  - platform: esp8266_pwm
    id: brightness
    pin: GPIO5    
  
  - platform: esp8266_pwm
    pin: GPIO13
    frequency: 1000 Hz
    id: pwm_r

  - platform: esp8266_pwm
    pin: GPIO12
    frequency: 1000 Hz
    id: pwm_g

  - platform: esp8266_pwm
    pin: GPIO14
    frequency: 1000 Hz
    id: pwm_b


```