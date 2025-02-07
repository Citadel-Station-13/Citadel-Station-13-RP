GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/multirole)
/datum/prototype/robot_module/nanotrasen/multirole
	id = "nt-multirole"
	use_robot_module_path = /obj/item/robot_module/robot/standard
	light_color = "#FFFFFF"
	iconsets = list(
		/datum/prototype/robot_iconset/biped_k4t,
		/datum/prototype/robot_iconset/baseline_old/standard,
		/datum/prototype/robot_iconset/hover_eyebot/standard,
		/datum/prototype/robot_iconset/biped_marina/standard,
		/datum/prototype/robot_iconset/biped_tall/tallflower,
		/datum/prototype/robot_iconset/baseline_toiletbot/standard,
		/datum/prototype/robot_iconset/biped_sleek/standard,
		/datum/prototype/robot_iconset/grounded_spider/standard,
		/datum/prototype/robot_iconset/biped_heavy/standard,
		/datum/prototype/robot_iconset/cat_feli/standard,
		/datum/prototype/robot_iconset/baseline_standard/standard,
		/datum/prototype/robot_iconset/baseline_misc/omoikane,
		/datum/prototype/robot_iconset/hover_drone/standard,
		/datum/prototype/robot_iconset/biped_insekt/standard,
		/datum/prototype/robot_iconset/biped_tall/alternative/standard,
		/datum/prototype/robot_iconset/hover_glitterfly/standard,
		/datum/prototype/robot_iconset/biped_miss/standard,
		/datum/prototype/robot_iconset/hover_x88/standard,
		/datum/prototype/robot_iconset/hover_coffin/standard,
		/datum/prototype/robot_iconset/hover_handy/standard,
		/datum/prototype/robot_iconset/grounded_mechoid/standard,
		/datum/prototype/robot_iconset/biped_noble/standard,
		/datum/prototype/robot_iconset/grounded_zoomba/standard,
		/datum/prototype/robot_iconset/grounded_worm/standard,
		/datum/prototype/robot_iconset/raptor/peacekeeper,
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

// todo: legacy
/obj/item/robot_module/robot/standard
	sprites = list(
		"Android" = "droid",
		"Convict" = "servitor",
	)
