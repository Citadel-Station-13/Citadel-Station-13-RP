/obj/item/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	icon = 'icons/obj/weapons.dmi'
	slot_flags = SLOT_BELT
	force = 10
	throw_force = 7
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

/obj/item/melee/chainofcommand/suicide_act(mob/user)
	var/datum/gender/T = GLOB.gender_datums[user.get_visible_gender()]
	user.visible_message(SPAN_DANGER("\The [user] [T.is] strangling [T.himself] with \the [src]! It looks like [T.he] [T.is] trying to commit suicide."), SPAN_DANGER("You start to strangle yourself with \the [src]!"), SPAN_DANGER("You hear the sound of someone choking!"))
	return (OXYLOSS)

/obj/item/melee/sabre
	name = "officer's sabre"
	desc = "An elegant weapon, its monomolecular edge is capable of cutting through flesh and bone with ease."
	hitsound = "swing_hit"
	icon_state = "sabre"
	hitsound = 'sound/weapons/rapierhit.ogg'
	force = 35
	throw_force = 15
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/melee/sabre/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	visible_message(SPAN_DANGER("[user] is slitting [TU.his] stomach open with \the [src.name]! It looks like [TU.hes] trying to commit seppuku."), SPAN_DANGER("You slit your stomach open with \the [src.name]!"), SPAN_DANGER("You hear the sound of flesh tearing open.")) // gory, but it gets the point across
	return(BRUTELOSS)

/obj/item/melee/umbrella
	name = "umbrella"
	desc = "To keep the rain off you. Use with caution on windy days."
	icon = 'icons/obj/items.dmi'
	icon_state = "umbrella_closed"
	addblends = "umbrella_closed_a"
	slot_flags = SLOT_BELT
	force = 5
	throw_force = 5
	w_class = ITEMSIZE_NORMAL
	var/open = FALSE

/obj/item/melee/umbrella/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/melee/umbrella/attack_self()
	src.toggle_umbrella()

/obj/item/melee/umbrella/proc/toggle_umbrella()
	open = !open
	icon_state = "umbrella_[open ? "open" : "closed"]"
	addblends = icon_state + "_a"
	item_state = icon_state
	update_icon()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

// Randomizes color
/obj/item/melee/umbrella/random/Initialize(mapload)
	add_atom_colour("#"+get_random_colour(), FIXED_COLOUR_PRIORITY)
	return ..()

/obj/item/melee/cursedblade
	name = "crystal blade"
	desc = "The red crystal blade's polished surface glints in the light, giving off a faint glow."
	icon_state = "soulblade"
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 30
	throw_force = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	can_speak = 1
	var/list/voice_mobs = list() //The curse of the sword is that it has someone trapped inside.


/obj/item/melee/cursedblade/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/melee/cursedblade/proc/ghost_inhabit(var/mob/candidate)
	if(!isobserver(candidate))
		return
	//Handle moving the ghost into the new shell.
	announce_ghost_joinleave(candidate, 0, "They are occupying a cursed sword now.")
	var/mob/living/voice/new_voice = new /mob/living/voice(src) 	//Make the voice mob the ghost is going to be.
	new_voice.transfer_identity(candidate) 	//Now make the voice mob load from the ghost's active character in preferences.
	new_voice.mind = candidate.mind			//Transfer the mind, if any.
	new_voice.ckey = candidate.ckey			//Finally, bring the client over.
	new_voice.name = "cursed sword"			//Cursed swords shouldn't be known characters.
	new_voice.real_name = "cursed sword"
	voice_mobs.Add(new_voice)
	listening_objects |= src

/obj/item/melee/skateboard
	name = "skaetbord"
	desc = "You shouldn't be seeing this. Contact an Admin."
	icon_state = "skateboard"
	icon = 'icons/obj/weapons.dmi'
	w_class = ITEMSIZE_HUGE
	slot_flags = SLOT_BELT
	force = 10
	throw_force = 7
	var/board_item_type = null

/obj/item/melee/skateboard/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	if(!isturf(newLoc))
		return
	new board_item_type(newLoc)
	qdel(src)

/obj/item/melee/skateboard/improv
	name = "improvised skateboard"
	desc = "A skateboard. It can be placed on its wheels and ridden, or used as a radical weapon."
	icon_state = "skateboard"
	icon = 'icons/obj/weapons.dmi'
	slot_flags = SLOT_BELT
	force = 10
	board_item_type = /obj/vehicle_old/skateboard/improv
	throw_force = 7

