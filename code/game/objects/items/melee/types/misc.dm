/obj/item/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	icon = 'icons/obj/weapons.dmi'
	slot_flags = SLOT_BELT
	damage_force = 10
	throw_force = 7
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

/obj/item/melee/umbrella
	name = "umbrella"
	desc = "To keep the rain off you. Use with caution on windy days."
	icon = 'icons/obj/items.dmi'
	icon_state = "umbrella_closed"
	addblends = "umbrella_closed_a"
	slot_flags = SLOT_BELT
	damage_force = 5
	throw_force = 5
	w_class = WEIGHT_CLASS_NORMAL
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR
	var/open = FALSE

/obj/item/melee/umbrella/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/melee/umbrella/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	src.toggle_umbrella()

/obj/item/melee/umbrella/proc/toggle_umbrella()
	open = !open
	icon_state = "umbrella_[open ? "open" : "closed"]"
	addblends = icon_state + "_a"
	item_state = icon_state
	update_icon()
	update_worn_icon()

// Randomizes color
/obj/item/melee/umbrella/random/Initialize(mapload)
	add_atom_color("#"+get_random_colour())
	return ..()

/obj/item/melee/cursedblade
	name = "crystal blade"
	desc = "The red crystal blade's polished surface glints in the light, giving off a faint glow."
	icon_state = "soulblade"
	slot_flags = SLOT_BELT | SLOT_BACK
	damage_force = 30
	throw_force = 10
	w_class = WEIGHT_CLASS_NORMAL
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	can_speak = 1
	var/list/voice_mobs = list() //The curse of the sword is that it has someone trapped inside.

	passive_parry = /datum/passive_parry/melee{
		parry_chance_projectile = 15;
		parry_chance_default = 50;
	}

/obj/item/melee/cursedblade/proc/ghost_inhabit(var/mob/candidate)
	if(!isobserver(candidate))
		return
	//Handle moving the ghost into the new shell.
	announce_ghost_joinleave(candidate, 0, "They are occupying a cursed sword now.")
	var/mob/living/voice/new_voice = new /mob/living/voice(src) 	//Make the voice mob the ghost is going to be.
	new_voice.transfer_identity(candidate) 	//Now make the voice mob load from the ghost's active character in preferences.
	new_voice.mind = candidate.mind			//Transfer the mind, if any.
	candidate.transfer_client_to(new_voice)
	new_voice.name = "cursed sword"			//Cursed swords shouldn't be known characters.
	new_voice.real_name = "cursed sword"
	voice_mobs.Add(new_voice)
	listening_objects |= src

/obj/item/melee/skateboard
	name = "skaetbord"
	desc = "You shouldn't be seeing this. Contact an Admin."
	icon_state = "skateboard"
	icon = 'icons/obj/weapons.dmi'
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = SLOT_BELT
	damage_force = 10
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
	damage_force = 10
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
	damage_force = 30
	throw_force = 10
	w_class = WEIGHT_CLASS_NORMAL
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	reach = 2
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_sound = 'sound/items/bikehorn.ogg'

/obj/item/melee/clownstaff/Initialize(mapload, material_key)
	. = ..()
	AddComponent(/datum/component/jousting)

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
	damage_force = 30
	damage_tier = 4
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	throw_force = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("grasped", "torn", "cut", "pierced", "lashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	var/poison_chance = 100
	var/poison_amount = 5
	var/poison_type = "shredding_nanites"

/obj/item/melee/nanite_knife/melee_finalize(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	. = ..()
	if(. & (CLICKCHAIN_ATTACK_MISSED | CLICKCHAIN_FLAGS_UNCONDITIONAL_ABORT))
		return
	if(clickchain.attack_contact_multiplier <= 0)
		return
	var/mob/living/L = clickchain.performer
	if(!istype(L))
		return
	if(!L.reagents)
		return
	if(L.can_inject(src, null, clickchain.target_zone))
		inject_poison(L, clickchain.target_zone)

 // Does actual poison injection, after all checks passed.
/obj/item/melee/nanite_knife/proc/inject_poison(mob/living/M, target_zone)
	if(prob(poison_chance))
		to_chat(M, "<span class='warning'>You feel nanites digging into your skin!</span>")
		M.reagents.add_reagent(poison_type, poison_amount)

//Interestingly, a magic flame sword has a lot in common with the thermal cutter Tech and I made for Goblins. So I decided it should share some of that code.
/obj/item/melee/ashlander
	name = "bone sword"
	desc = "A sharp sword crafted from knapped bone. In spite of its primitive appearance, it is still incredibly deadly."
	icon_state = "bonesword"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	damage_force = 20
	throw_force = 10
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut", "chopped")
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE

/obj/item/melee/ashlander/elder
	name = "elder bone sword"
	desc = "These swords are crafted from one solid piece of a gigantic bone. Carried by the Ashlander priesthood, these weapons are considered holy relics and are often preserved over the lives of their wielders."
	icon_state = "elderbonesword"
	var/active = 0
	var/flame_intensity = 2
	var/flame_color = "#FF9933"
	var/SA_bonus_damage = 25 // 50 total against demons and aberrations.
	var/SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION

/obj/item/melee/ashlander/elder/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, null, null, FALSE)

/obj/item/melee/ashlander/elder/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(isliving(target))
		var/mob/living/tm = target // targeted mob
		if(SA_vulnerability & tm.mob_class)
			tm.apply_damage(SA_bonus_damage) // fuck em

/obj/item/melee/ashlander/elder/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(!active)
		activate()
	else if(active)
		deactivate()

/obj/item/melee/ashlander/elder/update_icon()
	..()
	if(active)
		icon_state = "[initial(icon_state)]_1"
	else
		icon_state = initial(icon_state)

	// Lights
	if(active && flame_intensity)
		set_light(flame_intensity, flame_intensity, flame_color)
	else
		set_light(0)

	update_worn_icon()

/obj/item/melee/ashlander/elder/proc/activate(mob/living/user)
	to_chat(user, "<span class='notice'>You ignite the [src]'s sacred flame.</span>")
	playsound(loc, 'sound/weapons/gun_flamethrower3.ogg', 50, 1)
	src.damage_force = 20
	src.damage_type = DAMAGE_TYPE_BURN
	src.set_weight_class(WEIGHT_CLASS_BULKY)
	src.attack_sound = 'sound/weapons/gun_flamethrower2.ogg'
	active = 1
	update_icon()

/obj/item/melee/ashlander/elder/proc/deactivate(mob/living/user)
	to_chat(user, "<span class='notice'>You douse \the [src]'s sacred flame.</span>")
	playsound(loc, 'sound/weapons/gun_flamethrower1.ogg', 50, 1)
	src.damage_force = 20
	src.damage_type = DAMAGE_TYPE_BRUTE
	src.set_weight_class(initial(src.w_class))
	src.attack_sound = initial(src.attack_sound)
	src.active = 0
	update_icon()

/obj/item/melee/ashlander/elder/proc/isOn()
	return active

/obj/item/melee/ashlander/elder/is_hot()
	return isOn()

/obj/item/melee/shiv
	name = "shiv"
	desc = "A crude improvised weapon. Although visually frightening, shivs are usually more effective for maiming than killing."
	icon_state = "shiv"
	item_state = "knife"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "stabbed", "sliced", "diced", "cut")
	damage_force = 8
	throw_force = 5
	w_class = WEIGHT_CLASS_SMALL
	damage_mode = DAMAGE_MODE_SHARP

