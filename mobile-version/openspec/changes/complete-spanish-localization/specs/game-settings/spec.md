## MODIFIED Requirements

### Requirement: Players can select the application language
The mobile game SHALL provide English and Spanish language choices from Settings, and a language change SHALL update every visible interface text, including screens built at runtime.

#### Scenario: Player opens Settings
- **WHEN** the player selects Settings from the main menu
- **THEN** a Settings view displays English and Spanish language choices
- **AND** the currently active language is indicated

#### Scenario: Player changes language
- **WHEN** the player selects a supported language
- **THEN** visible interface text updates immediately
- **AND** screens opened afterwards, including the level up screen and the monster attack information, are shown in the selected language
- **AND** the preference is persisted independently from player saves

## ADDED Requirements

### Requirement: All visible interface text is translated
The mobile game SHALL show every visible interface text, including names that come from game data, in the active language.

#### Scenario: Spanish interface has no English text
- **WHEN** the active language is Spanish
- **THEN** every visible title, label, button, tooltip, feedback line and modal text is shown in Spanish
- **AND** no raw translation key is shown

#### Scenario: Data-driven names are translated
- **WHEN** a monster, monster attack, player ability, player class or status effect name from the game data is displayed
- **THEN** it is shown in the active language
- **AND** the game data and saved games keep the original name or id

#### Scenario: Name without a translation
- **WHEN** a data-driven name has no translation for the active language
- **THEN** the original data name is shown instead of a translation key
