/obj/item/slime_scanner
	name = "slime scanner"
	icon_state = "xenobio"
	item_state = "xenobio"
	icon = 'icons/obj/device.dmi'
	origin_tech = list(TECH_BIO = 1)
	w_class = WEIGHT_CLASS_SMALL
	throw_force = 0
	throw_speed = 3
	throw_range = 7
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 20)

/obj/item/slime_scanner/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(!istype(target, /mob/living/simple_mob/slime/xenobio))
		to_chat(user, "<B>This device can only scan lab-grown slimes!</B>")
		return
	var/mob/living/simple_mob/slime/xenobio/S = target
	user.show_message("Slime scan results:<br>[S.slime_color] [S.is_adult ? "adult" : "baby"] slime<br>Health: [S.health]<br>Mutation Probability: [S.mutation_chance]")

	var/list/mutations = list()
	for(var/potential_color in S.slime_mutation)
		var/mob/living/simple_mob/slime/xenobio/slime = potential_color
		mutations.Add(initial(slime.slime_color))
	user.show_message("Potental to mutate into [english_list(mutations)] colors.<br>Extract potential: [S.cores]<br>Nutrition: [S.nutrition]/[S.get_max_nutrition()]")

	if (S.nutrition < S.get_starve_nutrition())
		user.show_message("<span class='alert'>Warning: Subject is starving!</span>")
	else if (S.nutrition < S.get_hunger_nutrition())
		user.show_message("<span class='warning'>Warning: Subject is hungry.</span>")
	user.show_message("Electric change strength: [S.power_charge]")

	if(S.has_polaris_AI())
		var/datum/ai_holder/polaris/simple_mob/xenobio_slime/AI = S.ai_holder
		if(AI.resentment)
			user.show_message("<span class='warning'>Warning: Subject is harboring resentment.</span>")
		if(AI.rabid)
			user.show_message("<span class='danger'>Subject is enraged and extremely dangerous!</span>")
	if(S.harmless)
		user.show_message("Subject has been pacified.")
	if(S.unity)
		user.show_message("Subject is friendly to other slime colors.")

	user.show_message("Growth progress: [S.amount_grown]/10")
