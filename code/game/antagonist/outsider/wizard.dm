var/datum/antagonist/wizard/wizards

/datum/antagonist/wizard
	id = MODE_WIZARD
	role_type = BE_WIZARD
	role_text = "Space Wizard"
	role_text_plural = "Space Wizards"
	bantype = "wizard"
	landmark_id = "wizard"
	welcome_text = "You will find a list of available spells in your spell book. Choose your magic arsenal carefully.<br>In your pockets you will find a teleport scroll. Use it as needed."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE
	antaghud_indicator = "wizard"

	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 1


/datum/antagonist/wizard/New()
	..()
	wizards = src

/datum/antagonist/wizard/create_objectives(datum/mind/wizard)

	if(!..())
		return

	var/kill
	var/escape
	var/steal
	var/hijack

	switch(rand(1,100))
		if(1 to 30)
			escape = 1
			kill = 1
		if(31 to 60)
			escape = 1
			steal = 1
		if(61 to 99)
			kill = 1
			steal = 1
		else
			hijack = 1

	if(kill)
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = wizard
		kill_objective.find_target()
		wizard.objectives |= kill_objective
	if(steal)
		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = wizard
		steal_objective.find_target()
		wizard.objectives |= steal_objective
	if(escape)
		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = wizard
		wizard.objectives |= survive_objective
	if(hijack)
		var/datum/objective/hijack/hijack_objective = new
		hijack_objective.owner = wizard
		wizard.objectives |= hijack_objective
	return

/datum/antagonist/wizard/update_antag_mob(datum/mind/wizard)
	..()
	wizard.store_memory("<B>Remember:</B> do not forget to prepare your spells.")
	wizard.current.real_name = "[pick(GLOB.wizard_first)] [pick(GLOB.wizard_second)]"
	wizard.current.name = wizard.current.real_name

/datum/antagonist/wizard/equip(mob/living/carbon/human/wizard_mob)

	if(!..())
		return 0

	wizard_mob.equip_to_slot_or_del(new /obj/item/radio/headset(wizard_mob), SLOT_ID_LEFT_EAR)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(wizard_mob), SLOT_ID_UNIFORM)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(wizard_mob), SLOT_ID_SHOES)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe(wizard_mob), SLOT_ID_SUIT)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/head/wizard(wizard_mob), SLOT_ID_HEAD)
	if(wizard_mob.backbag == 2) wizard_mob.equip_to_slot_or_del(new /obj/item/storage/backpack(wizard_mob), SLOT_ID_BACK)
	if(wizard_mob.backbag == 3) wizard_mob.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(wizard_mob), SLOT_ID_BACK)
	if(wizard_mob.backbag == 4) wizard_mob.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(wizard_mob), SLOT_ID_BACK)
	if(wizard_mob.backbag == 5) wizard_mob.equip_to_slot_or_del(new /obj/item/storage/backpack(wizard_mob), SLOT_ID_BACK)
	wizard_mob.equip_to_slot_or_del(new /obj/item/storage/box(wizard_mob), /datum/inventory_slot_meta/abstract/put_in_backpack)
	wizard_mob.equip_to_slot_or_del(new /obj/item/teleportation_scroll(wizard_mob), SLOT_ID_RIGHT_POCKET)
	wizard_mob.equip_to_slot_or_del(new /obj/item/spellbook(wizard_mob), /datum/inventory_slot_meta/abstract/hand/right)
	return 1

/datum/antagonist/wizard/check_victory()
	var/survivor
	for(var/datum/mind/player in current_antagonists)
		if(!player.current || player.current.stat)
			continue
		survivor = 1
		break
	if(!survivor)
		feedback_set_details("round_end_result","loss - wizard killed")
		to_chat(world, SPAN_ANNOUNCE("The [(current_antagonists.len>1)?"[role_text_plural] have":"[role_text] has"] been killed by the crew!"))

/**
 * To batch-remove wizard spells. Linked to mind.dm.
 */
/mob/proc/spellremove()
	for(var/spell/spell_to_remove in src.spell_list)
		remove_spell(spell_to_remove)

/**
 * Does this clothing slot count as wizard garb? (Combines a few checks)
 */
/proc/is_wiz_garb(obj/item/clothing/Clothing)
	return Clothing && Clothing.wizard_garb

/**
 * Checks if the wizard is wearing the proper attire.
 * Made a proc so this is not repeated 14 (or more) times.
 */
/mob/proc/wearing_wiz_garb()
	to_chat(src, "Silly creature, you're not a human. Only humans can cast this spell.")
	return FALSE

/**
 * Humans can wear clothes.
 */
/mob/living/carbon/human/wearing_wiz_garb()
	if(!is_wiz_garb(src.wear_suit))
		to_chat(src, SPAN_WARNING("I don't feel strong enough without my robe."))
		return FALSE
	if(!is_wiz_garb(src.shoes))
		to_chat(src, SPAN_WARNING("I don't feel strong enough without my sandals."))
		return FALSE
	if(!is_wiz_garb(src.head))
		to_chat(src, SPAN_WARNING("I don't feel strong enough without my hat."))
		return FALSE
	return TRUE
