GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/security)
/datum/prototype/robot_module/nanotrasen/security
	id = "nt-security"
	display_name = "NT-Security"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/security
	module_hud_state = "security"
	light_color = "#FF0000"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/baseline_standard/security,
		/datum/prototype/robot_iconset/hover_eyebot/security,
		/datum/prototype/robot_iconset/grounded_landmate/security,
		/datum/prototype/robot_iconset/grounded_landmate/security_tread,
		/datum/prototype/robot_iconset/biped_marina/security,
		/datum/prototype/robot_iconset/biped_tall/tallred,
		/datum/prototype/robot_iconset/baseline_toiletbot/security,
		/datum/prototype/robot_iconset/biped_sleek/security,
		/datum/prototype/robot_iconset/grounded_spider/security,
		/datum/prototype/robot_iconset/biped_heavy/security,
		/datum/prototype/robot_iconset/baseline_old/security,
		/datum/prototype/robot_iconset/baseline_old/security_riot,
		/datum/prototype/robot_iconset/hover_drone/security,
		/datum/prototype/robot_iconset/biped_insekt/security,
		/datum/prototype/robot_iconset/biped_tall/alternative/security,
		/datum/prototype/robot_iconset/biped_miss/security,
		/datum/prototype/robot_iconset/hover_glitterfly/security,
		/datum/prototype/robot_iconset/grounded_mechoid/security,
		/datum/prototype/robot_iconset/hover_handy/security,
		/datum/prototype/robot_iconset/biped_noble/security,
		/datum/prototype/robot_iconset/grounded_zoomba/security,
		/datum/prototype/robot_iconset/grounded_worm/security,
		/datum/prototype/robot_iconset/dog_borgi/security,
		/datum/prototype/robot_iconset/dog_k9/security,
		/datum/prototype/robot_iconset/dog_otie/security,
		/datum/prototype/robot_iconset/dog_pupdozer/security,
		/datum/prototype/robot_iconset/dog_vale/security,
		/datum/prototype/robot_iconset/cat_feli/security,
		/datum/prototype/robot_iconset/drake_mizartz/security,
		/datum/prototype/robot_iconset/dog_k9/red,
		/datum/prototype/robot_iconset/raptor/security,
		/datum/prototype/robot_iconset/hover_coffin/combat,
	)

/datum/prototype/robot_module/nanotrasen/security/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/handcuffs/cyborg,
			/obj/item/melee/baton/robot,
			/obj/item/gun/projectile/energy/taser/mounted/cyborg,
			/obj/item/barrier_tape_roll/police,
			/obj/item/reagent_containers/spray/pepper,
			/obj/item/gripper/security,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/gun/projectile/energy/laser/mounted,
		)

// todo: this is evil
/datum/prototype/robot_module/nanotrasen/security/legacy_custom_regenerate_resources(mob/living/silicon/robot/robot, dt, multiplier)
	..()
	for(var/obj/item/flash/flash in robot.robot_inventory.provided_items)
		// todo: refactor flash
		flash.times_used = 0
		if(flash.broken)
			flash.broken = 0
			flash.icon_state = "flash"

// todo: legacy
/obj/item/robot_module_legacy/robot/security
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)

