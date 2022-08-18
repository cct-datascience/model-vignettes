## Setting up tensorflow

See rocker ML docs here: https://rocker-project.org/images/versioned/rstudio.html


1. Run the rocker docker container `docker run --rm -it  -p 8787:8787/tcp -e PASSWORD=rstudio --name rocker_ml rocker/ml:latest`
    _note_ if you get a message that port 8787 is being used, change it to another port, e.g. `-p 8788:8787/tcp` rocker/ml:latest
2. Open docker desktop
6. Click "CLI" icon that looks like `>_` - this logs you into the container as root 
    * I think this is equivalent to `docker exec -it rocker_ml /bin/sh`
7. Run `/rocker_scripts/install_tensorflow.sh` to install the R tensorflow package
5. In Docker desktop, click the "Containers Apps" panel
6. Click "open in browser" icon to launch Rstudio server in the browser.
6. Log in user:rstudio, password:rstudio
7. Install other required packages, get going
  - `tensorflow::install_tensorflow()`

To mount folder from your local directory 
- easiest is in docker desktop
  - click images --> on image, click run
  - here you can set port, and also mount a local directory. Go from `~/path/to/reponame` to either `/tmp` or `/home/rstudio/reponame` 
- equivalent at command line (I think, haven't tested) is adding following to docker run command above
  - `--mount type=bind,source="$(pwd)",target=/home/rstuio`

  complete docker run command might be:

  ```sh
  docker run --rm -it  \
    -p 8787:8787/tcp \
    -e PASSWORD=rstudio \
    --name rocker_ml \
    --mount type=bind,source="$(pwd)",target=/home/rstuio \
    rocker/ml:latest
```