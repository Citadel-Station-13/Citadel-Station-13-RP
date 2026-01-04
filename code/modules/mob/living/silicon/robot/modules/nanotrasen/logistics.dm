GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/logistics)
/datum/prototype/robot_module/nanotrasen/logistics
	id = "nt-logistics"
	display_name = "NT-Logistics"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/logistics
	module_hud_state = "mining"
	light_color = "#FBE281"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/dog_k9/logistics,
		/datum/prototype/robot_iconset/dog_k9/logistics_dark,
		/datum/prototype/robot_iconset/dog_vale/mining,
		/datum/prototype/robot_iconset/drake_mizartz/mining,
		/datum/prototype/robot_iconset/cat_feli/mining,
		/datum/prototype/robot_iconset/hover_eyebot/mining,
		/datum/prototype/robot_iconset/biped_marina/miner,
		/datum/prototype/robot_iconset/biped_heavy/miner,
		/datum/prototype/robot_iconset/grounded_spider/mining,
		/datum/prototype/robot_iconset/baseline_toiletbot/logistics,
		/datum/prototype/robot_iconset/biped_sleek/mining,
		/datum/prototype/robot_iconset/hover_drone/mining,
		/datum/prototype/robot_iconset/hover_glitterfly/mining,
		/datum/prototype/robot_iconset/biped_miss/mining,
		/datum/prototype/robot_iconset/hover_handy/mining,
		/datum/prototype/robot_iconset/grounded_mechoid/miner,
		/datum/prototype/robot_iconset/biped_tall/alternative/miner,
		/datum/prototype/robot_iconset/biped_noble/mining,
		/datum/prototype/robot_iconset/grounded_zoomba/miner,
		/datum/prototype/robot_iconset/grounded_worm/miner,
		/datum/prototype/robot_iconset/raptor/mining,
		/datum/prototype/robot_iconset/baseline_standard/logistics,
		/datum/prototype/robot_iconset/grounded_landmate/mining,
		/datum/prototype/robot_iconset/hover_coffin/mining,
	)

/datum/prototype/robot_module/nanotrasen/logistics/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	if(normal_out)
		normal_out |= list(
			/obj/item/borg/sight/meson,
			/obj/item/switchtool,
			/obj/item/weldingtool/electric/mounted,
			/obj/item/storage/bag/ore,
			/obj/item/pickaxe/borgdrill,
			/obj/item/gun/projectile/energy/kinetic_accelerator/cyborg,
			/obj/item/storage/bag/sheetsnatcher/borg,
			/obj/item/gripper/miner,
			/obj/item/mining_scanner,
			/obj/item/pickaxe/plasmacutter,
		)
	return ..()

// todo: legacy
/obj/item/robot_module_legacy/robot/logistics
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)
