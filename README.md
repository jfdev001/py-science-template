# Development

## Setup

1. Make sure that you have `make` installed
2. Make sure that you can use `bash` (see [here](https://www.howtogeek.com/444596/how-to-change-the-default-shell-to-bash-in-macos-catalina/) for macOS)
3. Make sure that you have conda installed (`which conda` should return a path to your conda installation)
4. call `make create_environment`

## Installing new packages
In the appropriate conda environment, install packages using `conda install <name of package>`. Whatever package you installed, you should add its name to the `environment.yml` file. Other users of the repository can then easily update their local environments in order to have the same packages as you. To update your local environment with a changed environment file, call the below command:

```shell
make update_environment
```

## Git

Anytime you're developing, make sure you create a new branch.

```shell
# Creates a new git branch called `mybranch`
git checkout -b mybranch
```

Make the minimal necessary changes to get what you need working. 

```shell
# Stage those changes
# NOTE: Try to be in the root project directory, otherwise you might 
# accidentally only stage some of your changes
git add ./
```

Then commit those changes with an appropriately descriptive message. You can write short messages with the below command:

```shell
git commit -m "a short message"
```

or you can write a longer message in the default text editor of your system with this command:

```shell
git commit
```

Once you've committed, what you've done is create a local commit history for *your* branch only. The `main` branch does not *see* these changes. In order for the `main` branch to see these changes, checkout to the `main` branch and then merge with the name of your branch:

```shell
git checkout main
git merge mybranch
```

If you end up with merge conflicts, best to resolve these in an IDE like vscode. Try not to work on the same `.ipynb` as your peers since these are prone to merge conflicts. If something breaks, it's easy to walk changes back, so don't worry about this. 

Once you're ready to push your changes to the remote repository, do the following:

```shell
git pull
git push
```

Always pull before you push. Again, if you end up with merge conflicts, just be judicious about what you change.

You can rinse and repeat this process since this is the minimum commands needed for git. There are plenty of tutorials as well online, so feel free to look at those.

# Project Organization
------------

    ├── LICENSE
    ├── Makefile           <- Makefile with commands like `make create_environment`
    ├── README.md          <- The top-level README for developers using this project.
    ├── data
    │   ├
    │   ├── interim        <- Intermediate data that has been transformed.
    │   ├── processed      <- The final, canonical data sets for modeling.
    │   └── raw            <- The original, immutable data dump.
    │
    ├
    │
    ├── models             <- Trained and serialized models, model predictions, or model summaries
    │
    ├── notebooks          <- Jupyter notebooks. Naming convention is a number (for ordering),
    │                         the creator's initials, and a short `-` delimited description, e.g.
    │                         `1.0-jqp-initial-data-exploration`.
    │
    ├── references         <- Data dictionaries, manuals, and all other explanatory materials.
    │
    ├── reports            <- Generated analysis as HTML, PDF, LaTeX, etc.
    │   └── figures        <- Generated graphics and figures to be used in reporting
    │
    ├── environment.yml    <- The environment file for reproducing the analysis environment
    │                         
    │
    ├── setup.py           <- makes project pip installable (pip install -e .) so src can be imported
    ├── src                <- Source code for use in this project.
    │   ├── __init__.py    <- Makes src a Python module
    │   │
    │   ├── data           <- Scripts to download or generate data
    │   │   └── make_dataset.py
    │   │
    │   ├── features       <- Scripts to turn raw data into features for modeling
    │   │   └── build_features.py
    │   │
    │   ├── models         <- Scripts to train models and then use trained models to make
    │   │   │                 predictions
    │   │   ├── predict_model.py
    │   │   └── train_model.py
    │   │
    │   └── visualization  <- Scripts to create exploratory and results oriented visualizations
    │       └── visualize.py


--------
