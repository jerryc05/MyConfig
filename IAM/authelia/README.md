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
# Refer to  config.template.yml
cat <<EOF >./configuration.yml
theme: 'auto'
jwt_secret: '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c64)'
server:
  address: ':8443'
  disable_healthcheck: true
  tls:
    key: '???'
    certificate: '???'
log:
  level: 'debug'
totp:
  issuer: '????example.com???'
authentication_backend:
  file:
    path: './__users.yml'
webauthn:
  display_name: '????example.com???'
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
      - '*.????example.com'
      - ????example.com
      policy: one_factor
session:
  name: 'sso_sess'
  cookies:
    - name: 'sso_sess'
      domain: '?????example.com'
      authelia_url: 'https://auth.??????example.com'
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