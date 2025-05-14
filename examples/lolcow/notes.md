to pull the lolcow container use 
```shell
apptainer pull shub://GodloveD/lolcow
```

to run this container 
```shell
apptainer run lolcow_latest.sif
```

to get the definition from a sif image 
```shell
apptainer inspect --deffile lolcow_latest.sif
```

output 
```shell
BootStrap: docker
From: ubuntu:16.04

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%environment
    export LC_ALL=C
    export PATH=/usr/games:$PATH

%runscript
    fortune | cowsay | lolcat

```


