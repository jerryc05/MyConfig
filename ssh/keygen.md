## If we have security key

### If security key supports `ed25519`
```
ssh-keygen -t ed25519-sk -Oresident  # -C "Comments here...(e.g. which device)"
```

### Else
```
ssh-keygen -t ecdsa-sk -Oresident  # -C "Comments here...(e.g. which device)"
```

## Else
```
ssh-keygen -t ed25519  # -C "Comments here...(e.g. which device)"
```
