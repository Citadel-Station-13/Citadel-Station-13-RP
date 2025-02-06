GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/multirole)
/datum/prototype/robot_module/nanotrasen/multirole
	id = "nt-multirole"
	use_robot_module_path = /obj/item/robot_module/robot/standard
	light_color = "#FFFFFF"
	allowed_frames = list(
		/datum/robot_frame{
			name = "K4T";
			robot_chassis = /datum/prototype/robot_chassis/biped;
			robot_iconset = /datum/prototype/robot_iconset/biped_k4t;
		},
		/datum/robot_frame{
			name = "M-USE (Nanotrasen)";
			robot_chassis = /datum/prototype/robot_chassis/;
			robot_iconset = /datum/prototype/robot_iconset/baseline_old/standard;
		},
		/datum/robot_frame{
			name = "Cabeiri";
			robot_chassis = /datum/prototype/robot_chassis/hover;
			robot_iconset = /datum/prototype/robot_iconset/eyebot/standard;
		},
		/datum/robot_frame{
			name = "Haruka";
			robot_chassis = /datum/prototype/robot_chassis/biped;
			robot_iconset = /datum/prototype/robot_iconset/biped_marina/standard;
		},
		/datum/robot_frame{
			name = "Usagi";
			robot_chassis = /datum/prototype/robot_chassis/biped;
			robot_iconset = /datum/prototype/robot_iconset/biped_tall/tallflower;
		},
		/datum/robot_frame{
			name = "Telemachus";
			robot_chassis = /datum/prototype/robot_chassis/baseline;
			robot_iconset = /datum/prototype/robot_iconset/baseline_toiletbot;
		},
		/datum/robot_frame{
			name = "WT - Operator";
			robot_chassis = /datum/prototype/robot_chassis/biped;
			robot_iconset = /datum/prototype/robot_iconset/biped_sleek;
		},
		/datum/robot_frame{
			name = "WT - Omni";
			robot_chassis = /datum/prototype/robot_chassis/baseline;
			robot_iconset = /datum/prototype/robot_iconset/baseline_misc/omoikane;
		},
		/datum/robot_frame{
			name = "XI-GUS";
			robot_chassis = /datum/prototype/robot_chassis/grounded;
			robot_iconset = /datum/prototype/robot_iconset/grounded_spider/standard;
		},
		/datum/robot_frame{
			name = "XI-ALP";
			robot_chassis = /datum/prototype/robot_chassis/biped;
			robot_iconset = /datum/prototype/robot_iconset/biped_heavy/standard;
		},
		/datum/robot_frame{
			name = "F3-LINE";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/feline;
			robot_iconset = /datum/prototype/robot_iconset/cat_feli/standard;
		},
		/datum/robot_frame{
			name = "Basic";
			robot_chassis = /datum/prototype/robot_chassis/baseline;
			robot_iconset = /datum/prototype/robot_iconset/baseline_old/standard;
		}
	)

/datum/prototype/robot_module/nanotrasen/multirole/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/melee/baton/loaded,
			/obj/item/tool/wrench/cyborg,
			/obj/item/healthanalyzer,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/melee/transforming/energy/sword,
		)

#warn translate chassis below

/obj/item/robot_module/robot/standard
	sprites = list(
		"Android" = "droid",
		"Drone" = "drone-standard",
		"Insekt" = "insekt-Default",
		"Misato" = "tall2standard",
		"L3P1-D0T" = "Glitterfly-Standard",
		"Convict" = "servitor",
		"Miss M" = "miss-standard",
		"Coffin" = "coffin-Standard",
		"X-88" = "xeightyeight-standard",
		"Handy" = "handy-standard",
		"Acheron" = "mechoid-Standard",
		"Shellguard Noble" = "Noble-STD",
		"ZOOM-BA" = "zoomba-standard",
		"W02M" = "worm-standard"
	)
