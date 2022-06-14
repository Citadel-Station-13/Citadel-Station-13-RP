//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos
/obj/structure/hygiene
	var/next_gurgle = 0
	var/clogged // -1 = never clog

/obj/structure/hygiene/Initialize(mapload)
	. = ..()
	SSfluids.hygiene_props[src] = TRUE

/obj/structure/hygiene/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	SSfluids.hygiene_props -= src
	. = ..()

/obj/structure/hygiene/proc/clog(severity)
	if(!isnull(clogged))
		return FALSE
	clogged = severity
	START_PROCESSING(SSprocessing, src)
	return TRUE

/obj/structure/hygiene/proc/unclog()
	clogged = null
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/hygiene/attackby(obj/item/thing, mob/user)
	if(!isnull(clogged) && clogged > 0 && istype(thing, /obj/item/clothing/mask/plunger))
		user.visible_message(SPAN_NOTICE("\The [user] strives valiantly to unclog \the [src] with \the [thing]!"))
		spawn
			playsound(loc, 'sound/effects/plunger.ogg', 75, TRUE)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, TRUE)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, TRUE)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, TRUE)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, TRUE)
		if(do_after(user, 45, src) && clogged)
			visible_message(SPAN_NOTICE("With a loud gurgle, \the [src] begins flowing more freely."))
			playsound(loc, pick(SSfluids.gurgles), 100, 1)
			clogged--
			if(clogged <= 0)
				unclog()
		return
	. = ..()

/obj/structure/hygiene/examine()
	. = ..()
	if(clogged)
		to_chat(usr, SPAN_WARNING("It seems to be badly clogged!"))

/obj/structure/hygiene/process(delta_time)
	if(isnull(clogged))
		return
	var/flood_amt
	switch(clogged)
		if(1)
			flood_amt = FLUID_SHALLOW
		if(2)
			flood_amt = FLUID_OVER_MOB_HEAD
		if(3)
			flood_amt = FLUID_DEEP
	if(flood_amt)
		var/turf/T = loc
		if(istype(T))
			var/obj/effect/fluid/F = locate() in T
			if(!F) F = new(loc)
			T.show_bubbles()
			if(world.time > next_gurgle)
				visible_message("\The [src] gurgles and overflows!")
				next_gurgle = world.time + 80
				playsound(T, pick(SSfluids.gurgles), 50, 1)
			SET_FLUID_DEPTH(F, min(F.fluid_amount + (rand(30,50)*clogged), flood_amt))

/obj/structure/hygiene/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	/// If the lid is up.
	var/open = FALSE
	/// If the cistern bit is open.
	var/cistern = FALSE
	/// The combined w_class of all the items in the cistern.
	var/w_items = NONE
	/// The mob being given a swirlie.
	var/mob/living/swirlie = null

/obj/structure/hygiene/toilet/Initialize(mapload)
	. = ..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/hygiene/toilet/attack_hand(mob/living/user)
	if(swirlie)
		usr.setClickCooldown(user.get_attack_speed())
		usr.visible_message(
			SPAN_DANGER("[user] slams the toilet seat onto [swirlie.name]'s head!"), \
			SPAN_NOTICE("You slam the toilet seat onto [swirlie.name]'s head!"), \
			SPAN_HEAR("You hear reverberating porcelain."))
		swirlie.adjustBruteLoss(5)
		return

	if(cistern && !open)
		if(!contents.len)
			to_chat(user, SPAN_NOTICE("The cistern is empty."))
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.loc = get_turf(src)
			to_chat(user, SPAN_NOTICE("You find \an [I] in the cistern."))
			w_items -= I.w_class
			return

	open = !open
	update_icon()

/obj/structure/hygiene/toilet/update_icon()
	icon_state = "toilet[open][cistern]"

