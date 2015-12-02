# ossim-GoCD

#### This repository generally is not cloned by humans. It is intended for access by an automated GoCD continuous-integration process used by the core OSSIM development team. 

While OSSIM core contains scripts for building and testing OSSIM. The scripts included here are tailored for working in a GoCD environment.

## OSSIM Preferences for GoCD

This repository also maintains the ossim-preferences file used by the GoCD agents. It provides paths to all plugins as they are made available in the pipeline configuration. It also provides the path to the elevation data used in the OSSIM testing. 

The following environment variables need to be defined in the GoCD pipeline environment:

   * OSSIM_DATA -- Location on the GoCD agent outside of the pipeline where the test data resides. It is syncronized against a master data repository each time the pipeline is executed
   * OSSIM_DATA_REPOSITORY -- The NFS mount location for the remote data repository
   * GENERATE_EXPECTED_RESULTS -- must be set to true for the first run of tests to generate expected results in $OSSIM_DATA/expected_results
   
