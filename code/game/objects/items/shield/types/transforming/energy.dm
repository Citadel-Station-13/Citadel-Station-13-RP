/obj/item/shield/transforming/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/items/shields/transforming.dmi'
	icon_state = "energy"
	base_icon_state = "energy"
	slot_flags = SLOT_EARS
	atom_flags = NOCONDUCT

	damage_force = 3
	active_damage_force = 10

	w_class = WEIGHT_CLASS_TINY
	active_weight_class = WEIGHT_CLASS_BULKY

	throw_force = 5.0
	throw_speed = 1
	throw_range = 4

	passive_parry = /datum/passive_parry/shield{
		parry_chance_default = 50;
		parry_frame = /datum/parry_frame/passive_block/energy;
	}

	active_via_overlay = TRUE

	var/lrange = 1.5
	var/lpower = 1.5
	var/lcolor = "#006AFF"

	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	attack_verb = list("shoved", "bashed")

	/// drop projectiles sometimes?
	var/legacy_projectile_damage_drop = TRUE
	/// divisor to projectile damage before we drop the hit
	var/legacy_projectile_damage_drop_divisor = 1.6

	activation_sound = 'sound/weapons/saberon.ogg'
	deactivation_sound = 'sound/weapons/saberoff.ogg'

/obj/item/shield/transforming/energy/passive_parry_intercept(mob/defending, attack_type, datum/attack_source, datum/passive_parry/parry_data)
	if(istype(attack_source, /obj/projectile))
		var/obj/projectile/casted_projectile = attack_source
		if(legacy_projectile_damage_drop)
			if((is_sharp(casted_projectile) && casted_projectile.damage_force > 10) || (casted_projectile.projectile_type & PROJECTILE_TYPE_BEAM))
				if(prob(casted_projectile.damage_force / legacy_projectile_damage_drop_divisor))
					return // drop the shield
	. = ..()
	if(!.)
		return
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(3, 0, defending.loc)
	spark_system.start()

/obj/item/shield/transforming/energy/on_activate(datum/event_args/actor/actor, silent)
	. = ..()
	slot_flags = NONE
	if(!silent)
		actor.chat_feedback(
			SPAN_WARNING("You activate \the [src]."),
			target = src,
		)
	set_light(lrange, lpower, lcolor)

/obj/item/shield/transforming/energy/on_deactivate(datum/event_args/actor/actor, silent)
	. = ..()
	slot_flags = SLOT_EARS
	if(!silent)
		actor.chat_feedback(
			SPAN_WARNING("You collapse \the [src]."),
			target = src,
		)
	set_light(0)

/obj/item/shield/transforming/energy/build_active_overlay()
	var/image/built = ..()
	if(lcolor)
		built.color = lcolor
	return built

/obj/item/shield/transforming/energy/build_active_worn_overlay()
	var/image/built = ..()
	if(lcolor)
		built.color = lcolor
	return built

// todo: legacy below

/obj/item/shield/transforming/energy/AltClick(mob/living/user)
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

/obj/item/shield/transforming/energy/examine(mob/user, dist)
	. = ..()
	. += "<span class='notice'>Alt-click to recolor it.</span>"

/obj/item/shield/transforming/energy/imperial
	name = "imperial shield"
	desc = "What the hell is this?"
	desc = "It's really easy to mispronounce the name of this shield if you've only read it in books."
	icon_state = "imperial_shield"
	base_icon_state = "imperial_shield"
