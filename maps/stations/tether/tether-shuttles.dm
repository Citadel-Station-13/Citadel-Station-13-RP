//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(/tether, /medivac, "Medivac External Dock")
DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(/tether, /securiship, "Securiship External Dock")

DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(/tether, /tour_bus, "Tour Bus Hanger")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(/tether, /expedition_shuttle, "Expedition Shuttle Hanger")
	docking_restrict_to_starting = TRUE
DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(/tether, /mining_ferry, "Mining Ferry Hanger")
	docking_restrict_to_starting = TRUE

DECLARE_SHUTTLE_FERRY_DOCK_MAP_PAIR(/tether, /backup_ferry, "Tether Backup Ferry")
