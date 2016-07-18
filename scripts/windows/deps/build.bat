@echo off
call .\env.bat
set BUILD_COMMAND=jom /J 4
set BUILD_TYPE=Release
set SCRIPT_DIR=%CD%
cd ..\..\..
set DEV_HOME=%CD%

if defined DEPENDENCY_VERSION (
set INSTALL_PREFIX=%DEV_HOME%\ossim-deps-%DEPENDENCY_VERSION%
) else (
set DEPENDENCY_VERSION=1.0.0
set INSTALL_PREFIX=%DEV_HOME%\ossim-deps-1.0.0
)

if not exist "%INSTALL_PREFIX%" ( mkdir "%INSTALL_PREFIX%" )
rem echo ************************** BUILDING kakadu-v7_5-01123C**************************
rem cd "%DEV_HOME%\kakadu-v7_5-01123C\apps\kdu_hyperdoc"
rem msbuild kdu_hyperdoc_2013.vcxproj /p:Configuration=Release;Platform=x64
rem if errorlevel 1 goto exitprogram

echo ************************** COPYING binaries MrSID_DSDK-9.5.1.4427-win64-vc14 **************************
if not exist "%INSTALL_PREFIX%\mrsid" ( mkdir "%INSTALL_PREFIX%\mrsid")
if not exist "%INSTALL_PREFIX%\mrsid\Lidar_DSDK" ( mkdir "%INSTALL_PREFIX%\Lidar_DSDK")
if not exist "%INSTALL_PREFIX%\mrsid\Raster_DSDK" ( mkdir "%INSTALL_PREFIX%\Raster_DSDK")

if errorlevel 1 goto exitprogram
xcopy "%DEV_HOME%\MrSID_DSDK-9.5.1.4427-win64-vc14\Lidar_DSDK\*" "%INSTALL_PREFIX%\mrsid\Lidar_DSDK\" /s /e /Y
if errorlevel 1 goto exitprogram
xcopy "%DEV_HOME%\MrSID_DSDK-9.5.1.4427-win64-vc14\Raster_DSDK\*" "%INSTALL_PREFIX%\mrsid\Raster_DSDK\" /s /e /Y
if errorlevel 1 goto exitprogram

echo ************************** COPYING binaries kakadu-v7_5-01123C-winx64 **************************
if not exist "%INSTALL_PREFIX%\kakadu" ( mkdir "%INSTALL_PREFIX%\kakadu")

if errorlevel 1 goto exitprogram
xcopy "%DEV_HOME%\kakadu-v7_5-01123C-winx64\*" "%INSTALL_PREFIX%\kakadu\" /s /e

if errorlevel 1 goto exitprogram

echo ************************** BUILDING hdf5-1.8.16 ************************
cd "%DEV_HOME%\hdf5-1.8.16"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
rem jom install
nmake install
if errorlevel 1 goto exitprogram

echo ************************** BUILDING sqlite-3100100 ************************
cd "%DEV_HOME%\sqlite-3100100"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=1
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram


echo ************************** BUILDING geos-3.4.2************************
cd "%DEV_HOME%\geos-3.4.2"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram


echo ************************** BUILDING expat-2.1.0 ************************
cd "%DEV_HOME%\expat-2.1.0"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram


echo ************************** BUILDING curl-7.46.0 ************************
cd "%DEV_HOME%\curl-7.46.0"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram


echo ************************** BUILDING zlib-1.2.5 *********************
cd "%DEV_HOME%\zlib-1.2.5"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram


echo ************************** BUILDING libpng-1.2.43 *********************
cd "%DEV_HOME%"\libpng-1.2.43
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DPNG_SHARED=ON -DPNG_STATIC=OFF -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram


echo ************************** BUILDING libjpeg-turbo-1.4.2 *********************
cd "%DEV_HOME%\libjpeg-turbo-1.4.2"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DENABLE_STATIC=OFF -DENABLE_SHARED=ON -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DWITH_SIMD=FALSE -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram


echo ************************** BUILDING tiff-4.0.6 *********************
cd "%DEV_HOME%"\tiff-4.0.6
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram

echo ************************** BUILDING proj-4.9.2 *********************
cd "%DEV_HOME%\proj-4.9.2"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DPROJ_LIB_SUBDIR=lib -DLIBDIR=lib -DPROJ_INCLUDE_SUBDIR=include -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram

echo ************************** BUILDING libgeotiff-1.4.1 *********************
cd "%DEV_HOME%\libgeotiff-1.4.1"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram

echo ************************** BUILDING gpstk-2.5 **********************
cd "%DEV_HOME%\gpstk-2.5\dev"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_CXX_FLAGS="/wd4290 /EHsc" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
if errorlevel 1 goto exitprogram

echo ************************** BUILDING gdal-2.0.1 *********************
cd "%DEV_HOME%\gdal-2.0.1"
set GDAL_HOME=%INSTALL_PREFIX%
nmake /f makefile.vc MSVC_VER=1900
if errorlevel 1 goto exitprogram
cd "%DEV_HOME%"\gdal-2.0.1
nmake /f makefile.vc MSVC_VER=1900 devinstall
if errorlevel 1 goto exitprogram

echo ************************** BUILDING opencv-3.1.0 ************************
cd "%DEV_HOME%\opencv-3.1.0"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
jom install
if errorlevel 1 goto exitprogram


echo ************************** BUILDING OpenSceneGraph-3.2.3 *********************
cd "%DEV_HOME%\OpenSceneGraph-3.2.3"
if not exist build ( mkdir build )
cd build
cmake .. -G "NMake Makefiles JOM" -DCMAKE_CXX_FLAGS="/EHsc -DWIN32 -DNOMINMAX" -DCMAKE_C_FLAGS="/EHsc -DNOMINMAX" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%
if errorlevel 1 goto exitprogram
%BUILD_COMMAND% install
REM nmake install
if errorlevel 1 goto exitprogram

cd "%SCRIPT_DIR%"
exit

:exitprogram
exit
