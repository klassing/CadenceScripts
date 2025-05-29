@echo off

:: -----------------------------------------------
:: - Author: Ryan Klassing
:: - Description: 
:: -    Basic "installer" for the 'load_pcb_colors.il' SKILL script files.
:: -    This file will copy all necessary files to the appropriate Cadence directories.

::Setup general constants
set script_version=v0.1.2

::setup filepath constants
set allegro_color_path=C:\Cadence\PCB_colors\
set allegro_skill_path=C:\Cadence\SPB_24.1\share\pcb\etc\
set script_color_path=color_files\
set script_skill_path=script_files\

::setup file search constants
set skill_search=*.il
set palette_search=*.col
set param_search=*.prm
set init_file=allegro.ilinit

::alert the start of the installer
echo ************************************************
echo *****                                      *****
echo *****     Skill script installer: %script_version%     *****
echo *****                                      *****
echo ************************************************

::verify the script color filepath exists
if not exist %script_color_path% (
    echo Unable to find path: %script_color_path%.  Unable to proceed.
    GOTO END
)

::verify the script skill filepath exists
if not exist %script_skill_path% (
    echo Unable to find path: %script_skill_path%.  Unable to proceed.
    GOTO END
)

::verify the PCB color destination filepath exists, otherwise create it
if not exist %allegro_color_path% mkdir %allegro_color_path%

::copy the color files
echo ..Copying color files...
robocopy %script_color_path% %allegro_color_path% %param_search% %palette_search%

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