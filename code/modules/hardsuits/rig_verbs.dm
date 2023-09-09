/obj/item/hardsuit/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	user?.client?.queue_legacy_verb_update()

/obj/item/hardsuit/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	user?.client?.queue_legacy_verb_update()

// Interface for humans.
/obj/item/hardsuit/verb/hardsuit_interface()

	set name = "Open Hardsuit Interface"
	set desc = "Open the hardsuit system interface."
	set category = "Hardsuit"
	set src = usr.contents

	if(wearer && (wearer.back == src || wearer.belt == src))
		nano_ui_interact(usr)

/obj/item/hardsuit/verb/toggle_vision()

	set name = "Toggle Visor"
	set desc = "Turns your hardsuit visor off or on."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!is_activated())
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(!check_power_cost(usr))
		return

	if(!check_suit_access(usr))
		return

	if(!visor)
		to_chat(usr, "<span class='warning'>The hardsuit does not have a configurable visor.</span>")
		return

	if(!visor.active)
		visor.activate()
	else
		visor.deactivate()

/obj/item/hardsuit/proc/toggle_helmet()

	set name = "Toggle Helmet"
	set desc = "Deploys or retracts your helmet."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	toggle_piece("helmet",wearer)

/obj/item/hardsuit/proc/toggle_chest()

	set name = "Toggle Chestpiece"
	set desc = "Deploys or retracts your chestpiece."
	set category = "Hardsuit"
	set src = usr.contents

	if(!check_suit_access(usr))
		return

	toggle_piece("chest",wearer)

/obj/item/hardsuit/proc/toggle_gauntlets()

	set name = "Toggle Gauntlets"
	set desc = "Deploys or retracts your gauntlets."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	toggle_piece("gauntlets",wearer)

/obj/item/hardsuit/proc/toggle_boots()

	set name = "Toggle Boots"
	set desc = "Deploys or retracts your boots."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	toggle_piece("boots",wearer)

/obj/item/hardsuit/verb/deploy_suit()

	set name = "Deploy Hardsuit"
	set desc = "Deploys helmet, gloves and boots."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	if(!check_power_cost(usr))
		return

	deploy(wearer)

/obj/item/hardsuit/verb/toggle_seals_verb()

	set name = "Toggle Hardsuit"
	set desc = "Activates or deactivates your hardsuit."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	toggle_seals(wearer)

/obj/item/hardsuit/verb/switch_vision_mode()

	set name = "Switch Vision Mode"
	set desc = "Switches between available vision modes."
	set category = "Hardsuit"
	set src = usr.contents

	if(!is_activated())
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(malfunction_check(usr))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	if(!visor)
		to_chat(usr, "<span class='warning'>The hardsuit does not have a configurable visor.</span>")
		return

	if(!visor.active)
		visor.activate()

	if(!visor.active)
		to_chat(usr, "<span class='warning'>The visor is suffering a hardware fault and cannot be configured.</span>")
		return

	visor.engage()

/obj/item/hardsuit/verb/alter_voice()

	set name = "Configure Voice Synthesizer"
	set desc = "Toggles or configures your voice synthesizer."
	set category = "Hardsuit"
	set src = usr.contents

	if(!is_activated())
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(malfunction_check(usr))
		return

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!speech)
		to_chat(usr, "<span class='warning'>The hardsuit does not have a speech synthesizer.</span>")
		return

	speech.engage()

/obj/item/hardsuit/verb/select_module()

	set name = "Select Module"
	set desc = "Selects a module as your primary system."
	set category = "Hardsuit"
	set src = usr.contents

	if(!is_activated())
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(malfunction_check(usr))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	var/list/selectable = list()
	for(var/obj/item/hardsuit_module/module in installed_modules)
		if(module.selectable)
			selectable |= module

	var/obj/item/hardsuit_module/module = input("Which module do you wish to select?") as null|anything in selectable

	if(!istype(module))
		selected_module = null
		to_chat(usr, "<font color=#4F49AF><b>Primary system is now: deselected.</b></font>")
		return

	selected_module = module
	to_chat(usr, "<font color=#4F49AF><b>Primary system is now: [selected_module.interface_name].</b></font>")

/obj/item/hardsuit/verb/toggle_module()

	set name = "Toggle Module"
	set desc = "Toggle a system module."
	set category = "Hardsuit"
	set src = usr.contents

	if(!is_activated())
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(malfunction_check(usr))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	var/list/selectable = list()
	for(var/obj/item/hardsuit_module/module in installed_modules)
		if(module.toggleable)
			selectable |= module

	var/obj/item/hardsuit_module/module = input("Which module do you wish to toggle?") as null|anything in selectable

	if(!istype(module))
		return

	if(module.active)
		to_chat(usr, "<font color=#4F49AF><b>You attempt to deactivate \the [module.interface_name].</b></font>")
		module.deactivate()
	else
		to_chat(usr, "<font color=#4F49AF><b>You attempt to activate \the [module.interface_name].</b></font>")
		module.activate()

/obj/item/hardsuit/verb/engage_module()

	set name = "Engage Module"
	set desc = "Engages a system module."
	set category = "Hardsuit"
	set src = usr.contents

	if(!is_activated())
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(malfunction_check(usr))
		return

	if(!istype(wearer) || (!wearer.back == src && !wearer.belt == src))
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	var/list/selectable = list()
	for(var/obj/item/hardsuit_module/module in installed_modules)
		if(module.usable)
			selectable |= module

	var/obj/item/hardsuit_module/module = input("Which module do you wish to engage?") as null|anything in selectable

	if(!istype(module))
		return

	to_chat(usr, "<font color=#4F49AF><b>You attempt to engage the [module.interface_name].</b></font>")
	module.engage()
