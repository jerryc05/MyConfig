## Prebuilt binary (skip building)
https://buildkite.com/authelia/authelia/

## Before build
0.  Clone from `https://github.com/authelia/authelia`, and go into it
0.  Install `golang`, `pnpm`

## Building
-   Refer to https://www.authelia.com/contributing/development/build-and-test/
-   As per https://github.com/authelia/authelia/discussions/5800#discussioncomment-6695585, copy `api/` to `internal/server/public_html/`
-   ```sh
    CGO_ENABLED=1 CGO_CPPFLAGS="-Ofast -march=native" CGO_LDFLAGS="-Wl,-z,relro,-z,now" go build -ldflags "-linkmode=external -s -w" -trimpath -buildmode=pie -o authelia ./cmd/authelia
    ```

## After build
```sh
EXAMPLE_COM='example.com'  # repelace `example.com` before using it!

# Refer to  config.template.yml
cat <<EOF >./configuration.yml
theme: 'auto'
jwt_secret: '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c64)'
server:
  address: ':8443'  # '$(pwd)/__unix.sock'
  disable_healthcheck: true
  tls:
    key: '???'
    certificate: '???'
log:
  level: 'debug'
totp:
  issuer: '${EXAMPLE_COM}'
authentication_backend:
  file:
    path: './__users.yml'
    watch: true
webauthn:
  display_name: '${EXAMPLE_COM}'
#duo_api:  # do not define this to disable Duo
password_policy:
  zxcvbn:
    enabled: true
    min_score: 2 
#privacy_policy:
#  enabled: false
#  require_user_acceptance: false
#  policy_url: ''
access_control:
  default_policy: 'deny'
  rules:
    - domain:
      - sso.${EXAMPLE_COM}
      policy: bypass
    # - domain:
    #   - '*.${EXAMPLE_COM}'
    #   policy: one_factor  # two_factor
session:
  secret: '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c64)'
  name: '_auth'
  cookies:
    - name: '_auth'
      domain: '${EXAMPLE_COM}'
storage:
  encryption_key: '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c64)'
  local:
    path: ./__db.sqlite3
notifier:
  filesystem:
    filename: ./__notification.txt
#  smtp:
#identity_providers:
#  oidc:
#    hmac_secret: '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c64)'

EOF
```
Validate config:
```sh
./authelia validate-config --config ./configuration.yml
```

### Systemd
```sh
SYSTEMD_DIR_='/etc/systemd/system'
sudo tee $SYSTEMD_DIR_/authelia.service <<EOF
[Unit]
Description=Authelia authentication and authorization server
After=multi-user.target

[Service]
Environment=AUTHELIA_SERVER_DISABLE_HEALTHCHECK=true
ExecStart="$(pwd)/authelia" --config "$(pwd)/configuration.yml"
WorkingDirectory=$(pwd)
User=$(whoami)
Group=$(whoami)

[Install]
WantedBy=multi-user.target
EOF
```

### Start
```sh
sudo systemctl enable authelia 
sudo systemctl start authelia
systemctl status authelia
```

### Nginx
see `nginx/` in this repo