/obj/structure/simple_door
	name = "door"
	density = 1
	anchored = 1
	CanAtmosPass = ATMOS_PASS_DENSITY

	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	material_parts = MATERIAL_DEFAULT_NONE
	material_primary = MATERIAL_PART_DEFAULT
	material_costs = SHEET_MATERIAL_AMOUNT * 10

	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/oreAmount = 7

/obj/structure/simple_door/Initialize(mapload, datum/prototype/material/material_like)
	if(!isnull(material_like))
		var/resolved_material = RSmaterials.fetch_or_defer(material_like)
		switch(resolved_material)
			if(REPOSITORY_FETCH_DEFER)
				// todo: handle
			else
				set_primary_material(resolved_material)
	return ..()

/obj/structure/simple_door/update_material_single(datum/prototype/material/material)
	. = ..()
	if(isnull(material))
		name = initial(name)
		set_multiplied_integrity(1)
		set_armor(/datum/armor/none)
		color = null
		set_opacity(FALSE)
	else
		name = "[material.display_name] [initial(name)]"
		set_multiplied_integrity(material.relative_integrity)
		set_armor(material.create_armor(MATERIAL_SIGNIFICANCE_DOOR))
		color = material.icon_colour
		set_opacity(material.opacity > MATERIAL_OPACITY_THRESHOLD)
	update_icon()

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

/obj/structure/simple_door/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.a_intent == INTENT_HARM)
		return ..()
	return TryToSwitchState(user)

/obj/structure/simple_door/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/simple_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates)
		return
	var/datum/prototype/material/material = get_primary_material()
	if(ismob(user))
		var/mob/M = user
		if(!material.can_open_material_door(user))
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
	else if(istype(user, /obj/vehicle/sealed/mecha))
		SwitchState()

/obj/structure/simple_door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/simple_door/proc/Open()
	isSwitchingStates = 1
	var/datum/prototype/material/material = get_primary_material()
	playsound(loc, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]opening",src)
	sleep(10)
	density = 0
	set_opacity(0)
	state = 1
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/proc/Close()
	isSwitchingStates = 1
	var/datum/prototype/material/material = get_primary_material()
	playsound(loc, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]closing",src)
	sleep(10)
	density = 1
	set_opacity(1)
	state = 0
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/update_icon_state()
	var/datum/prototype/material/material = get_primary_material()
	if(isnull(material))
		icon_state = state? "open" : "closed"
		return
	if(state)
		icon_state = "[material.door_icon_base]open"
	else
		icon_state = material.door_icon_base
	return ..()

/obj/structure/simple_door/attackby(obj/item/W as obj, mob/user as mob)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(istype(W,/obj/item/pickaxe))
		user.setClickCooldownLegacy(DEFAULT_ATTACK_COOLDOWN)
		var/datum/prototype/material/material = get_primary_material()
		var/obj/item/pickaxe/digTool = W
		visible_message("<span class='danger'>[user] starts digging [src]!</span>")
		if(do_after(user, digTool.digspeed * material.relative_integrity, src))
			visible_message("<span class='danger'>[user] finished digging [src]!</span>")
			deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)

/obj/structure/simple_door/drop_products(method, atom/where)
	. = ..()
	var/datum/prototype/material/material = get_primary_material()
	material?.place_dismantled_product(where, method == ATOM_DECONSTRUCT_DISASSEMBLED? 10 : 6)

/obj/structure/simple_door/iron
	material_parts = /datum/prototype/material/iron

/obj/structure/simple_door/silver
	material_parts = /datum/prototype/material/silver

/obj/structure/simple_door/gold
	material_parts = /datum/prototype/material/gold

/obj/structure/simple_door/uranium
	material_parts = /datum/prototype/material/uranium

/obj/structure/simple_door/sandstone
	material_parts = /datum/prototype/material/sandstone

/obj/structure/simple_door/phoron
	material_parts = /datum/prototype/material/phoron

/obj/structure/simple_door/diamond
	material_parts = /datum/prototype/material/diamond

/obj/structure/simple_door/wood
	material_parts = /datum/prototype/material/wood_plank

/obj/structure/simple_door/sifwood
	material_parts = /datum/prototype/material/wood_plank/sif

/obj/structure/simple_door/hardwood
	material_parts = /datum/prototype/material/wood_plank/hardwood

/obj/structure/simple_door/resin
	material_parts = /datum/prototype/material/resin

/obj/structure/simple_door/cult
	material_parts = /datum/prototype/material/cult

/obj/structure/simple_door/cult/TryToSwitchState(atom/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!iscultist(L) && !istype(L, /mob/living/simple_mob/construct))
			return
	..()
