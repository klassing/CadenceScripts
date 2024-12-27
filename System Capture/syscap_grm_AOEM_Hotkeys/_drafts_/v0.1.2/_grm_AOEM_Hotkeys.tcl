#source {C:\SPB_Data\cdssetup\canvas\resources\syscap\_grm_AOEM_Hotkeys.tcl}

#/////////////////////////////////////////////////////////////////////////////////
#  TCL file: _grm_AOEM_Hotkeys.tcl
#            Scripts to assist with adding various common functions/keybindings for AOEM
#
#   Author: Ryan Klassing / Tyler Dill
#   Version: v1.2
#   Date: 2024/12/26
#
#   Release Notes:
#     ------v0.1.2------
#       Release Date: 
#           2024/12/26
#       Description:
#           Updated local object type checks to utilize grm::filter item type checks for better maintenance
#           Updated net color scripts to apply color to all nets selected, even if other object types are also selected
#           Added new setDNU function to apply DNU to the BOM tag of the selected component
#           Added new setDNU_vis function to apply DNU to the BOM tag and add visualization of the non placed component
#           Added new remDNU function to remove the DNU BOM tag and remove any added DNU visualizations
#
#     ------v0.1.1------
#       Release Date: 
#           2024/12/10
#       Description:
#           Renamed openInFindPart to FPENG to allow consistent naming with other findpart functions
#           Added new FPAML function to do an AML search in FindPart for the selected component
#
#     ------v0.1.0------
#       Release Date: 
#           2024/08/21
#       Description:
#           Initial Release
#     
#/////////////////////////////////////////////////////////////////////////////////

#define this tcl file
package provide _grm_AOEM_Hotkeys 0.1.2

#add external dependent tcl scripts
package require _grm_menu
package require _grm_search
package require _grm_filter
package require _grm_debug
package require _bom_io

#wrap this script in a namespace to prevent conflicts
namespace eval grm::AOEM_Hotkeys {

    variable scriptFileName [file normalize [info script]]

    #define a few namespace globals for easier code maintenance / customizations by individuals if they want
        #Define Desired HTML Color for applying the "Power Net" coloring
        set clrPower "#ff0000"

        #Define Desired HTML Color for applying the "GND Net" coloring
        set clrGND "#000001"

        #Define the Desired HTML Color for applying the "Highspeed Net" coloring
        set clrHS "#00b050"

        #Define the Desired HTML Color for applying the "Lowspeed Net" coloring
        set clrLS "#0000ff"

        #define the Desired HTML Color for applying DNU BOM tags
        set clrDNUprop "#ff0000"

        #define the desired HTML Color for DNU "x" visualization
        set clrDNUx "#ff0000"

        #define itemType for "x" visualization (found experimentally by using getType)
        set DBTline 6

        #define the desired width for the DNU "x" visualization
        set widthDNUx 3

        #define the desired HTML Color for DNU component visualization
        set clrDNUcompfill "#383838"

        #define default shape fill color (for when we clear the DNU visualization)
        set clrDEFcompfill "none"

        #define the desired HTML Color for DNU component visualization
        set clrDNUcompline "#b2b2b2"

        #define default shape fill color (for when we clear the DNU visualization)
        set clrDEFcompline "#000000"


    # ----------------------------------------------------------------------------------
    # Unselect all objects passed by their ID
    # ----------------------------------------------------------------------------------
    proc unselectByID {lObjIDs} {
        foreach objID $lObjIDs {
            sch::dbUnselectObjectById $objID $::sch::DBFalse
        }
    }

    # ----------------------------------------------------------------------------------
    # Select all objects passed by their ID
    # ----------------------------------------------------------------------------------
    proc selectByID {lObjIDs} {
        foreach objID $lObjIDs {
            sch::dbSelectObjectByIdEx $objID $::sch::DBFalse $::sch::DBFalse
        }
    }

    # ----------------------------------------------------------------------------------
    # Unselect everything
    # ----------------------------------------------------------------------------------
    proc unselectAll {} {
        #Grab a list of all objects selected
        set lSelObjs [getSel]

        #Unselect them all
        unselectByID $lSelObjs
    }

