//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig_module/item_deploy/simple/toolset/engineering
	stored = list(
		/obj/item/tool/screwdriver/rig_basic,
		/obj/item/tool/wirecutters/rig_basic,
		/obj/item/tool/wrench/rig_basic,
		/obj/item/tool/crowbar/rig_basic,
	)
	#warn impl

/obj/item/rig_module/item_deploy/simple/toolset/engineering/with_multitool
	stored = list(
		/obj/item/tool/screwdriver/rig_basic,
		/obj/item/tool/wirecutters/rig_basic,
		/obj/item/tool/wrench/rig_basic,
		/obj/item/tool/crowbar/rig_basic,
		/obj/item/multitool,
	)

/obj/item/rig_module/item_deploy/simple/toolset/engineering/with_welder
	stored = list(
		/obj/item/tool/screwdriver/rig_basic,
		/obj/item/tool/wirecutters/rig_basic,
		/obj/item/tool/wrench/rig_basic,
		/obj/item/tool/crowbar/rig_basic,
		/obj/item/weldingtool/electric,
	)

/obj/item/rig_module/item_deploy/simple/toolset/engineering/full
	stored = list(
		/obj/item/tool/screwdriver/rig_basic,
		/obj/item/tool/wirecutters/rig_basic,
		/obj/item/tool/wrench/rig_basic,
		/obj/item/tool/crowbar/rig_basic,
		/obj/item/weldingtool/electric,
		/obj/item/multitool,
	)

/obj/item/tool/wrench/rig_basic
	name = "integrated wrench"
	tool_sound = 'sound/items/drill_use.ogg'
	tool_speed = 1.0

/obj/item/tool/wirecutters/rig_basic
	name = "integrated wirecutters"
	tool_sound = 'sound/items/jaws_cut.ogg'
	tool_speed = 1.0

/obj/item/weldingtool/electric/mounted/rig_basic
	name = "arc welder"
	tool_speed = 1.0

/obj/item/tool/crowbar/rig_basic
	name = "integrated prybar"
	tool_sound = 'sound/items/jaws_pry.ogg'
	tool_speed = 1.0

/obj/item/tool/screwdriver/rig_basic
	name = "integrated screwdriver"
	tool_sound = 'sound/items/drill_use.ogg'
	tool_speed = 1.0

//? Power (tier 2)

// todo: powertools, including welder

/obj/item/rig_module/item_deploy/simple/toolset/engineering/industrial

//? Hardlight (tier 3)

// todo: hardlight, including welder

/obj/item/rig_module/item_deploy/simple/toolset/engineering/hardlight
