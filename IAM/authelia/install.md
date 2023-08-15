## Before build
0.  Clone from `https://github.com/authelia/authelia`, and go into it
0.  Install `golang`

## Building
-   ```sh
    go build -o authelia cmd/authelia/*.go
    ```

## After build

```sh
# Refer to  config.template.yml
cat <<EOF >./configuration.yml
theme: 'auto'
jwt_secret: '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c16)'
server:
  port: 8443
  disable_healthcheck: true
  tls:
    key: '???'
    certificate: '???'
log:  
  level: 'debug'
totp:
  issuer: '???????'
```

### Systemd
```sh
SYSTEMD_DIR_='/etc/systemd/system'
sudo mkdir -p $SYSTEMD_DIR_/authelia.service.d/
sudo cp ./authelia.service $SYSTEMD_DIR_/
cat <<EOF | sudo tee $SYSTEMD_DIR_/authelia.service.d/override.conf
[Service]
ExecStart=
ExecStart="$(pwd)/authelia" --config "$(pwd)/configuration.yml"
WorkingDirectory="$(pwd)"
DynamicUser=no
User=$(whoami)
EOF
```

### Start
```sh
sudo systemctl enable authelia 
sudo systemctl start authelia
systemctl status authelia
```