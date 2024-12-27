@echo off

:: -----------------------------------------------
:: - Author: Ryan Klassing
:: - Description: 
:: -    Basic "installer" for the '_grm_AOEM_NetColors.tcl' TCL script files.
:: -    This file will copy all necessary files to the appropriate Cadence directories.

::Setup general constants
set installer_script_version=v0.1

::setup filepath constants
set syscap_tcl_path=C:\SPB_Data\cdssetup\canvas\resources\syscap\
set script_tcl_path=script_files\
set old_NetColors_script_path=%syscap_tcl_path%_grm_AOEM_NetColors.tcl

::setup file search constants
set tcl_search=*.tcl

::alert the start of the installer
echo ************************************************
echo *****                                      *****
echo *****      TCL  script installer: %installer_script_version%     *****
echo *****                                      *****
echo ************************************************

::verify the script tcl filepath exists
if not exist %script_tcl_path% (
    echo Unable to find path: %script_tcl_path%.  Unable to proceed.
    GOTO END
)

::verify the necessary syscap path exists
if not exist %syscap_tcl_path% (
    echo ..System Capture's TCL script path is missing: %syscap_tcl_path%
    echo ..Creating TCL script path at %syscap_tcl_path%
    mkdir %syscap_tcl_path%
)

::copy the TCL script
echo ..Copying TCL script files...
robocopy %script_tcl_path% %syscap_tcl_path% %tcl_search%

::this new script consolidates some previous files, so remove the old files if the user happened to previously install them
if exist %old_NetColors_script_path% (
    echo ..Cleaning up outdated scripts that are no longer used: %old_NetColors_script_path%
    del %old_NetColors_script_path%
)

:END
    echo TCL installer has finished.
    pause