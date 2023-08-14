## Register
```sh
./acme.sh --register-account -m ??????
```

## Issue (`dns_cf`)
```sh
export CF_Token=""
./acme.sh --issue --dns dns_cf --ocsp-must-staple --keylength ec-256 -d ?????? -d ??????
```

## Cron
```sh
./acme.sh --install-cronjob
```

## Install
```sh
./acme.sh --install-cert -d jerryc05.icu --cert-file ~/cert.pem --fullchain-file ~/fullchain.pem --key-file ~/key.pem
```