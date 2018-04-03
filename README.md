# dreamhost-dyndns
Dynamically update your Dreamhost DNS using the Dreamhost API

## Config

Add a Dreamhost [API Key](https://panel.dreamhost.com/?tree=home.api) with
access to the `dns-*` functions. Set the `APIKEY` environment variable to this
value.

Specify the record you wish to dynamically modify in the `DNSRECORD`
environment variable.

## Usage

Specify the `APIKEY` and `DNSRECORD` variables in your crontab, and add an
entry to run the `dhdns.sh` script. The script will update your DNS record only
if the current IP is different.
