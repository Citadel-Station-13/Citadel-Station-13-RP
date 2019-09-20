/obj/structure/simple_door
	name = "door"
	density = 1
	anchored = 1

	icon = 'icons/obj/doors/material_primary_doors.dmi'
	icon_state = "metal"

	material_primary = DEFAULT_WALL_material_primary
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/hardness = 1
	var/oreAmount = 7

/obj/structure/simple_door/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/structure/simple_door/proc/TemperatureAct(temperature)
	hardness -= material_primary.combustion_effect(get_turf(src),temperature, 0.3)
	CheckHardness()

/obj/structure/simple_door/Initialize(mapload, primary_material_primary)
	if(primary_material_primary)
		material_primary = primary_material_primary
	. = ..()

/obj/structure/simple_door/Updatematerial_primarys()
	. = ..()
	hardness = max(1,round(material_primary?.integrity/10))
	icon_state = material_primary?.door_icon_base || initial(icon_state)
	name = "[material_primary?.display_name] door"
	if(material_primary.opacity < 0.5)
		set_opacity(0)
	else
		set_opacity(1)
	if(material_primary.products_need_process())
		processing_objects |= src
	update_nearby_tiles(need_rebuild=1)

/obj/structure/simple_door/Destroy()
	processing_objects -= src
	update_nearby_tiles()
	return ..()

/obj/structure/simple_door/Bumped(atom/user)
	..()
	if(!state)
		return TryToSwitchState(user)
	return

/obj/structure/simple_door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/simple_door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/simple_door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/simple_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(material_primary && !material_primary.can_open_material_primary_door(user))
			return
		if(world.time - user.last_bumped <= 60)
			return
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(istype(user, /obj/mecha))
		SwitchState()

/obj/structure/simple_door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/simple_door/proc/Open()
	isSwitchingStates = 1
	playsound(loc, material_primary?.dooropen_noise, 100, 1)
	flick("[material_primary? material_primary.door_icon_base : initial(icon_state)]opening",src)
	sleep(10)
	density = 0
	set_opacity(0)
	state = 1
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/proc/Close()
	isSwitchingStates = 1
	playsound(loc, material_primary?.dooropen_noise, 100, 1)
	flick("[material_primary? material_primary.door_icon_base : initial(icon_state)]closing",src)
	sleep(10)
	density = 1
	set_opacity(1)
	state = 0
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/update_icon()
	. = ..()
	if(state)
		icon_state = "[material_primary? material_primary.door_icon_base : initial(icon_state)]open"
	else
		icon_state = material_primary?.door_icon_base || initial(icon_state)

/obj/structure/simple_door/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/digTool = W
		user << "You start digging the [name]."
		if(do_after(user,digTool.digspeed*hardness) && src)
			user << "You finished digging."
			Dismantle()
	else if(istype(W,/obj/item/weapon)) //not sure, can't not just weapons get passed to this proc?
		hardness -= W.force/100
		user << "You hit the [name] with your [W.name]!"
		CheckHardness()
	else if(istype(W,/obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(material_primary?.ignition_point && WT.remove_fuel(0, user))
			TemperatureAct(150)
	else
		attack_hand(user)
	return

/obj/structure/simple_door/proc/CheckHardness()
	if(hardness <= 0)
		Dismantle(1)

/obj/structure/simple_door/proc/Dismantle(devastated = 0)
	material_primary?.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/structure/simple_door/ex_act(severity = 1)
	switch(severity)
		if(1)
			Dismantle(1)
		if(2)
			if(prob(20))
				Dismantle(1)
			else
				hardness--
				CheckHardness()
		if(3)
			hardness -= 0.1
			CheckHardness()
	return

/obj/structure/simple_door/process()
	if(!material_primary?.radioactivity)
		return
	radiation_repository.radiate(src, round(material_primary?.radioactivity/3))

/obj/structure/simple_door/iron
	material_primary = MATERIAL_ID_IRON

/obj/structure/simple_door/silver
	material_primary = MATERIAL_ID_SILVER

/obj/structure/simple_door/gold
	material_primary = MATERIAL_ID_GOLD

/obj/structure/simple_door/uranium
	material_primary = MATERIAL_ID_URANIUM

/obj/structure/simple_door/sandstone
	material_primary = MATERIAL_ID_SANDSTONE

/obj/structure/simple_door/phoron
	material_primary = MATERIAL_ID_PHORON

/obj/structure/simple_door/diamond
	material_primary = MATERIAL_ID_DIAMOND

/obj/structure/simple_door/wood
	material_primary = MATERIAL_ID_WOOD

/obj/structure/simple_door/sifwood
	material_primary = MATERIAL_ID_SIFWOOD

/obj/structure/simple_door/resin
	material_primary = MATERIAL_ID_RESIN

/obj/structure/simple_door/cult
	material_primary = MATERIAL_ID_CULT

/obj/structure/simple_door/cult/TryToSwitchState(atom/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!iscultist(L) && !istype(L, /mob/living/simple_animal/construct))
			return
	..()
