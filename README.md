# dreamhost-dyndns Dynamically update your Dreamhost DNS using the Dreamhost
API and Bash

## Configuration

Add a Dreamhost [API Key](https://panel.dreamhost.com/?tree=home.api) with
access to the `dns-*` functions. Set the `DHDNS_APIKEY` environment variable to
this value.

Specify the record you wish to dynamically modify in the `DHDNS_DNSRECORD`
environment variable.

## Usage

Specify the `DHDNS_APIKEY` and `DHDNS_DNSRECORD` variables in your crontab, and
add an entry to run the `dhdns.sh` script. The script will update your DNS
record only if the current IP is different.
