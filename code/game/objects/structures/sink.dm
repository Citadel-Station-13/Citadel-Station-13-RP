/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = 1
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/sink/MouseDroppedOnLegacy(var/obj/item/thing, var/mob/user)
	..()
	if(!istype(thing) || !thing.is_open_container())
		return ..()
	if(!usr.Adjacent(src))
		return ..()
	if(!thing.reagents || thing.reagents.total_volume == 0)
		to_chat(usr, "<span class='warning'>\The [thing] is empty.</span>")
		return
	// Clear the vessel.
	visible_message("<span class='notice'>\The [usr] tips the contents of \the [thing] into \the [src].</span>")
	thing.reagents.clear_reagents()
	thing.update_icon()

/obj/structure/sink/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(!user.standard_hand_usability_check(src, e_args.using_hand_index, HAND_MANIPULATION_GENERAL))
		return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	to_chat(usr, "<span class='notice'>You start washing your hands.</span>")

	busy = 1
	sleep(40)
	busy = 0

	if(!Adjacent(user)) return		//Person has moved away from the sink

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	for(var/mob/V in viewers(src, null))
		V.show_message("<span class='notice'>[user] washes their hands using \the [src].</span>")

/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob)
	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	var/obj/item/reagent_containers/RG = O
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] using \the [src].</span>","<span class='notice'>You fill \the [RG] using \the [src].</span>")
		return 1

	else if (istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		if(B.active)
			flick("baton_active", src)
			B.use_charge(B.charge_cost)
			B.powered_melee_impact(user, user)
			var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
			user.visible_message( \
				"<span class='danger'>[user] was stunned by [TU.his] wet [O]!</span>", \
				"<span class='userdanger'>[user] was stunned by [TU.his] wet [O]!</span>")
			return 1
	else if(istype (O, /obj/item/stack/hairlesshide))
		var/obj/item/stack/hairlesshide/HH = O
		usr.visible_message("<span class='notice'>\The [usr] starts soaking \the [HH]</span>", "<span class='notice'>You start soaking \the [HH]</span>", "You hear the sound of something being submerged")
		if(do_after(user,30))
			to_chat(usr, "<span class='notice'>You completely saturate the [HH.singular_name]</span>")
			HH.use(1)
			var/turf/T = get_turf(usr)
			new /obj/item/stack/wetleather(T)
		else
			return 1
	else if(istype(O, /obj/item/mop))
		O.reagents.add_reagent("water", 5)
		to_chat(user, "<span class='notice'>You wet \the [O] in \the [src].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, "<span class='notice'>You start washing \the [I].</span>")

	busy = 1
	sleep(40)
	busy = 0

	if(user.loc != location) return				//User has moved
	if(!I) return 								//Item's been destroyed while washing
	if(user.get_active_held_item() != I) return		//Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message( \
		"<span class='notice'>[user] washes \a [I] using \the [src].</span>", \
		"<span class='notice'>You wash \a [I] using \the [src].</span>")

/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"

/obj/structure/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"
	desc = "A small pool of some liquid, ostensibly water."

/obj/structure/sink/puddle/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/sink/puddle/attackby(obj/item/O as obj, mob/user as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

//***Oil well puddles from Main.
/obj/structure/sink/oil_well	//You're not going to enjoy bathing in this...
	name = "oil well"
	desc = "A bubbling pool of oil.This would probably be valuable, had bluespace technology not destroyed the need for fossil fuels 200 years ago."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "puddle-oil"
	var/dispensedreagent = /datum/reagent/crude_oil

/obj/structure/sink/oil_well/Initialize(mapload)
	.=..()
	create_reagents(20)
	reagents.add_reagent(dispensedreagent, 20)

/* Okay, just straight up, I tried to code this like blood overlays, but I just do NOT understand the system. If someone wants to sort it, enable this too.
/obj/structure/sink/oil_well/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	flick("puddle-oil-splash",src)
	reagents.reaction(M, 20) //Covers target in 20u of oil.
	to_chat(M, "<span class='notice'>You touch the pool of oil, only to get oil all over yourself. It would be wise to wash this off with water.</span>")
*/

/obj/structure/sink/oil_well/attackby(obj/item/O, mob/user, params)
	flick("puddle-oil-splash",src)
	if(O == /obj/item/shovel) //attempt to deconstruct the puddle with a shovel
		to_chat(user, "You fill in the oil well with soil.")
		qdel()
		return 1
	if(istype(O, /obj/item/reagent_containers)) //Refilling bottles with oil
		var/obj/item/reagent_containers/RG = O
		if (istype(RG) && RG.is_open_container())
			RG.reagents.add_reagent("oil", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
			user.visible_message("<span class='notice'>[user] fills \the [RG] using \the [src].</span>","<span class='notice'>You fill \the [RG] using \the [src].</span>")
			return 1
	if(user.a_intent != INTENT_HARM)
		to_chat(user, "<span class='notice'>You won't have any luck getting \the [O] out if you drop it in the oil.</span>")
		return 1
	else
		return ..()
