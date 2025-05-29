;--------------------TITLE BLOCK------------------------------------
;This contains a handful of scripts to manage layer visibility for easier key binding
;
;This script has been written and tested with Allegro 23.1 only
;
;Created by Ryan Klassing
;--------------------TITLE BLOCK------------------------------------

;------------------VERSION HISTORY----------------------------------
;   v0.1    (2024-04-23)
;       -initial launch of the script
;------------------VERSION HISTORY----------------------------------

;--------------------INSTALLATION-----------------------------------
; 1) Place this skill script into the following directory: C:\Cadence\SPB_23.1\share\pcb\etc\
; 2) If you haven't already loaded skill scripts before:
;   2.a) Navigate to C:\Cadence\SPB_23.1\share\pcb\etc\
;   2.b) Copy the file "example.ilinit" and rename it to "allegro.ilinit" in the same directory
;--------------------INSTALLATION-----------------------------------


;---------------------HOW TO USE------------------------------------
;How to use the script depends on whether you have configured the script to auto-load or not
;   Option 1: Via Command Line
;       To manually execute the script after it's been auto-loaded, simply type any of the following commands:
;
;           ----COMMAND----             --------DESCRIPTION--------
;           hide_all_layers             - turns all layers visibility off
;           show_layers                 - can be used to set any number of layers passed by a RegEx or List of subclass names
;           show_top_layers             - sets all top layers to visible, leaving existing visible layers untouched
;           show_bot_layers             - sets all bottom layers to visible, leaving existing visible layers untouched
;           show_only_top_layers        - calls hide_all_layers, show_top_layers
;           show_only_bot_layers        - calls hide_all_layers, show_bot_layers
;           show_tb_layers              - calls show_top_layers, show_bot_layers
;           show_only_tb_layers         - calls hide_all_layers, show_ext_layers
;           show_etch_layers            - sets all etch layers to visible, leaving existing visible layers untouched
;                                         Note: can be called with an optional parameter to set a specific layer visibility only
;           show_only_etch_layers       - calls hide_all_layers, show_etch_layers
;           show_mech_layers            - sets mechanical relevant layers visible
;           show_all_layers             - calls hide_all_layers, show_top_layers(t), show_bot_layers(t), show_etch_layers, show_mech_layers
;           
;   Option 2: Via Funckey
;       To simplify the execution, add any of the above commands to the env file located at C:\SPB_Data\pcbenv\
;           An example is below:
;               funckey A show_all_layers
;           Note --> you can change the "C" to whatever key you would like this command bound to
; 
;   Option 3: Run by menu item
;       To automatically add this command to the Allegro menu, ensure the variable ADDMENU is set to 1
;       To prevent it being added from the menu, ensure variable addmenu is set to 0
ADDMENU = 1     ;NOTE, menu will be found on the top of Allegro menu bar under "Layer Visibility" -> Available Commands
;
;
;   Note: in case the script isn't installed following the instructions under "INSTALLATION" above, then you will need to manually
;       load it each time you want to invoke any of the options above.  It can be loadded by typing "skill load PATH_TO_FILE" in the command line
;---------------------HOW TO USE------------------------------------

;----------------------------- THE SCRIPT ---------------------------------------
;Script version
VERSION = "v0.1"

;Enable for debug printing, disable for release
DEBUG_PRINT = nil

;Print a note in Allegro commadn line when this script is loaded
printf("  --> Loading Skill file: \"layer_visibility.il\" - %s\n", VERSION)

