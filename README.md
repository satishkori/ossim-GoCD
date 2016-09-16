### GoCD Status builds 
Resource | *master* | *dev* | 
------------ | ------------- | -------------
centos6 | ![centos6 Status](http://omar.ossim.org/gocd/status/centos6_master_status.svg) | ![centos6 Status](http://omar.ossim.org/gocd/status/centos6_dev_status.svg)
centos7 | ![centos7 Status](http://omar.ossim.org/gocd/status/centos7_master_status.svg) | ![centos7 Status](http://omar.ossim.org/gocd/status/centos7_dev_status.svg)

# ossim-GoCD

#### This repository generally is not cloned by humans. It is intended for access by an automated GoCD continuous-integration process used by the core OSSIM development team. 

While OSSIM core contains scripts for building and testing OSSIM, the scripts included here are tailored for working in a GoCD environment. 

### Linux

The following scripts are used in the current GoCD pipelines:

* `install.sh` -- Called by the pipeline build-stage to install ossim in a sandbox directory. All subsequent tests are run from this sandbox. For the case where the build and test pipelines are separate (therefore no sandbox is preserved), the script takes the option "-z" to zip the install directory. The zipped install sandbox filename includes a time-stamp but a link to it is also created with the generic name "install.zip". This latter filename is used to upload the artifact for use by a subsequent test pipeline.
* `generate_results.sh <resource>` -- This is the script responsible for generating the expected results that will be uploaded to the GoCD server for subsequent testing on the same resource type. The script requires that the environment contain `$OSSIM_DATA` and `$OSSIM_DATA_REPOSITORY`, specifying where the test data and expected results are stored on the agent and the server.
* `sync_data.sh <resource>` -- This script syncronizes the test data and expected results between the GoCD server and the agent running the test. The expected results are generated for each agent OS, specified as the argument <resource>. The script insures that the correct expected results are copied. If expected results are being generated (as indicated by the environment variable `$SKIP_EXPECTED_RESULTS_SYNC`, then the script will not bother downloading those results. The script requires that the environment contain `$OSSIM_DATA` and `$OSSIM_DATA_REPOSITORY`, specifying where the test data and expected results are stored on the agent and the server.
* `test.sh` -- As the name implies, this is the script that runs all command-line OSSIM tests and checks for a failure. It exits with a 0 unless an error or failure was detected.  The script requires that the environment contain `$OSSIM_DATA`, specifying where the test data and expected results are stored on the agent. It is necessary to first run `sync_data.sh` to insure the data is present and updated before running the tests.
* `upload_badge.sh <resource> <branch> <status> <stage>` -- This script updates the GoCD passed/failed/unknown status badge displayed on the ossim README.md (and here as well). Argument <resource> (as currently supported) must be one of the following: "centos6" | "centos7" | "win7x64", <branch> must be the branch we are building "dev" | "master", <status> must be "passed" | "failed" | "unknown", and <stage> is the stage we are in and can be "build" | "test". See the "Badge Uploading" section below for more information.
 
### Windows

The following scripts are used in the GoCD pipeline

* `build.bat`-- This script is called by the pipeline build stage to build OSSIM to a sandbox location identified by the OSSIM_INSTALL_PREFIX environment variable.  If not specified it will install in a directory called "install" at the root of the build pipeline directory.

# OSSIM Preferences for GoCD

This repository also maintains the ossim-preferences file used by the GoCD agents. It provides paths to all plugins as they are made available in the pipeline configuration. It also provides the path to the elevation data used in the OSSIM testing. 

# GoCD Pipelines

As of Jan 2016, the primary pipelines in use are 
* `ossimlabs-dev` -- Build and test of dev branch for linux
* `ossimlabs-dev-win7x64` -- Build and test of dev branch for windows
* `ossimlabs-master` -- Build and test of master branch for linux
* `generate-test-expected` -- Generates expected results using the sandbox artifact created by ossimlabs-dev.

TODO: Need to consolidate windows and linux builds/tests into a single pipeline.

As described above, the following environment variables need to be defined in the GoCD pipeline environment test-stage:
   * OSSIM_DATA -- Location on the GoCD agent outside of the pipeline where the test data resides. It is syncronized against a master data repository each time the pipeline is executed.
   * OSSIM_DATA_REPOSITORY -- The NFS mount location for the remote data repository. 

## Customizing a Pipeline to Test a Feature Branch

The pipelines listed above apply mostly to the "dev" branch of all referenced reopsitories. However, it is fairly straightforward to create a new pipeline to test a feature branch instead. These are the steps:

1. Clone the pipeline you would like to use. From the top menu bar of GoCD, select Admin->Pipelines, find the exisiting pipeline you would like to use for your branch, and select "Clone". GoCD will ask you to name your pipeline. You should include the branch name in the pipeline name to make it easy to identify. Your new pipeline will appear in the list.
2. Select your pipeline from the list to go to its setup page. Under the "Materials" tab, click on a material name, say "ossim". A dialog box will appear that let's you edit the branch being fetched. Enter your feature branch anem and then "CHECK CONNECTION" to make sure GoCD can see it.

That's it. Be aware that any testing stage will still use the expected results that were generated from the "dev" branch. If you did anything that changes the results, even if the result is better, your test will fail.


# Status Badges

## Creating the badges

We used the script `generateImageBadges.sh` found under the ossim-GoCD/scripts directory to generate the image badges used for showing status for our builds.  The site [http://img.shields.io](http://img.shields.io) has a restful API to produce the badges and was used by the `generateImageBadges.sh` script.


## Uploading Build Status

The following describes the implementation in linux. Presumably a similar scheme will be adopted for other resource types.

The GoCD status is displayed in the README.md to provide a quick view of the latest pipeline status for the "dev" and "master" branch. There are a set of SVG images in this repository representing badges for "passed", and "failed" and also which stage. One of these images are copied to a central server (omar.ossim.org) as `<resource>_<branch>_status.svg`, which in turn is accessed by the README.md. 

In GoCD, the last task of all jobs is to run the `upload_badge.sh <resource> <branch> failed <stage>` script if a failure is detected. This will upload the appropriate badge SVG to the image server. Furthermore, the last jobs of the last stage call `upload_badge.sh <resource> <branch> passed <stage>` to indicate all went well with the pipeline.
 

