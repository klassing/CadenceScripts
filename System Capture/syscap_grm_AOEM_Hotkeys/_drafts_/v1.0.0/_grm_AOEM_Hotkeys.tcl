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
#     ------v1.0.0------
#       Release Date: 
#           2024/12/26
#       Description:
#           Updated local object type checks to utilize grm::filter item type checks for better maintenance
#           Updated net color scripts to apply color to all nets selected, even if other object types are also selected
#           Added new toggleDNU functionality to allow one-button management of DNU visualization of components (supports single component or multi-selection)
#               Note: this also ensures all gates of a component are set at the same time, regardless of which pages the gates are spread across
#           Added new addXtoDNU_currentPage functionality to allow converting a specific page from traditional BOM tag only, to BOM tag + X visualization
#           Added new addXtoDNU_allPages functionality to allow converting an entire design from traditional BOM tag only, to BOM tag + X visualization
#               Note: this can take up to 5-7minutes on a very large design with many DNU components
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
package provide _grm_AOEM_Hotkeys 1.0.0

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
        set widthDNUx 2

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
    proc unselectByID {lobjIDs} {
        foreach objID $lobjIDs {
            sch::dbUnselectObjectById $objID $::sch::DBFalse
        }
    }

    # ----------------------------------------------------------------------------------
    # Select all objects passed by their ID
    # ----------------------------------------------------------------------------------
    proc selectByID {lobjIDs} {
        foreach objID $lobjIDs {
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
    proc onlyselectByID {lobjIDs} {
        #unselect all items
        unselectAll

        #Ensure all desired objects are selected
        selectByID $lobjIDs
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a Power Net
    # ----------------------------------------------------------------------------------
    proc setNetColorPower {} {
        #Grab a list of all unique nets selected
        set lNets [getUniqueValidNets [getSel]]

        #select only the nets
        onlyselectByID $lNets

        #set the color to all selected nets at once
        setLineColor $grm::AOEM_Hotkeys::clrPower
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a GND Net
    # ----------------------------------------------------------------------------------
    proc setNetColorGND {} {
        #Grab a list of all unique nets selected
        set lNets [getUniqueValidNets [getSel]]

        #select only the nets
        onlyselectByID $lNets

        #set the color to all selected nets at once
        setLineColor $grm::AOEM_Hotkeys::clrGND
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a High Speed Net
    # ----------------------------------------------------------------------------------
    proc setNetColorHS {} {
        #Grab a list of all unique nets selected
        set lNets [getUniqueValidNets [getSel]]

        #select only the nets
        onlyselectByID $lNets

        #set the color to all selected nets at once
        setLineColor $grm::AOEM_Hotkeys::clrHS
    }

    # ----------------------------------------------------------------------------------
    # Set the selection as a Low Speed Net
    # ----------------------------------------------------------------------------------
    proc setNetColorLS {} {
        #Grab a list of all unique nets selected
        set lNets [getUniqueValidNets [getSel]]

        #select only the nets
        onlyselectByID $lNets

        #set the color to all selected nets at once
        setLineColor $grm::AOEM_Hotkeys::clrLS
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
    # Procedure to toggle the DNU tag on/off for the passed list of objectIDs
    #
    #   lobjIDs - list of db IDs of objects/components that the toggle script should process
    #   optional bForceDNU - boolean flag as follows:
    #       0 = Script will determine how to apply (or remove) DNU based on the list of object IDs (see below)
    #       1 = Script will only apply DNU but will not remove DNU from anything
    #
    #   Automatic DNU application follows this logic:
    #       If all object IDs passed are currently set to DNU, then the script will remove DNU from all of them
    #       Otherwise, all object IDs passed will be set to DNU
    # ----------------------------------------------------------------------------------
    proc toggleDNU { lobjIDs {bForceDNU 0} } {
        #keep a cache of the current page, in case we navigate away - we'll return here once we're done
        set ogPageSpath [sch::dbGetActivePageSpath]

        #Unselect all objects to prevent applying changes to unintentded items
        unselectAll

        #start by cleaning up any stray X lines that the user might have selected
        foreach strayLine $lobjIDs {
            if {[sch::dbIsValid $strayLine]} {
                remStrayXlines $strayLine
            }
        }

        #since we may have deleted some dbIDs above, let's create a clean list of only valid objectIDs
        set lobjIDs [getUniqueValidIDs $lobjIDs]

        #next, see if any remaining X lines are selected, and replace them with the component behind them
        #   this is done in case the user accidentally selected the X line when running the script,
        #   since the X lines are set to "front" visually and can be easy to grab on smaller components
        set lobjIDs [getUniqueValidComponents $lobjIDs]

        #collect a list of unique refdes's based on the now unique list of component IDs - helps us avoid duplicating efforts for multi-gate components
        set lRefDes [getUniqueRefDesByIDs $lobjIDs]

        #get a list of all Spaths for each instance/gate of all the provided refdes
        set lCompSpaths []
        foreach refDes $lRefDes { lappend lCompSpaths [getSpathListOfComponentSafe $refDes] }

        #remove all brackets applied within the compiled list, so that it can be treated as a single level list
        set lCompSpaths [string map {\{ "" \} ""} $lCompSpaths]
        
        #check how to proceed on DNU application or removal
        if {$bForceDNU} {
            #force the setting of DNU to the selected components
            set bApplyDNU 1
        } else {
            #check if we should be applying or removing DNU from all components
            set bApplyDNU [checkForApplyingDNU $lCompSpaths]
        }

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

        #Select the original components
        onlyselectByID $lobjIDs
    }

    # ----------------------------------------------------------------------------------
    # Procedure to toggle the DNU tag on/off for the selected components
    # ----------------------------------------------------------------------------------
    proc toggleDNUselection {} {
        toggleDNU [getSel]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to scan the selected page for components set to DNU and ensure they all have the X visualization applied
    # ----------------------------------------------------------------------------------
    proc addXtoDNU_page { pgID } {
        #Grab a list of all items on the page
        set lPgObjs [sch::dbGetPageItems $pgID]

        #prepare a list to track components that we want to process
        set lObjs {}

        #loop through all items on the page to create a list only of components that have BOM set to DNU, but don't currently have an X visualization
        foreach objID $lPgObjs {
            #while looping through all items, go ahead and clean up any stray X lines
            if {[sch::dbIsValid $objID]} {
                remStrayXlines $objID
            }

            #only perform the check if the item is a non testpoint component that has BOM set to DNU but no X visualization
            if {[isBOMComponent $objID] && [checkForDNUbyID $objID] && [llength [getXlinesFromComponentID $objID]] == 0 && [sch::dbIsValid $objID]} {
                #add to the running list
                lappend lObjs $objID
            }
        }

        #pass the list of objects to the toggle DNU script, but force that it applies DNU
        toggleDNU $lObjs 1
    }

    # ----------------------------------------------------------------------------------
    # Procedure to scan the current page for components set to DNU and ensure they all have the X visualization applied
    # ----------------------------------------------------------------------------------
    proc addXtoDNU_currentPage {} {
        addXtoDNU_page  [ sch::dbGetActivePage ]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to scan all pages in the design set to DNU and ensure they all have the X visualization applied
    # ----------------------------------------------------------------------------------
    proc addXtoDNU_allPages {} {
        #cache the current page to return to once we're finished
        set curPageSpath [sch::dbGetActivePageSpath]

        #start at the first page
        sch::firstPage

        #pass each page to the handling script until we're done
        while (1) {
            #handle the current page
            addXtoDNU_currentPage

            #loop to the next page, unless we're at the end of the design
            if {[sch::nextPage] != 0} {break}
        }

        #return to the original page
        openItem $curPageSpath SCH PAGE
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return a unique list of only valid nets from the passed list of objects
    # ----------------------------------------------------------------------------------
    proc getUniqueValidNets { lobjIDs } {
        #create a temporary list to keep track of only the nets
        set validNets {}
        foreach objID $lobjIDs {
            if {[grm::filter::isWire $objID] && [sch::dbIsValid $objID] && [lsearch -exact $validNets $objID] < 0} {lappend validNets $objID}
        }
        return $validNets
    }

    # ----------------------------------------------------------------------------------
    # Boolean check to determine if the objectID provided is a line object
    # ----------------------------------------------------------------------------------
    proc isLine { objID } {
        return [expr [sch::dbGetType $objID] == $::sch::DBTLine ? 1 : 0]
    }

    # ----------------------------------------------------------------------------------
    # Boolean check to determine if the objectID provided is a component for BOM management (component, not a testpoint, not a netshort)
    # ----------------------------------------------------------------------------------
    proc isBOMComponent { objID } {
        return [expr [grm::filter::isComponent $objID] && ![grm::filter::isTestpoint $objID] && ![grm::filter::isNetShort $objID]]
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
    # Check to determine if the objectID provided is a component that contains a visualization "x" over it
    #   Any X lines detected to be over this objectID are returned to the calling function in a list
    # ----------------------------------------------------------------------------------
    proc getXlinesFromComponentID { objID } {
        if {[isBOMComponent $objID]} {
            #To be considered "found", we must find line objects with the same outer dimensions as the component

            #return a list of lines that match the component's bounding box
            return [getMatchingBBoxItemsByID $objID grm::AOEM_Hotkeys::isLine]
        }
    }

    # ----------------------------------------------------------------------------------
    # Check to determine if the passed line objectID contains a component that exactly matches its bounding box
    #   Any component(s) detected to match the line's bounding box are returned to the calling function in a list
    # ----------------------------------------------------------------------------------
    proc getComponentsFromXlineID { objID } {
        if {[isLine $objID]} {
            #To be considered "found", we must find a component with the same exact outer dimensions as the component

            #return a list of components that match the lines's bounding box
            return [getMatchingBBoxItemsByID $objID [list isBOMComponent]]
        }
    }

    # ----------------------------------------------------------------------------------
    # Check to determine if the passed line objectID contains X lines that exactly matches its bounding box
    #   Any lines(s) detected to match the line's bounding box are returned to the calling function in a list
    #
    #   Note: this list will ALWAYS return at least one ID (the line itself) since both the passing and checking types are the same
    # ----------------------------------------------------------------------------------
    proc getXlinesFromLineID { objID } {
        if {[isLine $objID]} {
            #To be considered "found", we must find lines with the same exact outer dimensions as the component

            #return a list of lines that match the lines's bounding box
            return [getMatchingBBoxItemsByID $objID [list grm::AOEM_Hotkeys::isLine]]
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return a list of objects that have an identical bounding box to the passed objID
    #   objID can be a component or any shape item type
    #   lMatchingTests is a list of user-provided procedures that will all be a collective boolean AND logic check for a valid matching type
    #       Note: all matching tests must take a single object ID as an input parameter and return boolean 1 for a match and 0 for failure
    #       Note: if a user wishes to provide any logic inverses for these tests, simply pass the procedure name starting with !
    #       Note: if this parameter is not provided, then all valid object IDs found with a matching bbox will be returned
    #       
    # Example of possible scenarios are below:
    #   { objID {grm::AOEM_Hotkeys::isLine} {grm::filter::isComponent !grm::filter::isTestpoint}}
    #
    #       This will  will do the following:
    #           Grab the outer dimensions / bounding box of the objID
    #           Select all objects inside the bounding box that match the following boolean logic:
    #               if {[grm::filter::isComponent $bboxObjID] && ![grm::filter::isTestpoint $bboxObjID]}
    #
    #   
    # ----------------------------------------------------------------------------------
    proc getMatchingBBoxItemsByID { objID {lMatchingTests "sch::dbIsValid"} } {

        #get the primary object's bounding box
        set objIDbox [userGetShapeBBoxByIDdbUnits $objID]

        #get a list of items within this bounding box
        set lBBoxObjs [sch::dbGetItemsInBBox [sch::dbGetPageOfObject $objID] $objIDbox]

        #prepare a list to store identified X lines in
        set lMatches {}

        #loop through all found items and look for any of the matching types
        foreach bboxObjID $lBBoxObjs {
            #start the boolean test string
            set bTestString ""

            #set some variables to keep track of how many logical tests there are
            set testIDX 1
            set testLength [llength $lMatchingTests]

            #build up the logical test string based on each of the provided procedures
            foreach matchingTest $lMatchingTests {
                #start with the logical bracket
                set bTest "\["

                #check for inverted logic on this test
                if {[string index $matchingTest 0] == "!"} {
                    #start the logical test with inversion
                    set bTest "!\["

                    #remove the ! from the procedure name before proceeding
                    set matchingTest [string trimleft $matchingTest "!"]
                }

                #add the procedure name, a space, the passing object ID, and the closing bracket
                append bTest "$matchingTest $bboxObjID\]"

                #see if we're at the end of the boolean tests, or if we need to add a logical AND for the next test
                if {$testIDX < $testLength} {
                    #prepare for the next logical test
                    incr testIDX
                    append bTest " && "
                }

                #add this boolean test to the overall boolean test string
                append bTestString $bTest
            }

            #now that we have the boolean tests completed, perform the check to see if this item type matches
            if {[expr $bTestString]} {
                #get bounds of this object
                set bboxObjbox [userGetShapeBBoxByIDdbUnits $bboxObjID]

                #see if the bounds match
                if {$objIDbox == $bboxObjbox} {
                    lappend lMatches $bboxObjID
                }
            }
        }

        # return any matching X lines
        return $lMatches
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return a pair of X/Y coordinates (in db Units) for the Top Left and Bottom Right of the shapes bounding box
    #   Safely supports both components and shapes as passed object IDs
    # ----------------------------------------------------------------------------------
    proc userGetShapeBBoxByIDdbUnits { objID } {
        #start by getting the coordinates
        set topLeftUserUnits [list [getLeftByIDuserUnits $objID] [getTopByIDuserUnits $objID]]
        set botRightUserUnits [list [getRightByIDuserUnits $objID] [getBotByIDuserUnits $objID]]

        #verify there were valid coordinates before calling conversion to avoid any errors
        if {[llength $topLeftUserUnits] > 0 && [llength $botRightUserUnits] > 0} {
            return [list [sch::dbConvertToDBUnits $topLeftUserUnits] [sch::dbConvertToDBUnits $botRightUserUnits]]
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to check if the passed object ID is part of an X line, that is no longer over a component
    #   If this is found to be the case - this object (X line) and any partners (with same bounding box) will be deleted
    # ----------------------------------------------------------------------------------
    proc remStrayXlines { objID } {
        #start by checking if the provided component is even a line
        if {[isLine $objID]} {

            #get a list of all components (if any) within a bounding box defined by the line's bounding box
            set lbboxComps [getComponentsFromXlineID $objID]

            #get a list of all lines (if any) within a bounding box defined by the line's bounding box
            set lbboxLines [getXlinesFromLineID $objID]
            
            #prepare a list to keep track of any lines that we'll be removing
            set lRemovedLines {}

            #to be considered a "stray X line", it must have 0 components found and at least 2 lines found - all with the same outer dimensions
            if {[llength $lbboxComps] == 0 && [llength $lbboxLines] > 1} {
                set lRemovedLines $lbboxLines
            } else {
                #no stray lines found
                return
            }

            #loop through each stray line id and delete them
            foreach lineID $lRemovedLines {
                #make one last sanity check that this is a valid line (shouldn't be possible to have added something else, but who says engineers aren't careful)
                if {[isLine $lineID] && [sch::dbIsValid $lineID]} {
                    #select only this item and delete it
                    onlyselectByID $lineID
                    delete
                }
            }

            #unselect everything
            unselectAll

            #return the list of deleted lines
            return $lRemovedLines
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to ensure only unique (listed only once) and valid components are selected
    #   In case lines are passed - this procedure will attempt to replace them with any found
    #   components "behind" them, in case the user accidentally selected a line instead of the component
    # ----------------------------------------------------------------------------------
    proc getUniqueValidComponents { lobjIDs } {
        #setup a temporary list to keep track of only components
        set tempCompList {}

        #loop through the list of all objects passed
        foreach objID $lobjIDs {
            #for now, we don't care about uniqueness - we can replace our list later with removing duplicates
            if {[isBOMComponent $objID]} {
                #add the component to the temp list
                lappend tempCompList $objID
            } elseif {[isLine $objID]} {
                #find any number of components that match this line's bounding box
                set lbboxComponents [getComponentsFromXlineID $objID]

                #it should be impossible for this to be > 1, but why not be safe
                foreach compID $lbboxComponents {
                    #add these to the running list
                    lappend tempCompList $compID
                }
            }
        }

        #now that we have a list of only non-testpoint components, let's make sure it's valid and each ID is only listed once
        return [getUniqueValidIDs $tempCompList]
    }

    # ----------------------------------------------------------------------------------
    # Procedure to take in a list of database IDs and return a list that contains only valid IDs
    #   this also will ensure each ID only exists once in the list
    # ----------------------------------------------------------------------------------
    proc getUniqueValidIDs { lobjIDs } {
        #loop through the provide list, and collect all IDs that are currently valid
        set validIDs {}
        foreach objID $lobjIDs {
            if {[sch::dbIsValid $objID] && [lsearch -exact $validIDs $objID] < 0} {lappend validIDs $objID}
        }
        return $validIDs
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
        if {[isBOMComponent $objID]} {
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
        #ensure the passed object ID is a non testpoint component and doesn't already have an X visualization over it
        if {[isBOMComponent $objID] && [llength [getXlinesFromComponentID $objID]] == 0} {
            #Ensure only the component is selected
            onlyselectByID $objID

            #set the component's fill color
            setFillColor $grm::AOEM_Hotkeys::clrDNUcompfill

            #set the component's line color
            setLineColor $grm::AOEM_Hotkeys::clrDNUcompline

            set compLeft [getLeftByIDuserUnits $objID]
            set compTop [getTopByIDuserUnits $objID]
            set compRight [getRightByIDuserUnits $objID]
            set compBot [getBotByIDuserUnits $objID]

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
        if {[isBOMComponent $objID]} {
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
        if {[isBOMComponent $objID]} {
            #check if there are any X lines to remove
            set lXlines [getXlinesFromComponentID $objID]

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
    # Procedure to return the coordinates (User Units, not dbUnits) of the left boundary of the component or line
    #   Safely handles components or lines as passed object ID
    # ----------------------------------------------------------------------------------
    proc getLeftByIDuserUnits { objID } {
        if {[grm::filter::isComponent $objID]} {
            return [getCompLeftByIDuserUnits $objID]
        } else {
            return [getShapeLeftByIDuserUnits $objID]
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the top boundary of the component or line
    #   Safely handles components or lines as passed object ID
    # ----------------------------------------------------------------------------------
    proc getTopByIDuserUnits { objID } {
        if {[grm::filter::isComponent $objID]} {
            return [getCompTopByIDuserUnits $objID]
        } else {
            return [getShapeTopByIDuserUnits $objID]
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the right boundary of the component or line
    #   Safely handles components or lines as passed object ID
    # ----------------------------------------------------------------------------------
    proc getRightByIDuserUnits { objID } {
        if {[grm::filter::isComponent $objID]} {
            return [getCompRightByIDuserUnits $objID]
        } else {
            return [getShapeRightByIDuserUnits $objID]
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the bottom boundary of the component or line
    #   Safely handles components or lines as passed object ID
    # ----------------------------------------------------------------------------------
    proc getBotByIDuserUnits { objID } {
        if {[grm::filter::isComponent $objID]} {
            return [getCompBotByIDuserUnits $objID]
        } else {
            return [getShapeBotByIDuserUnits $objID]
        }
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the left boundary of the component
    # ----------------------------------------------------------------------------------
    proc getCompLeftByIDuserUnits { objID } {
        #find the coordinates
        set coordLeft [lindex [sch::dbConvertToUserUnits [lindex [sch::dbGetShapeBBox $objID] 0]] 0]

        #return the coordinates
        return $coordLeft
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the top boundary of the component
    # ----------------------------------------------------------------------------------
    proc getCompTopByIDuserUnits { objID } {
        #find the coordinates
        set coordTop [lindex [sch::dbConvertToUserUnits [lindex [sch::dbGetShapeBBox $objID] 0]] 1]

        #return the coordinates
        return $coordTop
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the right boundary of the component
    # ----------------------------------------------------------------------------------
    proc getCompRightByIDuserUnits { objID } {
        #find the coordinates
        set coordRight [lindex [sch::dbConvertToUserUnits [lindex [sch::dbGetShapeBBox $objID] 1]] 0]

        #return the coordinates
        return $coordRight
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the bottom boundary of the component
    # ----------------------------------------------------------------------------------
    proc getCompBotByIDuserUnits { objID } {
        #find the coordinates
        set coordBot [lindex [sch::dbConvertToUserUnits [lindex [sch::dbGetShapeBBox $objID] 1]] 1]
        
        #return the coordinates
        return $coordBot
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return a list of all X coordinates of a shape (User Units, not dbUnits)
    # ----------------------------------------------------------------------------------
    proc getShapeXpointsByIDuserUnits { objID } {
        #initially blank list to collect all X coordinates of the Shape's points
        set lXpoints []

        #only collect coordinate points if it's not a component
        if {![grm::filter::isComponent $objID]} {
            #collect the line's points in database format
            set lDBPoints [sch::dbGetPoints $objID]

            #make sure points were found
            if {[llength $lDBPoints] == 0} {return}

            #loop through all points, convert to User Units, then add them to the lXpoints list
            foreach DBpoint $lDBPoints {
                lappend lXpoints [lindex [sch::dbConvertToUserUnits $DBpoint] 0]
            }
        }

        #return the list
        return $lXpoints
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return a list of all Y coordinates of a shape (User Units, not dbUnits)
    # ----------------------------------------------------------------------------------
    proc getShapeYpointsByIDuserUnits { objID } {
        #initially blank list to collect all X coordinates of the Shape's points
        set lYpoints []

        #only collect coordinate points if it's not a component
        if {![grm::filter::isComponent $objID]} {
            #collect the Shapes's points in database format
            set lDBPoints [sch::dbGetPoints $objID]

            #make sure points were found
            if {[llength $lDBPoints] == 0} {return}

            #loop through all points, convert to User Units, then add them to the lXpoints list
            foreach DBpoint $lDBPoints {
                lappend lYpoints [lindex [sch::dbConvertToUserUnits $DBpoint] 1]
            }
        }

        #return the list
        return $lYpoints
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the left boundary of the Shape
    # ----------------------------------------------------------------------------------
    proc getShapeLeftByIDuserUnits { objID } {
        #Left is the smallest X coordinate in the list of the Shape's points
        set lXpoints [getShapeXpointsByIDuserUnits $objID]

        #Only return a valid set of points
        if {[llength $lXpoints] > 0 } {return [::tcl::mathfunc::min {*}$lXpoints]}
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the top boundary of the Shape
    # ----------------------------------------------------------------------------------
    proc getShapeTopByIDuserUnits { objID } {
        #Top is the smallest Y coordinate in the list of the Shape's points
        set lYpoints [getShapeYpointsByIDuserUnits $objID]

        #Only return a valid set of points
        if {[llength $lYpoints] > 0 } {return [::tcl::mathfunc::min {*}$lYpoints]}
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the right boundary of the Shape
    # ----------------------------------------------------------------------------------
    proc getShapeRightByIDuserUnits { objID } {
        #Right is the larget X coordinate in the list of the Shape's points
        set lXpoints [getShapeXpointsByIDuserUnits $objID]

        #Only return a valid set of points
        if {[llength $lXpoints] > 0 } {return [::tcl::mathfunc::max {*}$lXpoints]}
    }

    # ----------------------------------------------------------------------------------
    # Procedure to return the coordinates (User Units, not dbUnits) of the bottom boundary of the Shape
    # ----------------------------------------------------------------------------------
    proc getShapeBotByIDuserUnits { objID } {
        #Bottom is the larget Y coordinate in the list of the Shape's points
        set lYpoints [getShapeYpointsByIDuserUnits $objID]

        #Only return a valid set of points
        if {[llength $lYpoints] > 0 } {return [::tcl::mathfunc::max {*}$lYpoints]}
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
            if {[isBOMComponent $objID]} {
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
            {"&DNU Management" {sch} {} {
                {"Toggle DNU" {} {grm::AOEM_Hotkeys::toggleDNUselection} {}}
                {"Apply X to all DNU components on the current page" {} {grm::AOEM_Hotkeys::addXtoDNU_currentPage} {}}
                {"Apply X to all DNU components in the design" {} {grm::AOEM_Hotkeys::addXtoDNU_allPages} {}}
            }}
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
            {"FindPart &Utilities" {sch} {} {
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

    }
}

#After loading the file, run the init function
grm::AOEM_Hotkeys::init

# end of file