#warn redo sprite; active sprite as _active
/obj/item/shield/toggle/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield"
	item_state = "eshield"
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
		parry_frame = /datum/parry_frame/passive_block{
			parry_sfx = 'sound/weapons/blade1.ogg';
		};
	}

	var/lrange = 1.5
	var/lpower = 1.5
	var/lcolor = "#006AFF"

	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	attack_verb = list("shoved", "bashed")
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

	/// drop projectiles sometimes?
	var/legacy_projectile_damage_drop = TRUE
	/// divisor to projectile damage before we drop the hit
	var/legacy_projectile_damage_drop_divisor = 1.3

	activation_soud = 'sound/weapons/saberon.ogg'
	deactivation_soud = 'sound/weapons/saberoff.ogg'

/obj/item/shield/toggle/energy/passive_parry_intercept(mob/defending, list/shieldcall_args, datum/passive_parry/parry_data)
	var/weapon = shieldcall_args[SHIELDCALL_ARG_WEAPON]
	if(istype(weapon, /obj/projectile))
		var/obj/projectile/casted_projectile = weapon
		if(legacy_projectile_damage_drop)
			if((is_sharp(casted_projectile) && shieldcall_args[SHIELDCALL_ARG_DAMAGE] > 10) || (casted_projectile.projectile_type & PROJECTILE_TYPE_BEAM))
				if(prob(shieldcall_args[SHIELDCALL_ARG_DAMAGE] / legacy_projectile_damage_drop_divisor))
					return // drop the shield
	. = ..()
	if(!.)
		return
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(3, 0, user.loc)
	spark_system.start()

#warn parse
/obj/item/shield/toggle/energy/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if (active)
		slot_flags = null
		to_chat(user, "<span class='notice'>\The [src] is now active.</span>")

	else
		slot_flags = SLOT_EARS
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")

/obj/item/shield/toggle/energy/update_icon()
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

/obj/item/shield/toggle/energy/AltClick(mob/living/user)
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

/obj/item/shield/toggle/energy/examine(mob/user, dist)
	. = ..()
	. += "<span class='notice'>Alt-click to recolor it.</span>"

/obj/item/shield/toggle/energy/imperial
	name = "energy scutum"
	desc = "It's really easy to mispronounce the name of this shield if you've only read it in books."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	item_icons = list(SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi', SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi')
