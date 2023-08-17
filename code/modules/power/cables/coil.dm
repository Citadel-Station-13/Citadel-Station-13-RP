#define MAXCOIL 30

/obj/item/stack/cable_coil
	name = "cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	amount = MAXCOIL
	max_amount = MAXCOIL
	color = COLOR_RED
	desc = "A coil of power cable."
	throw_force = 10
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 5
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20)
	slot_flags = SLOT_BELT
	item_state = "coil"
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")
	stacktype = /obj/item/stack/cable_coil
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/stack/cable_coil/cyborg
	name = "cable coil synthesizer"
	desc = "A device that makes cable."
	gender = NEUTER
	materials = null
	uses_charge = 1
	charge_costs = list(1)

/obj/item/stack/cable_coil/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	if(locate(/obj/item/stool) in user.loc)
		user.visible_message("<span class='suicide'>[user] is making a noose with the [src.name]! It looks like [TU.he] [TU.is] trying to commit suicide.</span>")
	else
		user.visible_message("<span class='suicide'>[user] is strangling [TU.himself] with the [src.name]! It looks like [TU.he] [TU.is] trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/stack/cable_coil/Initialize(mapload, new_amount = MAXCOIL, merge, param_color)
	. = ..()
	if (param_color) // It should be red by default, so only recolor it if parameter was specified.
		add_atom_colour(param_color, FIXED_COLOUR_PRIORITY)
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	update_icon()
	update_wclass()

///////////////////////////////////
// General procedures
///////////////////////////////////

//you can use wires to heal robotics
/obj/item/stack/cable_coil/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(ishuman(target) && user.a_intent == INTENT_HELP)
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/S = H.organs_by_name[user.zone_sel.selecting]

		if(!S || S.robotic < ORGAN_ROBOT || S.open == 3)
			to_chat(user, SPAN_WARNING("That isn't a robotic limb."))
			return

		var/use_amt = min(src.amount, CEILING(S.burn_dam / 20, 1), 5)
		if(can_use(use_amt))
			if(S.robo_repair(5*use_amt, BURN, "some damaged wiring", src, user))
				use(use_amt)
		return
	return ..()

/obj/item/stack/cable_coil/update_icon()
	if (!color)
		color = pick(COLOR_RED, COLOR_BLUE, COLOR_LIME, COLOR_ORANGE, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)
	if(amount == 1)
		icon_state = "coil1"
		name = "cable piece"
	else if(amount == 2)
		icon_state = "coil2"
		name = "cable piece"
	else
		icon_state = "coil"
		name = "cable coil"

/obj/item/stack/cable_coil/proc/set_cable_color(var/selected_color, var/user)
	if(!selected_color)
		return

	var/final_color = GLOB.possible_cable_coil_colours[selected_color]
	if(!final_color)
		final_color = GLOB.possible_cable_coil_colours["Red"]
		selected_color = "red"
	color = final_color
	to_chat(user, "<span class='notice'>You change \the [src]'s color to [lowertext(selected_color)].</span>")

/obj/item/stack/cable_coil/proc/update_wclass()
	if(amount == 1)
		w_class = ITEMSIZE_TINY
	else
		w_class = ITEMSIZE_SMALL

/obj/item/stack/cable_coil/examine(mob/user)
	. = ..()

	if(get_amount() == 1)
		. += "A short piece of power cable."
	else if(get_amount() == 2)
		. += "A piece of power cable."
	else
		. += "A coil of power cable. There are [get_amount()] lengths of cable in the coil."

/obj/item/stack/cable_coil/verb/make_restraint()
	set name = "Make Cable Restraints"
	set category = "Object"
	var/mob/M = usr

	if(CHECK_MOBILITY(M, MOBILITY_CAN_USE))
		if(!istype(usr.loc,/turf)) return
		if(src.amount <= 14)
			to_chat(usr, "<span class='warning'>You need at least 15 lengths to make restraints!</span>")
			return
		var/obj/item/handcuffs/cable/B = new /obj/item/handcuffs/cable(usr.loc)
		B.color = color
		to_chat(usr, "<span class='notice'>You wind some cable together to make some restraints.</span>")
		src.use(15)
	else
		to_chat(usr, "<span class='notice'>You cannot do that.</span>")

/obj/item/stack/cable_coil/cyborg/verb/set_colour()
	set name = "Change Colour"
	set category = "Object"

	var/selected_type = input("Pick new colour.", "Cable Colour", null, null) as null|anything in GLOB.possible_cable_coil_colours
	set_cable_color(selected_type, usr)

// Items usable on a cable coil :
//   - Wirecutters : cut them duh !
//   - Cable coil : merge cables

/obj/item/stack/cable_coil/transfer_to(obj/item/stack/cable_coil/S)
	if(!istype(S))
		return
	..()

/obj/item/stack/cable_coil/use(used)
	. = ..()
	update_appearance()
	return

/obj/item/stack/cable_coil/add()
	. = ..()
	update_appearance()
	return

///////////////////////////////////////////////
// Cable laying procedures
//////////////////////////////////////////////

// called when cable_coil is clicked on a turf/simulated/floor
/obj/item/stack/cable_coil/proc/turf_place(turf/simulated/F, mob/user)
	if(!isturf(user.loc))
		return

	if(get_amount() < 1) // Out of cable
		to_chat(user, "There is no cable left.")
		return

	if(get_dist(F,user) > 1) // Too far
		to_chat(user, "You can't lay cable at a place that far away.")
		return

	if(!F.is_plating())		// Ff floor is intact, complain
		to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
		return

	var/dirn
	if(user.loc == F)
		dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
	else
		dirn = get_dir(F, user)

	var/end_dir = 0
	if(istype(F, /turf/simulated/open))
		if(!can_use(2))
			to_chat(user, "You don't have enough cable to do this!")
			return
		end_dir = DOWN

	for(var/obj/structure/cable/LC in F)
		if((LC.d1 == dirn && LC.d2 == end_dir ) || ( LC.d2 == dirn && LC.d1 == end_dir))
			to_chat(user, "<span class='warning'>There's already a cable at that position.</span>")
			return

	put_cable(F, user, end_dir, dirn)
	if(end_dir == DOWN)
		put_cable(GetBelow(F), user, UP, 0)
		to_chat(user, "You slide some cable downward.")

/obj/item/stack/cable_coil/proc/put_cable(turf/simulated/F, mob/user, d1, d2)
	if(!istype(F))
		return

	var/obj/structure/cable/C = new(F)
	C.cableColor(color)
	C.d1 = d1
	C.d2 = d2
	C.add_fingerprint(user)
	C.update_icon()

	//create a new powernet with the cable, if needed it will be merged later
	var/datum/powernet/PN = new()
	PN.add_cable(C)

	C.mergeConnectedNetworks(C.d1) //merge the powernets...
	C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
	C.mergeConnectedNetworksOnTurf()

	if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
		C.mergeDiagonalsNetworks(C.d1)

	if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
		C.mergeDiagonalsNetworks(C.d2)

	use(1)
	if (C.shock(user, 50))
		if (prob(50)) //fail
			new/obj/item/stack/cable_coil(C.loc, 1, C.color)
			qdel(C)

// called when cable_coil is click on an installed obj/cable
// or click on a turf that already contains a "node" cable
/obj/item/stack/cable_coil/proc/cable_join(obj/structure/cable/C, mob/user)
	var/turf/U = user.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || !T.is_plating())		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, user) > 1)		// make sure it's close enough
		to_chat(user, "You can't lay cable at a place that far away.")
		return

	if(U == T) //if clicked on the turf we're standing on, try to put a cable in the direction we're facing
		turf_place(T,user)
		return

	var/dirn = get_dir(C, user)

	// one end of the clicked cable is pointing towards us
	if(C.d1 == dirn || C.d2 == dirn)
		if(!U.is_plating())						// can't place a cable if the floor is complete
			to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for(var/obj/structure/cable/LC in U)		// check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					to_chat(user, "There's already a cable at that position.")
					return
			put_cable(U,user,0,fdirn)
			return

	// exisiting cable doesn't point at our position, so see if it's a stub
	else if(C.d1 == 0)
							// if so, make it a full cable pointing from it's old direction to our dirn
		var/nd1 = C.d2	// these will be the new directions
		var/nd2 = dirn


		if(nd1 > nd2)		// swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for(var/obj/structure/cable/LC in T)		// check to make sure there's no matching cable
			if(LC == C)			// skip the cable we're interacting with
				continue
			if((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) )	// make sure no cable matches either direction
				to_chat(user, "There's already a cable at that position.")
				return


		C.cableColor(color)

		C.d1 = nd1
		C.d2 = nd2

		C.add_fingerprint()
		C.update_icon()


		C.mergeConnectedNetworks(C.d1) //merge the powernets...
		C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
		C.mergeConnectedNetworksOnTurf()

		if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d1)

		if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d2)

		use(1)

		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/stack/cable_coil(C.loc, 2, C.color)
				qdel(C)
				return

		C.denode()// this call may have disconnected some cables that terminated on the centre of the turf, if so split the powernets.
		return

