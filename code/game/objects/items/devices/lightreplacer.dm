
// Light Replacer (LR)
//
// ABOUT THE DEVICE
//
// This is a device supposedly to be used by Janitors and Janitor Cyborgs which will
// allow them to easily replace lights. This was mostly designed for Janitor Cyborgs since
// they don't have hands or a way to replace lightbulbs.
//
// HOW IT WORKS
//
// You attack a light fixture with it, if the light fixture is broken it will replace the
// light fixture with a working light; the broken light is then placed on the floor for the
// user to then pickup with a trash bag. If it's empty then it will just place a light in the fixture.
//
// HOW TO REFILL THE DEVICE
//
// It can be manually refilled or by clicking on a storage item containing lights.
// If it's part of a robot module, it will charge when the Robot is inside a Recharge Station.
//
// EMAGGED FEATURES
//
// NOTICE: The Cyborg cannot use the emagged Light Replacer and the light's explosion was nerfed. It cannot create holes in the station anymore.
//
// I'm not sure everyone will react the emag's features so please say what your opinions are of it.
//
// When emagged it will rig every light it replaces, which will explode when the light is on.
// This is VERY noticable, even the device's name changes when you emag it so if anyone
// examines you when you're holding it in your hand, you will be discovered.
// It will also be very obvious who is setting all these lights off, since only Janitor Borgs and Janitors have easy
// access to them, and only one of them can emag their device.
//
// The explosion cannot insta-kill anyone with 30% or more health.

#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3


/obj/item/lightreplacer

	name = "light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs, broken lightbulbs, or sheets of glass."
	force = 8
	icon = 'icons/obj/janitor.dmi'
	icon_state = "lightreplacer0"
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 2)

	var/emagged = FALSE //old emagcode
	var/max_uses = 20
	var/uses = 0
	var/failmsg = ""
	// How much to increase per each glass?
	var/increment = 5
	// How much to take from the glass?
	var/decrement = 1
	var/charge = 1

	// Eating used bulbs gives us bulb shards
	var/bulb_shards = 0
	// when we get this many shards, we get a free bulb.
	var/shards_required = 4


/obj/item/lightreplacer/Initialize()
	. = ..()
	failmsg = "The [name]'s refill light blinks red."

/obj/item/lightreplacer/examine(mob/user)
	. = ..()
	. += status_string()

