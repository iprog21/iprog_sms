# IPROG SMS

<img src="https://github.com/IPROG-TECH/media-files/blob/main/iprogtech-logo.png" width="150" alt="IPROG TECH" align="right" />

This gem is provided by [**IPROG TECH**](https://www.iprog.tech/), an information technology company specializing in web development services using Ruby on Rails. IPROG TECH also offers free programming tutorials.

**Providing Good Quality Web Services:**
- Startup
- Maintenance
- Upgrading & Conversion

<a href="https://www.buymeacoffee.com/iprog21" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

## About this gem

This gem allows you to send SMS using the SIM800C module with Ruby. It supports auto-detection of the SIM800C serial port and fetching phone numbers and messages from an API.

## Installation

```ruby
$ gem install iprog_sms
```

## Usage

**Send SMS**
```ruby
bin/iprog_send_sms
```
Demo: https://youtu.be/3MnbHhyuuGY

---

**Send SMS from API**
```ruby
bin/iprog_send_sms_from_api
```
Demo: https://youtu.be/Zx4jOFucmsk

---

**SIM800c Troubleshoot**
```ruby
bin/iprog_sms_troubleshoot
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/iprog21/iprog_sms.

## License
This gem is available as open source under the terms of the [MIT License](./LICENSE.txt).

## Code of Conduct
This project has adopted the [Contributor Covenant Code of Conduct](./CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to iprog.tech@gmail.com.

## ⚠️ Compatibility Warning

The `iprog_sms` gem is designed to work with the **SIM800C module**, which has a **network limitation**:

- **Supported Networks**: **2G only**
- **Unsupported Networks**: **3G, 4G, and 5G** are **not compatible** due to the hardware limitation of the SIM800C module.

Please ensure that a 2G network is available in your region, as newer networks (3G, 4G, 5G) are not supported by this module.
