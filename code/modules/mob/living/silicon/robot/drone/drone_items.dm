
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
			item_mount?.material_give_amount(src, null, /datum/prototype/material/wood_plank::id, 2000)
			item_mount?.material_give_amount(src, null, /datum/prototype/material/plastic::id, 2000)
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

			item_mount?.material_give_amount(src, null, /datum/prototype/material/steel::id, 15000)
			item_mount?.material_give_amount(src, null, /datum/prototype/material/glass::id, 15000)
			item_mount?.material_give_amount(src, null, /datum/prototype/material/wood_plank::id, 2000)
			item_mount?.material_give_amount(src, null, /datum/prototype/material/plastic::id, 1000)
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W,/obj/item/cigbutt))
			item_mount?.material_give_amount(src, null, /datum/prototype/material/plastic::id, 500)
		else if(istype(W,/obj/structure/spider/spiderling))
			item_mount?.material_give_amount(src, null, /datum/prototype/material/wood_plank::id, 2000)
			item_mount?.material_give_amount(src, null, /datum/prototype/material/plastic::id, 2000)
		else if(istype(W,/obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				item_mount?.material_give_amount(src, null, /datum/prototype/material/steel::id, 250)
				item_mount?.material_give_amount(src, null, /datum/prototype/material/glass::id, 250)
			else
				continue
		else if(istype(W,/obj/effect/decal/remains/robot))
			item_mount?.material_give_amount(src, null, /datum/prototype/material/steel::id, 2000)
			item_mount?.material_give_amount(src, null, /datum/prototype/material/plastic::id, 2000)
			item_mount?.material_give_amount(src, null, /datum/prototype/material/glass::id, 1000)
		else if(istype(W,/obj/item/trash))
			item_mount?.material_give_amount(src, null, /datum/prototype/material/steel::id, 1000)
			item_mount?.material_give_amount(src, null, /datum/prototype/material/plastic::id, 3000)
		else if(istype(W,/obj/effect/debris/cleanable/blood/gibs/robot))
			item_mount?.material_give_amount(src, null, /datum/prototype/material/steel::id, 2000)
			item_mount?.material_give_amount(src, null, /datum/prototype/material/glass::id, 2000)
		else if(istype(W,/obj/item/ammo_casing))
			item_mount?.material_give_amount(src, null, /datum/prototype/material/steel::id, 1000)
		else if(istype(W,/obj/item/material/shard/shrapnel))
			item_mount?.material_give_amount(src, null, /datum/prototype/material/steel::id, 1000)
		else if(istype(W,/obj/item/material/shard))
			item_mount?.material_give_amount(src, null, /datum/prototype/material/glass::id, 1000)
		else if(istype(W,/obj/item/reagent_containers/food/snacks/grown))
			item_mount?.material_give_amount(src, null, /datum/prototype/material/wood_plank::id, 4000)
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