/obj/structure/cable/yellow
	color = COLOR_YELLOW

/obj/structure/cable/green
	color = COLOR_LIME

/obj/structure/cable/blue
	color = COLOR_BLUE

/obj/structure/cable/pink
	color = COLOR_PINK

/obj/structure/cable/orange
	color = COLOR_ORANGE

/obj/structure/cable/cyan
	color = COLOR_CYAN

/obj/structure/cable/white
	color = COLOR_WHITE

//////////////////////////////
// Misc.
/////////////////////////////

/obj/item/stack/cable_coil/cut
	item_state = "coil2"

/obj/item/stack/cable_coil/cut/Initialize(mapload, new_amount, merge)
	. = ..()
	src.amount = rand(1,2)
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	update_icon()
	update_wclass()

/obj/item/stack/cable_coil/yellow
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_YELLOW

/obj/item/stack/cable_coil/blue
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_BLUE

/obj/item/stack/cable_coil/green
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_LIME

/obj/item/stack/cable_coil/pink
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_PINK

/obj/item/stack/cable_coil/orange
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_ORANGE

/obj/item/stack/cable_coil/cyan
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_CYAN

/obj/item/stack/cable_coil/white
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_WHITE

/obj/item/stack/cable_coil/silver
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_SILVER

/obj/item/stack/cable_coil/gray
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_GRAY

