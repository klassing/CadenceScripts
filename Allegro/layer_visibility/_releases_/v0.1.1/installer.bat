@echo off

:: -----------------------------------------------
:: - Author: Ryan Klassing
:: - Description: 
:: -    Basic "installer" for the 'layer_visibility.il' SKILL script files.
:: -    This file will copy all necessary files to the appropriate Cadence directories.

::Setup general constants
set installer_version=v0.1.1

::setup filepath constants
set allegro_skill_path=C:\Cadence\SPB_24.1\share\pcb\etc\
set script_skill_path=script_files\

::setup file search constants
set skill_search=*.il
set init_file=allegro.ilinit

::alert the start of the installer
echo ************************************************
echo *****                                      *****
echo *****     Skill script installer: %script_version%     *****
echo *****                                      *****
echo ************************************************

::verify the script skill filepath exists
if not exist %script_skill_path% (
    echo Unable to find path: %script_skill_path%.  Unable to proceed.
    GOTO END
)

::verify the necessary allegro path exists
if not exist %allegro_skill_path% (
    echo ..Allegro skill path is missing: %allegro_skill_path%
    echo Unable to proceed.  Please double check Allegro installation files and try again.
    GoTo END
)

::copy the skill script
echo ..Copying skill script files...
robocopy %script_skill_path% %allegro_skill_path% %skill_search%

::see if we need to copy the skill init file
if not exist %allegro_skill_path%%init_file% (
    ::copy the init file
    robocopy %script_skill_path% %allegro_skill_path% %init_file%
)

:END
    echo Skill installer has finished.
    pause