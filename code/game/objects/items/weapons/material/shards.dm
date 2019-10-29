// Glass shards

/obj/item/weapon/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	sharp = 1
	edge = 1
	w_class = ITEMSIZE_SMALL
	force_divisor = 0.25 // 7.5 with hardness 30 (glass)
	thrown_force_divisor = 0.5
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material = MATERIAL_ID_GLASS
	material_usage_flags = USE_PRIMARY_MATERIAL_COLOR | USE_PRIMARY_MATERIAL_OPACITY
	var/shard_visual_size = "large"
	unbreakable = 1 //It's already broken.
	drops_debris = 0

/obj/item/weapon/material/shard/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	viewers(user) << pick("<span class='danger'>\The [user] is slitting [TU.his] wrists with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>",
	                      "<span class='danger'>\The [user] is slitting [TU.his] throat with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/ewapon/material/shard/Initialize(mapload)
	. = ..()
	size = pick("large", "medium", "small")
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

/obj/item/weapon/material/shard/UpdateMaterials()
	. = ..()
	if(material_primary)
		if(material_primary.shard_icon)
			icon_state = "[material_primary.shard_icon][shard_visual_size]"
		else
			icon_state = initial(icon_state)

/obj/item/weapon/material/shard/UpdateDescriptions()
	. = ..()
	if(material_primary)
		name = "[material_primary.display_name] [material_primary.shard_type || "shard"]"
		desc = "A small piece of [material_primary.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as a ... a throwing weapon?"
		switch(material_primary.shard_type)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		name = initial(name)
		desc = initial(desc)

/obj/item/weapon/material/shard/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool) && material_primary?.shard_can_repair)
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			material.place_sheet(loc)
			qdel(src)
			return
	return ..()

/obj/item/weapon/material/shard/Crossed(AM as mob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
				return

			if(H.species.flags & NO_MINOR_CUT)
				return

			to_chat(H, "<span class='danger'>You step on \the [src]!</span>")

			var/list/check = list("l_foot", "r_foot")
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(affecting.robotic >= ORGAN_ROBOT)
						return
					if(affecting.take_damage(force, 0))
						H.UpdateDamageIcon()
					H.updatehealth()
					if(affecting.organ_can_feel_pain())
						H.Weaken(3)
					return
				check -= picked
			return

// Preset types - left here for the code that uses them
/obj/item/weapon/material/shard/shrapnel
	material_primary = MATERIAL_ID_STEEL

/obj/item/weapon/material/shard/phoron
	material_id = MATERIAL_ID_PHORON_GLASS
