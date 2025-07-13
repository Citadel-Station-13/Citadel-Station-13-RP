/mob/living/carbon/human/revive(force, full_heal, restore_nutrition = TRUE)
	. = ..()
	if(!.)
		return
	//! WARNING WARNING SHITCODE ALERT !//
	// This is because the logic for being unconscious from damage is, for some reason, in UI. //
	handle_regular_UI_updates()

/mob/living/carbon/human/rejuvenate(fix_missing, reset_to_slot, restore_nutrition = TRUE, var/delete_nif = FALSE)
	. = ..()
	if(!.)
		return
	// blood
	restore_blood()
	reset_blood_to_species()

	// todo: this obviously doesn't respect reset_to_slot.
	if(fix_missing || reset_to_slot)
		species.create_organs(src, delete_nif)
		restore_all_organs()
		client?.prefs?.copy_to(src)
		if(dna)
			dna.ResetUIFrom(src)
			sync_organ_dna()
