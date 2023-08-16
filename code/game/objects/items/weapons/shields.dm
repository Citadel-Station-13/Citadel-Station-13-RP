//** Shield Helpers
//These are shared by various items that have shield-like behaviour

//bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_shield_arc(mob/user, var/bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/projectile))
		var/obj/projectile/P = damage_source
		attack_dir = get_dir(get_turf(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(get_turf(user), get_turf(attacker))
	else if(damage_source)
		attack_dir = get_dir(get_turf(user), get_turf(damage_source))

	if(!(attack_dir && (attack_dir & bad_arc)))
		return 1
	return 0

/proc/default_parry_check(mob/user, mob/attacker, atom/damage_source)
	//parry only melee attacks
	if(istype(damage_source, /obj/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = global.reverse_dir[user.dir] //arc of directions from which we cannot block
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/proc/unique_parry_check(mob/user, mob/attacker, atom/damage_source)	// An overrideable version of the above proc.
	return default_parry_check(user, attacker, damage_source)

/obj/item/shield
	name = "shield"
	var/base_block_chance = 50
	preserve_item = 1
	item_icons = list(
				SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
				SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
				)

/obj/item/shield/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = global.reverse_dir[user.dir] //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		if(prob(get_block_chance(user, damage, damage_source, attacker)))
			user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
			return 1
	return 0

/obj/item/shield/proc/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance

/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept for close quarters engagement.  It's also capable of protecting from less powerful projectiles."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riot"
	slot_flags = SLOT_BACK
	damage_force = 5.0
	throw_force = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_MATERIAL = 2)
	materials = list(MAT_GLASS = 7500, MAT_STEEL = 1000)
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/shield/riot/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = global.reverse_dir[user.dir] //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		if(prob(get_block_chance(user, damage, damage_source, attacker)))
			//At this point, we succeeded in our roll for a block attempt, however these kinds of shields struggle to stand up
			//to strong bullets and lasers.  They still do fine to pistol rounds of all kinds, however.
			if(istype(damage_source, /obj/projectile))
				var/obj/projectile/P = damage_source
				if((is_sharp(P) && P.armor_penetration >= 10) || istype(P, /obj/projectile/beam))
					//If we're at this point, the bullet/beam is going to go through the shield, however it will hit for less damage.
					//Bullets get slowed down, while beams are diffused as they hit the shield, so these shields are not /completely/
					//useless.  Extremely penetrating projectiles will go through the shield without less damage.
					user.visible_message("<span class='danger'>\The [user]'s [src.name] is pierced by [attack_text]!</span>")
					if(P.armor_penetration < 30) //PTR bullets and x-rays will bypass this entirely.
						P.damage = P.damage / 2
					return 0
			//Otherwise, if we're here, we're gonna stop the attack entirely.
			user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
			playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)
			return 1
	return 0

/obj/item/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/shield/riot/flash
	name = "strobe shield"
	desc = "A shield with a built in, high intensity light capable of blinding and disorienting suspects. Takes regular handheld flashes as bulbs."
	icon_state = "flashshield"
	item_state = "flashshield"
	var/obj/item/flash/embedded_flash
	var/flashfail = 0

/obj/item/shield/riot/flash/Initialize(mapload)
	. = ..()
	embedded_flash = new(src)

/obj/item/shield/riot/flash/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	return embedded_flash.attack_mob(arglist(args))

/obj/item/shield/riot/flash/attack_self(mob/user)
	. = ..()
	if(.)
		return
	. = embedded_flash.attack_self(user)
	update_icon()

/obj/item/shield/riot/flash/handle_shield(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	. = ..()
	if (. && damage && !embedded_flash.broken)
		embedded_flash.melee_attack_chain()
		update_icon()

/obj/item/shield/riot/flash/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/flash))
		var/obj/item/flash/flash = W
		if(flashfail)
			to_chat(user, "<span class='warning'>No sense replacing it with a broken bulb!</span>")
			return
		else
			to_chat(user, "<span class='notice'>You begin to replace the bulb...</span>")
			if(do_after(user, 20, target = user))
				if(flashfail || !flash || QDELETED(flash))
					return
				playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
				qdel(embedded_flash)
				embedded_flash = flash
				flash.forceMove(src)
				update_icon()
				return
	..()

/obj/item/shield/riot/flash/emp_act(severity)
	. = ..()
	embedded_flash.emp_act(severity)
	update_icon()

/obj/item/shield/riot/flash/update_icon_state()
	. = ..()
	if(!embedded_flash || embedded_flash.broken)
		icon_state = "riot"
		item_state = "riot"
	else
		icon_state = "flashshield"
		item_state = "flashshield"

/obj/item/shield/riot/flash/examine(mob/user, dist)
	. = ..()
	if (embedded_flash?.broken)
		. += "<span class='info'>The mounted bulb has burnt out. You can try replacing it with a new one.</span>"

/obj/item/shield/makeshift
	name = "metal shield"
	desc = "A large shield made of wired and welded sheets of metal. The handle is made of cloth and leather, making it unwieldy."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "makeshift_shield"
	item_state = "metal"
	slot_flags = null
	damage_force = 10
	throw_force = 7

/obj/item/shield/riot/tower
	name = "tower shield"
	desc = "An immense tower shield. Designed to ensure maximum protection to the user, at the expense of mobility."
	item_state = "metal"
	icon_state = "metal"
	damage_force = 16
	slowdown = 2
	throw_force = 15 //Massive piece of metal
	w_class = ITEMSIZE_HUGE

/obj/item/shield/riot/tower/swat
	name = "swat shield"

/* I don't know if I really want this in the game. I DO want the code though.
/obj/item/shield/riot/implant
	name = "hardlight shield implant"
	desc = "A hardlight plane of force projected from the implant. While it is capable of withstanding immense amounts of abuse, it will eventually overload from sustained impacts, especially against energy attacks. Recharges while retracted."
	item_state = "holoshield"
	icon_state = "holoshield"
	slowdown = 1
	shield_flags = SHIELD_FLAGS_DEFAULT
	max_integrity = 100
	obj_integrity = 100
	can_shatter = FALSE
	clothing_flags = ITEM_CAN_BLOCK
	shield_flags = SHIELD_FLAGS_DEFAULT | SHIELD_KINETIC_STRONG | SHIELD_DISABLER_DISRUPTED
	var/recharge_timerid
	var/recharge_delay = 15 SECONDS

/// Entirely overriden take_damage. This shouldn't exist outside of an implant (other than maybe christmas).
/obj/item/shield/riot/implant/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir, armour_penetration = 0)
	obj_integrity -= damage_amount
	if(obj_integrity < 0)
		obj_integrity = 0
	if(obj_integrity == 0)
		if(ismob(loc))
			var/mob/living/L = loc
			playsound(src, "sparks", 100, TRUE)
			L.visible_message("<span class='boldwarning'>[src] overloads from the damage sustained!</span>")
			L.dropItemToGround(src)			//implant component catch hook will grab it.

/obj/item/shield/riot/implant/Moved()
	. = ..()
	if(istype(loc, /obj/item/organ/cyberimp/arm/shield))
		recharge_timerid = addtimer(CALLBACK(src, PROC_REF(recharge)), recharge_delay, flags = TIMER_STOPPABLE)
	else		//extending
		if(recharge_timerid)
			deltimer(recharge_timerid)
			recharge_timerid = null

/obj/item/shield/riot/implant/proc/recharge()
	if(obj_integrity == max_integrity)
		return
	obj_integrity = max_integrity
	if(ismob(loc.loc))		//cyberimplant.user
		to_chat(loc, "<span class='notice'>[src] has recharged its reinforcement matrix and is ready for use!</span>")
*/

/obj/item/shield/riot/energy_proof
	name = "energy resistant shield"
	desc = "An ablative shield designed to absorb and disperse energy attacks. This comes at significant cost to its ability to withstand ballistics and kinetics, breaking apart easily."
	icon_state = "riot_laser"

/obj/item/shield/riot/kinetic_proof
	name = "kinetic resistant shield"
	desc = "A polymer and ceramic shield designed to absorb ballistic projectiles and kinetic force. It doesn't do very well into energy attacks, especially from weapons that inflict burns."
	icon_state = "riot_bullet"

//Exotics/Costume Shields
/obj/item/shield/riot/roman
	name = "scutum"
	desc = "A replica shield for close quarters engagement.  Its modern materials are also capable of protecting from less powerful projectiles."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "roman_shield"
	slot_flags = SLOT_BACK
	materials = list(MAT_WOOD = 7500, MAT_STEEL = 1000)
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

/obj/item/shield/riot/buckler
	name = "buckler"
	desc = "A wrist mounted round shield for close quarters engagement.  Its modern materials are also capable of protecting from less powerful projectiles."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "buckler"
	slot_flags = SLOT_BACK | SLOT_BELT
	materials = list(MAT_WOOD = 7500, MAT_STEEL = 1000)
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

/*
 * Energy Shield
 */

/obj/item/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield"
	item_state = "eshield"
	slot_flags = SLOT_EARS
	atom_flags = NOCONDUCT
	damage_force = 3.0
	throw_force = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_SMALL
	var/lrange = 1.5
	var/lpower = 1.5
	var/lcolor = "#006AFF"
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	attack_verb = list("shoved", "bashed")
	var/active = 0
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

/obj/item/shield/energy/handle_shield(mob/user)
	if(!active)
		return 0 //turn it on first!
	. = ..()

	if(.)
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/shield/energy/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/projectile))
		var/obj/projectile/P = damage_source
		if((is_sharp(P) && damage > 10) || istype(P, /obj/projectile/beam))
			return (base_block_chance - round(damage / 3)) //block bullets and beams using the old block chance
	return base_block_chance

