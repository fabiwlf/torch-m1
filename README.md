# 📈 PyTorch for M1 Macs and ARM64 Devices
PyTorch for ARM64 (works on M1 Macs) / x64 and raspberry Pi etc.

### Usage

#### Using Image from GitHub packages
```sh
docker pull https://github.com/fabiwlf/torch-m1
```

#### Running example
```sh
# This will start a container and mount the "example" folder to it
docker run -it --rm -v $(pwd)/example:/app https://github.com/fabiwlf/torch-m1
```

#### Building Image from source
```sh
docker buildx build -f Dockerfile -t https://github.com/fabiwlf/torch-m1 --load # from Dockerfile