/obj/item/proc/unique_parry_check(mob/user, mob/attacker, atom/damage_source)	// An overrideable version of the above proc.
	SHOULD_NOT_OVERRIDE(TRUE)
	return default_parry_check(user, attacker, damage_source)

/obj/proc/handle_shield()
	SHOULD_NOT_OVERRIDE(TRUE)

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
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = list(TECH_MATERIAL = 2)
	materials_base = list(MAT_GLASS = 7500, MAT_STEEL = 1000)
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/shield/riot/passive_parry_intercept(mob/defending, list/shieldcall_args, datum/passive_parry/parry_data)
	. = ..()


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

/obj/item/shield/riot/flash/passive_parry_intercept(mob/defending, list/shieldcall_args, datum/passive_parry/parry_data)
	. = ..()
	if(!.)
		return
	if(embedded_flash.broken)
		return
	if(!shieldcall_args[SHIELDCALL_ARG_ATTACK_TYPE] & (ATTACK_TYPE_MELEE | ATTACK_TYPE_UNARMED))
		return
	var/datum/event_args/actor/clickchain/clickchain = shieldcall_args[SHIELDCALL_ARG_CLICKCHAIN]
	var/mob/attacker = clickchain?.performer
	if(attacker)
		embedded_flash.melee_interaction_chain(attacker, defending)
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
	encumbrance = ITEM_ENCUMBRANCE_SHIELD_TOWER
	throw_force = 15 //Massive piece of metal
	w_class = WEIGHT_CLASS_HUGE

/obj/item/shield/riot/tower/swat
	name = "swat shield"

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
	materials_base = list(MAT_WOOD = 7500, MAT_STEEL = 1000)
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
	materials_base = list(MAT_WOOD = 7500, MAT_STEEL = 1000)
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

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
	damage_force = 0
	throw_force = 0
	throw_speed = 2
	throw_range = 6
	materials_base = list(MAT_PLASTIC = 7500, "foam" = 1000)
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

/obj/item/shield/riot/foam/passive_parry_intercept(mob/defending, list/shieldcall_args, datum/passive_parry/parry_data)
	var/allowed = FALSE
	var/weapon = shieldcall_args[SHIELDCALL_ARG_WEAPON]
	if(isobj(weapon))
		var/obj/casted_object = weapon
		if(istype(casted_object, /obj/projectile))
			var/obj/projectile/casted_projectile = casted_object
			if(istype(casted_projectile, /obj/projectile/bullet/reusable/foam))
				allowed = TRUE
		else if(casted_object.get_primary_material_id() == /datum/material/toy_foam::id)
			allowed = TRUE
	if(!allowed)
		return
	return ..()
