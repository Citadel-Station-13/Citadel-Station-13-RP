/// holosphere 'sphere'
/mob/living/simple_mob/holosphere_shell
	name = "holosphere shell"
	desc = "A holosphere shell."

	icon = 'icons/mob/species/holosphere/holosphere.dmi'
	icon_state = "holosphere_body"
	icon_dead = "holosphere_body"

	maxHealth = 100
	health = 100

	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	aquatic_movement = 1
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	minbodytemp = 0
	maxbodytemp = INFINITY
	heat_resist = 1
	cold_resist = 1

	legacy_melee_damage_lower = 0
	legacy_melee_damage_upper = 0

	holder_type = /obj/item/holder/holosphere_shell

	mob_size = MOB_MEDIUM
	pass_flags = ATOM_PASS_TABLE

	has_langs = list(LANGUAGE_GALCOM, LANGUAGE_EAL)

	var/eye_icon_state = "holosphere_eye"

	// space movement related
	var/last_space_movement = 0

	// the transform component we are used with
	var/datum/component/custom_transform/transform_component
	// the human we belong to
	var/mob/living/carbon/human/hologram

/mob/living/simple_mob/holosphere_shell/Initialize(mapload, mob/living/carbon/human/H)
	. = ..()
	give_holosphere_actions()
	RegisterSignal(src, COMSIG_MOB_SAY, PROC_REF(handle_hologram_shell_speech))

/mob/living/simple_mob/holosphere_shell/regenerate_icons()
	cut_overlays()
	if(stat != DEAD)
		var/image/eye_icon = image('icons/mob/species/holosphere/holosphere.dmi',eye_icon_state)
		eye_icon.color = rgb(hologram.r_eyes, hologram.b_eyes, hologram.g_eyes)
		add_overlay(eye_icon)

/mob/living/simple_mob/holosphere_shell/verb/enable_hologram()
	set name = "Enable Hologram (Holosphere)"
	set desc = "Enable your hologram."
	set category = VERB_CATEGORY_IC

	transform_component.try_untransform()

// same way pAI space movement works in pai/mobility.dm
/mob/living/simple_mob/holosphere_shell/Process_Spacemove(movement_dir = NONE)
	. = ..()
	if(!. && src.loc != hologram)
		if(world.time >= last_space_movement + 3 SECONDS)
			last_space_movement = world.time
			// place an effect for the movement
			new /obj/effect/temp_visual/pai_ion_burst(get_turf(src))
			return TRUE

/mob/living/simple_mob/holosphere_shell/examine(mob/user, dist)
	return hologram?.examine(user, dist) || ..()

// simplified version of robo_repair because user cannot equal the shell (the shell has no hands!)
/mob/living/simple_mob/holosphere_shell/proc/shell_repair(repair_amount, damage_type, damage_desc, obj/item/tool, mob/living/user)
	var/damage_amount
	switch(damage_type)
		if(DAMAGE_TYPE_BRUTE)
			damage_amount = bruteloss
		if(DAMAGE_TYPE_BURN)
			damage_amount = fireloss
		if("omni")
			damage_amount = max(bruteloss,fireloss)
		else
			return FALSE
	if(!damage_amount)
		to_chat(user, SPAN_NOTICE("Nothing to fix!"))
		return FALSE

	user.setClickCooldownLegacy(user.get_attack_speed_legacy(tool))

	switch(damage_type)
		if(DAMAGE_TYPE_BRUTE)
			src.heal_brute_loss(repair_amount)
		if(DAMAGE_TYPE_BURN)
			src.heal_fire_loss(repair_amount)
		if("omni")
			src.heal_brute_loss(repair_amount)
			src.heal_fire_loss(repair_amount)

	if(damage_desc)
		user.visible_message(SPAN_NOTICE("\The [user] patches [damage_desc] on [src] with [tool]."))

	return TRUE

/mob/living/simple_mob/holosphere_shell/revive(force, full_heal, restore_nutrition)
	..()
	hologram.revive(force, full_heal, restore_nutrition)

/mob/living/simple_mob/holosphere_shell/proc/give_holosphere_actions()
	var/datum/action/holosphere/toggle_transform/toggle_transform = new(src)
	toggle_transform.grant(actions_innate)

/mob/living/simple_mob/holosphere_shell/strip_menu_act(mob/user, action)
	return hologram.strip_menu_act(arglist(args))

/mob/living/simple_mob/holosphere_shell/strip_menu_options(mob/user)
	return hologram.strip_menu_options(arglist(args))

/mob/living/simple_mob/holosphere_shell/strip_interaction_prechecks(mob/user, autoclose, allow_loc)
	allow_loc = TRUE
	return hologram.strip_interaction_prechecks(arglist(args))

/mob/living/simple_mob/holosphere_shell/open_strip_menu(mob/user)
	return hologram.open_strip_menu(arglist(args))

/mob/living/simple_mob/holosphere_shell/close_strip_menu(mob/user)
	return hologram.close_strip_menu(arglist(args))

/mob/living/simple_mob/holosphere_shell/request_strip_menu(mob/user)
	return hologram.request_strip_menu(arglist(args))

/mob/living/simple_mob/holosphere_shell/render_strip_menu(mob/user)
	return hologram.render_strip_menu(arglist(args))

/mob/living/simple_mob/holosphere_shell/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	var/mob/living/L = user
	if(!istype(L))
		return
	if(L.a_intent == INTENT_HELP)
		get_scooped(L)
	else
		..()

/mob/living/simple_mob/holosphere_shell/inducer_scan(obj/item/inducer/I, list/things_to_induce = list(), inducer_flags)
	. = ..()
	things_to_induce += src

/mob/living/simple_mob/holosphere_shell/inducer_act(obj/item/inducer/I, amount, inducer_flags)
	. = ..()
	var/needed = (hologram.species.max_nutrition - nutrition)
	if(needed <= 0)
		return
	var/got = min((((amount * GLOB.cellrate) / SYNTHETIC_NUTRITION_KJ_PER_UNIT) * SYNTHETIC_NUTRITION_INDUCER_CHEAT_FACTOR), needed)
	hologram.adjust_nutrition(got)
	return (got * SYNTHETIC_NUTRITION_KJ_PER_UNIT) / GLOB.cellrate / SYNTHETIC_NUTRITION_INDUCER_CHEAT_FACTOR

/mob/living/simple_mob/holosphere_shell/proc/handle_hologram_shell_speech(datum/source, list/message_args)
	var/message = message_args["message"]
	var/language_name = message_args["language_name"]
	var/language_flags = message_args["language_flags"]
	message_args["message"] = hologram.handle_autohiss(message, language_name, language_flags, TRUE)

/mob/living/simple_mob/holosphere_shell/say_understands()
	return hologram?.say_understands(arglist(args)) || ..()
