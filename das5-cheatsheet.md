# DAS-5 Cheat Sheet

- DAS5 uses a scheduler called SLURM, the basic procedure to use it is first reserving a node (or a number of them) and then running your script on that node.
- You are recommended to use the VU node of DAS-5 (fs0.das5.cs.vu.nl)
- You are not allowed to use the account name given to you for this course for any other work such as training NN etc...
- For information about DAS-5 see https://www.cs.vu.nl/das5/

## DAS-5 Usage Policy

- Once you log in to DAS-5 you will be automatically in a shell environment on the headnode.
- While on the headnode you are only supposed to edit files and compile your code and not execute code on the head node.
- You need to use prun to run your code on a DAS-5 node.
- You should not execute on a DAS-5 node for more than 15 minutes at a time.

## Connecting to DAS-5

Use ssh to connect to the cluster:

```
ssh -Y username@fs0.das5.cs.vu.nl
```

Enter your password, If its correct then you should be logged in.

Note that you are not at VU, then you will have to first ssh to a VU login node, and then ssh to DAS-5 from there. For example,

```
ssh vuusername@ssh.data.vu.nl # then type in password for vu login
ssh dasusername@fs0.das5.cs.vu.nl # then type password for das5
```

where `vuusername` is something along the lines of `jfr226`, that is whatever you use to access your VU canvas.

If you are a MacOS or Linux user, ssh is already available to you in the terminal.

If you are a Windows user, you need to use a ssh client for Windows. The easiest option is to use putty: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html

## Standard Hardware