/obj/structure/hygiene/toilet/attackby(obj/item/I, mob/living/user)
	if(I.is_crowbar())
		to_chat(user, SPAN_NOTICE("You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]."))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(do_after(user, 30))
			user.visible_message(
				SPAN_NOTICE("[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!"), \
				SPAN_NOTICE("You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!"), \
				SPAN_HEAR("You hear grinding porcelain."))
			cistern = !cistern
			update_icon()
			return

	if(istype(I, /obj/item/grab))
		user.setClickCooldown(user.get_attack_speed(I))
		var/obj/item/grab/G = I

		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting

			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, SPAN_NOTICE("[GM.name] needs to be on the toilet."))
					return
				if(open && !swirlie)
					user.visible_message(
						SPAN_WARNING("[user] starts to give [GM.name] a swirlie!"), \
						SPAN_NOTICE("You start to give [GM.name] a swirlie!"))
					swirlie = GM
					if(do_after(user, 30, GM))
						user.visible_message(
							SPAN_DANGER("[user] gives [GM.name] a swirlie!"), \
							SPAN_NOTICE("You give [GM.name] a swirlie!"), \
							SPAN_HEAR("You hear a toilet flushing."))
						if(!GM.internal)
							GM.adjustOxyLoss(5)
					swirlie = null
				else
					user.visible_message(
						SPAN_DANGER("[user] slams [GM.name] into the [src]!"), \
						SPAN_NOTICE("You slam [GM.name] into the [src]!"))
					GM.adjustBruteLoss(5)
			else
				to_chat(user, SPAN_NOTICE("You need a tighter grip."))

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(I.w_class > 3)
			to_chat(user, SPAN_WARNING("\The [I] does not fit."))
			return
		if(w_items + I.w_class > 5)
			to_chat(user, SPAN_WARNING("The cistern is full."))
			return
		user.drop_item()
		I.loc = src
		w_items += I.w_class
		to_chat(user, SPAN_NOTICE("You carefully place \the [I] into the cistern."))
		return

	. = ..()

/obj/structure/hygiene/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE

/obj/structure/hygiene/urinal/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting
			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, SPAN_NOTICE("[GM.name] needs to be on the urinal."))
					return
				user.visible_message(
					SPAN_DANGER("[user] slams [GM.name] into the [src]!"),
					SPAN_NOTICE("You slam [GM.name] into the [src]!"))
				GM.adjustBruteLoss(8)
			else
				to_chat(user, SPAN_NOTICE("You need a tighter grip."))
	. = ..()



/obj/structure/hygiene/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2550s by the Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	anchored = TRUE
	clogged = -1

	var/on = FALSE
	var/obj/effect/mist/mymist = null
	var/ismist = FALSE			//needs a var so we can make it linger~
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/is_washing = FALSE
	var/list/temperature_settings = list("normal" = 310, "boiling" = T0C+100, "freezing" = T0C)
	var/datum/looping_sound/showering/soundloop

/obj/structure/hygiene/shower/Initialize(mapload)
	. = ..()
	create_reagents(50)
	START_PROCESSING(SSprocessing, src)
	soundloop = new(list(src), FALSE)

/obj/structure/hygiene/shower/Destroy()
	QDEL_NULL(soundloop)
	return ..()

//add heat controls? when emagged, you can freeze to death in it?

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = MOB_LAYER + 1
	anchored = TRUE
	mouse_opacity = FALSE

/obj/structure/hygiene/shower/attack_hand(mob/M as mob)
	on = !on
	update_icon()
	if(on)
		soundloop.start()
		if (M.loc == loc)
			wash(M)
			process_heat(M)
		for (var/atom/movable/G in src.loc)
			G.clean_blood()
	else
		soundloop.stop()

/obj/structure/hygiene/shower/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/analyzer))
		to_chat(user, "<span class='notice'>The water temperature seems to be [watertemp].</span>")
		return

	if(I.is_wrench())
		var/newtemp = input(user, "What setting would you like to set the temperature valve to?", "Water Temperature Valve") in temperature_settings
		to_chat(user, "<span class='notice'>You begin to adjust the temperature valve with \the [I].</span>")
		playsound(src.loc, I.usesound, 50, 1)
		if(do_after(user, 50 * I.toolspeed))
			watertemp = newtemp
			user.visible_message("<span class='notice'>[user] adjusts the shower with \the [I].</span>", "<span class='notice'>You adjust the shower with \the [I].</span>")
			add_fingerprint(user)
			return
	. = ..()

/obj/structure/hygiene/shower/update_icon()	//this is terribly unreadable, but basically it makes the shower mist up
	overlays.Cut()					//once it's been on for a while, in addition to handling the water overlay.
	if(mymist)
		qdel(mymist)
		mymist = null

	if(on)
		overlays += image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir)
		if(temperature_settings[watertemp] < T20C)
			return //no mist for cold water
		if(!ismist)
			spawn(50)
				if(src && on)
					ismist = 1
					mymist = new /obj/effect/mist(loc)
		else
			ismist = 1
			mymist = new /obj/effect/mist(loc)
	else if(ismist)
		ismist = 1
		mymist = new /obj/effect/mist(loc)
		spawn(250)
			if(src && !on)
				qdel(mymist)
				mymist = null
				ismist = 0

