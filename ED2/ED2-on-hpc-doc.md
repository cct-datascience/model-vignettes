# ED2 Model on HPC notes/documentation

Any hpc specific questions can be directed to the hpc team email list  
hpc-consult-request@list.arizona.edu

The primary difference the hpc will have compared to what might be considered a standard ED2 model launch is that docker is not available on the hpc environment. Instead singularity is available and for the most part can accomplish the same goals.
See [singularity docs](https://sylabs.io/docs/) for more information on the similarities/differences and cross-over between the two.

1) First thing is to simply ssh into the hpc, like so

    `
    ssh <your-username>@hpc.arizona.edu
    `

    Alternatively you could also make use of the ood interface located [here](ood.hpc.arizona.edu). Documentation, shell access, and job submission forms may be found here among other useful interfacing tools.
2) Secondly there are no modules (such as singularity) ready to go by default. The following command will load in singularity

    `
    module load singularity
    `

    Use `module avail` to see the full list of available modules

3) Pull the image down from dockerhub: [pecan/model-ed2-git](https://hub.docker.com/r/pecan/model-ed2) 
This can be done with the following singularity command

    `
    singularity pull docker://pecan/model-ed2-git
    `
    
    When this has finished there should be a .sif file for the singularity container which will be used later
4) This done the next step would be to download some site data to run the model on. For the purposes of doing a test run the set found [here](https://pecanproject.github.io/pecan-documentation/master/workflow-modules.html#install-data) was used.
    * Here this set uses curl which is a module that needs to be loaded just as singularity was before.
5) From here the two final things needed are the config.xml and the ED2IN files (for the purposes of this test run the ones used were [here](https://pecanproject.github.io/pecan-documentation/master/workflow-modules.html#inst-ed2), scroll down until you see ED 2.2 r82, focus on the second part where it says to perform a test run)
6) All this done there should simply be left to run the container and mount everything onto it correctly in a highly convoluted manner, like so. 

    `
    singularity run -B ~/<path-sites-folder>:/data -B ~/<path-to-inputs-folder>:/data/inputs -B ~/<path-to-config.xml>:/work/config.xml -B ~/ED2IN:/work/ED2IN ~/<path-ed2-singularity-image-file> /bin/bash
    `
    
    `-B` is the singularity flag for mounting to containers
    
    After this command is executed (given there are no errors of course) you will be within the container shell. There may be different visual representations the console will give for being in the container and could seem almost as if there is no difference. To check that you are within type out `ed2` and press tab to autocomplete the command `ed2.git` should be what it completes to. Or simply trying to execute the `ed2.git` command should not return a `bash:command ed2.git is not recognized` error.
7) At this point the `ed2.git` command should be executed with the `-s` flag to stop anything relying on mpi.
8) As far as fully implementing/running the model as a whole (as in outside of a small test run) see this documentation for either calling up an [interactive hpc session](https://public.confluence.arizona.edu/display/UAHPC/Running+Jobs#RunningJobs-6.InteractiveJobs
) or simply [submitting an hpc job](https://public.confluence.arizona.edu/display/UAHPC/Running+Jobs). 