# Examples

## Limit `root` login from private ranges only
In `/etc/pam.d/login`, add new lines:
```
account     required      pam_access.so accessfile=YOUR_ACCESS_FILE
#                                       └ Optional
```

In `YOUR_ACCESS_FILE`(or `/etc/security/access.conf` by default), add new lines:
```
# Limit `root` login from private ranges only
-:root:ALL
+:root:192.168.0.0/16 127.0.0.0/8
```

## Password similarity
In `/etc/pam.d/system-auth`(CentOS) or `/etc/pam.d/common-password`(Debian), add a new line:
```
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok remember=3
#                                                                                  └ Shall not be
```

## Password complexity requirements

### `pam_passwdqc.so` (Recommended, prompts text-based requirements)
#### Install
```
apt install libpam-passwdqc
```
#### Configure
In `/etc/pam.d/system-auth`(CentOS) or `/etc/pam.d/common-password`(Debian), add a new line:
```
password    required      pam_passwdqc.so config=YOUR_CONFIG_FILE
```

In `YOUR_ACCESS_FILE`(or `/etc/passwdqc.conf` by default), add new lines:
```
# The character classes are:
#   digits
#   lower-case letters
#   upper-case letters
#   other characters.
min=disabled,12,8,6,6
#   |        |  | | └ Min num of digits containing 4 classes
#   |        |  | └ Min num of digits containing 3 classes
#   |        |  └ Min num of passphrase chars          # --┐
#   |        └ Min num of digits containing 2 classes  #   |
#   └ Min num of digits containing 1 classes           #   |
                                                       #   |
# Num of chars in suggested passphrase                 # <-┘
passphrase=3

# Max num of chars
max=30

# Num of chars in common substring to conclude that passwords are [similar]
match=4

# Whether accept new password being [similar] to old one
similar=deny

enforce=everyone

# This tells pam_passwdqc to include upper-case letters used as the first character and
#   digits used as the last character of a password when calculating the number of
#   character classes. (Might not work on all versions)
disable_firstupper_lastdigit_check
```

### `pam_cracklib.so`
#### Install
```
apt install libpam-cracklib
```
#### Configure
In `/etc/pam.d/system-auth`(CentOS) or `/etc/pam.d/common-password`(Debian), append to existing line:
```
password    requisite     pam_cracklib.so try_first_pass retry=3 minlen=7 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1
#                                                                |        |          |          |          └ Min num of special characters in negative, positive means no limit
#                                                                |        |          |          └ Min num of lowercase letters, same as above
#                                                                |        |          └ Min num of uppercase letters, same as above
#                                                                |        └ Min num of digits, same as above
#                                                                └ Min length of a password plus one
```