//I would like two-handed weapons that don't use our annoying material system, resulting in a "Steel Mjollnir". Drives me crazy.
/obj/item/melee/twohanded
	name = "Two Handed Weapon"
	desc = "You shouldn't be seeing this. Report to a Maintainer."
	w_class = WEIGHT_CLASS_BULKY
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null

	passive_parry = /datum/passive_parry/melee{
		parry_chance_melee = 15;
	}

/obj/item/melee/twohanded/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(!wielded)
		wielded = 1
	else if(wielded)
		wielded = 0
	update_icon()

/obj/item/melee/twohanded/update_icon()
	..()
	if(wielded)
		icon_state = "[icon_state]_1"
		item_state = icon_state
	else
		icon_state = initial(icon_state)
		item_state = icon_state

/obj/item/melee/twohanded/mjollnir
	name = "Mjollnir"
	desc = "A long, heavy hammer. This weapons crackles with barely contained energy."
	icon_state = "mjollnir"
	attack_sound = 'sound/effects/lightningbolt.ogg'
	damage_force = 0
	throw_force = 30
	force_wielded = 75
	force_unwielded = 50
	damage_tier = 6
	w_class = WEIGHT_CLASS_HUGE
	attack_verb = list("attacked", "smashed", "crushed", "wacked", "pounded")
	weight = ITEM_WEIGHT_BASELINE

//This currently just kills the user. lol
/*
/obj/item/melee/twohanded/mjollnir/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	..()

	if(wielded || isliving(target))
		if(prob(10))
			G.electrocute_act_parse_this(500, src, def_zone = BP_TORSO)
			return
		if(prob(10))
			G.dust()
			return
		else
			G.stun_effect_act_parse_this(10 , 50, BP_TORSO, src)
			G.take_random_targeted_damage(brute = 10)
			G.afflict_unconscious(20 * 20)
			playsound(src.loc, /datum/soundbyte/sparks, 50, 1)
			return
*/

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
	var/datum/reagent_holder/R = new/datum/reagent_holder(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	update_icon()

/obj/item/melee/thermalcutter/Destroy()
	if(active)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/melee/thermalcutter/examine(mob/user, dist)
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

/obj/item/melee/thermalcutter/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	if(istype(target, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,target) <= 1)
		if(!active && max_fuel)
			target.reagents.trans_to_obj(src, max_fuel)
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
			var/obj/structure/reagent_dispensers/fueltank/tank = target
			tank.explode()
			return
	if (src.active)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(target))
			var/mob/living/L = target
			L.IgniteMob()
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)

/obj/item/melee/thermalcutter/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
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

	update_worn_icon()

/obj/item/melee/thermalcutter/proc/activate(var/mob/M)
	var/turf/T = get_turf(src)
	if(!active)
		if (get_fuel() > 0)
			if(M)
				to_chat(M, "<span class='notice'>You switch the [src] on.</span>")
			else if(T)
				T.visible_message("<span class='danger'>\The [src] turns on.</span>")
			playsound(loc, acti_sound, 50, 1)
			src.damage_force = 15
			src.damage_type = DAMAGE_TYPE_BURN
			src.set_weight_class(WEIGHT_CLASS_BULKY)
			src.attack_sound = 'sound/items/welder.ogg'
			damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
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
		src.damage_force = 3
		src.damage_type = DAMAGE_TYPE_BRUTE
		damage_mode = NONE
		src.set_weight_class(initial(src.w_class))
		src.active = 0
		src.attack_sound = initial(src.attack_sound)
		update_icon()

/obj/item/melee/thermalcutter/is_hot()
	return isOn()

#undef FUEL_BURN_INTERVAL
