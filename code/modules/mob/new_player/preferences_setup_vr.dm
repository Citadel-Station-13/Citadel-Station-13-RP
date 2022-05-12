/datum/preferences/update_preview_icon() // Lines up and un-overlaps character edit previews. Also un-splits taurs.
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	if(!mannequin.dna) // Special handling for preview icons before SSAtoms has initailized.
		mannequin.dna = new /datum/dna(null)
	mannequin.delete_inventory(TRUE)
	if(regen_limbs)
		var/datum/species/current_species = name_static_species_meta(species)
		current_species.create_organs(mannequin)
		regen_limbs = 0
	dress_preview_mob(mannequin)
	mannequin.update_transform()
	mannequin.toggle_tail_vr(setting = TRUE)
	mannequin.toggle_wing_vr(setting = TRUE)
	COMPILE_OVERLAYS(mannequin)
	update_character_previews(new /mutable_appearance(mannequin))
