# Utils to run a Oracle Database Instance with docker

These utils are useful to create and run an Oracle Database with Docker.
Oracle provides docker files, but to create an image additional work is necessary. 
These utils make this work easier.

Official Docker Images : https://github.com/oracle/docker-images

## Requirements
### Dependencies
Download the database install zip-file into the directory ```downloads/```.
See: [Download directory](downloads/README.md)

### dm.basesize >= 18GB
The build phase is very space consuming. For example, the installation binaries (>3GB) are copied into the container.
The default maximum size (10GB) for docker containers is not sufficient and must be increased.

1. delete previously downloaded base images (oraclelinux:7-slim )
    ```
    $ docker rmi oraclelinux:7-slim
    ``` 

2. set  dm.basesize=18GB 
How to increase the size is depending on the docker version and storage configurations
    * e.g. CentOS Atomic Host 7.4 (Docker 1.12.6):  
        add ```--storage-opt dm.basesize=18G```	to /etc/sysconfig/docker-storage
    * e.g. OL7 (Docker 17.12.1-ce):  
        add ```"storage-opts": ["dm.basesize=18G"]``` to /etc/docker/daemon.json
 
3. restart the docker daemon
    ```
    $ sudo systemctl restart docker
    ```

4. check the config: 
    ``` 
    $ docker info | grep 'Base Device Size'
    Base Device Size: 18.25 GB
    ```  

## Usage

### 1. Clone this Repository
```
$ git clone https://github.com/nochmu/docker-oracle12c.git 
$ cd docker-oracle12c
```

### 2. Build the image
```
$ make image
```

### 3. Create the Container
```
# ./container_new.sh <container-suffix>
$ ./container_new.sh demo
docker run -d --name oracle12c_demo -p 1521 -p 5500 -e ORACLE_SID=CDB -e ORACLE_PDB=PDB -e ORACLE_PWD=ng2bDdcDCw0Qn -v oracle12c_demo_data:/opt/oracle/oradata oracle/database:12.2.0.1-ee
0544c5d36b41aa76720293398bc71c329347fa6b1a91935f84adccda6b05c55b
Name:     oracle12c_demo
Port:     1521/tcp -> 0.0.0.0:32779
          5500/tcp -> 0.0.0.0:32778
SID:      CDB
PDB:      PDB
Password: ng2bDdcDCw0Qn
Volumes:  oracle12c_demo_data:/opt/oracle/oradata
```

Watch the log file
```
docker logs oracle12c_dem
```


## Development
Git Repository: https://github.com/nochmu/docker-oracle12c 

Maintainer: nochmu <github@nochmu.net>

