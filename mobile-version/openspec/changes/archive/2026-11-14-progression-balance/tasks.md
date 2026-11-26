## 1. Measurement
- [x] 1.1 Playtest bot (`tools/playtest_bot.gd`) and CLI (`tools/playtest.gd`)
- [x] 1.2 Baseline measurement

## 2. Tuning
- [x] 2.1 Basic attack 3 damage / 1 energy; level-1 monster armor and life
- [x] 2.2 Monster experience × 4
- [x] 2.3 Bounded monster count and gradual map growth from level 10
- [x] 2.4 Post-10 threshold growth as a percentage
- [x] 2.5 Strength damage bonus
- [x] 2.6 Monster level ranges; monster growth kept at 2 points per level after comparing 2.0 / 2.5 / 3.0

## 3. Safety
- [x] 3.1 Refresh saved attacks from data on load
- [x] 3.2 Tests read attack values from data; `tests/verify_balance.gd`
