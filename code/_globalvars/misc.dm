GLOBAL_VAR_INIT(timezoneOffset, 0) // The difference betwen midnight (of the host computer) and 0 world.ticks.

GLOBAL_VAR_INIT(TAB, "&nbsp;&nbsp;&nbsp;&nbsp;")

//Loadout stuff
GLOBAL_DATUM_INIT(global_underwear, /datum/category_collection/underwear, new)

GLOBAL_VAR_INIT(internal_tick_usage, 0.2 * world.tick_lag)