;-------------------------------------
; Description: tool to wrap debug prints and to disable them during release
;--START------------------------------
    procedure( debugPrintln(message)
        if(DEBUG_PRINT && stringp(message) then println(message))
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to hide all layers
;--START------------------------------
    hide_all_layers_command = "hide_all_layers"     ; This text much match the procedure call --> easier for registering commands later
    hide_all_layers_menu_text = "Hide All Layers"   ; This text will be displayed in the menu for triggering this procedure
    procedure( hide_all_layers()
        ;Simple built in function from API - this procedure is basically a logical rename for ease of use
        axlVisibleDesign(nil)
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to set various layers to visible
;   Param RegEx: optional parameter as a string 
;       nil     ==> will not be used to set any layers visible
;     string    ==> will search all layer subclasses using this string as a RegEx and enable visibility for all matches
;   Param layerStrings: optional parameter as a list of strings (can also be a list of lists )
;       nil     ==> will not be used to set any layers visible
;       list    ==> will search all layer subclasses and set visible each exact match of every string in the list
;--START------------------------------
    procedure( show_layers(@key (RegEx nil) @rest layerStrings)
        ;Loop through each layer class in the design and set any layers that match the RegEx visible
        foreach(layerClass (axlGetParam("paramLayerGroup")->groupMembers)
            ;loop through each subclass for the layer
            foreach(layerSubClass (axlGetParam(sprintf(String "paramLayerGroup:%s" layerClass))->groupMembers)
                ;Loop through our defined list, and set to visible if any of them are found
                if(listp(layerStrings) then
                    ;Loop through each list within the list (layerStrings can be a list of lists)
                    foreach(searchList layerStrings
                        foreach(searchString searchList
                            ;See if the current subClass is in the list
                            if(equal(lowerCase(searchString) lowerCase(layerSubClass)) then
                                ;Enable the layer visibility
                                axlVisibleLayer(strcat(layerClass "/" layerSubClass) t)
                            )
                        )
                    )
                )

                ;If the user passed a RegEx to force certain enables, check for that match as well
                if(RegEx
                    ;See if the RegEx is found for this layer
                    if(rexMatchp(lowerCase(RegEx) lowerCase(layerSubClass)) then
                        ;Enable the layer visibility
                        axlVisibleLayer(strcat(layerClass "/" layerSubClass) t)
                    )
                )
            )
        )

        ;Refresh the display to take effect
        axlFlushDisplay()
        axlVisibleUpdate(t)
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to set the top layers visible, leaving other layers untouched
;   Param showAll: optional parameter. 
;       nil     ==> will only turn on the "visibleList"
;       t       ==> will force all layers with "top" in the name to be shown
;--START------------------------------
    show_top_layers_command = "show_top_layers"     ; This text much match the procedure call --> easier for registering commands later
    show_top_layers_menu_text = "Show Top Layers"   ; This text will be displayed in the menu for triggering this procedure
    procedure( show_top_layers(@optional (showAll nil))
        ;Define a list of layer names that we want to show, unless the user passes showAll = t
        ;   Note: feel free to modify this list of its desired to show other specific users
        visibleList = list(
            "Top"
            "Package_Top"
            "Soldermask_Top"
            "Pastemask_Top"
            "Filmmasktop"
            "Assembly_Top"
            "Other_Outline_Top"
            "Design_Outline"
            "Pin_Number"
            "Place_Grid_Top"
            "Silkscreen_Top"
            "Top_Room"
            "Drawing_Origin"
            "Title_Block"
        )

        ;Set a regular expression to use for searching the top layers
        if(showAll then searchEx = "top" else searchEx = nil)

        ;Log that we're starting
        debugPrintln("Enabling Top Layer visibility...")

        ;Enable the layers
        show_layers(?RegEx searchEx visibleList)
        
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to set the bottom layers visible, leaving other layers untouched
;   Param showAll: optional parameter. 
;       nil     ==> will only turn on the "visibleList"
;       t       ==> will force all layers with "bot" in the name to be shown
;--START------------------------------
    show_bot_layers_command = "show_bot_layers"         ; This text much match the procedure call --> easier for registering commands later
    show_bot_layers_menu_text = "Show Bottom Layers"    ; This text will be displayed in the menu for triggering this procedure

    procedure( show_bot_layers(@optional (showAll nil))
        ;Define a list of layer names that we want to show, unless the user passes showAll = t
        ;   Note: feel free to modify this list of its desired to show other specific users
        visibleList = list(
            "Bottom"
            "Package_Bottom"
            "Soldermask_Bottom"
            "Pastemask_Bottom"
            "Filmmaskbottom"
            "Assembly_Bottom"
            "Other_Outline_Bot"
            "Design_Outline"
            "Pin_Number"
            "Place_Grid_Bottom"
            "Silkscreen_Bottom"
            "Bottom_Room"
            "Drawing_Origin"
            "Title_Block"
        )

        ;Set a regular expression to use for searching the top layers
        if(showAll then searchEx = "bot" else searchEx = nil)

        ;Log that we're starting
        debugPrintln("Enabling Bot Layer visibility...")

        ;Enable the layers
        show_layers(?RegEx searchEx visibleList)
        
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to show only the top layers
;   Param showAll: optional parameter. 
;       nil     ==> will only turn on the "visibileTopList"
;       t       ==> will force all layers with "top" in the name to be shown
;--START------------------------------
    show_only_top_layers_command = "show_only_top_layers"       ; This text much match the procedure call --> easier for registering commands later
    show_only_top_layers_menu_text = "Show Only Top Layers"     ; This text will be displayed in the menu for triggering this procedure
    procedure( show_only_top_layers(@optional (showAll nil))
        ;Hide all layers
        hide_all_layers()

        ;Turn on the top layers
        show_top_layers(showAll)
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to show only the top layers
;   Param showAll: optional parameter. 
;       nil     ==> will only turn on the "visibileTopList"
;       t       ==> will force all layers with "top" in the name to be shown
;--START------------------------------
    show_only_bot_layers_command = "show_only_bot_layers"       ; This text much match the procedure call --> easier for registering commands later
    show_only_bot_layers_menu_text = "Show Only Bottom Layers"  ; This text will be displayed in the menu for triggering this procedure
    procedure( show_only_bot_layers(@optional (showAll nil))
        ;Hide all layers
        hide_all_layers()

        ;Turn on the bottom layers
        show_bot_layers(showAll)
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to show only the external (top/bottom) layers
;   Param showAll: optional parameter. 
;       nil     ==> will only turn on the "visibileTopList"
;       t       ==> will force all layers with "top" in the name to be shown
;--START------------------------------
    show_tb_layers_command = "show_tb_layers"         ; This text much match the procedure call --> easier for registering commands later
    show_tb_layers_menu_text = "Show External Layers"  ; This text will be displayed in the menu for triggering this procedure
    procedure( show_tb_layers(@optional (showAll nil))
        ;Turn on the top layers
        show_top_layers(showAll)

        ;Turn on the bottom layers
        show_bot_layers(showAll)
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to show only the external (top/bottom) layers
;   Param showAll: optional parameter. 
;       nil     ==> will only turn on the "visibileTopList"
;       t       ==> will force all layers with "top" in the name to be shown
;--START------------------------------
    show_only_tb_layers_command = "show_only_tb_layers"         ; This text much match the procedure call --> easier for registering commands later
    show_only_tb_layers_menu_text = "Show Only External Layers"  ; This text will be displayed in the menu for triggering this procedure
    procedure( show_only_tb_layers(@optional (showAll nil))
        ;Hide all layers
        hide_all_layers()

        ;Turn on the top layers
        show_top_layers(showAll)

        ;Turn on the bottom layers
        show_bot_layers(showAll)
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to set all etch layers visible, leaving other layers untouched
;   Param layerIDs: optional parameter. 
;       nil         ==> will turn on all etch layers
;       [1,2,...]   ==> will only turn on the etch layer(s) with this ID --> pass each layerID as their own parameter
;
; Example:
;   show_etch_layers()          ==> will turn on all etch layers
;   show_etch_layers(1 3 5)     ==> wlil turn on etch layers 1, 3, and 5
;--START------------------------------
    show_etch_layers_command = "show_etch_layers"           ; This text much match the procedure call --> easier for registering commands later
    show_etch_layers_menu_text = "Show All Etch Layers"     ; This text will be displayed in the menu for triggering this procedure

    procedure( show_etch_layers(@rest layerIDs)

        ;Grab all etch layers
        etchLayers = axlGetParam("paramLayerGroup:ETCH")->groupMembers

        ;Create a new list that we'll use to keep track of all inner layers that should be set to visible
        etchLayerList = list()

        ;See if the user passed us a list of layers to explicitly be shown or not
        if(layerIDs && nth(1,layerIDs) then
            ;Loop through the layerIDs (could be a list of lists) to see which layers should be enabled
            foreach(tempList layerIDs
                foreach(tempLayer tempList
                    ;See if the user passed a numerical layer ID or a string
                    if(isintegerp(tempLayer) then
                        ;if this is the first layer (1), then just run the show_top_layers script
                        if(equal(tempLayer 1) then show_top_layers())

                        ;if this is the last layer, then just run the show_bot_layers script
                        if(equal(tempLayer length(etchLayers)) then show_bot_layers())

                        ;otherwise, add the nth layer corresponding to this numerical layerID as long as its in a valid range
                        if(or(greaterp(tempLayer 1) lessp(tempLayer length(etchLayers))) then etchLayerList = append1(etchLayerList nth(tempLayer-1 etchLayers)))

                    else
                        ;verify this is actually a string
                        if(stringp(tempLayer) then
                            ;if this is the first layer ("top"), then just run the show_top_layers script
                            if(rexMatchp("top" lowerCase(tempLayer)) then show_top_layers())

                            ;if this is the bottom layer ("bot" or "bottom"), then just run the show_bot_layers script
                            if(rexMatchp("bot" lowerCase(tempLayer)) then show_bot_layers())

                            ;otherwise, see if this layer is within the etchLayers
                            foreach(etchLayer etchLayers
                                if(rexMatchp(lowerCase(tempLayer) lowerCase(etchLayer)) then etchLayerList = append1(etchLayerList etchLayer))
                            )
                        )
                    )
                )
            )
        else    ;No list provided, so we'll enable them all
            ;Show the top layer
            show_top_layers()

            ;Show the bottom layer
            show_bot_layers()

            ;Loop through all inner layers and add them to the etchLayerList to be enabled
            for(i 1 length(etchLayers)-2
                etchLayerList = append1(etchLayerList nth(i etchLayers))
            )

        )

        ;enable the remaining etch layers
        show_layers(etchLayerList)
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to show only etch layers
;   Param layerIDs: optional parameter. 
;       nil         ==> will turn on all etch layers
;       [1,2,...]   ==> will only turn on the etch layer(s) with this ID --> pass each layerID as their own parameter
;
; Example:
;   show_etch_layers()          ==> will turn on all etch layers
;   show_etch_layers(1 3 5)     ==> wlil turn on etch layers 1, 3, and 5
;--START------------------------------
    procedure( show_only_etch_layers(@rest layerIDs)

        ;Hide all layers
        hide_all_layers()

        ;Only set the desired etch layers visible
        show_etch_layers(layerIDs)
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to show mechanical layers
;--START------------------------------
    show_mech_layers_command = "show_mech_layers"           ; This text much match the procedure call --> easier for registering commands later
    show_mech_layers_menu_text = "Show Mechanical Layers"   ; This text will be displayed in the menu for triggering this procedure

    procedure( show_mech_layers()
        ;Define a list of layer names that we want to show
        ;   Note: feel free to modify this list of its desired to show other specific users
        visibleList = list(
            "All"
        )

        ;Only set the desired etch layers visible
        show_layers(?RegEx "All")
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to show only all relevant layers
;--START------------------------------
    show_all_layers_command = "show_all_layers"         ; This text much match the procedure call --> easier for registering commands later
    show_all_layers_menu_text = "Show All Layers"       ; This text will be displayed in the menu for triggering this procedure
    procedure( show_all_layers()

        ;Hide all layers to have a clean slate
        hide_all_layers()

        ;Show all top layers
        show_top_layers(t)

        ;Show all bottom layers
        show_bot_layers(t)

        ;Show all etch layers
        show_etch_layers()

        ;Show all mechanical layers
        show_mech_layers()
    )
;---END-------------------------------

;-------------------------------------
; Description: Command to add all other commands into an allegro menu
;--START------------------------------
    procedure( add_layer_visibility_menu(@optional t_menu)
        ;define some constants
        visibility_menu = "Layer Visibility"     ;menu name

        ;See if the first menu item already exists
        visPtr = axlUIMenuFind(nil hide_all_layers_command)

        ;Add items to the menu if configured to do so and it doesn't already exist
        if((ADDMENU > 0 && !visPtr) then 

            ;put the menu pointer to just before the Help menu
            menuPtr = axlUIMenuFind(nil -1)

            ;create a menu folder to contain the command
            visMenu = axlUIMenuInsert(menuPtr 'popup visibility_menu)

            ;add the commands to the menu
            axlUIMenuInsert(visMenu hide_all_layers_menu_text hide_all_layers_command)
            axlUIMenuInsert(visMenu show_top_layers_menu_text show_top_layers_command)
            axlUIMenuInsert(visMenu show_only_top_layers_menu_text show_only_top_layers_command)
            axlUIMenuInsert(visMenu show_bot_layers_menu_text show_bot_layers_command)
            axlUIMenuInsert(visMenu show_only_bot_layers_menu_text show_only_bot_layers_command)
            axlUIMenuInsert(visMenu show_tb_layers_menu_text show_tb_layers_command)
            axlUIMenuInsert(visMenu show_only_tb_layers_menu_text show_only_tb_layers_command)
            axlUIMenuInsert(visMenu show_etch_layers_menu_text show_etch_layers_command)
            axlUIMenuInsert(visMenu show_mech_layers_menu_text show_mech_layers_command)
            axlUIMenuInsert(visMenu show_all_layers_menu_text show_all_layers_command)
        )
    )
;---END-------------------------------

;register the commands so we cant invoke directly from Allegro command line
axlCmdRegister(hide_all_layers_command 'hide_all_layers)
axlCmdRegister(show_top_layers_command 'show_top_layers)
axlCmdRegister(show_only_top_layers_command 'show_only_top_layers)
axlCmdRegister(show_bot_layers_command 'show_bot_layers)
axlCmdRegister(show_only_bot_layers_command 'show_only_bot_layers)
axlCmdRegister(show_tb_layers_command 'show_tb_layers)
axlCmdRegister(show_only_tb_layers_command 'show_only_tb_layers)
axlCmdRegister(show_etch_layers_command 'show_etch_layers)
axlCmdRegister(show_mech_layers_command 'show_mech_layers)
axlCmdRegister(show_all_layers_command 'show_all_layers)

;attach the add menuy callback procedure to the menu trigger
axlTriggerSet('menu 'add_layer_visibility_menu)