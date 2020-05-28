//A switchblade with a little switch to switch blades, to switch from a six to a sixteen inch blade
//Switchtools and holotools, ported from vg and updated a bit. Switchtools are from R&D, surgery switchtool is also from R&D, admin holotool is self-explainitory, CE holotool is CE-only in his locker.
/obj/item/switchtool
	name = "switchtool"
	icon = 'icons/obj/switchtool.dmi'
	icon_state = "switchtool"
	desc = "A multi-deployable, multi-instrument, finely crafted multi-purpose tool. The envy of engineers everywhere."
	siemens_coefficient = 1
	force = 3
	w_class = ITEMSIZE_SMALL
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_switchtool.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_switchtool.dmi')
	var/deploy_sound = "sound/weapons/switchblade.ogg"
	var/undeploy_sound = "sound/weapons/switchblade.ogg"
	throwforce = 6.0
	throw_speed = 3
	throw_range = 6

	//the colon separates the typepath from the name
	var/list/obj/item/start_modules = list(/obj/item/tool/screwdriver/switchy = null,
											/obj/item/tool/wrench/switchy = null,
											/obj/item/tool/wirecutters/switchy = null,
											/obj/item/tool/crowbar/switchy = null,
											/obj/item/multitool/switchy = null)
	var/list/obj/item/stored_modules = list()
	var/obj/item/deployed//what's currently in use
	var/switchingtype = "basic"//type for update_icon

/obj/item/switchtool/resolve_attackby(atom/A, mob/user, params, attack_modifier = 1)
	if(istype(A, /obj/item/storage))//we place automatically
		return ..()
	if(istype(A, /atom/movable))
		var/atom/movable/AM = A
		if(deployed)
			return AM.attackby(deployed, user, params, attack_modifier)

/obj/item/switchtool/New()
	..()
	for(var/module in start_modules)//making the modules
		stored_modules |= new module(src)

/obj/item/switchtool/examine()
	..()
	to_chat(usr, "This one is capable of holding [get_formatted_modules()].")

/obj/item/switchtool/attack_self(mob/user)
	if(!user)
		return

	if(deployed)
		to_chat(user, "You store \the [deployed].")
		undeploy()
	else
		choose_deploy(user)

//makes the string list of modules ie "a screwdriver, a knife, and a clown horn"
//does not end with a full stop, but does contain commas
/obj/item/switchtool/proc/get_formatted_modules()
	var/counter = 0
	var/module_string = ""
	for(var/obj/item/module in stored_modules)
		counter++
		if(counter == stored_modules.len)
			module_string += "and \a [module.name]"
		else
			module_string += "\a [module.name], "
	return module_string

/obj/item/switchtool/proc/undeploy()
	playsound(get_turf(src), undeploy_sound, 10, 1)
	deployed = null
	cut_overlays()
	w_class = initial(w_class)
	update_icon()

