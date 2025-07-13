// -------------- Sickshot -------------
/obj/item/gun/projectile/energy/sickshot
	name = "\'Discombobulator\' revolver"
	desc = "Need to stun someone? Don't mind having to clean up the mess afterwards? The MPA6 'Discombobulator' is the answer to your prayers. \
	Using a short-range concentrated blast of disruptive sound, the Discombobulator will nauseate and confuse the target for several seconds. NOTE: Not suitable \
	for use in vacuum. Usage on animals may cause panic and rage without stunning. May cause contraction and release of various 'things' from various 'orifices', even if the target is already dead."

	description_info = "This gun causes nausea in targets, stunning them briefly and causing vomiting. It will also cause them to vomit up prey, sometimes. Repeated shots may help in that case."
	description_fluff = ""
	description_antag = ""

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "sickshot"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	fire_sound = 'sound/weapons/eluger.ogg'
	projectile_type = /obj/projectile/sickshot

	charge_cost = 600

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 2)

//Projectile
/obj/projectile/sickshot
	name = "discombobulator pulse"
	icon_state = "sound"
	damage_force = 5
	damage_tier = 4
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_MELEE
	embed_chance = 0
	vacuum_traversal = 0
	range = WORLD_ICON_SIZE * 5 //Scary name, but just deletes the projectile after this range

/obj/projectile/sickshot/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return

	if(isliving(target))
		var/mob/living/L = target
		if(prob(20))
			L.release_vore_contents()

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.vomit()
			H.Confuse(2)
