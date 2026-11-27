## 1. Implementation
- [x] 1.1 `scripts/stat_order.gd`: `CANONICAL` (life, energy, mana, armor, strength, speed, reputation, experience, dungeon XP), `select()`, `is_canonical()`
- [x] 1.2 `main.gd`: screen stat lists become keys; hub, exploration HUD, fight panel (player and monster), Level Up rows and guide derive their order with `StatOrder.select()`
- [x] 1.3 Stat rows and guide entries carry their stat key (`stat_key` meta)

## 2. Verification
- [x] 2.1 New `tests/verify_stat_order.gd`: the order is identical across hub, exploration, Level Up rows, Level Up guide and fight panel (player and monster)
- [x] 2.2 `tests/verify_stat_help.gd` orders updated; full suite passing
- [ ] 2.3 `openspec validate consistent-stat-order` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.4 Manual check on a phone