/obj/item/melee/skateboard/beginner
	name = "skateboard"
	desc = "A XTREME SPORTZ brand skateboard for beginners. Ages 8 and up."
	icon_state = "skateboard"
	board_item_type = /obj/vehicle_old/skateboard/beginner

/obj/item/melee/skateboard/pro
	name = "skateboard"
	desc = "A RaDSTORMz brand professional skateboard. Looks a lot more stable than the average board."
	icon_state = "skateboard2"
	board_item_type = /obj/vehicle_old/skateboard/pro

/obj/item/melee/skateboard/hoverboard
	name = "hoverboard"
	desc = "A blast from the past, so retro!"
	icon_state = "hoverboard_red"
	board_item_type = /obj/vehicle_old/skateboard/hoverboard

/obj/item/melee/skateboard/hoverboard/admin
	name = "Board of Directors"
	desc = "The engineering complexity of a spaceship concentrated inside of a board. Just as expensive, too."
	icon_state = "hoverboard_nt"
	board_item_type = /obj/vehicle_old/skateboard/hoverboard/admin

/obj/item/melee/skateboard/scooter
	name = "scooter"
	desc = "A fun way to get around."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "scooter_frame"
	board_item_type = /obj/vehicle_old/skateboard/scooter

//Clown Halberd
/obj/item/melee/clownstaff
	name = "clown halberd"
	desc = "This deadly halberd is wielded by Columbina's melee specialists. The curved blade at the end has been painted to look like a banana, disguising its deadly edge."
	icon_state = "clownstaff"
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 30
	throw_force = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/items/bikehorn.ogg'

//Clown Dagger
/obj/item/melee/clownop
	name = "clown knife"
	desc = "This curved blade is painted to look like a banana, disguising its deadly edge."
	icon_state = "clownrender"
	item_state = "clown_dagger"

//Lalilulelo?
/obj/item/melee/nanite_knife
	name = "writhing blade"
	desc = "A jagged blade made out of a strangely shimmering metal. Its wicked shape splits and curls in on itself with cold mutability."
	icon_state = "writhing"
	item_state = "knife"
	slot_flags = SLOT_BELT
	force = 30
	throw_force = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	attack_verb = list("grasped", "torn", "cut", "pierced", "lashed")
	hitsound = 'sound/weapons/bladeslice.ogg'
	armor_penetration = 10
	var/poison_chance = 100
	var/poison_amount = 5
	var/poison_type = "shredding_nanites"

/obj/item/melee/nanite_knife/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	. = ..()
	if(isliving(M))
		if(M.reagents)
			target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(M.can_inject(src, null, target_zone))
				inject_poison(M, target_zone)

 // Does actual poison injection, after all checks passed.
/obj/item/melee/nanite_knife/proc/inject_poison(mob/living/M, target_zone)
	if(prob(poison_chance))
		to_chat(M, "<span class='warning'>You feel nanites digging into your skin!</span>")
		M.reagents.add_reagent(poison_type, poison_amount)

/obj/item/melee/nanite_knife/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	user.visible_message(pick("<span class='danger'>\The [user] is shoving \the [src] into [TU.is] chest! It looks like [TU.he] [TU.is] trying to commit suicide.</span>",\
		"<span class='danger'>\The [user] is stabbing themselves with \the [src]! It looks like [TU.he] [TU.is] trying to commit suicide.</span>"))
	var/turf/T = get_turf(src)
	user.gib()
	new /mob/living/simple_mob/mechanical/cyber_horror(T)
	return

//The Tyrmalin equivalent of the plasma cutter. I'm not making it a plasma cutter subtype because it has to be snowflaked. It should match most cutter stats, otherwise.
#define FUEL_BURN_INTERVAL 15
/obj/item/melee/thermalcutter
	name = "thermal cutter"
	desc = "Used by Tyrmalin scrappers to slice trough old space-hulks and robots alike."
	icon_state = "thermalcutter"
	item_state = "thermalcutter"
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 4)
	var/active = 0
	var/max_fuel = 20
	var/flame_intensity = 2
	var/flame_color = "#FF9933"
	var/burned_fuel_for = 0
	var/acti_sound = 'sound/items/welderactivate.ogg'
	var/deac_sound = 'sound/items/welderdeactivate.ogg'
	var/digspeed = 20
	var/excavation_amount = 200
	var/destroy_artefacts = FALSE // some mining tools will destroy artefacts completely while avoiding side-effects.