/obj/item/switchtool/proc/deploy(var/module)
	if(!(module in stored_modules))
		return FALSE
	if(deployed)
		return FALSE
	playsound(get_turf(src), deploy_sound, 10, 1)
	deployed = module
	update_icon()
	if(istype(deployed, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = deployed
		W.setWelding(1)
	return TRUE

/obj/item/switchtool/proc/choose_deploy(mob/user)
	var/list/potential_modules = list()
	for(var/obj/item/module in stored_modules)
		potential_modules += module.name

	if(!potential_modules.len)
		to_chat(user, "No modules to deploy.")
		return

	else if(potential_modules.len == 1)
		deploy(potential_modules[1])
		to_chat(user, "You deploy \the [potential_modules[1]]")
		return TRUE

	else
		var/chosen_module = input(user,"What do you want to deploy?", "[src]", "Cancel") as anything in potential_modules
		if(chosen_module != "Cancel")
			var/true_module = ""
			for(var/obj/item/checkmodule in stored_modules)
				if(checkmodule.name == chosen_module)
					true_module = checkmodule
					break
			if(deploy(true_module))
				to_chat(user, "You deploy \the [deployed].")
			return TRUE
		return

/obj/item/switchtool/handle_shield(mob/user)
	if(deployed.deploytype == "shield")
		return TRUE
	return FALSE

/obj/item/switchtool/is_crowbar()
	if(deployed && deployed.deploytype == "crowbar")
		return TRUE
	return FALSE

/obj/item/switchtool/is_screwdriver()
	if(deployed && deployed.deploytype == "screwdriver")
		return TRUE
	return FALSE

/obj/item/switchtool/is_wrench()
	if(deployed && deployed.deploytype == "wrench")
		return TRUE
	return FALSE

/obj/item/switchtool/is_wirecutter()
	if(deployed && deployed.deploytype == "wirecutters")
		return TRUE
	return FALSE

/obj/item/switchtool/is_multitool()
	if(deployed && deployed.deploytype == "multitool")
		return TRUE
	return FALSE

/obj/item/switchtool/is_welder()
	if(deployed && deployed.deploytype == "welder")
		return TRUE
	return FALSE

/obj/item/switchtool/update_icon()//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	. = ..()
	var/mutable_appearance/tool_overlay
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(deployed)
		switch(switchingtype)
			if("basic")
				switch(deployed.deploytype)
					if("screwdriver")
						tool_overlay = mutable_appearance(icon, "[icon_state]_driver")
					if("wrench")
						tool_overlay = mutable_appearance(icon, "[icon_state]_wrench")
					if("crowbar")
						tool_overlay = mutable_appearance(icon, "[icon_state]_crowbar")
					if("wirecutter")
						tool_overlay = mutable_appearance(icon, "[icon_state]_cutter")
					if("multitool")
						tool_overlay = mutable_appearance(icon, "[icon_state]_multitool")
			if("surgery")
				switch(src.deployed.deploytype)
					if("scalpel")
						tool_overlay = mutable_appearance(icon, "[icon_state]_scalpel")
					if("saw")
						tool_overlay = mutable_appearance(icon, "[icon_state]_saw")
					if("drill")
						tool_overlay = mutable_appearance(icon, "[icon_state]_drill")
					if("cautery")
						tool_overlay = mutable_appearance(icon, "[icon_state]_cautery")
					if("hemostat")
						tool_overlay = mutable_appearance(icon, "[icon_state]_hemostat")
					if("retractor")
						tool_overlay = mutable_appearance(icon, "[icon_state]_retractor")
					if("bone_clamp")
						tool_overlay = mutable_appearance(icon, "[icon_state]_bone_clamp")
			if("ce")
				switch(src.deployed.deploytype)
					if("driver")
						tool_overlay = mutable_appearance(icon, "[icon_state]_driver")
					if("wrench")
						tool_overlay = mutable_appearance(icon, "[icon_state]_wrench")
					if("crowbar")
						tool_overlay = mutable_appearance(icon, "[icon_state]_crowbar")
					if("wirecutters")
						tool_overlay = mutable_appearance(icon, "[icon_state]_wirecutters")
					if("multitool")
						tool_overlay = mutable_appearance(icon, "[icon_state]_multitool")
					if("welder")
						tool_overlay = mutable_appearance(icon, "[icon_state]_welder")
					if("light")
						tool_overlay = mutable_appearance(icon, "[icon_state]_light")
					if("soap")
						tool_overlay = mutable_appearance(icon, "[icon_state]_soap")
			if("adminholo")
				switch(src.deployed.deploytype)
					if("light")
						tool_overlay = mutable_appearance(icon, "[icon_state]_lamp")
					if("soap")
						tool_overlay = mutable_appearance(icon, "[icon_state]_soap")
					if("scalpel")
						tool_overlay = mutable_appearance(icon, "[icon_state]_scalpel")
					if("saw")
						tool_overlay = mutable_appearance(icon, "[icon_state]_saw")
					if("drill")
						tool_overlay = mutable_appearance(icon, "[icon_state]_drill")
					if("cautery")
						tool_overlay = mutable_appearance(icon, "[icon_state]_cautery")
					if("hemostat")
						tool_overlay = mutable_appearance(icon, "[icon_state]_hemostat")
					if("retractor")
						tool_overlay = mutable_appearance(icon, "[icon_state]_retractor")
					if("boneclamp")
						tool_overlay = mutable_appearance(icon, "[icon_state]_boneclamp")
					if("driver")
						tool_overlay = mutable_appearance(icon, "[icon_state]_driver")
					if("wrench")
						tool_overlay = mutable_appearance(icon, "[icon_state]_wrench")
					if("crowbar")
						tool_overlay = mutable_appearance(icon, "[icon_state]_crowbar")
					if("wirecutters")
						tool_overlay = mutable_appearance(icon, "[icon_state]_wirecutters")
					if("multitool")
						tool_overlay = mutable_appearance(icon, "[icon_state]_multitool")
					if("welder")
						tool_overlay = mutable_appearance(icon, "[icon_state]_welder")
					if("shield")
						tool_overlay = mutable_appearance(icon, "[icon_state]_shield")
					if("sword")
						tool_overlay = mutable_appearance(icon, "[icon_state]_blade")
		add_overlay(tool_overlay)
	if(istype(usr,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr
		H.update_inv_l_hand()
		H.update_inv_r_hand()

/obj/item/switchtool/surgery
	name = "surgeon's switchtool"
	icon_state = "surgery_switchtool"
	desc = "A switchtool containing most of the necessary items for impromptu surgery. For the surgeon on the go."
	start_modules = list(/obj/item/surgical/scalpel/switchy = null,
						/obj/item/surgical/hemostat/switchy = null,
						/obj/item/surgical/retractor/switchy = null,
						/obj/item/surgical/bonesetter/switchy = null)
	switchingtype = "surgery"

//Unique adminspawn switchtool. Has all the tools.
/obj/item/switchtool/holo
	name = "Tool"
	icon_state = "holo_switchtool"
	item_state = "holoswitchtool"
	desc = "An object that can take on the holographic hardlight form of nearly any tool in use today."
	description_fluff = "Mankind's first tool was likely a blade crudely shaped from flint. Versatile, at the time - one could skin creatures, use it as a weapon, hack at trees and cut plants. This is, potentially, mankind's last tool- able to be dynamically upgraded to support different holoprojector setups, allowing even more tools to be used by one device, once a working holoprojector setup for an application is implemented."
	var/brightness_max = 4
	var/brightness_min = 2
	deploy_sound = "sound/weapons/switchsound.ogg"
	undeploy_sound = "sound/weapons/switchsound.ogg"
	light_color =  LIGHT_COLOR_CYAN

	start_modules = list(
						/obj/item/surgical/scalpel/laser3/holoswitch = null,
						/obj/item/surgical/circular_saw/holoswitch = null,
						/obj/item/surgical/surgicaldrill/holoswitch = null,
						/obj/item/surgical/cautery/holoswitch = null,
						/obj/item/surgical/hemostat/holoswitch = null,
						/obj/item/surgical/retractor/holoswitch = null,
						/obj/item/surgical/bone_clamp/holoswitch = null,
						/obj/item/tool/screwdriver/holoswitch = null,
						/obj/item/tool/wrench/holoswitch = null,
						/obj/item/tool/crowbar/holoswitch = null,
						/obj/item/tool/wirecutters/holoswitch = null,
						/obj/item/weldingtool/holoswitch = null,
						/obj/item/multitool/holoswitch = null,
						/obj/item/flashlight/holoswitch = null,
						/obj/item/soap/holoswitch = null,
						/obj/item/melee/energy/sword/holoswitch = null,
						/obj/item/shield/holoswitch = null)

/obj/item/switchtool/holo/deploy(var/obj/item/module) //We lightin' it up in here
	if(module.deploytype == "flashlight")
		set_light(brightness_max, 4, light_color)
	else
		set_light(brightness_min, 1, light_color)
/obj/item/switchtool/holo/undeploy()
	set_light(0)


/obj/item/switchtool/holo/CE
	name = "Chief Engineer's holotool"
	icon_state = "ce_switchtool"
	item_state = "ceswitchtool"
	desc = "A finely crafted device that uses a micro-scale hardlight emitter to form hardlight manipulators in the form of tools. Can also operate in low-power mode as a flashlight and in high-power mode as a UV cleaner."
	light_color =  LIGHT_COLOR_ORANGE

	start_modules = list(
						/obj/item/tool/screwdriver/holoswitch = null,
						/obj/item/tool/wrench/holoswitch = null,
						/obj/item/tool/crowbar/holoswitch = null,
						/obj/item/tool/wirecutters/holoswitch = null,
						/obj/item/weldingtool/holoswitch = null,
						/obj/item/multitool/holoswitch = null,
						/obj/item/flashlight/holoswitch = null,
						/obj/item/soap/holoswitch = null)
	switchingtype = "ce"

//Actual tools go here.

/obj/item/soap/holoswitch
	name = "holographically contained UV light"
	desc = "This should not exist."
	deploytype = "soap"

/obj/item/flashlight/holoswitch
	name = "low-power holoemitter"
	desc = "This should not exist"
	power_use = 0
	deploytype = "flashlight"

/obj/item/tool/screwdriver/holoswitch
	name = "hardlight screwdriver"
	desc = "This should not exist."
	deploytype = "screwdriver"
	toolspeed = 0.9

/obj/item/tool/wrench/holoswitch
	name = "hardlight bolt driver"
	desc = "This should not exist."
	deploytype = "wrench"
	toolspeed = 0.9

/obj/item/tool/crowbar/holoswitch
	name = "hardlight pry bar"
	desc = "This should not exist."
	deploytype = "crowbar"
	toolspeed = 0.9

/obj/item/tool/wirecutters/holoswitch
	name = "hardlight wire cutting tool"
	desc = "This should not exist."
	deploytype = "wirecutter"
	toolspeed = 0.9

/obj/item/weldingtool/holoswitch
	name = "laser welding tool"
	desc = "This should not exist."
	deploytype = "welder"
	toolspeed = 0.9
	var/nextrefueltick = 0

/obj/item/multitool/holoswitch
	name = "hardlight electromagnetic microinducer"
	desc = "This should not exist."
	deploytype = "multitool"

/obj/item/weldingtool/holoswitch/process()
	..()
	if(get_fuel() < get_max_fuel() && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent("fuel", 1)

/obj/item/surgical/scalpel/laser3/holoswitch
	name = "hybrid hardlight-laser scalpel"
	desc = "This should not exist."
	deploytype = "scalpel"
	toolspeed = 0.9

/obj/item/surgical/retractor/holoswitch
	name = "hardlight retractor"
	desc = "This should not exist."
	deploytype = "retractor"
	toolspeed = 0.9

/obj/item/surgical/hemostat/holoswitch
	name = "hardlight haemostat"
	desc = "This should not exist."
	deploytype = "hemostat"
	toolspeed = 0.9

/obj/item/surgical/cautery/holoswitch
	name = "laser cautery"
	desc = "This should not exist."
	deploytype = "cautery"
	toolspeed = 0.9

/obj/item/surgical/circular_saw/holoswitch
	name = "hardlight saw"
	desc = "This should not exist."
	deploytype = "saw"
	toolspeed = 0.9

/obj/item/surgical/surgicaldrill/holoswitch
	name = "hardlight surgical drill"
	desc = "This should not exist."
	deploytype = "drill"
	toolspeed = 0.9

/obj/item/surgical/bone_clamp/holoswitch
	name = "hardlight bone rectifier"
	desc = "This should not exist."
	deploytype = "boneclamp"
	toolspeed = 0.9

/obj/item/melee/energy/sword/holoswitch
	name = "hardlight blade"
	desc = "This should not exist."
	deploytype = "sword"

/obj/item/shield/holoswitch
	name = "hardlight shield"
	desc = "This should not exist."
	deploytype = "shield"

/obj/item/soap/holoswitch/pre_attack()
	. = ..()
	wet()

/obj/item/tool/screwdriver/switchy
	name = "switchtool screwdriver"
	desc = "This should not exist."
	deploytype = "screwdriver"
	toolspeed = 1.2

/obj/item/tool/wrench/switchy
	name = "switchtool wrench"
	desc = "This should not exist."
	deploytype = "wrench"
	toolspeed = 1.2

/obj/item/tool/crowbar/switchy
	name = "switchtool crowbar"
	desc = "This should not exist."
	deploytype = "crowbar"
	toolspeed = 1.2

/obj/item/tool/wirecutters/switchy
	name = "switchtool cutters"
	desc = "This should not exist."
	deploytype = "wirecutters"
	toolspeed = 1.2

/obj/item/multitool/switchy
	name = "switchtool micro-multitool"
	desc = "This should not exist."
	deploytype = "multitool"

/obj/item/surgical/scalpel/switchy
	name = "switchtool scalpel"
	desc = "This should not exist."
	deploytype = "scalpel"
	toolspeed = 1.2

/obj/item/surgical/hemostat/switchy
	name = "switchtool hemostat"
	desc = "This should not exist."
	deploytype = "hemostat"
	toolspeed = 1.2

/obj/item/surgical/retractor/switchy
	name = "switchtool retractor"
	desc = "This should not exist."
	deploytype = "retractor"
	toolspeed = 1.2

/obj/item/surgical/bonesetter/switchy
	name = "switchtool bone setter"
	desc = "This should not exist."
	deploytype = "boneclamp"
	toolspeed = 1.2
