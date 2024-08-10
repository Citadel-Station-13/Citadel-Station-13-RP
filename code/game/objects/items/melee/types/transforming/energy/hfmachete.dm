/obj/item/melee/transforming/energy/hfmachete
	name = "high-frequency machete"
	desc = "A high-frequency broad blade used either as an implement or in combat like a short sword."
	icon_state = "hfmachete"
	base_icon_state = "hfmachete"
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	damage_force = 20 // You can be crueler than that, Jack.
	throw_force = 40
	throw_speed = 8
	throw_range = 8
	w_class = WEIGHT_CLASS_NORMAL
	siemens_coefficient = 1
	origin_tech = list(TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	attack_verb = list("attacked", "diced", "cleaved", "torn", "cut", "slashed")
	armor_penetration = 50
	var/base_state = "hfmachete"
	attack_sound = "machete_hit_sound" // dont mind the meaty hit sounds if you hit something that isnt meaty
	can_cleave = TRUE
	embed_chance = 0 // let's not

	active_damage_force = 40

	activation_sound = 'sound/weapons/hf_machete/hfmachete1.ogg'
	deactivation_sound = 'sound/weapons/hf_machete/hfmachete0.ogg'

	active_weight_class = WEIGHT_CLASS_BULKY
	inactive_weight_class = WEIGHT_CLASS_NORMAL

#warn parse
/obj/item/melee/transforming/energy/hfmachete/proc/toggleActive(mob/user, var/togglestate = "")
	switch(togglestate)
		if("on")
			active = 1
		if("off")
			active = 0
		else
			active = !active
	if(active)
		throw_force = 20
		throw_speed = 3
		// sharpness = 1.7
		// sharpness_flags += HOT_EDGE | CUT_WALL | CUT_AIRLOCK - if only there  a good sharpness system
		armor_penetration = 100
		to_chat(user, "<span class='warning'> [src] starts vibrating.</span>")
	else
		throw_force = initial(throw_force)
		throw_speed = initial(throw_speed)
		// sharpness = initial(sharpness)
		// sharpness_flags = initial(sharpness_flags) - if only there was a good sharpness system
		armor_penetration = initial(armor_penetration)
		to_chat(user, "<span class='notice'> [src] stops vibrating.</span>")
	update_icon()

/obj/item/melee/transforming/energy/hfmachete/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	..()
	if(target)
		if(istype(target,/obj/effect/plant))
			var/obj/effect/plant/P = target
			P.die_off()
