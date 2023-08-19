# Download
https://github.com/ory/kratos/releases

# Get default config file
```sh
wget https://github.com/ory/kratos/raw/master/cmd/serve/stub/kratos.yml
```

# Systemd
```sh
SYSTEMD_DIR_='/etc/systemd/system'
sudo tee $SYSTEMD_DIR_/authelia.service <<EOF
[Unit]
Description=Kratos Service
After=network.target

[Service]
ExecStart="$(pwd)/authelia" --config "$(pwd)/configuration.yml"
WorkingDirectory=$(pwd)
User=$(whoami)
Group=$(whoami)

[Install]
WantedBy=multi-user.target
EOF
```

# Before start
```sh
./kratos migrate sql 'PATH_TO_SQL_URI_WITH_PARAM' -c config.yml
```