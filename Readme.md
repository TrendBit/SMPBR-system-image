
# Configure image
```
sudo sdm --customize --plugin @plugins --extend --xmb 4096--restart 2024-11-19-raspios-bookworm-arm64-lite.img
```

# Burn image
```
sudo sdm --burn /dev/sdX --hostname smpbr --expand-root 2024-11-19-raspios-bookworm-arm64-lite.img
```