From [here](https://www.cs.vu.nl/das5/special.shtml):

"""
The standard compute node type of DAS-5 sites has a dual 8-core 2.4 GHz 
(Intel Haswell E5-2630-v3) CPU configuration and 64 GB memory. 
"""

## Commands

#### Training GPU Accelerated ML Models

On DAS-5, the latest possible version of TensorFlow (as of JGF writing 2023-04-20) that 
can be run (and the toolkits that are tested by Google) is TensorFlow 
v2.4.0. In order to run ML jobs, you need to have a `conda` environment setup 
on DAS-5. Note that `<username>` corresponds to what is written in 
`<username>@fs0 ~$`. Your `<username>` is also an environment variable that
can be printed by typing `echo $USER` into the terminal, though with bash
commands like `cd`, if you include `$USER`, then bash will substitute the
value of that environment variable into the command. Anyways, to set up conda 
simply do the following:

```shell
##################################################
# Setting up miniconda
##################################################

# Change to a `scratch` directory that is much larger than the home directory
# $USER == your username... so for JGF the below command would be evaluated
# as `cd /var/scratch/ppp2211`
cd /var/scratch/$USER

# Download the miniconda installer
wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh

# Run the installer
# IMPORTANT!!!!!!
# You will be asked where to install miniconda3, specify
# the following path: /var/scratch/<username>/miniconda3
bash Miniconda3-latest-Linux-x86_64.sh

# Logout of DAS-5 then log back in.
# Your terminal should now look like 
(base) [<username>@fs0 ~]$

# Because you will be using pip, and since pip will cache packages by
# default in the userhome directory, which has limited space, you should
# change the default caching directory that pip uses with the following:
mkdir -p /var/scratch/$USER/.cache/pip
echo export PIP_CACHE_DIR="/var/scratch/$USER/.cache/pip" >> ~/.bashrc
```

Now that you have installed `conda`, you can setup TensorFlow:

```shell
##################################################
# Then you have two options to set up TensorFlow:
# (1) using `make` if you are in JGF repository
# (2) doing it yourself
##################################################

# To do (1)
# All you need to do is the following:
make create_environment # or if any env already exists, `make update_environment`
conda activate <name of environment>
module load cuda11.0/toolkit/11.0.3
module load cuDNN/cuda11.0/8.0.5

# To do (2), it's mostly the same
conda create --name <name of environment> python=3.8 -y
conda activate <name of environment>
pip install tensorflow==2.4.0
module load cuda11.0/toolkit/11.0.3
module load cuDNN/cuda11.0/8.0.5

# After either (1) or (2), you can verify that
# your tensorflow detects GPUs by running the below command.
# if the the printed number of GPUs available is greater than 0, then it works
prun -np 1 -native '-C TitanX --gres=gpu:1' -v  \
    python -c "import tensorflow as tf; print('Num GPUs Available:', len(tf.config.list_physical_devices('GPU')))"
```

Now that you have TensorFlow on DAS-5 setup, you can run GPU accelerated jobs
by just scheduling the job and running the python script. Here is a dummy
example in which I specify using a TitanX GPU:

```shell
prun -np 1 -native '-C TitanX --gres=gpu:1' -v  python <script.py> <script args>
```

See the next subsection for which GPUs are available, but in general, it is
best to simply use the RTX 2080 TI by doing a command such as the following:

```shell
prun -np 1 -native '-C RTX2080Ti --gres=gpu:1' -v  python <script.py> <script args>
```

Note that you can debug as normal using 

#### DAS-5 GPUs

See [here](https://en.wikipedia.org/wiki/List_of_Nvidia_graphics_processing_units) for a list of NVIDIA GPUs. Based on the wiki, the NVIDIA GPUs that are available on DAS-5 are dated in the table below.

| Year        | GPU on DAS-5|
| ----------- | ----------- |
| 2018        |  RTX2080Ti  |
| 2015        |  TitanX     |
| 2015        |  GTX980     |
| 2013        |  K20        |

### DAS-5 Special Hardware
From [here](https://www.cs.vu.nl/das5/special.shtml):
* 16 of the GPU nodes have an NVidia GTX TitanX Maxwell GPU;
* 2 of the GPU nodes have two (!) NVidia GTX Titan X Pascal GPUs;
* 1 of the GPU nodes has an NVidia GTX980 GPU;
* 1 of the GPU nodes has an NVidia GTX Titan GPU;
* 1 of the GPU nodes has an NVidia Tesla K20 GPU;
* 1 of the GPU nodes has two (!) NVidia RTX 2080 Ti GPUs;
* 16 of the regular CPU nodes have a 240 GB SSD drive mounted as /local-ssd;
* node069-node071,node078: 4 next-generation compute nodes with an 
NVidia RTX 2080 Ti GPU, specially purchased for long VU/AI application jobs; 
they are in the special partition "proq";
* node076 and node077: Intel Knights Landing nodes.

### Show nodes informations ( available hardware etc )

```
sinfo -o "%40N %40f"
```

### Check which modules are loaded at the moment

```
module list 
```

### Check which modules are available

```
module avail
```

### Load prun

```
module load prun
```

### Load cuda module

```
module load cuda80/toolkit
```

### Show active and pending reservations

```
preserve -llist
```

### Reserve a node with the â€™cpunodeâ€™ flag for 15 minutes:

- **BE AWARE: 15 minutes is the maximum time slot you should reserve!**
- **In the output of your command you will see your reservation number**

```
preserve -np 1 -native '-C cpunode' -t 15:00
```

### RUN CODE ON YOUR RESERVED NODE

```
prun -np 1 -reserve <RESERVATION_ID> cat /proc/cpuinfo
```

### GET A RANDOMLY ASSIGNED NODE AND RUN CODE ON IT

```
prun -np 1 cat /proc/cpuinfo
```

### SCHEDULE A RESERVATION FOR A NODE WITH A GTX1080TI GPU ON CHRISTMAS DAY ( 25TH OF DECEMBER )STARTING AT MIDNIGHT AND 15 MINUTES FOR 15 MINUTES

```
preserve -np 1 -native '-C gpunode,RTX2080Ti' -s 12-25-00:15 -t 15:00
```

### CANCEL RESERVATION

```
preserve -c <RESERVATION_ID>
```
