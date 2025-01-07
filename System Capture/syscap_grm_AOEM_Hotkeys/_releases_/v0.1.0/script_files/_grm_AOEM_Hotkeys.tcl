#source {C:\SPB_Data\cdssetup\canvas\resources\syscap\_grm_AOEM_Hotkeys.tcl}

#/////////////////////////////////////////////////////////////////////////////////
#  TCL file: _grm_AOEM_Hotkeys.tcl
#            Scripts to assist with adding various common functions/keybindings for AOEM
#
#   Author: Ryan Klassing / Tyler Dill
#   Version: v0.1.0
#   Date: 2024/08/21
#
#   Release Notes:
#     ------v0.1.0------
#       Initial Release
#/////////////////////////////////////////////////////////////////////////////////

#define this tcl file
package provide _grm_AOEM_Hotkeys 1.0

#add external dependent tcl scripts
package require _grm_menu
package require _grm_search
package require _grm_filter
package require _bom_io

#wrap this script in a namespace to prevent conflicts
namespace eval grm::AOEM_Hotkeys {

    variable scriptFileName [file normalize [info script]]

    #define a few namespace globals for easier code maintenance / customizations by individuals if they want
        #Nets are item type = 26 (found from manual testing with dbGetType)
        set tNetType 26

        #Define Desired HTML Color for applying the "Power Net" coloring
        set clrPower "#ff0000"

        #Define Desired HTML Color for applying the "GND Net" coloring
        set clrGND "#000001"

        #Define the Desired HTML Color for applying the "Highspeed Net" coloring
        set clrHS "#00b050"

        #Define the Desired HTML Color for applying the "Lowspeed Net" coloring
        set clrLS "#0000ff"

    # ----------------------------------------------------------------------------------
    # Boolean check to determine if the selected object(s) are exclusively nets
    # ----------------------------------------------------------------------------------
    proc checkForNets {} {
        #Setup boolean flag to make sure all items selected are a net
        set bNets 1

        #Grab a list of all objects selected
        set lSelObjs [getSel]

        #Check each object
        foreach obj $lSelObjs {

            #grab the current item type
            set lObjType [sch::dbGetType $obj]

            #flag if this is not a net
            if {$lObjType != $grm::AOEM_Hotkeys::tNetType} {set bNets 0}
        }

        #return the check
        return $bNets
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a Power Net
    # ----------------------------------------------------------------------------------
    proc setNetColorPower {} {
        #only set the color if the selection is a net
        if { [checkForNets] } {
            #log the action
            puts "Setting Line Color ==> $grm::AOEM_Hotkeys::clrPower"

            #set the color
            setLineColor $grm::AOEM_Hotkeys::clrPower
        }
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a GND Net
    # ----------------------------------------------------------------------------------
    proc setNetColorGND {} {
        #only set the color if the selection is a net
        if { [checkForNets] } {
            #log the action
            puts "Setting Line Color ==> $grm::AOEM_Hotkeys::clrGND"

            #set the color
            setLineColor $grm::AOEM_Hotkeys::clrGND
        }
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a High Speed Net
    # ----------------------------------------------------------------------------------
    proc setNetColorHS {} {
        #only set the color if the selection is a net
        if { [checkForNets] } {
            #log the action
            puts "Setting Line Color ==> $grm::AOEM_Hotkeys::clrHS"

            #set the color
            setLineColor $grm::AOEM_Hotkeys::clrHS
        }
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a Low Speed Net
    # ----------------------------------------------------------------------------------
    proc setNetColorLS {} {
        #only set the color if the selection is a net
        if { [checkForNets] } {
            #log the action
            puts "Setting Line Color ==> $grm::AOEM_Hotkeys::clrLS"

            #set the color
            setLineColor $grm::AOEM_Hotkeys::clrLS
        }
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
    proc openInFindPart {} {
        exec cmd.exe /c [string cat "start http://findpart.garmin.com/ngfindPart/executeEngPartSearch?strSearch=" [string replace [string replace [sch::dbGetPropNameVal [grm::search::recursiveMatches [getSel] grm::filter::isPartNumberProperty] [sch::dbGetSPathForActiveTab]] 0 12 ""] 12 13 ""]]
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
            }}
            {"&Utilities" {sch} {} {
                {"Open in FindPart" {} {grm::AOEM_Hotkeys::openInFindPart} {}}
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