/obj/item/stack/cable_coil/black
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_BLACK

/obj/item/stack/cable_coil/maroon
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_MAROON

/obj/item/stack/cable_coil/olive
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_OLIVE

/obj/item/stack/cable_coil/lime
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_LIME

/obj/item/stack/cable_coil/teal
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_TEAL

/obj/item/stack/cable_coil/navy
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_NAVY

/obj/item/stack/cable_coil/purple
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_PURPLE

/obj/item/stack/cable_coil/beige
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_BEIGE

/obj/item/stack/cable_coil/brown
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_BROWN

/obj/item/stack/cable_coil/random/Initialize(mapload, new_amount, merge)
	. = ..()
	stacktype = /obj/item/stack/cable_coil
	color = pick(COLOR_RED, COLOR_BLUE, COLOR_LIME, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN, COLOR_SILVER, COLOR_GRAY, COLOR_BLACK, COLOR_MAROON, COLOR_OLIVE, COLOR_LIME, COLOR_TEAL, COLOR_NAVY, COLOR_PURPLE, COLOR_BEIGE, COLOR_BROWN)

/obj/item/stack/cable_coil/random_belt/Initialize(mapload, new_amount, merge)
	. = ..()
	stacktype = /obj/item/stack/cable_coil
	color = pick(COLOR_RED, COLOR_YELLOW, COLOR_ORANGE)
	amount = 30

//Endless alien cable coil


/datum/category_item/catalogue/anomalous/precursor_a/alien_wire
	name = "Precursor Alpha Object - Recursive Spool"
	desc = "Upon visual inspection, this merely appears to be a \
	spool for silver-colored cable. If one were to use this for \
	some time, however, it would become apparent that the cables \
	inside the spool appear to coil around the spool endlessly, \
	suggesting an infinite length of wire.\
	<br><br>\
	In reality, an infinite amount of something within a finite space \
	would likely not be able to exist. Instead, the spool likely has \
	some method of creating new wire as it is unspooled. How this is \
	accomplished without an apparent source of material would require \
	further study."
	value = CATALOGUER_REWARD_EASY

/obj/item/stack/cable_coil/alien
	name = "alien spool"
	desc = "A spool of cable. No matter how hard you try, you can never seem to get to the end."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_wire)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "coil"
	amount = MAXCOIL
	max_amount = MAXCOIL
	color = COLOR_SILVER
	throw_force = 10
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 5
	matter = list(MAT_STEEL = 50, MAT_GLASS = 20)
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")
	stacktype = null
	tool_speed = 0.25

/obj/item/stack/cable_coil/alien/Initialize(mapload, new_amount, merge, param_color)
	. = ..()
	if(embed_chance == -1)		//From /obj/item, don't want to do what the normal cable_coil does
		if(sharp)
			embed_chance = damage_force/w_class
		else
			embed_chance = damage_force/(w_class*3)
	update_icon()
	remove_obj_verb(src, /obj/item/stack/cable_coil/verb/make_restraint)

/obj/item/stack/cable_coil/alien/update_icon()
	icon_state = initial(icon_state)

/obj/item/stack/cable_coil/alien/can_use(var/used)
	return 1

/obj/item/stack/cable_coil/alien/use()	//It's endless
	return 1

/obj/item/stack/cable_coil/alien/add()	//Still endless
	return 0

/obj/item/stack/cable_coil/alien/update_wclass()
	return 0

/obj/item/stack/cable_coil/alien/attack_hand(mob/user, list/params)
	if (user.get_inactive_held_item() == src)
		var/N = input("How many units of wire do you want to take from [src]?  You can only take up to [amount] at a time.", "Split stacks", 1) as num|null
		if(N && N <= amount)
			var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
			CC.amount = N
			CC.update_icon()
			to_chat(user,"<font color=#4F49AF>You take [N] units of wire from the [src].</font>")
			if (CC)
				user.put_in_hands(CC)
				src.add_fingerprint(user)
				CC.add_fingerprint(user)
				spawn(0)
					if (src && usr.machine==src)
						src.interact(usr)
		else
			return
	else
		..()
	return