/obj/item/lightreplacer/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/material/glass))
		var/obj/item/stack/material/glass/G = W //no you dumbfuck you can't use metal on this
		if(uses >= max_uses)
			to_chat(user, "<span class='warning'>[src.name] is full.</span>")
			return
		else if(G.use(decrement))
			AddUses(increment)
			to_chat(user, "<span class='notice'>You insert a piece of glass into the [src.name]. You have [uses] light\s remaining.</span>")
			return
		else
			to_chat(user, "<span class='warning'>You need one sheet of glass to replace lights!</span>")

	// if(istype(W, /obj/item/shard))
	// 	if(uses >= max_uses)
	// 		to_chat(user, "<span class='warning'>[src.name] is full.</span>")
	// 		return
	// 	if(!user.temporarilyRemoveItemFromInventory(W))
	// 		return
	// 	AddUses(round(increment*0.75))
	// 	to_chat(user, "<span class='notice'>You insert a shard of glass into the [src.name]. You have [uses] light\s remaining.</span>")
	// 	qdel(W)
	// 	return

	if(istype(W, /obj/item/light))
		var/obj/item/light/L = W
		if(L.status == 0) // LIGHT OKAY
			if(uses < max_uses)
				// if(!user.temporarilyRemoveItemFromInventory(W))
				// 	return
				AddUses(1)
				user.drop_item()
				qdel(L)
		else
			// if(!user.temporarilyRemoveItemFromInventory(W))
			// 	return
			to_chat(user, "<span class='notice'>You insert the [L.name] into the [src.name]</span>")
			AddShards(1, user) //nope, now with this, we accept shit glass too!
			user.drop_item()
			qdel(L)
		return

	if(istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		var/found_lightbulbs = FALSE
		var/replaced_something = TRUE

		for(var/obj/item/I in S.contents)
			if(istype(I, /obj/item/light))
				var/obj/item/light/L = I
				found_lightbulbs = TRUE
				if(src.uses >= max_uses)
					break
				if(L.status == LIGHT_OK)
					replaced_something = TRUE
					AddUses(1)
					qdel(L)

				else if(L.status == LIGHT_BROKEN || L.status == LIGHT_BURNED)
					replaced_something = TRUE
					AddShards(1, user)
					qdel(L)

		if(!found_lightbulbs)
			to_chat(user, "<span class='warning'>\The [S] contains no bulbs.</span>")
			return

		if(!replaced_something && src.uses == max_uses)
			to_chat(user, "<span class='warning'>\The [src] is full!</span>")
			return

		to_chat(user, "<span class='notice'>You fill \the [src] with lights from \the [S]. " + status_string() + "</span>")

/obj/item/lightreplacer/attack_self(mob/user)
	to_chat(user, status_string())

/obj/item/lightreplacer/update_icon()
	icon_state = "lightreplacer[emagged ? 1 : 0]" //emag sanity checks, we don't want nulls

/obj/item/lightreplacer/proc/status_string()
	return "It has [uses] light\s remaining (plus [bulb_shards] fragment\s)."

/obj/item/lightreplacer/proc/Use(mob/user)
	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	AddUses(-1)
	return 1

// Negative numbers will subtract
/obj/item/lightreplacer/proc/AddUses(amount = 1)
	uses = clamp(uses + amount, 0, max_uses)

/obj/item/lightreplacer/proc/AddShards(amount = 1, user)
	bulb_shards += amount
	var/new_bulbs = round(bulb_shards / shards_required)
	if(new_bulbs > 0)
		AddUses(new_bulbs)
	bulb_shards = bulb_shards % shards_required
	if(new_bulbs != 0)
		to_chat(user, "<span class='notice'>\The [src] has fabricated a new bulb from the broken glass it has stored. It now has [uses] uses.</span>")
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	return new_bulbs

/obj/item/lightreplacer/proc/Charge(mob/user)
	charge += 1
	if(charge > 3)
		AddUses(1)
		charge = 1

/obj/item/lightreplacer/proc/ReplaceLight(obj/machinery/light/target, mob/living/U)

	if(target.status != LIGHT_OK)
		if(CanUse(U))
			if(!Use(U))
				return
			to_chat(U, "<span class='notice'>You replace the [target.light_type] with \the [src].</span>")

			if(target.status != LIGHT_EMPTY)
				AddShards(1, U)
				target.status = LIGHT_EMPTY
				target.update()

			var/obj/item/light/L2 = new target.light_type()
	// how it works: Create a dummy light, copypaste values to the target, then delete the dummy
	// so yes, the target bulb is still the same
			target.status = L2.status
			target.switchcount = L2.switchcount
			target.rigged = (emagged ? 1 : 0)
			//target.brightness = L2.brightness
			target.brightness_range = L2.brightness_range
			target.brightness_color = L2.brightness_color
			target.on = target.has_power()
			target.update()
			qdel(L2)

			if(target.on && target.rigged)
				target.explode()
			return

		else
			to_chat(U, failmsg)
			return
	else
		to_chat(U, "<span class='warning'>There is a working [target.light_type] already inserted!</span>")
		return

/obj/item/lightreplacer/emag_act(remaining_charges, mob/user)
	emagged = !emagged
	playsound(src.loc, "sparks", 100, 1)
	if(emagged)
		name = "shortcircuited [initial(name)]"
	else
		name = initial(name)
	update_icon()
	return TRUE

/obj/item/lightreplacer/proc/CanUse(mob/living/user)
	src.add_fingerprint(user)
	if(uses > 0)
		return 1
	else
		return 0

/obj/item/lightreplacer/afterattack(atom/T, mob/U, proximity)
	. = ..()
	if(!proximity)
		return
	if(!isturf(T))
		return

	var/used = FALSE
	for(var/atom/A in T)
		if(!CanUse(U))
			break
		used = TRUE
		if(istype(A, /obj/machinery/light))
			ReplaceLight(A, U)

	if(!used)
		to_chat(U, failmsg)

#undef LIGHT_OK
#undef LIGHT_EMPTY
#undef LIGHT_BROKEN
#undef LIGHT_BURNED
