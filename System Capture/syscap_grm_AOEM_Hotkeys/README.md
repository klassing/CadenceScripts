# CadenceScripts - System Capture - AOEM Hotkeys

## Description
The intent of this script is to provide a series of commonly used functions to allow the engineers to more easily hotkey those functions.  More details of each function provided by this script can be found in the sections below.

## Latest Release
[v1.0.0](_releases_/v1.0.0/) is the latest release.  Older releases can be found within the [\_releases\_](_releases_) folder.

## Automatic Installation
All files necessary for the installation can be found within each release versions subdirectory.

To run the automatic installation, simply run the batch file located at <_release_version_directory_>/tcL_script_installer.bat

## Manual Installation
All files necessary for the installation can be found within each release versions subdirectory.

To install this script for use in your instance of System Capture, please follow these steps:

1) Create the following directory, if it doesn't exist: C:\SPB_Data\cdssetup\canvas\resources\syscap
2) Place the _grm_AOEM_Hotkeys.tcl file, found in <_release_version_directory_>/script_files/, into the folder: C:\SPB_Data\cdssetup\canvas\resources\syscap
3) After restarting System Capture, the skill script should automatically be loaded and ready for use

## Using the script - Basic Commands
After installing the script (see "Installation" above), there are a few methods to invoke the basic commands from the table below:

- Invoke via System Capture Shortcuts (highly recommended)
    - To allow a single keystroke to trigger this command, navigate to System Capture's Edit → Preferences → System → Shortcuts
        - To search for the command you wish to apply a shortcut to, simply click in the top row of the table (underneath Command) and type the command name you wish to shortcut

- Invoke via menu
    - This script will add a series menu items to the menu bar to allow triggering the script by clicking (note: this is also what enables the commands to be registered into the shortcut browser described above).  The menu item can be found under "AOEM Hotkeys"

- Invoke via System Capture command line
    - To manually execute a function from the script after it's been auto-loaded, simply type the desired function name into the command window in System Capture.
        - Note: all functions in this script are wrapped in a namespace to prevent any chance of naming conflicts.  Therefore, all commands must be preceeded with grm::AOEM_Hotkeys:: if executed manually

| Sub Menu Name         | Menu Command Name 	                            | Command to Invoke Manually 	    | Description   |
|:-----------           |:-----------	                                    |:-----------	    	            |:-----------   |
| DNU Management        |                                                   |                                   |               |
|                       | Toggle DNU                                        | toggleDNUselection                | Procedure to toggle the DNU BOM tag and X visualization on/off for the selected components    |
|                       | Apply X to all DNU components on the current page | addXtoDNU_currentPage             | Procedure to scan the current page for components set to DNU and ensure they all have the X visualization applied |
|                       | Apply X to all DNU components in the design       | addXtoDNU_allPages                | Procedure to scan all pages in the design set to DNU and ensure they all have the X visualization applied |
| Net Colors            |                                                   |                                   |               |
|                       | Set Net Color: Power                              | setNetColorPower                  | Set the selection as a Power Net  |
|                       | Set Net Color: GND                                | setNetColorGND                    | Set the selection as a GND Net    |
|                       | Set Net Color: High Speed                         | setNetColorHS                     | Set the selection as a High Speed Net |
|                       | Set Net Color: Low Speed                          | setNetColorLS                     | Set the selection as a Low Speed Net  |
| Symbols               |                                                   |                                   |               |
|                       | Add PWR Input Symbol                              | addPWRINtoCursor                  | Add a generic PWR Input symbol, allowing the user to provide the net name |
|                       | Add PWR Output Symbol                             | addPWROUTtoCursor                 | Add a generic PWR Output symbol, allowing the user to provide the net name    |
|                       | Add GND Symbol                                    | addGenericGNDtoCursor             | Add a generic GND power symbol, allowing the user to provide the net name     |
|                       | Add GND Net                                       | addGNDtoCursor                    | Add the GND power symbol with the standard "GND" net name |
|                       | Add NC Symbol                                     | addNCtoCursor                     | Add the NC symbol |
| FindPart Utilities    |                                                   |                                   |               |
|                       | FindPart: Eng Search                              | FPENG                             | Open a FindPart browser and perform an EngPart search on the selected item in FindPart    |
|                       | FindPart: AML Search                              | FPAML                             | Open a FindPart browser and perform an AML search on the selected item in FindPart    |

## Using the script - Advanced Commands
There are several APIs included in this script that were necessary to support the simplified functions above.  Some of these may be useful for developers to leverage when creating other scripts, so a more detailed explanation of those is included below.  Note: not every procedure is described below, but rather the focus is on which procedures are most likely to be useful for other scripting tasks.
    - Note: all functions in this script are wrapped in a namespace to prevent any chance of naming conflicts.  Therefore, all commands must be preceeded with grm::AOEM_Hotkeys:: if used externally by the command line or by other scripts.
