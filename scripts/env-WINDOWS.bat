@echo off
setlocal enabledelayedexpansion
set SCRIPT_DIR=%~dp0
if not defined OSSIM_DEV_HOME (
   pushd %SCRIPT_DIR%..\..
   set OSSIM_DEV_HOME=!CD!
   popd
)
if not defined VISUAL_STUDIO_VERSION ( 
    set VISUAL_STUDIO_VERSION=14
)
if not defined OSSIM_INSTALL_PREFIX ( 
    set OSSIM_INSTALL_PREFIX=!OSSIM_DEV_HOME!install
)
if not defined OSSIM_DEPENDENCY_VERSION ( 
    set OSSIM_DEPENDENCY_VERSION=1.0.0
)
if not defined OSSIM_VERSION ( 
    set OSSIM_VERSION=1.9.0
)

set CMAKE_DIR=%OSSIM_DEV_HOME%\ossim\cmake

:: Default settings:
set PLATFORM=x64
set DEVENV=vs2015
set GEN_TYPE=NMAKE
set CMAKE_BUILD_TYPE=Release

:: Interpret the target system and set up environment:
IF %DEVENV%==vs2005 (
  IF %PLATFORM%==Win32 (
    set TARGET_SYSTEM="Visual Studio 8 2005"
    call "C:\Program Files (x86)\Microsoft Visual Studio 8\VC\vcvarsall" x86
  ) ELSE (
    set TARGET_SYSTEM="Visual Studio 8 2005 Win64"
    call "C:\Program Files (x86)\Microsoft Visual Studio 8\VC\vcvarsall" x64
  )
) 

IF %DEVENV%==vs2010 (
  IF %PLATFORM%==Win32 (
    set TARGET_SYSTEM="Visual Studio 10 Win32"
    call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall" x86
  ) ELSE (
    set TARGET_SYSTEM="Visual Studio 10 Win64"
    call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall" x64
  )
)

IF %DEVENV%==vs2015 (
  IF %PLATFORM%==Win32 (
    set TARGET_SYSTEM="Visual Studio 14 Win32"
    call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall" x86
  ) ELSE (
    set TARGET_SYSTEM="Visual Studio 14 Win64"
    call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall" x64
  )
)

if not defined BUILD_OMS (
   set BUILD_OMS=OFF
)

if not defined BUILD_CNES_PLUGIN (
   set BUILD_CNES_PLUGIN=OFF
)

if not defined BUILD_GEOPDF_PLUGIN (
   set BUILD_GEOPDF_PLUGIN=OFF
)
if not defined BUILD_GDAL_PLUGIN (
   set BUILD_GDAL_PLUGIN=OFF
)

if not defined BUILD_HDF5_PLUGIN (
   set BUILD_HDF5_PLUGIN=OFF
)

if not defined BUILD_KAKADU_PLUGIN (
   set BUILD_KAKADU_PLUGIN=OFF
)

if not defined BUILD_KAKADU_PLUGIN (
   set BUILD_KAKADU_PLUGIN=OFF
)

if not defined BUILD_KML_PLUGIN (
   set BUILD_KML_PLUGIN=OFF
)

if not defined BUILD_MRSID_PLUGIN (
   set BUILD_MRSID_PLUGIN=OFF
)

if not defined BUILD_OPENCV_PLUGIN (
   set BUILD_OPENCV_PLUGIN=OFF
)

if not defined BUILD_OPENJPEG_PLUGIN (
   set BUILD_OPENJPEG_PLUGIN=OFF
)

if not defined BUILD_PDAL_PLUGIN (
   set BUILD_PDAL_PLUGIN=OFF
)

if not defined BUILD_PNG_PLUGIN (
   set BUILD_PNG_PLUGIN=OFF
)

if not defined BUILD_SQLITE_PLUGIN (
   set BUILD_SQLITE_PLUGIN=OFF
)

if not defined BUILD_OSSIM_VIDEO (
   set BUILD_OSSIM_VIDEO=OFF
)

if not defined BUILD_OSSIM_GUI (
   set BUILD_OSSIM_GUI=OFF
)

if not defined BUILD_OSSIM_WMS (
   set BUILD_OSSIM_WMS=OFF
)

if not defined BUILD_OSSIM_PLANET (
   set BUILD_OSSIM_PLANET=OFF
)

set CMAKE_PARAMETERS=^
-DCMAKE_BUILD_TYPE=%CMAKE_BUILD_TYPE% ^
-DOSSIM_DEV_HOME=%OSSIM_DEV_HOME% ^
-D%PLATFORM%_USE_MP=ON ^
-DBUILD_LIBRARY_DIR=lib ^
-DBUILD_OMS=%BUILD_OMS% ^
-DBUILD_CNES_PLUGIN=%BUILD_CNES_PLUGIN% ^
-DBUILD_GEOPDF_PLUGIN=%BUILD_GEOPDF_PLUGIN% ^
-DBUILD_GDAL_PLUGIN=%BUILD_GDAL_PLUGIN% ^
-DBUILD_HDF5_PLUGIN=%BUILD_HDF5_PLUGIN% ^
-DBUILD_KAKADU_PLUGIN=%BUILD_KAKADU_PLUGIN% ^
-DKAKADU_ROOT_SRC=%KAKADU_ROOT_SRC% ^
-DKAKADU_AUX_LIBRARY=%KAKADU_AUX_LIBRARY% ^
-DKAKADU_LIBRARY=%KAKADU_LIBRARY% ^
-DBUILD_KML_PLUGIN=%BUILD_KML_PLUGIN% ^
-DBUILD_MRSID_PLUGIN=%BUILD_MRSID_PLUGIN% ^
-DMRSID_DIR=%MRSID_DIR% ^
-DOSSIM_PLUGIN_LINK_TYPE=SHARED ^
-DBUILD_OPENCV_PLUGIN=%BUILD_OPENCV_PLUGIN% ^
-DBUILD_OPENJPEG_PLUGIN=%BUILD_OPENJPEG_PLUGIN% ^
-DBUILD_PDAL_PLUGIN=%BUILD_PDAL_PLUGIN% ^
-DBUILD_PNG_PLUGIN=%BUILD_PNG_PLUGIN% ^
-DBUILD_SQLITE_PLUGIN=%BUILD_SQLITE_PLUGIN% ^
-DBUILD_OSSIM_VIDEO=%BUILD_OSSIM_VIDEO% ^
-DBUILD_OSSIM_GUI=%BUILD_OSSIM_GUI% ^
-DBUILD_OSSIM_WMS=%BUILD_OSSIM_WMS% ^
-DBUILD_OSSIM_PLANET=%BUILD_OSSIM_PLANET% ^
%CMAKE_DIR%
