# ossim-GoCD

#### This repository generally is not cloned by humans. It is intended for access by an automated GoCD setup stage.

GoCD automatically deletes all non-material folders in the pipeline root before fetching materials, even if the stage setting's "Clean Working Directory" is unselected. That setting applies only to specified materials (e.g., the ossim repository). Unfortunately, the "out-of-source" build was being deleted each time the materials were fetched, forcing a new and lengthy build from scratch each time. By placing the generated build files in a separate repo that is also specified as material for the pipeline, GoCD will not delete the build. 

The .gitignore file must contain all files and folders in the build so that no actual fetching occurs (except this README and the .gitignore file itself).

## OSSIM Preferences for GoCD

This repository also maintains the ossim-preferences file used by the GoCD agents. It provides paths to all plugins as they are made available in the pipeline configuration. It also provides the path to the elevation data used in the OSSIM testing. 

The following environment variables are referenced in the generic ossim-GoCD preferences file:

   * OSSIM_DATA
   * OSSIM_INSTALL_PREFIX
