## ADDED Requirements

### Requirement: Players can select the application language
The mobile game SHALL provide English and Spanish language choices from Settings.

#### Scenario: Player opens Settings
- **WHEN** the player selects Settings from the main menu
- **THEN** a Settings view displays English and Spanish language choices
- **AND** the currently active language is indicated

#### Scenario: Player changes language
- **WHEN** the player selects a supported language
- **THEN** visible interface text updates immediately
- **AND** the preference is persisted independently from player saves

### Requirement: Saved language overrides device detection
The mobile game SHALL restore a valid saved language preference on launch.

#### Scenario: No language preference exists
- **WHEN** the application starts without saved settings
- **THEN** Spanish devices use Spanish
- **AND** all other device languages use English

#### Scenario: Language preference exists
- **WHEN** the application starts with a valid saved language
- **THEN** the saved language is used regardless of the device language
