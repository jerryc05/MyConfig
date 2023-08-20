# Download
https://github.com/ory/kratos/releases

# Get default config file
```sh
wget https://github.com/ory/kratos/raw/master/cmd/serve/stub/kratos.yml
```

# Before start
```sh
./kratos migrate sql 'SQL_URI_WITH_PARAM' -c config.yml
```

# Test
```sh
export SERVE_PUBLIC_CORS_DEBUG=true
./kratos serve -c ./config.yml --sqa-opt-out --dev
```

# Reference UI
- Admin: https://github.com/dfoxg/kratos-admin-ui
- Self-service: https://github.com/ory/kratos-selfservice-ui-node

# Systemd
```sh
SYSTEMD_DIR_='/etc/systemd/system'
sudo tee $SYSTEMD_DIR_/ory-kratos.service <<EOF
[Unit]
Description=Kratos Service
After=network.target

[Service]
ExecStart="$(pwd)/kratos" serve -c "$(pwd)/config.yml" --sqa-opt-out

WorkingDirectory=$(pwd)
User=$(whoami)
Group=$(whoami)

[Install]
WantedBy=multi-user.target
EOF
```