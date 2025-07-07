# Changelog

## Unreleased

**Note:** Unreleased changes are checked in within the [\_drafts\_](_drafts_) folder to allow easier development/testing in the meantime.  Changelogs will only be written once new versions have been moved to the [\_releases\_](_releases_) directory.

## [1.0.3] - 2025-07-07

### Author:   Ryan Klassing

### Description:
    - Fixed a bug that was preventing the [addXtoDNU_allPages] script from functioning when Cadence hadn't already cached the pages to be open (I blame Cadence TCL documentation for not describing this return condition on sch::nextPage....)

## [1.0.2] - 2025-01-09

### Author:   Ryan Klassing

### Description:
    - Fixed a bug that was preventing the DNU color fill from being applied to components

## [1.0.1] - 2025-01-08

### Author:   Ryan Klassing

### Description:
    - Added functionality to allow the script to check the BOM and NOT_USED properties when getting/setting DNU status on components
        - this configuration can be set externally if needed.  Default configuration is for using both BOM and NOT_USED, but can be set to either BOM or NOT_USED if desired

## [1.0.0] - 2024-12-26

### Author:   Ryan Klassing

### Description:
    1. Updated local object type checks to utilize grm::filter item type checks for better maintenance
    2. Updated net color scripts to apply color to all nets selected, even if other object types are also selected
    3. Added new toggleDNU functionality to allow one-button management of DNU visualization of components (supports single component or multi-selection)
        - Note: this also ensures all gates of a component are set at the same time, regardless of which pages the gates are spread across
    4. Added new addXtoDNU_currentPage functionality to allow converting a specific page from traditional BOM tag only, to BOM tag + X visualization
    5. Added new addXtoDNU_allPages functionality to allow converting an entire design from traditional BOM tag only, to BOM tag + X visualization
        - Note: this can take up to 5-7minutes on a very large design with many DNU components

## [0.1.1] - 2024-12-10

### Author:   Ryan Klassing

### Description:
    1. Renamed openInFindPart to FPENG to allow consistent naming with other findpart functions
    2. Added new FPAML function to do an AML search in FindPart for the selected component

## [0.1.0] - 2024-08-21

### Author:   Ryan Klassing / Tyler Dill

### Description:
Initial release of the script.

## Note

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
