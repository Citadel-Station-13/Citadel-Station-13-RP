//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/map_helper/jigsaw_spawn
	#warn sprite

	var/allow_mob = FALSE
	var/allow_item = FALSE

	var/list/spawn_tags
	var/list/priority_tags

/obj/map_helper/jigsaw_spawn/mob_spawn
	spawn_tags = list(
		JIGSAW_SPAWN_TAG_MOB,
	)

/obj/map_helper/jigsaw_spawn/mob_spawn/prefer_boss
	priority_tags = list(
		JIGSAW_SPAWN_TAG_MOB_BOSS,
	)

/obj/map_helper/jigsaw_spawn/mob_spawn/prefer_ranged
	priority_tags = list(
		JIGSAW_SPAWN_TAG_MOB_RANGED,
	)

/obj/map_helper/jigsaw_spawn/mob_spawn/prefer_melee
	priority_tags = list(
		JIGSAW_SPAWN_TAG_MOB_MELEE,
	)

/obj/map_helper/jigsaw_spawn/item_spawn
	spawn_tags = list(
		JIGSAW_SPAWN_TAG_ITEM,
	)

/obj/map_helper/jigsaw_spawn/item_spawn/prefer_gun
	priority_tags = list(
		JIGSAW_SPAWN_TAG_ITEM_GUN,
	)

/obj/map_helper/jigsaw_spawn/item_spawn/prefer_melee
	priority_tags = list(
		JIGSAW_SPAWN_TAG_ITEM_MELEE,
	)

/obj/map_helper/jigsaw_spawn/item_spawn/prefer_armor
	priority_tags = list(
		JIGSAW_SPAWN_TAG_ITEM_ARMOR,
	)

/obj/map_helper/jigsaw_spawn/item_spawn/prefer_spacesuit
	priority_tags = list(
		JIGSAW_SPAWN_TAG_ITEM_SPACESUIT,
	)

/obj/map_helper/jigsaw_spawn/item_spawn/prefer_materials
	priority_tags = list(
		JIGSAW_SPAWN_TAG_ITEM_MATERIALS,
	)

/obj/map_helper/jigsaw_spawn/item_spawn/prefer_medical
	priority_tags = list(
		JIGSAW_SPAWN_TAG_ITEM_MEDICAL,
	)
