# Changelog

## Unreleased

**Note:** Unreleased changes are checked in within the [\_drafts\_](_drafts_) folder to allow easier development/testing in the meantime.  Changelogs will only be written once new versions have been moved to the [\_releases\_](_releases_) directory.

## [0.1.1] - 2024-04-23

### Author:   Ryan Klassing

### Description:
 - Changed the layer naming strategy to hopefully prevent naming conflicts when color mapping
     - v0.1 has a bug where if a user already used L02/L03 type naming, but had them in the wrong order -- we could hit a naming conflict
         - Naming strategy is as follows:
            1) Load up all existing layer names from the user
            2) Temporarily rename them to a naming convention that is extremely unlikely for the user to have picked (to try to ensure we have no naming conflicts)
            3) Now that we should have a clean starting point (no existing names should match the ideal "garmin standard" now) --> rename all layers sequentially to the garmin standard (L02, L03, ...)
            4) After applying the appropriate color file, rename layers back to their original state form Step1

## [0.1.0] - 2024-01-16

### Author:   Ryan Klassing

### Description:
Initial release of the script.

## Note

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