//Yes, showers are super powerful as far as washing goes.
/obj/structure/hygiene/shower/proc/wash(var/atom/movable/washing)
	if(on)
		wash_mob(washing)
		if(isturf(loc))
			var/turf/tile = loc
			for(var/obj/effect/E in tile)
				if(istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
					qdel(E)
		reagents.splash(washing, 10)

/obj/structure/hygiene/shower/process(delta_time)
	if(!on) return
	for(var/thing in loc)
		var/atom/movable/AM = thing
		var/mob/living/L = thing
		if(istype(AM) && AM.simulated)
			wash(AM)
			if(istype(L))
				process_heat(L)
	wash_floor()
	reagents.add_reagent("water", reagents.get_free_space())

/obj/structure/hygiene/shower/proc/wash_floor()
	if(!ismist && is_washing)
		return
	is_washing = 1
	var/turf/T = get_turf(src)
	reagents.splash(T, reagents.total_volume)
	T.clean(src)
	spawn(100)
		is_washing = 0

/obj/structure/hygiene/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M)) return

	var/temperature = temperature_settings[watertemp]
	var/temp_adj = between(BODYTEMP_COOLING_MAX, temperature - M.bodytemperature, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(temperature >= H.species.heat_level_1)
			to_chat(H, "<span class='danger'>The water is searing hot!</span>")
		else if(temperature <= H.species.cold_level_1)
			to_chat(H, "<span class='warning'>The water is freezing cold!</span>")

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"

/obj/structure/hygiene/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	var/busy = FALSE // Something's being washed at the moment

/obj/structure/hygiene/sink/MouseDrop_T(obj/item/thing, mob/user)
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

/obj/structure/hygiene/sink/attack_hand(mob/user)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
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

/obj/structure/hygiene/sink/attackby(obj/item/O, mob/living/user)

	if(istype(O, /obj/item/clothing/mask/plunger) && !isnull(clogged))
		return ..()


	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	var/obj/item/reagent_containers/RG = O
	if (istype(RG) && RG.is_open_container() && RG.reagents)
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] using \the [src].</span>","<span class='notice'>You fill \the [RG] using \the [src].</span>")
		return TRUE

	else if (istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == TRUE)
				flick("baton_active", src)
				user.Stun(10)
				user.stuttering = 10
				user.Weaken(10)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				var/datum/gender/TU = gender_datums[user.get_visible_gender()]
				user.visible_message( \
					"<span class='danger'>[user] was stunned by [TU.his] wet [O]!</span>", \
					"<span class='userdanger'>[user] was stunned by [TU.his] wet [O]!</span>")
				return TRUE
	else if(istype (O, /obj/item/stack/hairlesshide))
		var/obj/item/stack/hairlesshide/HH = O
		usr.visible_message("<span class='notice'>\The [usr] starts soaking \the [HH]</span>", "<span class='notice'>You start soaking \the [HH]</span>", "You hear the sound of something being submerged")
		if(do_after(user,30))
			to_chat(usr, "<span class='notice'>You completely saturate the [HH.singular_name]</span>")
			HH.use(1)
			var/turf/T = get_turf(usr)
			new /obj/item/stack/wetleather(T)
		else
			return TRUE
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

	busy = TRUE
	sleep(40)
	busy = FALSE

	if(user.loc != location) return				//User has moved
	if(!I) return 								//Item's been destroyed while washing
	if(user.get_active_hand() != I) return		//Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message( \
		"<span class='notice'>[user] washes \a [I] using \the [src].</span>", \
		"<span class='notice'>You wash \a [I] using \the [src].</span>")

/obj/structure/hygiene/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"

/obj/structure/hygiene/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"
	clogged = -1 // how do you clog a puddle

/obj/structure/hygiene/sink/puddle/attack_hand(var/mob/M)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/hygiene/sink/puddle/attackby(obj/item/O as obj, var/mob/user)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

//***Oil well puddles from Main.
/obj/structure/hygiene/sink/oil_well	//You're not going to enjoy bathing in this...
	name = "oil well"
	desc = "A bubbling pool of oil.This would probably be valuable, had bluespace technology not destroyed the need for fossil fuels 200 years ago."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "puddle-oil"
	clogged = -1 // how do you clog a pool of oil
	var/dispensedreagent = /datum/reagent/oil

/obj/structure/hygiene/sink/oil_well/Initialize(mapload)
	. = ..()
	create_reagents(20)
	reagents.add_reagent(dispensedreagent, 20)

/* Okay, just straight up, I tried to code this like blood overlays, but I just do NOT understand the system. If someone wants to sort it, enable this too.
/obj/structure/hygiene/sink/oil_well/attack_hand(mob/M)
	flick("puddle-oil-splash",src)
	reagents.reaction(M, 20) //Covers target in 20u of oil.
	to_chat(M, "<span class='notice'>You touch the pool of oil, only to get oil all over yourself. It would be wise to wash this off with water.</span>")
*/

