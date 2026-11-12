## MODIFIED Requirements

### Requirement: New game action menu shows five options
The new game view SHALL show exactly five lower action options: explore dungeon, challenge dungeon, manage equipment, shop, and exit.

#### Scenario: English new game actions are visible
- **WHEN** the device language is not Spanish and the new game view is displayed
- **THEN** the lower action list displays "Explore Dungeon", "Challenge Dungeon", "Manage Equipment", "Shop", and "Exit"

#### Scenario: Spanish new game actions are visible
- **WHEN** the device language is Spanish and the new game view is displayed
- **THEN** the lower action list displays "Explorar Mazmorra", "Desafiar Mazmorra", "Ordenar Equipo", "Tienda", and "Salir"

#### Scenario: Explore dungeon opens exploration view
- **WHEN** the user selects the explore-dungeon action
- **THEN** the app displays the dungeon exploration view
