## ADDED Requirements

### Requirement: Saves preserve permanent experience only
The mobile game SHALL persist permanent accumulated experience without restoring an interrupted dungeon's provisional experience.

#### Scenario: Player save is loaded
- **WHEN** a valid save is loaded
- **THEN** permanent accumulated experience is restored
- **AND** provisional dungeon experience is zero
- **AND** no dungeon run is marked active
