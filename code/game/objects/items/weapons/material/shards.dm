/obj/item/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	w_class = ITEMSIZE_SMALL
	material_significance = MATERIAL_SIGNIFICANCE_SHARD
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	material_parts = /datum/material/glass

/obj/item/material/shard/Initialize(mapload, material)
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

/obj/item/material/shard/update_material_single(datum/material/material)
	. = ..()
	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	if(material_color)
		color = material.icon_colour
		alpha = MATERIAL_OPACITY_TO_ALPHA(material.opacity)
	else
		color = "#ffffff"
		alpha = 255
	// we don't check for material shard type; we trust the caller knows what they're doing
	if(material.shard_type)
		name = "[material.display_name] [material.shard_type]"
		desc = "A small piece of [material.display_name]. It looks sharp."
		switch(material.shard_type)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		name = "what???"
		desc = "material [material.id] shard - which shouldn't exist. contact a coder."
		gender = NEUTER

/obj/item/material/shard/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	viewers(user) << pick("<span class='danger'>\The [user] is slitting [TU.his] wrists with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>",
	                      "<span class='danger'>\The [user] is slitting [TU.his] throat with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/material/shard/attackby(obj/item/W as obj, mob/user as mob)
	var/datum/material/material = get_material_part(MATERIAL_PART_DEFAULT)
	if(istype(W, /obj/item/weldingtool) && material.shard_can_repair)
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			material.place_sheet(drop_location())
			qdel(src)
			return
	return ..()

/obj/item/material/shard/afterattack(atom/target, mob/living/user, clickchain_flags, list/params)
	if(!istype(user))
		return
	var/active_hand //hand the shard is in
	var/will_break = FALSE
	var/protected_hands = FALSE //this is a fucking mess
	var/break_damage = 4
	var/light_glove_d = rand(2, 4)
	var/no_glove_d = rand(4, 6)
	var/list/forbidden_gloves = list(
			/obj/item/clothing/gloves/sterile,
			/obj/item/clothing/gloves/knuckledusters
		)

	if(src == user.get_left_held_item())
		active_hand = BP_L_HAND
	else if(src == user.get_right_held_item())
		active_hand = BP_R_HAND
	else
		return // If it's not actually in our hands anymore, we were probably gentle with it

	if(prob(75))
		will_break = TRUE

	var/obj/item/gloves = user.item_by_slot(SLOT_ID_GLOVES)

	if(gloves && (gloves.body_cover_flags & HANDS) && istype(gloves, /obj/item/clothing/gloves)) // Not-gloves aren't gloves, and therefore don't protect us
		protected_hands = TRUE // If we're wearing gloves we can probably handle it just fine
		for(var/I in forbidden_gloves)
			if(istype(gloves, I)) // forbidden_gloves is a blacklist, so if we match anything in there, our hands are not protected
				protected_hands = FALSE
				break

	if(gloves && !protected_hands)
		to_chat(user, "<span class='warning'>\The [src] partially cuts into your hand through your gloves as you hit \the [target]!</span>")
		user.apply_damage(light_glove_d + will_break ? break_damage : 0, BRUTE, active_hand, 0, 0, src, src.sharp || (damage_mode & DAMAGE_MODE_SHARP), src.edge || (damage_mode & DAMAGE_MODE_EDGE)) // Ternary to include break damage

	else if(!gloves)
		to_chat(user, "<span class='warning'>\The [src] cuts into your hand as you hit \the [target]!</span>")
		user.apply_damage(no_glove_d + will_break ? break_damage : 0, BRUTE, active_hand, 0, 0, src, src.sharp || (damage_mode & DAMAGE_MODE_SHARP), src.edge || (damage_mode & DAMAGE_MODE_EDGE))

	if(will_break && src.loc == user) // If it's not in our hand anymore
		user.visible_message("<span class='danger'>[user] hit \the [target] with \the [src], shattering it!</span>", "<span class='warning'>You shatter \the [src] in your hand!</span>")
		playsound(user, pick('sound/effects/Glassbr1.ogg', 'sound/effects/Glassbr2.ogg', 'sound/effects/Glassbr3.ogg'), 30, 1)
		qdel(src)
	return

/obj/item/material/shard/Crossed(atom/movable/AM as mob|obj)
	..()
	if(AM.is_incorporeal())
		return
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_cover_flags & FEET) ) )
				return

			if(H.species.species_flags & NO_MINOR_CUT)
				return

			to_chat(H, "<span class='danger'>You step on \the [src]!</span>")

			var/list/check = list("l_foot", "r_foot")
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(affecting.robotic >= ORGAN_ROBOT)
						return
					affecting.inflict_bodypart_damage(
						brute = damage_force,
					)
					if(affecting.organ_can_feel_pain())
						H.afflict_paralyze(20 * 2)
					return
				check -= picked
			return

// Preset types - left here for the code that uses them
/obj/item/material/shard/shrapnel
	material_parts = /datum/material/steel

/obj/item/material/shard/phoron
	material_parts = /datum/material/glass/phoron

/obj/item/material/shard/wood
	material_parts = /datum/material/wood_plank
