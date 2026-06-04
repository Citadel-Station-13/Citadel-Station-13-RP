DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /pad_1, "Pad 1")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /pad_2, "Pad 2")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /pad_3, "Pad 3")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /pad_4, "Pad 4")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /pad_5, "Pad 5")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /pad_6, "Pad 6")

DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /caravan, "Caravan Hanger")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /adventurer, "Adventurer Hanger")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /cargo_tug, "Cargo Tug Hanger")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /micro_shuttle, "Micro Shuttle Hanger")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/nebula_tradeport, /teshari_runabout, "Teshari Runabout Hanger")
	docking_restrict_to_starting = TRUE

DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(/nebula_tradeport, /beruang, "Beruang Hanger")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(/nebula_tradeport, /udang, "Udang Dock")
	// system doesn't support concave shuttles very well just allow trample
	trample_bounding_box = TRUE
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(/nebula_tradeport, /arrowhead, "Arrowhead Dock")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(/nebula_tradeport, /vevalia_salvage, "Vevalia Salvage Dock")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(/nebula_tradeport, /scoophead, "Scoophead Dock")
	docking_restrict_to_starting = TRUE

#warn demote caravan/adventurer to nebula specific