    # ----------------------------------------------------------------------------------
    # Unselect everything except for the passed object IDs
    # ----------------------------------------------------------------------------------
    proc onlyselectByID {lObjIDs} {
        #unselect all items
        unselectAll

        #Ensure all desired objects are selected
        selectByID $lObjIDs
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a Power Net
    # ----------------------------------------------------------------------------------
    proc setNetColorPower {} {
        #Grab a list of all objects selected
        set lSelObjs [getSel]

        #Loop through and set all nets to the power color
        foreach objID $lSelObjs {
            #only set the color if the selection is a net
            if { [grm::filter::isWire $objID] } {
                #Select the object
                onlyselectByID $objID

                #log the action
                puts "Setting Line Color ==> $grm::AOEM_Hotkeys::clrPower"

                #set the color
                setLineColor $grm::AOEM_Hotkeys::clrPower
            }
        }

        #Select the original objects to return to the users original state
        onlyselectByID $lSelObjs
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a GND Net
    # ----------------------------------------------------------------------------------
    proc setNetColorGND {} {
        #Grab a list of all objects selected
        set lSelObjs [getSel]

        #Loop through and set all nets to the power color
        foreach objID $lSelObjs {
            #only set the color if the selection is a net
            if { [grm::filter::isWire $objID] } {
                #Select the object
                onlyselectByID $objID

                #log the action
                puts "Setting Line Color ==> $grm::AOEM_Hotkeys::clrGND"

                #set the color
                setLineColor $grm::AOEM_Hotkeys::clrGND
            }
        }

        #Select the original objects to return to the users original state
        onlyselectByID $lSelObjs
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a High Speed Net
    # ----------------------------------------------------------------------------------
    proc setNetColorHS {} {
        #Grab a list of all objects selected
        set lSelObjs [getSel]

        #Loop through and set all nets to the power color
        foreach objID $lSelObjs {
            #only set the color if the selection is a net
            if { [grm::filter::isWire $objID] } {
                #Select the object
                onlyselectByID $objID

                #log the action
                puts "Setting Line Color ==> $grm::AOEM_Hotkeys::clrHS"

                #set the color
                setLineColor $grm::AOEM_Hotkeys::clrHS
            }
        }

        #Select the original objects to return to the users original state
        onlyselectByID $lSelObjs
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a Low Speed Net
    # ----------------------------------------------------------------------------------
    proc setNetColorLS {} {
        #Grab a list of all objects selected
        set lSelObjs [getSel]

        #Loop through and set all nets to the power color
        foreach objID $lSelObjs {
            #only set the color if the selection is a net
            if { [grm::filter::isWire $objID] } {
                #Select the object
                onlyselectByID $objID

                #log the action
                puts "Setting Line Color ==> $grm::AOEM_Hotkeys::clrLS"

                #set the color
                setLineColor $grm::AOEM_Hotkeys::clrLS
            }
        }

        #Select the original objects to return to the users original state
        onlyselectByID $lSelObjs
    }

    # ----------------------------------------------------------------------------------
    # Add a generic PWR Input symbol, allowing the user to provide the net name
    # ----------------------------------------------------------------------------------
    proc addPWRINtoCursor {} {
        addPower standard vcc_bar sym_1
    }

    # ----------------------------------------------------------------------------------
    # Add a generic PWR Output symbol, allowing the user to provide the net name
    # ----------------------------------------------------------------------------------
    proc addPWROUTtoCursor {} {
        addPower standard vcc_arrow sym_1
    }

    # ----------------------------------------------------------------------------------
    # Add a generic GND power symbol, allowing the user to provide the net name
    # ----------------------------------------------------------------------------------
    proc addGenericGNDtoCursor {} {
        addPower standard "gnd" sym_1 -g
    }

    # ----------------------------------------------------------------------------------
    # Add the GND power symbol with the standard "GND" net name
    # ----------------------------------------------------------------------------------
    proc addGNDtoCursor {} {
        addPower standard "gnd" sym_1 -g -i [list {signame=GND} {voltage=0 V}] -scope global
    }

    # ----------------------------------------------------------------------------------
    # Add the NC symbol
    # ----------------------------------------------------------------------------------
    proc addNCtoCursor {} {
        addComponent standard "garmin_nc" "sym_1" GARMIN_NC -n 1
    }

    # ----------------------------------------------------------------------------------
    # Open a FindPart browser and perform an EngPart search on the selected item in FindPart
    # ----------------------------------------------------------------------------------
    proc FPENG {} {
        exec cmd.exe /c [string cat "start http://findpart.garmin.com/ngfindPart/executeEngPartSearch?strSearch=" [string replace [string replace [sch::dbGetPropNameVal [grm::search::recursiveMatches [getSel] grm::filter::isPartNumberProperty] [sch::dbGetSPathForActiveTab]] 0 12 ""] 12 13 ""]]
    }

    # ----------------------------------------------------------------------------------
    # Open a FindPart browser and perform an AML search on the selected item in FindPart
    # ----------------------------------------------------------------------------------
    proc FPAML {} {
        exec cmd.exe /c [string cat "start http://findpart.garmin.com/ngfindPart/executeAMLSearch?strSearch=" [string replace [string replace [sch::dbGetPropNameVal [grm::search::recursiveMatches [getSel] grm::filter::isPartNumberProperty] [sch::dbGetSPathForActiveTab]] 0 12 ""] 12 13 ""]]
    }

    # ----------------------------------------------------------------------------------
    # Set the selected component to DNU with added visualizations
    # ----------------------------------------------------------------------------------
    proc addNCtoCursor {} {
        addComponent standard "garmin_nc" "sym_1" GARMIN_NC -n 1
    }

    # ----------------------------------------------------------------------------------
    # Apply DNU to the BOM property on an object, keeping the tag hidden
    # ----------------------------------------------------------------------------------
    proc setBOMDNUHidden { objID } {
        #ensure the object is selected, but don't zoom to the object
        sch::dbSelectObjectByIdEx $objID $::sch::DBFalse $::sch::DBFalse

        #add the DNU BOM property
        addProp -name {BOM} -value {DNU} -type 0 -display nodisp
    }

    # ----------------------------------------------------------------------------------
    # Boolean check to determine if the objectID provided contains a BOM attribute set to DNU
    # ----------------------------------------------------------------------------------
    proc checkForDNU { objID } {
        if {"DNU" == [sch::dbGetPropertyValueFromSPath [sch::dbGetSPath $objID] {BOM}]} {
            return 1
        } else { 
            return 0
        }
    }

    # ----------------------------------------------------------------------------------
    # Boolean check to determine if the objectID provided contains a visualization "x" over it
    # ----------------------------------------------------------------------------------
    proc checkForDNUx { objID } {
        #Setup boolean flag - default to assume it's not found
        set bDNUx 0

        #To be considered "found", we must find 2 line objects with the following properties:
        #   - TopLeft -> BottomRight locations must exactly match the objID passed
        #   - BottomLeft -> TopRight locations must exaclty match the objID passed

        #get the bounding box of the passed object for use in checking line coordinates
        set compLeft [getCompLeftByID $objID]
        set compTop [getCompTopByID $objID]
        set compRight [getCompRightByID $objID]
        set compBot [getCompBotByID $objID]

        #get the bounding box (db units) for use in getting a list of all components within its bounding box
        set compBox [sch::dbGetShapeBBox $objID]

        #get a list of items within this bounding box
        set lBBoxObjs [sch::dbGetItemsInBBox [sch::dbGetActivePage] $compBox]        
        set lXlines []

        #loop through all selected items and see if we can find a pair of lines that meet the criteria above
        foreach bboxObj $lBBoxObjs {
            if {[isLine $bboxObj]} {

                #get bounds of this line
                set lineLeft [getLineLeftByID $bboxObj]
                set lineTop [getLineTopByID $bboxObj]
                set lineRight [getLineRightByID $bboxObj]
                set lineBot [getLineBotByID $bboxObj]

                #if the line is exactly diagonal through the component, the outer bounding boxes should exactly match
                if {$lineLeft == $compLeft && $lineTop == $compTop && $lineRight == $compRight && $lineBot == $compBot} {
                    lappend lXlines $bboxObj
                }
            }
        }

        # return any matching X lines
        return $lXlines
    }

    # ----------------------------------------------------------------------------------
    # Boolean check to determine if the objectID provided is a line object
    # ----------------------------------------------------------------------------------
    proc isLine { objID } {
        return [expr [sch::dbGetType $objID] == $grm::AOEM_Hotkeys::DBTline ? 1 : 0]
    }


    # ----------------------------------------------------------------------------------
    # Procedure to toggle the DNU tag on/off the selected component(s).
    #   In case 1 component is selected, the BOM tag will be set to the opposite of its previous sate.
    #   In case > 1 component is selected, the BOM tag will be applied to all components equally with the following logic:
    #       If all components have the DNU BOM tag already, then all DNU tags will be removed
    #       Else - all components will be configured with DNU BOM tag
    #
    #   Example: 1 component is selected that already has BOM = DNU
    #       BOM attribute set to DNU will be deleted
    #
    #   Example: 3 components are selected where 2 have BOM = DNU while the other doesn't have a DNU BOM tag at all
    #       All components will be set to DNU
    #   
    #   Example: 3 components are selected where all 3 have BOM = DNU
    #       BOM attribute will be removed from all selected components
    # ----------------------------------------------------------------------------------
    proc toggleDNU {} {
        #Grab a list of all objects selected
        set lSelObjs [getSel]

        #Unselect all objects to prevent applying changes to unintentded items
        unselectAll

        #start with assuming we will be applying DNU tags
        set bApplyDNU [checkForApplyingDNU $lSelObjs]

        #loop through all of the component objects found earlier and add/remove the BOM tag as decided above for the components
        foreach objID $lSelObjs {
            #Determine if we're adding or removing
            if { $bApplyDNU } {
                #add the DNU BOM property
                puts "Applying DNU"
                addDNU $objID
            } else {
                #remove BOM property
                puts "Removing DNU"
                remDNU $objID
            }

        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to check whether we should apply or remove DNU based on the selected components
    #   return 1 = apply DNU to all components
    #   return 0 = remove DNU from all components
    # ----------------------------------------------------------------------------------
    proc checkForApplyingDNU { lSelObjs } {
        # Apply the following logic:
        # If all selected components have DNU, then remove DNU from all
        # otherwise, add DNU to all components

        #loop through all selected components
        foreach selObj $lSelObjs {
            if {[grm::filter::isComponent $selObj] && ![grm::filter::isTestpoint $selObj]} {
                #see if it has DNU - if not, then we can already return 1
                if { ![checkForDNU $selObj] } {return 1}
            }
        }

        #if we didn't find any components missing the DNU tag, then we should be removing DNU
        return 0
    }

    # ----------------------------------------------------------------------------------
    # Procedure to add DNU BOM tag + X Visualization to an object.
    # ----------------------------------------------------------------------------------
    proc addDNU { objID } {
        #ensure the passed object ID is a component, but not a testpoint
        if {[grm::filter::isComponent $objID] && ![grm::filter::isTestpoint $objID]} {
            #Ensure only the component is selected
            onlyselectByID $objID

            #add the DNU BOM property
            addProp -name {BOM} -value {DNU} -type 0 -display nodisp

            #add the DNU x visualization
            addDNUx $objID

            #Unselect all objects to prevent applying changes to unintentded items
            unselectAll
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to add DNU X Visualization to an object.
    # ----------------------------------------------------------------------------------
    proc addDNUx { objID } {
        #ensure the passed object ID is a component
        if {[grm::filter::isComponent $objID] && ![grm::filter::isTestpoint $objID]} {
            #Ensure only the component is selected
            onlyselectByID $objID

            #set the component's fill color
            setFillColor $grm::AOEM_Hotkeys::clrDNUcompfill

            #set the component's line color
            setLineColor $grm::AOEM_Hotkeys::clrDNUcompline

            set compLeft [getCompLeftByID $objID]
            set compTop [getCompTopByID $objID]
            set compRight [getCompRightByID $objID]
            set compBot [getCompBotByID $objID]

            #add the first line (Top Left -> Bottom Right), set its width and color
            addLine $compLeft $compTop $compRight $compBot
            setLineWidth $grm::AOEM_Hotkeys::widthDNUx
            setLineColor $grm::AOEM_Hotkeys::clrDNUx

            #add the second line (Bottom Left -> Top Right), set its width and color
            addLine $compLeft $compBot $compRight $compTop
            setLineWidth $grm::AOEM_Hotkeys::widthDNUx
            setLineColor $grm::AOEM_Hotkeys::clrDNUx
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to remove the DNU BOM tag + X Visualization from an object.
    # ----------------------------------------------------------------------------------
    proc remDNU { objID } {
        #ensure the passed object ID is a component
        if {[grm::filter::isComponent $objID] && ![grm::filter::isTestpoint $objID]} {
            #remove BOM property and update fill color as long as it contains DNU currently - otherwise leave it alone
            if { [checkForDNU $objID] } {
                #Ensure only the component is selected
                onlyselectByID $objID

                #remove the BOM property
                deleteProp -name "BOM"

                #update the fill color
                setFillColor $grm::AOEM_Hotkeys::clrDEFcompfill

                #update the line color
                setLineColor $grm::AOEM_Hotkeys::clrDEFcompline

                #remove the DNU x visualization
                remDNUx $objID

                #Unselect all objects to prevent applying changes to unintentded items
                unselectAll

            }
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to remove DNU X Visualization from an object.
    # ----------------------------------------------------------------------------------
    proc remDNUx { objID } {
        #ensure the passed object ID is a component
        if {[grm::filter::isComponent $objID] && ![grm::filter::isTestpoint $objID]} {
            #check if there are any X lines to remove
            set lXlines [checkForDNUx $objID]

            #only proceed if we found xLines
            if { [llength $lXlines] > 0 } {
                #delete each Xline detected
                foreach xLine $lXlines {
                    #ensure only this line is selected
                    onlyselectByID $xLine

                    #delete the line
                    delete
                }
            }
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the left boundary of the component
    # ----------------------------------------------------------------------------------
    proc getCompLeftByID { objID } {
        #find the coordinates
        set coordLeft [lindex [sch::dbConvertToUserUnits [lindex [sch::dbGetShapeBBox $objID] 0]] 0]

        #return the coordinates
        return $coordLeft
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the top boundary of the component
    # ----------------------------------------------------------------------------------
    proc getCompTopByID { objID } {
        #find the coordinates
        set coordTop [lindex [sch::dbConvertToUserUnits [lindex [sch::dbGetShapeBBox $objID] 0]] 1]

        #return the coordinates
        return $coordTop
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the right boundary of the component
    # ----------------------------------------------------------------------------------
    proc getCompRightByID { objID } {
        #find the coordinates
        set coordRight [lindex [sch::dbConvertToUserUnits [lindex [sch::dbGetShapeBBox $objID] 1]] 0]

        #return the coordinates
        return $coordRight
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the bottom boundary of the component
    # ----------------------------------------------------------------------------------
    proc getCompBotByID { objID } {
        #find the coordinates
        set coordBot [lindex [sch::dbConvertToUserUnits [lindex [sch::dbGetShapeBBox $objID] 1]] 1]
        
        #return the coordinates
        return $coordBot
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return a list of all X coordinates of a line (User Units, not dbUnits)
    # ----------------------------------------------------------------------------------
    proc getLineXpointsByID { objID } {
        #initially blank list to collect all X coordinates of the line's points
        set lXpoints []

        #only collect coordinate points if it's a line
        if {[isLine $objID]} {
            #collect the line's points in database format
            set lDBPoints [sch::dbGetPoints $objID]

            #loop through all points, convert to User Units, then add them to the lXpoints list
            foreach DBpoint $lDBPoints {
                lappend lXpoints [lindex [sch::dbConvertToUserUnits $DBpoint] 0]
            }
        }

        #return the list
        return $lXpoints
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return a list of all Y coordinates of a line (User Units, not dbUnits)
    # ----------------------------------------------------------------------------------
    proc getLineYpointsByID { objID } {
        #initially blank list to collect all X coordinates of the line's points
        set lYpoints []

        #only collect coordinate points if it's a line
        if {[isLine $objID]} {
            #collect the line's points in database format
            set lDBPoints [sch::dbGetPoints $objID]

            #loop through all points, convert to User Units, then add them to the lXpoints list
            foreach DBpoint $lDBPoints {
                lappend lYpoints [lindex [sch::dbConvertToUserUnits $DBpoint] 1]
            }
        }

        #return the list
        return $lYpoints
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the left boundary of the line
    # ----------------------------------------------------------------------------------
    proc getLineLeftByID { objID } {
        #Left is the smallest X coordinate in the list of the line's points
        set lXpoints [getLineXpointsByID $objID]
        return [::tcl::mathfunc::min {*}$lXpoints]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the top boundary of the line
    # ----------------------------------------------------------------------------------
    proc getLineTopByID { objID } {
        #Top is the smallest Y coordinate in the list of the line's points
        set lYpoints [getLineYpointsByID $objID]
        return [::tcl::mathfunc::min {*}$lYpoints]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the right boundary of the line
    # ----------------------------------------------------------------------------------
    proc getLineRightByID { objID } {
        #Right is the larget X coordinate in the list of the line's points
        set lXpoints [getLineXpointsByID $objID]
        return [::tcl::mathfunc::max {*}$lXpoints]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the bottom boundary of the line
    # ----------------------------------------------------------------------------------
    proc getLineBotByID { objID } {
        #Bottom is the larget Y coordinate in the list of the line's points
        set lYpoints [getLineYpointsByID $objID]
        return [::tcl::mathfunc::max {*}$lYpoints]
    }

    # ----------------------------------------------------------------------------------
    # Create a custom menu bar for all keybindings above
    #   Note: in order to apply a Syscap hotkey/shortcut/keybinding, the command
    #   must exist within a menu item with a textual description.
    #
    #   Garmin created some scripts to make adding menu items easier.  See _grm_menu.tcl for
    #       an explanation on how to setup menu structures
    # ----------------------------------------------------------------------------------
    variable AOEM_Hotkeys_Menu {
        {"&AOEM Hotkeys" {sch} "Help" {} {
            {"&Net Colors" {sch} {} {
                {"Set Net Color: Power" {} {grm::AOEM_Hotkeys::setNetColorPower} {}}
                {"Set Net Color: GND" {} {grm::AOEM_Hotkeys::setNetColorGND} {}}
                {"Set Net Color: High Speed" {} {grm::AOEM_Hotkeys::setNetColorHS} {}}
                {"Set Net Color: Low Speed" {} {grm::AOEM_Hotkeys::setNetColorLS} {}}
            }}
            {"&Symbols" {sch} {} {
                {"Add PWR Input Symbol" {} {grm::AOEM_Hotkeys::addPWRINtoCursor} {}}
                {"Add PWR Output Symbol" {} {grm::AOEM_Hotkeys::addPWROUTtoCursor} {}}
                {"Add GND Symbol" {} {grm::AOEM_Hotkeys::addGenericGNDtoCursor} {}}
                {"Add GND Net" {} {grm::AOEM_Hotkeys::addGNDtoCursor} {}}
                {"Add NC Symbol" {} {grm::AOEM_Hotkeys::addNCtoCursor} {}}
                {"Toggle DNU" {} {grm::AOEM_Hotkeys::toggleDNU} {}}
            }}
            {"&Utilities" {sch} {} {
                {"FindPart: Eng Search" {} {grm::AOEM_Hotkeys::FPENG} {}}
                {"FindPart: AML Search" {} {grm::AOEM_Hotkeys::FPAML} {}}
            }}
        }}
    }

    # ----------------------------------------------------------------------------------
    # Init function adds the necessary keybindings, after loading the menu items
    # ----------------------------------------------------------------------------------
    proc init {} {
        #add the menu items
        grm::menu::addMenuBar $grm::AOEM_Hotkeys::AOEM_Hotkeys_Menu sch

        #add each shortcut/keybinding
        #   Note: currently disabled, as we'll plan to let each user define their own keybinding, which Cadence cache's in the cpUserShortcuts.txt file
        #modifyActionShortcut {Set Net Color: Power} {1} {sch}
        #modifyActionShortcut {Set Net Color: GND} {2} {sch}
        #modifyActionShortcut {Set Net Color: High Speed} {3} {sch}
        #modifyActionShortcut {Set Net Color: Low Speed} {4} {sch} 
    }
}

#After loading the file, run the init function
grm::AOEM_Hotkeys::init

# end of file