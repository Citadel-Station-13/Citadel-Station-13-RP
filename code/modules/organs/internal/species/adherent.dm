/obj/item/organ/internal/brain/adherent
	name = "mentality matrix"
	desc = "The self-contained, self-supporting internal 'brain' of an Adherent unit."
	icon = 'icons/mob/species/adherent/organs.dmi'
	icon_state = "brain"
	organ_tag = O_BRAIN
	robotic = ORGAN_CRYSTAL

/obj/item/organ/internal/powered
	icon = 'icons/mob/species/adherent/organs.dmi'
	robotic = ORGAN_CRYSTAL

	var/maintenance_cost = 0.5
	var/base_action_state
	var/active = FALSE
	var/use_descriptor

/obj/item/organ/internal/powered/process(delta_time)
	. = ..()

	if(!owner)
		return
	if(!active)
		return

	if(owner.nutrition > 0)
		owner.adjust_nutrition(-maintenance_cost)
		active = FALSE
		to_chat(owner, SPAN_DANGER("Your [name] [gender == PLURAL ? "are" : "is"] out of power!"))
		refresh_action_button()

/obj/item/organ/internal/powered/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "[base_action_state]-[active ? "on" : "off"]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/internal/powered/attack_self(mob/user)
	. = ..()
	if(.)
		playsound(user, sound('sound/effects/ding.ogg'))
		if(is_broken())
			to_chat(owner, SPAN_WARNING("\The [src] [gender == PLURAL ? "are" : "is"] too damaged to function."))
			active = FALSE
		else
			active = !active
			to_chat(owner, SPAN_NOTICE("You are [active ? "now" : "no longer"] using your [name] to [use_descriptor]."))
		refresh_action_button()


/obj/item/organ/internal/powered/jets
	name = "maneuvering jets"
	desc = "Gas jets from a Adherent chassis."
	action_button_name = "Toggle Maneuvering Pack"
	use_descriptor = "adjust your vector"
	organ_tag = O_JETS
	parent_organ = BP_TORSO
	robotic = ORGAN_CRYSTAL
	gender = PLURAL
	icon_state = "jets"
	base_action_state = "adherent-pack"
	maintenance_cost = 0.2

/obj/item/organ/internal/powered/jets/Initialize(mapload)
	. = ..()
	//verbs |= /obj/item/organ/internal/powered/jets/proc/activatej

/obj/item/organ/internal/powered/jets/ui_action_click()
	activatej()

/obj/item/organ/internal/powered/jets/proc/activatej()
	/*set name = "Toggle Maneuvering Pack"
	set desc = "Toggles your manuevering jets"
	set category = "Abilities"*/

	var/mob/living/carbon/human/C = src.owner
	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(C, "You cannot fly in this state!")
		return
	if(C.nutrition < 25 && !C.flying) //Don't have any food in you?" You can't fly.
		to_chat(C, SPAN_NOTICE("You lack the energy to fly."))
		return
	owner.pass_flags ^= ATOM_PASS_TABLE
	C.flying = !C.flying
	C.update_floating()
	to_chat(C, SPAN_NOTICE("You have [C.flying?"started":"stopped"] flying."))

/obj/item/organ/internal/powered/jets/process(delta_time)
	var/mob/living/carbon/human/C = src.owner
	if(!active)
		return
	C.nutrition = C.nutrition - maintenance_cost

/obj/item/organ/internal/powered/float
	name = "levitation plate"
	desc = "A broad, flat disc of exotic matter. Slick to the touch."
	action_button_name = "Toggle Antigravity"
	organ_tag = O_FLOAT
	parent_organ = BP_GROIN
	robotic = ORGAN_CRYSTAL
	icon_state = "float"
	use_descriptor = "hover"
	base_action_state = "adherent-float"

/obj/item/organ/internal/powered/float/Initialize(mapload)
	. = ..()
	//verbs |= /obj/item/organ/internal/powered/float/proc/flying_toggle
	verbs |= /obj/item/organ/internal/powered/float/proc/hover

/obj/item/organ/internal/powered/float/ui_action_click()
	hover()
/obj/item/organ/internal/eyes/adherent
	name = "receptor prism"
	icon = 'icons/mob/species/adherent/organs.dmi'