/obj/structure/hygiene/sink/oil_well/attackby(obj/item/O, mob/user, params)
	flick("puddle-oil-splash",src)
	if(O == /obj/item/shovel) //attempt to deconstruct the puddle with a shovel
		to_chat(user, "You fill in the oil well with soil.")
		qdel()
		return TRUE
	if(istype(O, /obj/item/reagent_containers)) //Refilling bottles with oil
		var/obj/item/reagent_containers/RG = O
		if (istype(RG) && RG.is_open_container())
			RG.reagents.add_reagent("oil", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
			user.visible_message("<span class='notice'>[user] fills \the [RG] using \the [src].</span>","<span class='notice'>You fill \the [RG] using \the [src].</span>")
			return TRUE
	if(user.a_intent != INTENT_HARM)
		to_chat(user, "<span class='notice'>You won't have any luck getting \the [O] out if you drop it in the oil.</span>")
		return TRUE
	else
		return ..()

/obj/item/plunger
	name = "plunger"
	desc = "It's a plunger, for plunging."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "plunger"
	slot_flags = SLOT_MASK
	var/plunge_mod = 1 //time*plunge_mod = total time we take to plunge an object
	var/reinforced = FALSE //whether we do heavy duty stuff like geysers

/obj/item/plunger/attack(obj/O, mob/living/user)
	if(!O.plunger_act(src, user, reinforced))
		return ..()

/obj/item/plunger/throw_impact(atom/hit_atom, mob/living/carbon/human/target, target_zone)
	. = ..()
	if(target_zone != BP_HEAD)
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/H = hit_atom
		if(!H.wear_mask)
			H.equip_to_slot_if_possible(src, SLOT_MASK)
			H.visible_message("<span class='warning'>The plunger slams into [H]'s face!</span>", "<span class='warning'>The plunger suctions to your face!</span>")

/obj/item/plunger/reinforced
	name = "reinforced plunger"
	desc = "It's an Mk7 Reinforced Plunger, for heavy duty plunging."
	icon_state = "reinforced_plunger"

	reinforced = TRUE
	plunge_mod = 0.8

/* Nooooope, not yet.
/obj/structure/geyser
	name = "geyser"
	icon = 'icons/obj/lavaland/terrain.dmi'
	icon_state = "geyser"
	anchored = TRUE

	var/erupting_state = null //set to null to get it greyscaled from "[icon_state]_soup". Not very usable with the whole random thing, but more types can be added if you change the spawn prob
	var/activated = FALSE //whether we are active and generating chems
	var/reagent_id = /datum/reagent/oil
	var/potency = 2 //how much reagents we add every process (2 seconds)
	var/max_volume = 500
	var/start_volume = 50

/obj/structure/geyser/proc/start_chemming()
	activated = TRUE
	create_reagents(max_volume, DRAINABLE)
	reagents.add_reagent(reagent_id, start_volume)
	START_PROCESSING(SSfluids, src) //It's main function is to be plumbed, so use SSfluids
	if(erupting_state)
		icon_state = erupting_state
	else
		var/mutable_appearance/I = mutable_appearance('icons/obj/lavaland/terrain.dmi', "[icon_state]_soup")
		I.color = reagents.get_color()
		add_overlay(I)

/obj/structure/geyser/process()
	if(activated && reagents.total_volume <= reagents.maximum_volume) //this is also evaluated in add_reagent, but from my understanding proc calls are expensive
		reagents.add_reagent(reagent_id, potency)

/obj/structure/geyser/plunger_act(obj/item/plunger/P, mob/living/user, _reinforced)
	if(!_reinforced)
		to_chat(user, "<span class='warning'>The [P.name] isn't strong enough!</span>")
		return
	if(activated)
		to_chat(user, "<span class'warning'>The [name] is already active!</span>")
		return

	to_chat(user, "<span class='notice'>You start vigorously plunging [src]!</span>")
	if(do_after(user, 50 * P.plunge_mod, target = src) && !activated)
		start_chemming()

/obj/structure/geyser/random
	erupting_state = null
	var/list/options = list(/datum/reagent/clf3 = 10, /datum/reagent/water/hollowwater = 10, /datum/reagent/medicine/omnizine/protozine = 6, /datum/reagent/wittel = 1)

/obj/structure/geyser/random/Initialize()
	. = ..()
	reagent_id = pickweight(options)
*/
