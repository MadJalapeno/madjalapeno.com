---
layout: static
title: Bare Minimum Install
parent: ESPHome
excerpt: A simple and safe YAML for installing onto a device that will set it up to use information stored in your secrets.yaml file
---

## Bare Minimum ESPHome

After accidently overwriting the API key on a light bulb I didn't want to make the same mistake again, so now I have a new way of installing ESPHome on devices.

This is a simple YAML file for installing onto blank ESP devices, or when installing ESPhome over Tasmota, and I will be using it as a default.

Rather than a random API encryption key and a random WiFi password it will use the data stored in the appropriate keys of secrets.yaml right from the beginning.

To use, change the 4 lines indicated to match relevent configuration.

* **name** *(Required, string)*: This is the name of the node. It should always be unique in your ESPHome network. May only contain lowercase characters, digits and hyphens, and can be at most 24 characters long by default, or 31 characters long if name_add_mac_suffix is false. See Changing ESPHome Node Name.

* **friendly_name** *(Optional, string)*: This is the name sent to the frontend. It is used by Home Assistant as the integration name, device name, and is automatically prefixed to entities where necessary.

* **board** *(Required, string)*: The PlatformIO board ID that should be used. Choose the appropriate board from this list (the icon next to the name can be used to copy the board ID). This only affects pin aliases, flash size and some internal settings, if unsure choose a generic board from Espressif such as esp01_1m.

* [Core Reference](https://esphome.io/components/esphome/)
* [ESP8266 Reference](https://esphome.io/components/esp8266/)
* [ESP32 Reference](https://esphome.io/components/esp32/)

{% highlight yaml linenos%}

subsitutions:
  name: bare-minimum                # change me
  friendly_name: _bare_minimum      # change me

esp8266:                            # change me
  board: esp01_1m                   # change me

packages:
  base: !include common/base.yaml

{% endhighlight %}

The important sections that should not need changing are in another file called base.yaml that is in the common directory.

{% highlight yaml linenos%}

esphome:
  name: ${name}
  friendly_name: ${friendly_name}

# Enable Home Assistant API
api:
  encryption:
    key: !secret api_encryption_key

ota:
  password: !secret ota_password

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  # Enable fallback hotspot (captive portal) in case wifi connection fails
  ap:
    ssid: ${name}
    password: !secret ap_password

# Enable logging
logger:

captive_portal:    

{% endhighlight %}

As long as you still include the parts of the safe YAML file, it should reduce the risk of bricking a device.