;--------------------TITLE BLOCK------------------------------------
;This script will automatically detect the number of etch layers (copper layers)
;  in the .brd file, and load a corresponding color param + color palette based
;  on the layer count.
;
;This script has been written and tested with Allegro 23.1 only
;
;Created by Ryan Klassing
;--------------------TITLE BLOCK------------------------------------

;------------------VERSION HISTORY----------------------------------
;   v0.1.1    (2024-04-23)
;       -Changed the layer naming strategy to hopefully prevent conflicts
;           -v0.1 has a bug where if a user already used L02/L03 type naming, but had them in the wrong order -- we could hit a naming conflict
;           -Naming strategy is as follows:
;               1) Load up all existing layer names from the user
;               2) Temporarily rename them to a naming convention that is extremely unlikely for the user to have picked (to try to ensure we have no naming conflicts)
;               3) Now that we should have a clean starting point (no existing names should match the ideal "garmin standard" now) --> rename all layers sequentially to the garmin standard (L02, L03, ...)
;               4) After applying the appropriate color file, rename layers back to their original state form Step1
;
;   v0.1.0    (2024-01-16)
;       -initial launch of the script
;------------------VERSION HISTORY----------------------------------

;--------------------INSTALLATION-----------------------------------
; 1) Create the following directory, if it doesn't exist: C:\Cadence\PCB_colors\
; 2) Place the desired color palette into C:\Cadence\PCB_colors\
;   **** Important Note ****
;      The default name is "ROYGBIV_palette.col" --> if you wish to use a different
;       filename, do a CTRL+F in this document for the varible PALETTE_NAME and store 
;       your palette's filename into this variable --> then save to update
; 3) Place the desired parameter files for each stackup layer count into C:\Cadence\PCB_colors\
;   **** Important Note ****
;      The names much match the layer count of the stackup: 2L.prm , 4L.prm , ... 10L.prm , 12L.prm , ...
; 4) Place this skill script into the following directory: C:\Cadence\SPB_23.1\share\pcb\etc\
; 5) If you haven't already loaded skill scripts before:
;   5.a) Navigate to C:\Cadence\SPB_23.1\share\pcb\etc\
;   5.b) Copy the file "example.ilinit" and rename it to "allegro.ilinit" in the same directory
;--------------------INSTALLATION-----------------------------------

;---------------------HOW TO USE------------------------------------
;How to use the script depends on whether you have configured the script to auto-load or not
;   Option 1: Via Command Line
;       To manually execute the script after it's been auto-loaded, simply type "load_pcb_colors" into the command window in Allegro
;
;   Option 2: Via Funckey (highly recommended)
;       To simplify the execution, add the following line to the env file located at C:\SPB_Data\pcbenv\
;           funckey C load_pcb_colors
;       Note --> you can change the "C" to whatever key you would like this command bound to
; 
;   Option 3: Run by menu item
;       To automatically add this command to the Allegro menu, ensure the variable ADDMENU is set to 1
;       To prevent it being added from the menu, ensure variable addmenu is set to 0
ADDMENU = 1     ;NOTE, menu will be found on the top of Allegro menu bar under "Colors" -> "Load Color File"
;
;
;   Note: in case the script isn't installed following the instructions under "INSTALLATION" above, then you will need to manually
;       load it each time you want to invoke any of the options above.  It can be loadded by typing "skill load PATH_TO_FILE" in the command line
;---------------------HOW TO USE------------------------------------

;----------------------------- THE SCRIPT ---------------------------------------
;Script version
VERSION = "v0.1.1"

;Print a note in Allegro commadn line when this script is loaded
printf("  --> Loading Skill file: \"load_pcb_colors.il\" - %s\n", VERSION)

;Create variable to keep track of the procedure name
load_pcb_colors_command = "load_pcb_colors"     ;NOTE --> this must match exactly the procedure name below

