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
    # Apply DNU to the BOM property on an object (if it doesn't exist), and ensure the BOM property is not displayed
    # ----------------------------------------------------------------------------------
    proc setBOMDNUHidden { objID } {
        #setup some variables to support calling the property modifications
        set propertyName BOM
        set propertyValue DNU
        set propertyDisplay nodisp
        set command addProp

        #grab data regarding active page and page of the object
        set currentPage [sch::dbGetActivePage]
        set currentPageSpath [sch::dbGetActivePageSpath]
        set bReturnPage 0

        #property modification will only be successful if the object's page is active
        #check if the object's page is currently active
        if {[sch::dbGetPageOfObject $objID] != $currentPage} {
            #set a flag to remind us to revert the page when we're done
            set bReturnPage 1

            #ensure nothing else is selected
            unselectAll

            #Activate the object's page by selecting while setting navigation to true
            sch::dbSelectObjectByIdEx $objID $::sch::DBTrue $::sch::DBFalse
        } else {
            #ensure only this component is selected
            onlyselectByID $objID
        }

        #remove any existing BOM tag in case the user currently has this component applied to a BOM
        deleteProp -name $propertyName

        #Add the BOM property back and set to DNU the property modification
        addProp -name $propertyName -value $propertyValue -display $propertyDisplay

        #unselect all components
        unselectAll

        #return to the original page if necessary
        if {$bReturnPage} { openItem $currentPageSpath SCH PAGE }

    }

    # ----------------------------------------------------------------------------------
    # Boolean check to determine if the objectID provided contains a BOM attribute set to DNU
    # ----------------------------------------------------------------------------------
    proc checkForDNUbyID { objID } {
        if {"DNU" == [sch::dbGetPropertyValueFromSPath [sch::dbGetSPath $objID] {BOM}]} {
            return 1
        } else { 
            return 0
        }
    }

    # ----------------------------------------------------------------------------------
    # Boolean check to determine if the component provided contains a BOM attribute set to DNU
    # ----------------------------------------------------------------------------------
    proc checkForDNUbySpath { compSpath } {
        if {"DNU" == [sch::dbGetPropertyValueFromSPath $compSpath {BOM}]} {
            return 1
        } else { 
            return 0
        } 
    }

    # ----------------------------------------------------------------------------------
    # Boolean check to determine if the objectID provided contains a visualization "x" over it
    # ----------------------------------------------------------------------------------
    proc getDNUxLines { objID } {
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
        set lBBoxObjs [sch::dbGetItemsInBBox [sch::dbGetPageOfObject $objID] $compBox]        
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
        return [expr [sch::dbGetType $objID] == $::sch::DBTLine ? 1 : 0]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to toggle the DNU tag on/off for the passed list of objectIDs
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
    proc toggleDNU { lobjIDs } {
        #keep a cache of the current page, in case we navigate away - we'll return here once we're done
        set ogPageSpath [sch::dbGetActivePageSpath]

        #Unselect all objects to prevent applying changes to unintentded items
        unselectAll

        #collect a list of unique refdes's based on the provided items - helps us avoid duplicating efforts for multi-gate components
        set lRefDes [getUniqueRefDesByIDs $lobjIDs]

        #get a list of all Spaths for each instance/gate of all the provided refdes
        set lCompSpaths []
        foreach refDes $lRefDes { lappend lCompSpaths [getSpathListOfComponentSafe $refDes] }

        #remove all brackets applied within the compiled list, so that it can be treated as a single level list
        set lCompSpaths [string map {\{ "" \} ""} $lCompSpaths]
        
        #check if we should be applying or removing DNU from all components
        set bApplyDNU [checkForApplyingDNU $lCompSpaths]

        #get a list of all locations for the instances/gates that we'll be updating, organized by page to minimize page transitions
        #   {{page1 {x1 y1} {x2 y2} {x3 y3} ... } {page2 {x1 y1} ...} ...}
        set lInstanceLocationsByPage [getInstanceLocationsByPage $lCompSpaths]

        #loop through all instance locations, one page at a time, selecting each desired component on that page
        foreach lPageInstanceCollection $lInstanceLocationsByPage {
            #pageSpath is the first index
            set pageSpath [lindex $lPageInstanceCollection 0]

            #all remaining indeces are {x y} coordinate pairs for gates/instances on this page
            for {set idx 1} {$idx < [llength $lPageInstanceCollection]} {incr idx} {
                #get the object ID of the component at these coordinates
                set objID [getIDbyLocation $pageSpath [lindex $lPageInstanceCollection $idx]]

                #handle the application or removal of the DNU for this object
                if { $bApplyDNU } {
                    addDNU $objID
                } else {
                    remDNU $objID
                }
            }
        }

        #See if we need to return to the original page
        if {$ogPageSpath != [sch::dbGetActivePageSpath]} {openItem $ogPageSpath SCH PAGE}
    }

    # ----------------------------------------------------------------------------------
    # Procedure to toggle the DNU tag on/off for the selected components
    # ----------------------------------------------------------------------------------
    proc toggleDNUselection {} {
        toggleDNU [getSel]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to check whether we should apply or remove DNU based on the passed list of component instances
    #   return 1 = apply DNU to all components
    #   return 0 = remove DNU from all components
    # ----------------------------------------------------------------------------------
    proc checkForApplyingDNU { lCompSpaths } {
        # Apply the following logic:
        # If all passed component instances are set to DNU, then remove DNU from all
        # otherwise, add DNU to all component instances

        #loop through all components instances
        foreach compSpath $lCompSpaths {
            #see if it has DNU - if not, then we can already return 1
            if { ![checkForDNUbySpath $compSpath]} {return 1}
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
            #add the DNU BOM tag
            setBOMDNUHidden $objID

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
            if { [checkForDNUbyID $objID] } {
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
            set lXlines [getDNUxLines $objID]

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

    proc addXtoDNU_currentPage {} {
        addXtoDNU_page  [ sch::dbGetActivePage ]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to scan the selected page for components set to DNU and ensure they all have the X visualization applied
    # ----------------------------------------------------------------------------------
    proc addXtoDNU_page { pgID } {
        #Grab a list of all items on the page
        set lPgObjs [sch::dbGetPageItems $pgID]

        #loop through all items on the page
        foreach objID $lPgObjs {
            #only perform the check if the item is a non testpoint component
            if {[grm::filter::isComponent $objID] && ![grm::filter::isTestpoint $objID]} {
                #check if the item has a DNU BOM tag, but does not already have an X
                if {[checkForDNUbyID $objID] && [llength [getDNUxLines $objID]] == 0} {

                    #ensure the BOM tag is hidden
                    setBOMDNUHidden $objID

                    #apply the DNU X
                    addDNUx $objID
                }
            }
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return an item's ref des by its object ID
    # ----------------------------------------------------------------------------------
    proc getRefDesByID { objID } {
        return [lindex [lindex [sch::dbxGetRefDesAndOriginFromInstSpath [ sch::dbGetSPath $objID]] 1] 1]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return a list of unique reference designators from the provided list of object IDs
    # ----------------------------------------------------------------------------------
    proc getUniqueRefDesByIDs { lobjIDs } {
        #setup a list to be returned
        set lUniqueRefDes {}

        #loop through each ID
        foreach objID $lobjIDs {
            #only perform the check if the item is a non testpoint component
            if {[grm::filter::isComponent $objID] && ![grm::filter::isTestpoint $objID]} {
                #get the current refdes
                set refDes [getRefDesByID $objID]

                #add it to the list if we haven't already found this refdes
                if {[lsearch -exact $lUniqueRefDes $refDes] < 0} {lappend lUniqueRefDes $refDes}
            }
        }

        #return the list of unique refDes
        return $lUniqueRefDes
    }

    # ----------------------------------------------------------------------------------
    # Procedure to safely return a list of Spaths for all found instances/gates of a given Ref Des
    #   procedure is considered safer than sdaConn::getSpathListOfComponent because there seems to be a bug
    #   in the default procedure where if a component is selected when the command is executed,
    #   that instance/gate of the component will be deleted from the schematic.  This tool is really smart...
    # ----------------------------------------------------------------------------------
    proc getSpathListOfComponentSafe { refDes } {
        #make sure nothing is selected to avoid the bug described above
        unselectAll

        #return the list of all Spaths for this component within the root design
        return [sdaConn::getSpathListOfComponent $refDes [sch::dbGetRootDesignName]]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return a list of locations <pageSpath x y> for all provided instance/gate Spaths
    #   the returned list will be organized by pageSpaths, to minimize page transitions needed in calling procedures
    #   { {pageSpath1 {x1 y1} {x2 y2} {x3 y3} ...} {pageSpath2 {x1 y1} {x2 y2} ...} {pageSpath3 ... } }
    #   
    #   where:
    #       pageSpath is the Spath for the page of the given symbol instance/gate
    #       x is the x coordinate of the center of the given symbol instance/gate
    #       y is the y coordinate of the center of the given symbol instance/gate
    # ----------------------------------------------------------------------------------
    proc getInstanceLocationsByPage { lCompSpaths } {

        #pepare a couple lists to collect and organize the instance locations
        set lInstanceLocations {}
        set lInstanceLocationsByPage {}

        #prepare a couple list to collect and organize just the pageSpaths in, for helping us organize the instance lists later on
        set lPageSpaths {}

        #loop through each instance
        foreach compSpath $lCompSpaths {
            #grab the page and x/y coordinates for this instance/gate into JSON format
            set compJSON [sch::dbGetInfoFromInstanceSpath $compSpath]

            if {$compJSON != {}} {
                #pull the page and x/y coordinates out of JSON into usable variables
                set compDict [json::json2dict $compJSON]
                set compPageSpath [dict get $compDict id]
                set compX [dict get $compDict x]
                set compY [dict get $compDict y]

                #add the pageSpath to the running list if we haven't already found this one
                if {[lsearch -exact $lPageSpaths $compPageSpath] < 0} {
                    #check if this is the currently active page - if so, make sure it's at the begining of the list, otherwise append
                    if {$compPageSpath == [sch::dbGetActivePageSpath]} {
                        set lPageSpaths [linsert $lPageSpaths 0 $compPageSpath]
                    } else {
                        lappend lPageSpaths $compPageSpath
                    }
                }

                #append this gate instance's information
                lappend lInstanceLocations [list $compPageSpath $compX $compY]
            }
        }

        #ideally - we want the currently active page to be placed first into the organized list, so that any calling function
        #that iterates through this list, would start with processing components on the already active page
        #To do this, we'll see if the list of pages 

        #now loop through the unique pageSpaths and create the organized list with matches from the collected instance locations
        foreach pageSpath $lPageSpaths {
            #first index of the page list is the pageSpath itself
            set lPageInstances [list $pageSpath]

            #remaining indeces of the list are {x y} coordinates for each instance on the page that we care about
            foreach instanceLocation $lInstanceLocations {
                if {[lindex $instanceLocation 0] == $pageSpath} {

                    #grab the X and Y coordinates of this instance location
                    set xyCoordinate [list [lindex $instanceLocation 1] [lindex $instanceLocation 2]]

                    #add the coordinate pair to the page instance list
                    lappend lPageInstances $xyCoordinate
                }
            }

            #add the collected list {page {coord1} {coord2} ...} to the running organized list
            lappend lInstanceLocationsByPage $lPageInstances
        }

        #return the organized list of all instance locations
        return $lInstanceLocationsByPage
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return an object's ID by providing the page + coordinates found by sch::dbGetInfoFromInstanceSpath
    #   pageSpath = Spath to the page that the component is located on
    #   compCoordinates = list formatted as {x y} for the coordinates of the component
    # ----------------------------------------------------------------------------------
    proc getIDbyLocation { pageSpath compCoordinates } {
        #navigate to the new page if necessary
        if {$pageSpath != [sch::dbGetActivePageSpath]} { openItem $pageSpath SCH PAGE }

        #grab the coordinates
        set xLoc [lindex $compCoordinates 0]
        set yLoc [lindex $compCoordinates 1]

        #select only the component at the location provided
        unselectAll
        selectObject -occPath $pageSpath -type INST $xLoc $yLoc

        #grab the selected ID
        set objID [getSel]
        unselectAll

        #return the found ID
        return $objID
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
                {"Toggle DNU" {} {grm::AOEM_Hotkeys::toggleDNUselection} {}}
                {"Apply DNU X to All Symbols on Current Page" {} {grm::AOEM_Hotkeys::addXtoDNU_currentPage} {}}
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