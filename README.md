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
* `upload_badge.sh <resource> <status>` -- This script updates the GoCD passed/failed/unknown status badge displayed on the ossim README.md (and here as well). Argument <resource> (as currently supported) must be one of the following: "centos6" | "centos7" | "win7x64" | "mac",  and <status> must be "passed" | "failed" | "unknown". See the "Badge Uploading" section below for more information.
 
# OSSIM Preferences for GoCD

This repository also maintains the ossim-preferences file used by the GoCD agents. It provides paths to all plugins as they are made available in the pipeline configuration. It also provides the path to the elevation data used in the OSSIM testing. 

# GoCD Pipelines

As of Dec 2015, the primary pipelines in use are 
* `ossimlabs-dev` -- Build and test of dev branch
* `ossimlabs-master` -- Build and test of master branch
* `OSSIM_Core-dev-build` -- Builds only ossim and ossim-plugins repos. Installs to a sandbox and uploads the zipped sandbox to the Go server as an artifact.
* `generate-test-expected` -- Generates expected results using the sandbox artifact created by OSSIM_Core-dev-build.
* `OSSIM_Core-dev-test` -- Runs tests using the sandbox artifact created by `OSSIM_Core-dev-build`.
* 
As described above, the following environment variables need to be defined in the GoCD pipeline environment test-stage:

   * OSSIM_DATA -- Location on the GoCD agent outside of the pipeline where the test data resides. It is syncronized against a master data repository each time the pipeline is executed.
   * OSSIM_DATA_REPOSITORY -- The NFS mount location for the remote data repository. 

## Customizing a Pipeline to Test a Feature Branch

The pipelines listed above apply mostly to the "dev" branch of all referenced reopsitories. However, it is fairly straightforward to create a new pipeline to test a feature branch instead:
1. Clone the pipeline you would like to use.
2. Change the materials list to reflect you feature branch.
That's it.


# Badge Uploading

The following describes the implementation in linux. Presumably a similar scheme will be adopted for other resource types.

The GoCD status is displayed in the README.md to provide a quick view of the latest pipeline status for the "dev" branch. There are three PNG images in this repository representing badges for "passed", "failed", and "unknown". One of these images are copied to a central server (omar.ossim.org) as `<resource>_status.png`, which in turn is accessed by the README.md. 

In GoCD, the last task of all jobs is to run the `upload_badge.sh <resource> failed` script if a failure is detected. This will upload the appropriate badge PNG to the image server. Furthermore, the last jobs of the last stage call `upload_badge.sh <resource> passed` to indicate all went well with the pipeline.

