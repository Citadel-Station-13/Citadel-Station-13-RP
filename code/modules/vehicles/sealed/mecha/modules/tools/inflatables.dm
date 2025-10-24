/obj/item/vehicle_module/lazy/legacy/tool/powertool/inflatables
	name = "inflatable deployment mechanism"
	desc = "An exosuit-mounted inflatable barrier deployer. Useful!"
	icon_state = "mecha_inflatables"
	origin_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3)
	equip_cooldown = 3
	energy_drain = 30
	range = MELEE
	ready_sound = 'sound/effects/spray.ogg'

	tooltype = /obj/item/inflatable_dispenser/robot
	var/obj/item/inflatable_dispenser/my_deployer = null

/obj/item/vehicle_module/lazy/legacy/tool/powertool/inflatables/Initialize(mapload)
	. = ..()
	my_deployer = my_tool

/obj/item/vehicle_module/lazy/legacy/tool/powertool/inflatables/render_ui()
	var/rendered_mode
	if(my_deployer.mode)
		rendered_mode = "Door"
	else
		rendered_mode = "Wall"
	l_ui_button("toggleInflatableMode", "Inflatable Mode", rendered_mode)
	l_ui_html("Doors Left", "[my_deployer.stored_doors]")
	l_ui_html("Walls Left", "[my_deployer.stored_walls]")

/obj/item/vehicle_module/lazy/legacy/tool/powertool/inflatables/on_l_ui_button(key)
	. = ..()
	if(.)
		return
	switch(key)
		if("toggleInflatableMode")
			#warn log
			my_deployer.attack_self()
			return TRUE

/obj/item/vehicle_module/lazy/legacy/tool/powertool/inflatables/action(atom/target, params)
	if(!action_checks(target))
		return

	if(istype(target, /turf))
		my_deployer.try_deploy_inflatable(target, chassis.occupant_legacy)
	if(istype(target, /obj/item/inflatable) || istype(target, /obj/structure/inflatable))
		my_deployer.pick_up(target, chassis.occupant_legacy)

	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
