
///Don't ask why it's here, I just know it won't work without it. This is my personnal coconut.jpg - Papalus
//GLOBAL_LIST_INIT(full_alphabet, list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"))
//#define PROTOCOL_ARTICLE "Protocol article [rand(100,999)]-[uppertext(pick(GLOB.full_alphabet))] subsection #[rand(10,99)]"

/obj/item/organ/internal/brain/adherent
	name = "mentality matrix"
	desc = "The self-contained, self-supporting internal 'brain' of an Adherent unit."
	icon = 'icons/mob/human_races/adherent/organs.dmi'
	icon_state = "brain"
	organ_tag = O_BRAIN
	robotic = ORGAN_CRYSTAL

/*
/obj/item/organ/internal/brain/adherent/attack_self(var/mob/user)
	. = ..()
	if(.)
		var/regex/name_regex = regex("\[A-Z\]{2}-\[A-Z\]{1} \[0-9\]{4}")
		name_regex.Find(owner.real_name)
		if(world.time < next_rename)
			to_chat(owner, "<span class='warning'>[PROTOCOL_ARTICLE] forbids changing your ident again so soon.</span>")
			return
		var/res = name_regex.match
		if(isnull(res))
			to_chat(user, "<span class='warning'>Nonstandard names are not subject to real-time modification under [PROTOCOL_ARTICLE].</span>")
			return
		var/newname = sanitizeSafe(input(user, "Enter a new ident.", "Reset Ident") as text, MAX_NAME_LEN)
		if(newname)
			var/confirm = input(user, "Are you sure you wish your name to become [newname] [res]?","Reset Ident") as anything in list("No", "Yes")
			if(confirm == "Yes" && owner && user == owner && !owner.incapacitated() && world.time >= next_rename)
				next_rename = world.time + rename_delay
				owner.real_name = "[newname] [res]"
				if(owner.mind)
					owner.mind.name = owner.real_name
				owner.SetName(owner.real_name)
				to_chat(user, "<span class='notice'>You are now designated <b>[owner.real_name]</b>.</span>")
*/
/obj/item/organ/internal/powered
	icon = 'icons/mob/human_races/adherent/organs.dmi'
	var/maintenance_cost = 0.5
	var/base_action_state
	var/active = FALSE
	var/use_descriptor
	robotic = ORGAN_CRYSTAL

/obj/item/organ/internal/powered/process()
	. = ..()
	if(owner)
		if(active)
			if(owner.nutrition > 0)
				owner.adjust_nutrition(-maintenance_cost)
				active = FALSE
				to_chat(owner, "<span class='danger'>Your [name] [gender == PLURAL ? "are" : "is"] out of power!</span>")
				refresh_action_button()

/obj/item/organ/internal/powered/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "[base_action_state]-[active ? "on" : "off"]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/internal/powered/attack_self(var/mob/user)
	. = ..()
	if(.)
		playsound(user, sound('sound/effects/ding.ogg'))
		if(is_broken())
			to_chat(owner, "<span class='warning'>\The [src] [gender == PLURAL ? "are" : "is"] too damaged to function.</span>")
			active = FALSE
		else
			active = !active
			to_chat(owner, "<span class='notice'>You are [active ? "now" : "no longer"] using your [name] to [use_descriptor].</span>")
		refresh_action_button()

/obj/item/organ/internal/powered/jets
	name = "maneuvering jets"
	desc = "Gas jets from a Adherent chassis."
	action_button_name = "Toggle Maneuvering Pack"
	use_descriptor = "adjust your vector"
	organ_tag = BP_JETS
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
		to_chat(C, "<span class='notice'>You lack the energy to fly.</span>")
		return
	owner.pass_flags ^= PASSTABLE
	C.flying = !C.flying
	C.update_floating()
	to_chat(C, "<span class='notice'>You have [C.flying?"started":"stopped"] flying.</span>")

/obj/item/organ/internal/powered/jets/process()
	var/mob/living/carbon/human/C = src.owner
	if(active)
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
	icon = 'icons/mob/human_races/adherent/organs.dmi'
//	eye_icon = 'icons/mob/human_races/adherent/eyes.dmi'
	icon_state = "eyes"
	robotic = ORGAN_CRYSTAL
	organ_tag = O_EYES
	innate_flash_protection = FLASH_PROTECTION_MAJOR

/obj/item/organ/internal/eyes/adherent/Initialize(mapload)
	. = ..()
	verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color

/obj/item/organ/internal/cell/adherent
	name = "piezoelectric core"
	icon = 'icons/mob/human_races/adherent/organs.dmi'
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
	owner.pass_flags ^= PASSTABLE
	C.flying = !C.flying
	C.update_floating()
	to_chat(C, "<span class='notice'>You have [C.flying?"started":"stopped"] flying.</span>")*/

/obj/item/organ/internal/powered/float/proc/hover()
	set name = "Hover"
	set desc = "Allows you to stop gliding and hover. This will take a fair amount of energy to perform."
	set category = "Abilities"

	var/mob/living/carbon/human/C = src.owner
	if(!C.flying)
		to_chat(src, "You must be flying to hover!")
		return
	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(src, "You cannot hover in your current state!")
		return
	if(C.nutrition < 50 && !C.flying) //Don't have any food in you?" You can't hover, since it takes up 25 nutrition. And it's not 25 since we don't want them to immediately fall.
		to_chat(C, "<span class='notice'>You lack the energy to fly.</span>")
		return
	if(C.anchored)
		to_chat(C, "<span class='notice'>You are already hovering and/or anchored in place!</span>")
		return

	if(!C.anchored && !C.pulledby) //Not currently anchored, and not pulled by anyone.
		C.anchored = 1 //This is the only way to stop the inertial_drift.
		C.nutrition -= 25
		C.update_floating()
		to_chat(C, "<span class='notice'>You hover in place.</span>")
		spawn(6) //.6 seconds.
			C.anchored = 0
	else
		return
