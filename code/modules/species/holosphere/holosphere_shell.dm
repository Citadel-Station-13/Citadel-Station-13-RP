/// holosphere 'sphere'
/mob/living/simple_mob/holosphere_shell
	name = "holosphere shell"
	desc = "A holosphere shell."

	icon = 'icons/mob/species/holosphere/holosphere.dmi'
	icon_state = "holosphere_body"

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

	var/eye_icon_state = "holosphere_eye"
	var/eye_color = rgb(255,255,255)

	// space movement related
	var/last_space_movement = 0

	// the transform component we are used with
	var/datum/component/custom_transform/transform_component
	// the human we belong to
	var/mob/living/carbon/human/hologram

/mob/living/simple_mob/holosphere_shell/regenerate_icons()
	cut_overlays()
	var/image/eye_icon = image('icons/mob/species/holosphere/holosphere.dmi',eye_icon_state)
	eye_icon.color = eye_color
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
