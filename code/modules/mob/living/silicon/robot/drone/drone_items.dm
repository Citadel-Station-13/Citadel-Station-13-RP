
//TODO: (the) Matter decompiler (is shit)
/obj/item/matter_decompiler
	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon = 'icons/obj/device.dmi'
	icon_state = "decompiler"

/obj/item/matter_decompiler/afterattack(atom/target, mob/user, clickchain_flags, list/params)

	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)) return //Not adjacent.

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M,/mob/living/simple_mob/animal/passive/lizard) || istype(M,/mob/living/simple_mob/animal/passive/mouse))
			src.loc.visible_message("<span class='danger'>[src.loc] sucks [M] into its decompiler. There's a horrible crunching noise.</span>","<span class='danger'>It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises.</span>")
			new/obj/effect/debris/cleanable/blood/splatter(get_turf(src))
			qdel(M)
			item_mount?.push_material(/datum/prototype/material/wood_plank::id, 2000)
			item_mount?.push_material(/datum/prototype/material/plastic::id, 2000)
			return

		else if(istype(M,/mob/living/silicon/robot/drone) && !M.client)

			var/mob/living/silicon/robot/D = src.loc

			if(!istype(D))
				return

			to_chat(D, "<span class='danger'>You begin decompiling [M].</span>")

			if(!do_after(D,50))
				to_chat(D, "<span class='danger'>You need to remain still while decompiling such a large object.</span>")
				return

			if(!M || !D) return

			to_chat(D, "<span class='danger'>You carefully and thoroughly decompile [M], storing as much of its resources as you can within yourself.</span>")
			qdel(M)
			new/obj/effect/debris/cleanable/blood/oil(get_turf(src))

			item_mount?.push_material(/datum/prototype/material/steel::id, 15000)
			item_mount?.push_material(/datum/prototype/material/glass::id, 15000)
			item_mount?.push_material(/datum/prototype/material/wood_plank::id, 2000)
			item_mount?.push_material(/datum/prototype/material/plastic::id, 1000)
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W,/obj/item/cigbutt))
			item_mount?.push_material(/datum/prototype/material/plastic::id, 500)
		else if(istype(W,/obj/effect/spider/spiderling))
			item_mount?.push_material(/datum/prototype/material/wood_plank::id, 2000)
			item_mount?.push_material(/datum/prototype/material/plastic::id, 2000)
		else if(istype(W,/obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				item_mount?.push_material(/datum/prototype/material/steel::id, 250)
				item_mount?.push_material(/datum/prototype/material/glass::id, 250)
			else
				continue
		else if(istype(W,/obj/effect/decal/remains/robot))
			item_mount?.push_material(/datum/prototype/material/steel::id, 2000)
			item_mount?.push_material(/datum/prototype/material/plastic::id, 2000)
			item_mount?.push_material(/datum/prototype/material/glass::id, 1000)
		else if(istype(W,/obj/item/trash))
			item_mount?.push_material(/datum/prototype/material/steel::id, 1000)
			item_mount?.push_material(/datum/prototype/material/plastic::id, 3000)
		else if(istype(W,/obj/effect/debris/cleanable/blood/gibs/robot))
			item_mount?.push_material(/datum/prototype/material/steel::id, 2000)
			item_mount?.push_material(/datum/prototype/material/glass::id, 2000)
		else if(istype(W,/obj/item/ammo_casing))
			item_mount?.push_material(/datum/prototype/material/steel::id, 1000)
		else if(istype(W,/obj/item/material/shard/shrapnel))
			item_mount?.push_material(/datum/prototype/material/steel::id, 1000)
		else if(istype(W,/obj/item/material/shard))
			item_mount?.push_material(/datum/prototype/material/glass::id, 1000)
		else if(istype(W,/obj/item/reagent_containers/food/snacks/grown))
			item_mount?.push_material(/datum/prototype/material/wood_plank::id, 4000)
		else if(istype(W,/obj/item/pipe))
			// This allows drones and engiborgs to clear pipe assemblies from floors.
		else
			continue

		qdel(W)
		grabbed_something = 1

	if(grabbed_something)
		to_chat(user, "<span class='notice'>You deploy your decompiler and clear out the contents of \the [T].</span>")
	else
		to_chat(user, "<span class='danger'>Nothing on \the [T] is useful to you.</span>")
	return

//PRETTIER TOOL LIST.
/mob/living/silicon/robot/drone/installed_modules()

	if(weapon_lock)
		to_chat(src, "<span class='danger'>Weapon lock active, unable to use modules! Count:[weaponlock_time]</span>")
		return

	if(!module)
		module = new /obj/item/robot_module/drone(src)

	var/dat = "<HEAD><TITLE>Drone modules</TITLE></HEAD><BODY>\n"
	dat += {"
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}


	var/tools = "<B>Tools and devices</B><BR>"
	var/resources = "<BR><B>Resources</B><BR>"

	for (var/O in module.modules)

		var/module_string = ""

		if (!O)
			module_string += "<B>Resource depleted</B><BR>"
		else if(activated(O))
			module_string += "[O]: <B>Activated</B><BR>"
		else
			module_string += "[O]: <A HREF=?src=\ref[src];act=\ref[O]>Activate</A><BR>"

		if((istype(O,/obj/item) || istype(O,/obj/item)) && !(istype(O,/obj/item/stack/cable_coil)))
			tools += module_string
		else
			resources += module_string

	dat += tools

	if (emagged)
		if (!module.emag)
			dat += "<B>Resource depleted</B><BR>"
		else if(activated(module.emag))
			dat += "[module.emag]: <B>Activated</B><BR>"
		else
			dat += "[module.emag]: <A HREF=?src=\ref[src];act=\ref[module.emag]>Activate</A><BR>"

	dat += resources

	src << browse(dat, "window=robotmod")
