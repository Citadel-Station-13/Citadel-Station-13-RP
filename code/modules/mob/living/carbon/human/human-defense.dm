//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

//* Projectile Handling *//

/mob/living/carbon/human/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_TARGET_ABORT)
		return

	if(impact_flags & PROJECTILE_IMPACT_BLOCKED)
		return

	// todo: this shit shouldn't be here
	var/obj/item/organ/external/organ = get_organ()

	if(!proj.nodamage)
		organ.add_autopsy_data("[proj.name]", proj.damage_force)

	//Shrapnel
	if(proj.can_embed())
		var/armor = getarmor_organ(organ, "bullet")
		if(!prob(armor/2))		//Even if the armor doesn't stop the bullet from hurting you, it might stop it from embedding.
			var/hit_embed_chance = proj.embed_chance + (proj.damage_force - armor)	//More damage equals more chance to embed
			if(prob(max(hit_embed_chance, 0)))
				var/obj/item/material/shard/shrapnel/SP = new()
				SP.name = (proj.name != "shrapnel")? "[proj.name] shrapnel" : "shrapnel"
				SP.desc = "[SP.desc] It looks like it was fired from [proj.shot_from]."
				SP.loc = organ
				organ.embed(SP)

//* Misc Effects *//

/mob/living/carbon/human/slip_act(slip_class, source, hard_strength, soft_strength, suppressed)
	var/footcoverage_check = length(inventory.query_coverage(FEET))
	var/obj/item/shoes = inventory.get_slot_single(/datum/inventory_slot/inventory/shoes)
	if(((species.species_flags & NO_SLIP) && !footcoverage_check) || (shoes && (shoes.clothing_flags & NOSLIP))) //Footwear negates a species' natural traction.
		return 0
	return ..()
