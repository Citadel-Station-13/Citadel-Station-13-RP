DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /excursion_pad, "Exploration Shuttle Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /civillian_pad_1, "Civillian Transport Pad - A")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /civillian_pad_2, "Civillian Transport Pad - B")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /emt_pad, "EMT Shuttle Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /trade_pad, "Trade Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /scoophead_pad, "Scoophead Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /udang_pad, "Udang Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /spec_ops_pad, "Special Operations Pad")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /wilderness_pad, "Wilderness Pad")

#warn restrain these to shuttle
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /courser_hanger, "Courser Hanger")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/rift, /hammerhead_hanger, "Hammerhead Hanger")

// TODO: readd a way to fly into the sky

#warn impl all
// Exclusive landmark for docking at the station
/obj/effect/shuttle_landmark/rift/deck3/excursion
	name = "NSB Atlas - Exploration Shuttle Pad"
/obj/effect/shuttle_landmark/rift/deck3/civvie
	name = "NSB Atlas - Civilian Transport Pad"
/obj/effect/shuttle_landmark/rift/deck3/oldcentury
	name = "NSB Atlas - Secondary Civilian Transport Pad"
/obj/effect/shuttle_landmark/rift/deck3/emt
	name = "NSB Atlas - EMT Shuttle Pad"
/obj/effect/shuttle_landmark/rift/deck3/trade
	name = "NSB Atlas - Trade Pad"
/obj/effect/shuttle_landmark/rift/deck3/scoophead
	name = "NSB Atlas - Scoophead Pad"
/obj/effect/shuttle_landmark/rift/deck3/udang
	name = "NSB Atlas - Udang Pad"
/obj/effect/shuttle_landmark/rift/deck3/specops
	name = "NSB Atlas - Special Operations Pad"
/obj/effect/shuttle_landmark/rift/deck3/pirate
	name = "NSB Atlas - Pirate Landing Pad"
/obj/effect/shuttle_landmark/rift/deck3/courser
	name = "NSB Atlas - Courser Hangar"
/obj/effect/shuttle_landmark/rift/deck2/hammerhead
	name = "NSB Atlas - Hammerhead Hangar"

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
