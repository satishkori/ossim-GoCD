### Status of ossimlabs *dev* branch

Resource | GoCD Status
------------ | -------------
centos6 | ![centos6 Status](http://omar.ossim.org/gocd/centos6_status.png)
centos7 | ![centos7 Status](http://omar.ossim.org/gocd/centos7_status.png)
mac | ![mac Status](http://omar.ossim.org/gocd/mac_status.png)
win7x64 | ![win7x64 Status](http://omar.ossim.org/gocd/win7x64_status.png)

# ossim-GoCD

#### This repository generally is not cloned by humans. It is intended for access by an automated GoCD continuous-integration process used by the core OSSIM development team. 

While OSSIM core contains scripts for building and testing OSSIM. The scripts included here are tailored for working in a GoCD environment. Presently, only linux scripts are defined, but we hope to add scripts (and associated GoCD build/test/deploy pipelines) for Windows and Mac soon.

### Linux

The following scripts are used in the current GoCD pipelines:
* `install.sh` -- Called by the pipeline build-stage to install ossim in a sandbox directory. All subsequent tests are run from this sandbox. For the case where the build and test pipelines are separate (therefore no sandbox is preserved), the script takes the option "-z" to zip the install directory. The zipped install sandbox filename includes a time-stamp but a link to it is also created with the generic name "install.zip". This latter filename is used to upload the artifact for use by a subsequent test pipeline.
* `generate_results.sh <resource>` -- This is the script responsible for generating the expected results that will be uploaded to the GoCD server for subsequent testing on the same resource type. The script requires that the environment contain `$OSSIM_DATA` and `$OSSIM_DATA_REPOSITORY`, specifying where the test data and expected results are stored on the agent and the server.
* `sync_data.sh <resource>` -- This script syncronizes the test data and expected results between the GoCD server and the agent running the test. The expected results are generated for each agent OS, specified as the argument <resource>. The script insures that the correct expected results are copied. If expected results are being generated (as indicated by the environment variable `$SKIP_EXPECTED_RESULTS_SYNC`, then the script will not bother downloading those results. The script requires that the environment contain `$OSSIM_DATA` and `$OSSIM_DATA_REPOSITORY`, specifying where the test data and expected results are stored on the agent and the server.
* `test.sh` -- As the name implies, this is the script that runs all command-line OSSIM tests and checks for a failure. It exits with a 0 unless an error or failure was detected.  The script requires that the environment contain `$OSSIM_DATA`, specifying where the test data and expected results are stored on the agent. It is necessary to first run `sync_data.sh` to insure the data is present and updated before running the tests.
* `upload_badge.sh <resource> <status>` -- This script updates the GoCD passed/failed/unknown status badge displayed on the ossim README.md (and here as well). Argument <resource> (as currently supported) must be one of the following:
* * centos6
* * centos7
* * win7x64
* * mac
and <status> must be "passed" | "failed" | "unknown". 

 
## OSSIM Preferences for GoCD

This repository also maintains the ossim-preferences file used by the GoCD agents. It provides paths to all plugins as they are made available in the pipeline configuration. It also provides the path to the elevation data used in the OSSIM testing. 

The following environment variables need to be defined in the GoCD pipeline environment:

   * OSSIM_DATA -- Location on the GoCD agent outside of the pipeline where the test data resides. It is syncronized against a master data repository each time the pipeline is executed
   * OSSIM_DATA_REPOSITORY -- The NFS mount location for the remote data repository
   * GENERATE_EXPECTED_RESULTS -- must be set to true for the first run of tests to generate expected results in $OSSIM_DATA/expected_results
   