/obj/item/melee/thermalcutter/Initialize(mapload)
	. = ..()
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	update_icon()

/obj/item/melee/thermalcutter/Destroy()
	if(active)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/melee/thermalcutter/examine(mob/user)
	. = ..()
	if(max_fuel)
		. += "[icon2html(thing = src, target = world)] The [src.name] contains [get_fuel()]/[src.max_fuel] units of fuel!"

/obj/item/melee/thermalcutter/process(delta_time)
	if(active)
		++burned_fuel_for
		if(burned_fuel_for >= FUEL_BURN_INTERVAL)
			remove_fuel(1)
		if(get_fuel() < 1)
			activate(0)
		else			//Only start fires when its on and has enough fuel to actually keep working
			var/turf/location = src.loc
			if(istype(location, /mob/living))
				var/mob/living/M = location
				if(M.is_holding(src))
					location = get_turf(M)
			if (istype(location, /turf))
				location.hotspot_expose(700, 5)

/obj/item/melee/thermalcutter/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		if(!active && max_fuel)
			O.reagents.trans_to_obj(src, max_fuel)
			to_chat(user, "<span class='notice'>You refill [src].</span>")
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return
		else if(!active)
			to_chat(user, "<span class='notice'>[src] doesn't use fuel.</span>")
			return
		else
			message_admins("[key_name_admin(user)] triggered a fueltank explosion with a thermal cutter.")
			log_game("[key_name(user)] triggered a fueltank explosion with a thermal cutter.")
			to_chat(user, "<span class='danger'>You begin slicing into the fueltank and with a moment of lucidity you realize, this might not have been the smartest thing you've ever done.</span>")
			var/obj/structure/reagent_dispensers/fueltank/tank = O
			tank.explode()
			return
	if (src.active)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)

/obj/item/melee/thermalcutter/attack_self(mob/user)
	activate()

//Returns the amount of fuel in the welder
/obj/item/melee/thermalcutter/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/melee/thermalcutter/proc/get_max_fuel()
	return max_fuel

/obj/item/melee/thermalcutter/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!active)
		return 0
	if(amount)
		burned_fuel_for = 0 // Reset the counter since we're removing fuel.
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		update_icon()
		return 1
	else
		if(M)
			to_chat(M, "<span class='notice'>You need more fuel to complete this task.</span>")
		update_icon()
		return 0

/obj/item/melee/thermalcutter/proc/isOn()
	return active

/obj/item/melee/thermalcutter/update_icon()
	..()
	if(active)
		icon_state = "[initial(icon_state)]_1"
		item_state = "[initial(item_state)]_1"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)

	// Lights
	if(active && flame_intensity)
		set_light(flame_intensity, flame_intensity, flame_color)
	else
		set_light(0)

	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/melee/thermalcutter/proc/activate(var/mob/M)
	var/turf/T = get_turf(src)
	if(!active)
		if (get_fuel() > 0)
			if(M)
				to_chat(M, "<span class='notice'>You switch the [src] on.</span>")
			else if(T)
				T.visible_message("<span class='danger'>\The [src] turns on.</span>")
			playsound(loc, acti_sound, 50, 1)
			src.force = 15
			src.damtype = "fire"
			src.w_class = ITEMSIZE_LARGE
			src.hitsound = 'sound/items/welder.ogg'
			src.sharp = 1
			src.edge = 1
			active = 1
			update_icon()
		else
			if(M)
				to_chat(M, "<span class='notice'>You need more fuel to complete this task.</span>")
			return
	//Otherwise
	else if(active)
		if(M)
			to_chat(M, "<span class='notice'>You switch \the [src] off.</span>")
		else if(T)
			T.visible_message("<span class='warning'>\The [src] turns off.</span>")
		playsound(loc, deac_sound, 50, 1)
		src.force = 3
		src.damtype = "brute"
		src.w_class = initial(src.w_class)
		src.active = 0
		src.sharp = 0
		src.edge = 0
		src.hitsound = initial(src.hitsound)
		update_icon()

/obj/item/melee/thermalcutter/is_hot()
	return isOn()

#undef FUEL_BURN_INTERVAL