/obj/item/shield/energy/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>You beat yourself in the head with [src].</span>")
		var/mob/living/carbon/human/H = ishuman(user)? user : null
		H?.take_organ_damage(5)
	active = !active
	if (active)
		damage_force = 10
		update_icon()
		w_class = ITEMSIZE_LARGE
		slot_flags = null
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now active.</span>")

	else
		damage_force = 3
		update_icon()
		w_class = ITEMSIZE_TINY
		slot_flags = SLOT_EARS
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/shield/energy/update_icon()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "[icon_state]_blade")
	if(lcolor)
		blade_overlay.color = lcolor
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(active)
		add_overlay(blade_overlay)
		item_state = "[icon_state]_blade"
		set_light(lrange, lpower, lcolor)
	else
		set_light(0)
		item_state = "[icon_state]"

/obj/item/shield/energy/AltClick(mob/living/user)
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return
	if(alert("Are you sure you want to recolor your shield?", "Confirm Recolor", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",lcolor) as color|null
		if(energy_color_input)
			lcolor = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
		update_icon()

/obj/item/shield/energy/examine(mob/user, dist)
	. = ..()
	. += "<span class='notice'>Alt-click to recolor it.</span>"

/obj/item/shield/riot/tele
	name = "telescopic shield"
	desc = "An advanced riot shield made of lightweight materials that collapses for easy storage."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "teleriot0"
	slot_flags = null
	damage_force = 3
	throw_force = 3
	throw_speed = 3
	throw_range = 4
	w_class = ITEMSIZE_NORMAL
	var/active = 0
/*
/obj/item/shield/energy/IsShield()
	if(active)
		return 1
	else
		return 0
*/
/obj/item/shield/riot/tele/attack_self(mob/user)
	. = ..()
	if(.)
		return
	active = !active
	icon_state = "teleriot[active]"
	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)

	if(active)
		damage_force = 8
		throw_force = 5
		throw_speed = 2
		w_class = ITEMSIZE_LARGE
		slot_flags = SLOT_BACK
		to_chat(user, "<span class='notice'>You extend \the [src].</span>")
	else
		damage_force = 3
		throw_force = 3
		throw_speed = 3
		w_class = ITEMSIZE_NORMAL
		slot_flags = null
		to_chat(user, "<span class='notice'>[src] can now be concealed.</span>")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/shield/energy/imperial
	name = "energy scutum"
	desc = "It's really easy to mispronounce the name of this shield if you've only read it in books."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	item_icons = list(SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi', SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi')

/obj/item/shield/fluff/wolfgirlshield
	name = "Autumn Shield"
	desc = "A shiny silvery shield with a large red leaf symbol in the center."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "wolfgirlshield"
	slot_flags = SLOT_BACK | SLOT_OCLOTHING
	damage_force = 5.0
	throw_force = 5.0
	throw_speed = 2
	throw_range = 6
	item_icons = list(SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi', SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi', SLOT_ID_BACK = 'icons/vore/custom_items_vr.dmi', SLOT_ID_SUIT = 'icons/vore/custom_items_vr.dmi')
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	allowed = list(/obj/item/melee/fluffstuff/wolfgirlsword)

/obj/item/shield/fluff/roman
	name = "replica scutum"
	desc = "A replica shield for close quarters engagement.  It looks sturdy enough to withstand foam weapons, and nothing more."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "roman_shield"
	slot_flags = SLOT_BACK
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)
	damage_force = 5.0
	throw_force = 5.0
	throw_speed = 2
	throw_range = 6

//Foam Shield
/obj/item/shield/riot/foam
	name = "foam riot shield"
	desc = "A shield for close quarters engagement.  It looks sturdy enough to withstand foam weapons, and nothing more."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "foamriot"
	slot_flags = SLOT_BACK
	base_block_chance = 5
	damage_force = 0
	throw_force = 0
	throw_speed = 2
	throw_range = 6
	materials = list(MAT_PLASTIC = 7500, "foam" = 1000)
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)
