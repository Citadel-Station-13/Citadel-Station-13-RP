//Security

/area/security
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/main
	name = "\improper Security Office"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/lobby
	name = "\improper Security Lobby"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/security/brig
	name = "\improper Security - Brig"
	icon_state = "brig"

/area/security/brig/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.timer_duration = 1
	..()

/area/security/prison
	name = "\improper Security - Prison Wing"
	icon_state = "sec_prison"

/area/security/prison/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.timer_duration = 1
	..()

/area/security/prison/upper
	name = "\improper Security - Upper Prison Wing"
	icon_state = "sec_prison"

/area/security/prison/lower
	name = "\improper Security - Lower Prison Wing"
	icon_state = "sec_prison"

/area/security/warden
	name = "\improper Security - Warden's Office"
	icon_state = "Warden"

/area/security/armoury
	name = "\improper Security - Armory"
	icon_state = "armory"
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_BLUE_SHIELDED
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/security/briefing_room
	name = "\improper Security - Briefing Room"
	icon_state = "brig"

/area/security/evidence_storage
	name = "\improper Security - Equipment Storage"
	icon_state = "security_equipment_storage"

/area/security/evidence_storage
	name = "\improper Security - Evidence Storage"
	icon_state = "evidence_storage"

/area/security/interrogation
	name = "\improper Security - Interrogation"
	icon_state = "interrogation"

/area/security/riot_control
	name = "\improper Security - Riot Control"
	icon_state = "riot_control"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/security/detectives_office
	name = "\improper Security - Forensic Office"
	icon_state = "detective"
	sound_env = MEDIUM_SOFTFLOOR

/area/security/range
	name = "\improper Security - Firing Range"
	icon_state = "firingrange"

/area/security/security_aid_station
	name = "\improper Security - Security Aid Station"
	icon_state = "security_aid_station"

/area/security/security_bathroom
	name = "\improper Security - Restroom"
	icon_state = "security_bathroom"
	sound_env = SMALL_ENCLOSED

/area/security/security_cell_hallway
	name = "\improper Security - Cell Hallway"
	icon_state = "security_cell_hallway"

/area/security/security_equiptment_storage
	name = "\improper Security - Equipment Storage"
	icon_state = "security_equip_storage"

/area/security/security_lockerroom
	name = "\improper Security - Locker Room"
	icon_state = "security_lockerroom"

/area/security/security_processing
	name = "\improper Security - Security Processing"
	icon_state = "security_processing"

/area/security/tactical
	name = "\improper Security - Tactical Equipment"
	icon_state = "Tactical"
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_BLUE_SHIELDED

/area/security/hallway
	name = "\improper Security Hallway"
	icon_state = "security"

/area/security/hallwayaux
	name = "\improper Security Armory Hallway"
	icon_state = "security"

/area/security/forensics
	name = "\improper Forensics Lab"
	icon_state = "security"

/area/security/breakroom
	name = "\improper Security Breakroom"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/security/brig/visitation
	name = "\improper Visitation"
	icon_state = "security"

/area/security/brig/bathroom
	name = "\improper Brig Bathroom"
	icon_state = "security"

/area/security/armory/blue
	name = "\improper Armory - Blue"
	icon_state = "armory"

/area/security/armory/red
	name = "\improper Armory - Red"
	icon_state = "red2"

/area/security/observation
	name = "\improper Brig Observation"
	icon_state = "riot_control"

/area/security/eva
	name = "\improper Security EVA"
	icon_state = "security_equip_storage"

/area/security/recstorage
	name = "\improper Brig Recreation Storage"
	icon_state = "brig"

/area/security/training
	name = "\improper Training & Briefing Room"
	icon_state = "security"

/area/security/hangar
	name = "\improper Security Hangar"
	icon_state = "security_equip_storage"

/area/security/visitor
	name = "\improper Security Visitor Room"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/*
	New()
		..()

		spawn(10) //let objects set up first
			for(var/turf/turfToGrayscale in src)
				if(turfToGrayscale.icon)
					var/icon/newIcon = icon(turfToGrayscale.icon)
					newIcon.GrayScale()
					turfToGrayscale.icon = newIcon
				for(var/obj/objectToGrayscale in turfToGrayscale) //1 level deep, means tables, apcs, locker, etc, but not locker contents
					if(objectToGrayscale.icon)
						var/icon/newIcon = icon(objectToGrayscale.icon)
						newIcon.GrayScale()
						objectToGrayscale.icon = newIcon
*/

/area/security/nuke_storage
	name = "\improper Vault"
	icon_state = "nuke_storage"
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_BLUE_SHIELDED

/area/security/checkpoint
	name = "\improper Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint2
	name = "\improper Security - Arrival Checkpoint"
	icon_state = "security"
	ambience = AMBIENCE_ARRIVALS

/area/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint1"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint1"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint1"

/area/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint1"

/area/security/vacantoffice
	name = "\improper Vacant Office"
	icon_state = "security"

/area/security/vacantoffice2
	name = "\improper Vacant Office"
	icon_state = "security"

/area/security/hammerhead_bay
	name = "\improper Hammerhead Barge Hangar"
	icon_state = "hangar"