//	eye_icon = 'icons/mob/species/adherent/eyes.dmi'
	icon_state = "eyes"
	robotic = ORGAN_CRYSTAL
	organ_tag = O_EYES
	innate_flash_protection = FLASH_PROTECTION_MAJOR


/obj/item/organ/internal/eyes/adherent/Initialize(mapload)
	. = ..()
	verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color


/obj/item/organ/internal/cell/adherent
	name = "piezoelectric core"
	icon = 'icons/mob/species/adherent/organs.dmi'
	icon_state = "cell"
	organ_tag = O_CELL
	status = ORGAN_CRYSTAL


/obj/item/organ/internal/powered/cooling_fins
	name = "cooling fins"
	gender = PLURAL
	desc = "A lacy filligree of heat-radiating fins."
	action_button_name = "Toggle Cooling"
	organ_tag = O_COOLING_FINS
	parent_organ = BP_GROIN
	status = ORGAN_CRYSTAL
	icon_state = "fins"
	maintenance_cost = 0
	use_descriptor = "radiate heat"
	base_action_state = "adherent-fins"

	var/cooling = FALSE
	var/max_cooling = 10
	var/target_temp = T20C

/obj/item/organ/internal/powered/cooling_fins/Initialize(mapload)
	. = ..()
	verbs |= /obj/item/organ/internal/powered/cooling_fins/proc/activatecf

/obj/item/organ/internal/powered/cooling_fins/ui_action_click()
	activatecf()

/obj/item/organ/internal/powered/cooling_fins/proc/activatecf()
	var/mob/living/carbon/human/C = src.owner
	set name = "Toggle Cooling Fins"
	set desc = "Turns on your onboard cooling fin array."
	set category = "Abilities"

	cooling = !cooling
	to_chat(C, "You toggle your cooling fans [cooling ? "on" : "off"] ")

/obj/item/organ/internal/powered/cooling_fins/process(delta_time)
	var/mob/living/carbon/human/C = src.owner
	if(cooling)
		var/temp_diff = min(C.bodytemperature - target_temp, max_cooling)
		if(temp_diff >= 1)
			maintenance_cost = max(temp_diff, 1)
			C.bodytemperature -= temp_diff
		else
			maintenance_cost = 0


/obj/item/organ/internal/powered/float/proc/flying_toggle()
	/*set name = "Toggle Flight"
	set desc = "While flying over open spaces, you will use up some energy. If you run out energy, you will fall. Additionally, you can't fly if you are too heavy."
	set category = "Abilities"

	var/mob/living/carbon/human/C = src.owner
	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(C, "You cannot fly in this state!")
		return
	if(C.nutrition < 25 && !C.flying) //Don't have any food in you?" You can't fly.
		to_chat(C, "<span class='notice'>You lack the energy to fly.</span>")
		return
	owner.pass_flags ^= ATOM_PASS_TABLE
	C.flying = !C.flying
	C.update_floating()
	to_chat(C, "<span class='notice'>You have [C.flying?"started":"stopped"] flying.</span>")*/

/obj/item/organ/internal/powered/float/proc/hover()
	set name = "Hover"
	set desc = "Allows you to stop gliding and hover. This will take a fair amount of energy to perform."
	set category = "Abilities"

	var/mob/living/carbon/human/C = src.owner
	if(!C.flying)
		to_chat(src, SPAN_NOTICE("You must be flying to hover!"))
		return

	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(src, SPAN_NOTICE("You cannot hover in your current state!"))
		return

	// Don't have any food in you?" You can't hover, since it takes up 25 nutrition. And it's not 25 since we don't want them to immediately fall.
	if(C.nutrition < 50 && !C.flying)
		to_chat(C, SPAN_NOTICE("You lack the energy to fly."))
		return

	if(C.anchored)
		to_chat(C, SPAN_NOTICE("You are already hovering and/or anchored in place!"))
		return

	// Not currently anchored, and not pulled by anyone.
	if(!C.anchored && !C.pulledby)
		C.anchored = TRUE //This is the only way to stop the inertial_drift.
		C.nutrition -= 25
		C.update_floating()
		to_chat(C, SPAN_NOTICE("You hover in place."))
		spawn(6) //.6 seconds.
			C.anchored = FALSE
	else
		return
