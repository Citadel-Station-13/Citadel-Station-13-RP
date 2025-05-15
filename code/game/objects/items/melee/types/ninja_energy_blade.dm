/obj/item/melee/ninja_energy_blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "ninja_energy_blade"
	item_state = "ninja_energy_blade"
	damage_force = 40 //Normal attacks deal very high damage - about the same as wielded fire axe
	damage_tier = 5
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	anchored = 1    // Never spawned outside of inventory, should be fine.
	throw_force = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = WEIGHT_CLASS_BULKY//So you can't hide it in your pocket or some such.
	atom_flags = NOBLOODY
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	var/mob/living/creator
	var/datum/effect_system/spark_spread/spark_system

	var/lrange = 2
	var/lpower = 2
	var/lcolor = "#00FF00"

	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 60;
	}

/obj/item/melee/ninja_energy_blade/Initialize(mapload)
	. = ..()
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	START_PROCESSING(SSobj, src)
	set_light(lrange, lpower, lcolor)

/obj/item/melee/ninja_energy_blade/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/melee/ninja_energy_blade/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	qdel(src)

/obj/item/melee/ninja_energy_blade/dropped(mob/user, atom_flags, atom/newLoc)
	. = ..()
	qdel(src)

/obj/item/melee/ninja_energy_blade/process(delta_time)
	if(!creator || loc != creator || !creator.is_holding(src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host._handle_inventory_hud_remove(src)
		qdel(src)