### Additional APIs / Procedures
<details>
    <summary><b><i>unselectAll</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>Unselect everything.</td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>None</td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>unselectAll</td>
                        <td>This will clear all active selections on the canvasy</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

<br>

<details>
    <summary><b><i>onlyselectByID {lobjIDs}</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>Unselect everything except for the passed object IDs.</td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <b>lobjIDs</b>
                            <ul>
                                <li><b>Expected data type</b>: single object ID or a list of object IDs</li>
                                <li><b>Example</b>: "db:0000060b"</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>onlyselectByID [list db:0000060b db:0000060a db:00000609]</td>
                        <td>This will clear all active selections on the canvas, then select the above object IDs only</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

<br>

<details>
    <summary><b><i>getMatchingBBoxItemsByID { objID {lMatchingTests "sch::dbIsValid"} }</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>Procedure to return a list of objects that have an identical bounding box to the passed objID.</td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <b>objID</b>
                            <ul>
                                <li><b>Expected data type</b>: single object ID of any component or any shape</li>
                                <li><b>Example</b>: "db:0000060b"</li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <b>lMatchingTests</b>
                            <ul>
                                <li>
                                    <b>Expected data type</b>: single or list of procedure names to be logically AND'd together to determine if a found object within the bounding box of objID should be returned
                                    <ul>
                                        <li>Additional Note 1: all matching tests must take a single object ID as an input parameter and return boolean 1 for a match and 0 for failure</li>
                                        <li>Additional Note 2: if a user wishes to provide any logic inverses for these tests, simply pass the procedure name starting with !</li>
                                        <li>Additional Note 3: if this parameter is omitted entirely, then all valid object IDs found with a matching bbox will be returned</li>
                                    </ul>
                                </li>
                                <li><b>Example</b>: [list grm::filter::isComponent !grm::filter::isTestpoint !grm::filter::isNetShort]</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>getMatchingBBoxItemsByID db:0000060b [list grm::filter::isComponent !grm::filter::isTestpoint !grm::filter::isNetShort]</td>
                        <td>This will scan all items within the bounding dimensions of db:0000060b, then return all found items that are components but not testpoints and not netshorts</td>
                    </tr>
                    <tr>
                        <td>getMatchingBBoxItemsByID db:0000060b [list !grm::filter::isComponent]</td>
                        <td>This will scan all items within the bounding dimensions of db:0000060b, then return all found items that are not components</td>
                    </tr>
                    <tr>
                        <td>getMatchingBBoxItemsByID db:0000060b</td>
                        <td>This will scan all items within the bounding dimensions of db:0000060b, then return all found items that are valid database items (including db:0000060b itself)</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

<br>

<details>
    <summary><b><i>getLeftByIDuserUnits { objID }</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>Procedure to return the coordinates (User Units, not dbUnits) of the left boundary of the component or shape.</td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <b>objID</b>
                            <ul>
                                <li><b>Expected data type</b>: single object ID of any component or any shape</li>
                                <li><b>Example</b>: "db:0000060b"</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>getLeftByIDuserUnits db:0000060b</td>
                        <td>This will return the left-most X coordinate, in User Units, of the passed objID</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

<br>

<details>
    <summary><b><i>getTopByIDuserUnits { objID }</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>Procedure to return the coordinates (User Units, not dbUnits) of the top boundary of the component or shape</td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <b>objID</b>
                            <ul>
                                <li><b>Expected data type</b>: single object ID of any component or any shape</li>
                                <li><b>Example</b>: "db:0000060b"</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>getTopByIDuserUnits db:0000060b</td>
                        <td>This will return the top-most Y coordinate, in User Units, of the passed objID</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

<br>

<details>
    <summary><b><i>getRightByIDuserUnits { objID }</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>Procedure to return the coordinates (User Units, not dbUnits) of the right boundary of the component or shape</td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <b>objID</b>
                            <ul>
                                <li><b>Expected data type</b>: single object ID of any component or any shape</li>
                                <li><b>Example</b>: "db:0000060b"</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>getRightByIDuserUnits db:0000060b</td>
                        <td>This will return the right-most X coordinate, in User Units, of the passed objID</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

<br>

<details>
    <summary><b><i>getBotByIDuserUnits { objID }</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>Procedure to return the coordinates (User Units, not dbUnits) of the bottom boundary of the component or shape</td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <b>objID</b>
                            <ul>
                                <li><b>Expected data type</b>: single object ID of any component or any shape</li>
                                <li><b>Example</b>: "db:0000060b"</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>getBotByIDuserUnits db:0000060b</td>
                        <td>This will return the bottom-most Y coordinate, in User Units, of the passed objID</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