;-------------------------------------
;Definition of load_pcb_colors command
;-------------------------------------
;  Basic Algorith:
;   1) Store a copy of the current electrical layers (and their names)
;   2) Loop through each layer, and ensure its name matches the Garmin standard (TOP, L02, L03, ... L14, L15, BOTTOM)
;       Note: this is necessary to allow the color parameter file to apply colors to known layer names
;   3) Load an appropriate color parameter file and color palette based on the layer count
;   4) Rename all layers back to their original name, based on the copy stored in step 1
;
;  End Result:
;   All layer names will remain untouched (we'll rename during the script, but put them back to their old name when finished)
;   Color files will be applied based on the qty of layers
procedure( load_pcb_colors()
	;define constants
	PALETTE_NAME = "ROYGBIV_palette.col"            ;filename for the color palette to be used
	COLOR_PATH = "C:\\Cadence\\PCB_colors\\"        ;directory that holds the palette and color param files
    PARAM_END = "L.prm"                             ;ending characters for the color param files that comes after the layer count
    TOP_NAME = "TOP"                                ;External top layer name
    BOT_NAME = "BOTTOM"                             ;External bottom layer name
    LAYER_TEMP_NAME = "TMP_LYR_RNME_"               ;This naming will be temporarily applied to layers to hopefully prevent any naming conflicts with the standard naming topology
	
    ;print to the terminal that the script is starting
	println("Starting load_pcb_colors script.")

    ;store a copy of all etch layers in the cross section
    etchLayers = axlGetParam("paramLayerGroup:ETCH")->groupMembers

    ;determine how many layers there are
    layerCount = length(etchLayers)

    ;convert the layer count to a string for easier concatenation below
    strLayerCount = sprintf(nil "%d" layerCount)

    ;report the layer count in case something went wrong
    printf(".. Detected %s layers.\n", strLayerCount)

    ;log that we're about to rename layers
    println("..Temporarily renaming layers to prevent naming conflicts")

    ;ensure the external layers in the live cross section match the Garmin standard
    renameLayer(nth(0 etchLayers) TOP_NAME)                 ;rename the top layer
    renameLayer(nth(layerCount-1 etchLayers) BOT_NAME)      ;rename the bottom layer

    ;create an array to contain all temporary middle layer names
    declare(tempLayerNames[layerCount])

    ;fill the temporary array with the desired temporary names
    for(i 1 layerCount-2 
        setarray(tempLayerNames i sprintf(nil "%sL%02d" LAYER_TEMP_NAME i+1)) ;reminder --> array is 0 indexed, layer names are 1 indexed
    )

    ;rename the layer stack layers to the temporary names first --> this is done to prevent naming conflicts when moving to the "garmin standard names"
    for(i 1 layerCount-2
        renameLayer(nth(i etchLayers) tempLayerNames[i])
    )

    ;Log that we're renaming again
    println("..Proceeding with a safe rename to garmin's naming standard, to assist with color mapping.")

    ;now, rename the layers following the "garmin standard name" which is based on their layer ID
    for(i 1 layerCount-2
        renameLayer(tempLayerNames[i] sprintf(nil "L%02d" i+1)) ;reminder --> array is 0 indexed, layer names are 1 indexed
    )

    ;create the full filename to be loaded based on the layer count
    colorParamFile = strcat(COLOR_PATH , strLayerCount , PARAM_END)

    ;load the color param file
    axlImportXmlDBRecords(colorParamFile)

    ;for some stupid reason, the param file resets to the default color palette (even if it's exported WITH color palette selected)
    ;   therefore, we need to load the desired color palette
    colorPalette = strcat(COLOR_PATH , PALETTE_NAME)
    axlColorLoad(colorPalette)

    ;log status
    println("..Colors applied, reverting any renamed layers to their original name.")

    ;Revert external layer names as needed
    renameLayer(TOP_NAME nth(0 etchLayers))                 ;rename the top layer
    renameLayer(BOT_NAME nth(layerCount-1 etchLayers))      ;rename the bottom layer

    ;Revert inner layers as needed
    for(i 1 layerCount-2
        renameLayer(sprintf(nil "L%02d" i+1) nth(i etchLayers)) ;reminder --> array is 0 indexed, layers are 1 indexed
    )

    ;finished
    println("Color files loaded and all layer names returned to original name.")
)

;-------------------------------------
;Definition of command to rename layers in the stackup
;-------------------------------------
procedure( renameLayer(oldName newName)
    ;create a flag to return success (or lack thereof)
    success = nil

    ;only proceed if the newName is different than the oldName
    when( oldName != newName

        ;grab the layer property
        Layer = axlXSectionGet(nil oldName)

        ;only proceed if an existing layer name was provided
        when( Layer
            ;found a matching layer - create a structure to modify the new name
            newData = axlXSectionModify(
                ?name newName
            )

            ;push the structure to modify the name
            success = axlXSectionSet(Layer newData)

            ;log the results
            println(sprintf(nil "....Layer [%s] was renamed to [%s]" oldName Layer->name))
        )
    )

    ;returns nil if no rename was performed
    success
)

;-------------------------------------
;Definition of command to add a menu item to trigger the loading of colors
;-------------------------------------
procedure( pcb_color_menu_trigger(@optional t_menu)
    ;define some constants
    color_menu = "Colors"               ;menu name
    color_text = "Load Color File"      ;text to be displayed in the menu

    ;See if this menu already exists
    colorPtr = axlUIMenuFind(nil load_pcb_colors_command)

    ;Add to the menu if configured to do so and it doesn't already exist
    if((ADDMENU > 0 && !colorPtr) then 

        ;put the menu pointer to just before the Help menu
        menuPtr = axlUIMenuFind(nil -1)

        ;create a menu folder to contain the command
        colorMenu = axlUIMenuInsert(menuPtr 'popup color_menu)

        ;add the command to the menu
        axlUIMenuInsert(colorMenu color_text load_pcb_colors_command)
    )
)

;register the primary command, so we can start it from Allegro command line
axlCmdRegister(load_pcb_colors_command `load_pcb_colors)

;register the menu command, so users can invoke it later if desired
axlCmdRegister(strcat("add_menu_" , load_pcb_colors_command) `pcb_color_menu_trigger)

;attach the add menu callback procedure to the menu trigger
axlTriggerSet('menu 'pcb_color_menu_trigger)