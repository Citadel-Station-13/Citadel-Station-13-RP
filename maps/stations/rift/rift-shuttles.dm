DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /excursion_pad, "Exploration Shuttle Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /civillian_pad_1, "Civillian Transport Pad - A")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /civillian_pad_2, "Civillian Transport Pad - B")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /emt_pad, "EMT Shuttle Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /trade_pad, "Trade Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /scoophead_pad, "Scoophead Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /udang_pad, "Udang Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /spec_ops_pad, "Special Operations Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /wilderness_pad, "Wilderness Pad")

DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /courser_hanger, "Courser Hanger")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /hammerhead_hanger, "Hammerhead Hanger")
	docking_restrict_to_starting = TRUE

// TODO: readd a way to fly into the sky

#warn below

/datum/shuttle/autodock/ferry/supply
	ceiling_type = /turf/simulated/floor/plasteel/lythios43c

// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_rift"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_dock"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