<br>

<details>
    <summary><b><i>getUniqueRefDesByIDs { lobjIDs }</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>Procedure to return a list of unique reference designators from the provided list of object IDs</td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <b>lobjIDs</b>
                            <ul>
                                <li><b>Expected data type</b>: single object ID or list of object IDs of any component</li>
                                <li><b>Example</b>: "db:0000060b"</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>getUniqueRefDesByIDs db:0000060b</td>
                        <td>This will return the reference designator for the passed object ID</td>
                    </tr>
                    <tr>
                        <td>getUniqueRefDesByIDs db:0000060b db:0000060c</td>
                        <td>If both object IDs are unique components, this will return the reference designators for both of the passed object IDs.  If both object IDs are simply different gates of the same component, then their collective reference designator is returned.</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

<br>

<details>
    <summary><b><i>getInstanceLocationsByRefDes { lRefDes }</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>
                Procedure to return a list of locations {pageSpath x y} for all provided reference designators.
                <br>
                The returned list will be organized by pageSpaths, to minimize page transitions needed in calling procedures, with the following format:
                <br>
                { {pageSpath1 {x1 y1} {x2 y2} {x3 y3} ...} {pageSpath2 {x1 y1} {x2 y2} ...} {pageSpath3 ... } }
            </td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <b>lRefDes</b>
                            <ul>
                                <li><b>Expected data type</b>: single Reference Designator or list of Reference Designators</li>
                                <li><b>Example</b>: "I1000"</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>getInstanceLocationsByRefDes I1000</td>
                        <td>
                            Let's assume that I1000 is a single gate item and located on page 1; The returned result will be a list formatted as follows:
                            <br>
                            { {Page1_Spath {I1000_X I1000_Y}} }
                            <ul>
                                <li>Note: The first index of each sublist is always the pageSpath, and all following indeces of that sublist are coordinate pairs for each relevant gate on that page.</li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>getInstanceLocationsByRefDes [list I1000 I2000]</td>
                        <td>
                            Let's assume that I3000 is a single gate item and located on page 3, I2000 is a multi gate item with one gate each located on pages 2/3/4, and the user is currently viewing/active on page 3; The returned result will be a list formatted as follows:
                            <br>
                            {{Page3_Spath {I2000_Gate1_X I2000_Gate1_Y} {I3000_X I3000_Y}} {Page2_Spath {I2000_Gate2_X I2000_Gate2_Y}} {Page4_Spath {I2000_Gate3_X I2000_Gate3_Y}}}
                            <ul>
                                <li>Note: The first index of each sublist is always the pageSpath, and all following indeces of that sublist are coordinate pairs for each relevant gate on that page.</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

<br>

<details>
    <summary><b><i>getIDbyLocation { pageSpath compCoordinates }</i></b></summary>
    <br>
    <table>
        <tr>
            <td><b>Description</b>:</td>
            <td>
                Procedure to return an object's ID by providing the page + coordinates found by sch::dbGetInfoFromInstanceSpath.
            </td>
        </tr>
        <tr>
            <td><b>Parameters</b>:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <b>pageSpath</b>
                            <ul>
                                <li><b>Expected data type</b>: single pageSpath for a specific gate/instance of interest</li>
                                <li><b>Example</b>: "@worklib.\05085_00_r01\(tbl_1):QAM8397 Power(18)"</li>
                            </ul>
                        </td>
                        <td>
                            <b>compCoordinates</b>
                            <ul>
                                <li><b>Expected data type</b>: X/Y coordinate pair in UserUnits formatted as a 2 item list {x y}</li>
                                <li><b>Example</b>: "[list 16500 14400]"</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Script Example(s)</b>:</td>
            <td>
                <table>
                    <tr>
                        <th>Syntax/API</th>
                        <th>Result</th>
                    </tr>
                    <tr>
                        <td>getIDbyLocation "@worklib.\05085_00_r01\(tbl_1):QAM8397 Power(18)" [list 16500 14400]</td>
                        <td>
                            This will return the object ID for the instance/gate of the component located at {16500, 14400} on sheet 18 of the 05085_00_r01 schematic design.
                            <ul>
                                <li>Note: It is highly recommended to programmatically pass parameters into this function by using parsed results of getInstanceLocationsByRefDes for example.</li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</details>

## Author(s)
- Author(s): Ryan Klassing
- Copyright (C) 2017-2025 Ryan Klassing.
- Released under the MIT license.

## License

MIT License

Copyright (c) 2017-2025 Ryan Klassing

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
