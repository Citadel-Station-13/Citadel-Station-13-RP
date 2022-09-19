/**
 * switchtools!
 *
 * supports both the dynamic tool system by providing the necessary tool behaviours, as well as
 * the normal attackby system by passing melee_attack_chain down if necessary.
 */
/obj/item/switchtool
	name = "switchtool"
	icon = 'icons/obj/switchtool.dmi'
	icon_state = "switchtool"
	item_state = "switchtool"
	desc = "A multi-deployable, multi-instrument, finely crafted multi-purpose tool. The envy of engineers everywhere."
	siemens_coefficient = 1
	force = 3
	w_class = ITEMSIZE_SMALL
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_switchtool.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_switchtool.dmi')
	throw_force = 6
	throw_speed = 3
	throw_range = 6
	var/deploy_sound = "sound/weapons/switchblade.ogg"
	var/undeploy_sound = "sound/weapons/switchblade.ogg"

	/// modules; initial modules are as typepath. will associate object to module type at runtime
	var/list/tools = list(
		/obj/item/tool/screwdriver/switchy = SWITCHTOOL_SCREWDRIVER
	)

	/// tool functions
	var/list/tool_functions = list(
		TOOL_SCREWDRIVER,
		TOOL_CROWBAR,
		TOOL_WIRECUTTER,
		TOOL_WRENCH,
		TOOL_MULTITOOL
	)

	tool_speed = 1
	tool_quality = TOOL_QUALITY_DEFAULT

	/// currently deployed item
	var/obj/item/deployed



	//the colon separates the typepath from the name
	var/list/obj/item/start_modules = list(/obj/item/tool/screwdriver/switchy = null,
											/obj/item/tool/wrench/switchy = null,
											/obj/item/tool/wirecutters/switchy = null,
											/obj/item/tool/crowbar/switchy = null,
											/obj/item/multitool/switchy = null)
	var/list/obj/item/stored_modules = list()

	var/static/radial_driver = image(icon = 'icons/obj/tools.dmi', icon_state = "screwdriver") //AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	var/static/radial_wrench = image(icon = 'icons/obj/tools.dmi', icon_state = "wrench")
	var/static/radial_wirecutters = image(icon = 'icons/obj/tools.dmi', icon_state = "cutters")
	var/static/radial_crowbar = image(icon = 'icons/obj/tools.dmi', icon_state = "crowbar")
	var/static/radial_welder = image(icon = 'icons/obj/tools.dmi', icon_state = "tubewelder")
	var/static/radial_multitool = image(icon = 'icons/obj/device.dmi', icon_state = "multitool")
	var/static/radial_scalpel = image(icon = 'icons/obj/surgery.dmi', icon_state = "scalpel")
	var/static/radial_laserscalpel = image(icon = 'icons/obj/surgery.dmi', icon_state = "scalpel_laser3_on")
	var/static/radial_hemostat = image(icon = 'icons/obj/surgery.dmi', icon_state = "hemostat")
	var/static/radial_retractor = image(icon = 'icons/obj/surgery.dmi', icon_state = "retractor")
	var/static/radial_saw = image(icon = 'icons/obj/surgery.dmi', icon_state = "saw")
	var/static/radial_drill = image(icon = 'icons/obj/surgery.dmi', icon_state = "drill")
	var/static/radial_boneclamp = image(icon = 'icons/obj/surgery.dmi', icon_state = "bone_setter")
	var/static/radial_cautery = image(icon = 'icons/obj/surgery.dmi', icon_state = "cautery")
	var/static/radial_light = image(icon = 'icons/obj/lighting.dmi', icon_state = "flashlight_yellow-on")
	var/static/radial_soap = image(icon = 'icons/obj/device.dmi', icon_state = "uv_on")
	var/static/radial_shield = image(icon = 'icons/obj/weapons.dmi', icon_state = "riot_alt")
	var/static/radial_sword = image(icon = 'icons/obj/weapons.dmi', icon_state = "blade")

#warn impl
#warn we're going to need to either query items to find net tool qualities,
#warn or have a separate list for it.

/obj/item/switchtool/Initialize(mapload)
	. = ..()
	for(var/module in start_modules)//making the modules
		stored_modules |= new module(src)

/obj/item/switchtool/examine()
	. = ..()
	. += "This one is capable of holding [get_formatted_modules()]."

/obj/item/switchtool/attack_self(mob/user)
	if(!user)
		return
	if(deployed)
		to_chat(user, "You store \the [deployed].")
		undeploy()
		return
	else
		choose_deploy(user)

/obj/item/switchtool/proc/add_module(obj/item/module, switchtool_enum)

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
	playsound(src, undeploy_sound, 10, 1)
	if(istype(deployed, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = deployed
		W.setWelding(FALSE)
	deployed = null
	cut_overlays()
	w_class = initial(w_class)
	update_icon()

/obj/item/switchtool/proc/deploy(var/module)
	if(!(module in stored_modules))
		return FALSE
	if(deployed)
		return FALSE
	playsound(src, deploy_sound, 10, 1)
	deployed = module
	update_icon()
	if(istype(deployed, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = deployed
		W.setWelding(TRUE)
	return TRUE

/obj/item/switchtool/proc/choose_deploy(mob/user)
	var/list/options = list()
	switch(switchingtype)
		if("basic")
			options["screwdriver"] = radial_driver
			options["wrench"] = radial_wrench
			options["wirecutters"] = radial_wirecutters
			options["crowbar"] = radial_crowbar
			options["multitool"] = radial_multitool
		if("surgery")
			options["scalpel"] = radial_scalpel
			options["hemostat"] = radial_hemostat
			options["retractor"] = radial_retractor
			options["boneclamp"] = radial_boneclamp
		if("ce")
			options["screwdriver"] = radial_driver
			options["wrench"] = radial_wrench
			options["wirecutters"] = radial_wirecutters
			options["crowbar"] = radial_crowbar
			options["multitool"] = radial_multitool
			options["welder"] = radial_welder
			options["soap"] = radial_soap
			options["light"] = radial_light
		if("adminholo")
			options["screwdriver"] = radial_driver
			options["wrench"] = radial_wrench
			options["wirecutters"] = radial_wirecutters
			options["crowbar"] = radial_crowbar
			options["multitool"] = radial_multitool
			options["welder"] = radial_welder
			options["scalpel"] = radial_laserscalpel
			options["hemostat"] = radial_hemostat
			options["retractor"] = radial_retractor
			options["saw"] = radial_saw
			options["drill"] = radial_drill
			options["boneclamp"] = radial_boneclamp
			options["cautery"] = radial_cautery
			options["soap"] = radial_soap
			options["light"] = radial_light
			options["sword"] = radial_sword
			options["shield"] = radial_shield

	if(options.len < 1)
		to_chat(user, "The [src] doesn't have any available modules!")
		return
	var/list/choice = list()
	choice = show_radial_menu(user, src, options)
	for(var/obj/item/module in stored_modules)
		if(module.deploytype == choice)
			if(deploy(module))
				to_chat(user, "You deploy \the [deployed].")
				return TRUE

/obj/item/switchtool/handle_shield(mob/user)
	if(deployed.deploytype == "shield")
		return TRUE
	return FALSE


/obj/item/switchtool/update_icon()//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	. = ..()
	var/mutable_appearance/tool_overlay
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(!deployed)
		return
	switch(switchingtype)
		if("basic")
			switch(deployed.deploytype)
				if("screwdriver")
					tool_overlay = mutable_appearance(icon, "[icon_state]_driver")
				if("wrench")
					tool_overlay = mutable_appearance(icon, "[icon_state]_wrench")
				if("crowbar")
					tool_overlay = mutable_appearance(icon, "[icon_state]_crowbar")
				if("wirecutters")
					tool_overlay = mutable_appearance(icon, "[icon_state]_cutter")
				if("multitool")
					tool_overlay = mutable_appearance(icon, "[icon_state]_multitool")
		if("surgery")
			switch(src.deployed.deploytype)
				if("scalpel")
					tool_overlay = mutable_appearance(icon, "[icon_state]_scalpel")
				if("cautery")
					tool_overlay = mutable_appearance(icon, "[icon_state]_cautery")
				if("hemostat")
					tool_overlay = mutable_appearance(icon, "[icon_state]_hemostat")
				if("retractor")
					tool_overlay = mutable_appearance(icon, "[icon_state]_retractor")
				if("boneclamp")
					tool_overlay = mutable_appearance(icon, "[icon_state]_boneclamp")
		if("ce")
			switch(src.deployed.deploytype)
				if("screwdriver")
					tool_overlay = mutable_appearance(icon, "[icon_state]_driver")
				if("wrench")
					tool_overlay = mutable_appearance(icon, "[icon_state]_wrench")
				if("crowbar")
					tool_overlay = mutable_appearance(icon, "[icon_state]_crowbar")
				if("wirecutters")
					tool_overlay = mutable_appearance(icon, "[icon_state]_cutter")
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
					tool_overlay = mutable_appearance(icon, "[icon_state]_light")
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
				if("screwdriver")
					tool_overlay = mutable_appearance(icon, "[icon_state]_driver")
				if("wrench")
					tool_overlay = mutable_appearance(icon, "[icon_state]_wrench")
				if("crowbar")
					tool_overlay = mutable_appearance(icon, "[icon_state]_crowbar")
				if("wirecutters")
					tool_overlay = mutable_appearance(icon, "[icon_state]_cutter")
				if("multitool")
					tool_overlay = mutable_appearance(icon, "[icon_state]_multitool")
				if("welder")
					tool_overlay = mutable_appearance(icon, "[icon_state]_welder")
				if("shield")
					tool_overlay = mutable_appearance(icon, "[icon_state]_shield")
				if("sword")
					tool_overlay = mutable_appearance(icon, "[icon_state]_blade")
	if(light_color)
		tool_overlay.color = light_color
	add_overlay(tool_overlay)

//? tool redirection
/obj/item/switchtool/tool_speed(function, mob/user, atom/target, flags, usage)
	. = ..()

//? tool redirection
/obj/item/switchtool/tool_check(function, mob/user, atom/target, flags, usage)

//? tool redirection
/obj/item/switchtool/tool_query(mob/user, atom/target, flags, usage)

#warn impl above

//? click redirection
/obj/item/switchtool/melee_attack_chain(atom/target, mob/user, clickchain_flags, params)
	if(!deployed)
		return ..()
	. = deployed.melee_attack_chain(target, user, clickchain_flags | CLICKCHAIN_REDIRECTED, params)
	if(deployed.loc != src)
		deployed.forceMove(src)
		undeploy()

//? click redirection
/obj/item/switchtool/ranged_attack_chain(atom/target, mob/user, clickchain_flags, params)
	if(!deployed)
		return ..()
	. = deployed.ranged_attack_chain(target, user, clickchain_flags | CLICKCHAIN_REDIRECTED, params)
	if(deployed.loc != src)
		deployed.forceMove(src)
		undeploy()

/obj/item/switchtool/surgery
	name = "surgeon's switchtool"
	icon_state = "surgeryswitchtool"
	item_state = "surgeryswitchtool"
	desc = "A switchtool containing most of the necessary items for impromptu surgery. For the surgeon on the go."
	start_modules = list(/obj/item/surgical/scalpel/switchy = null,
						/obj/item/surgical/hemostat/switchy = null,
						/obj/item/surgical/retractor/switchy = null,
						/obj/item/surgical/bonesetter/switchy = null)
	switchingtype = "surgery"

//Unique adminspawn switchtool. Has all the tools.
/obj/item/switchtool/holo
	name = "Tool"
	icon_state = "holoswitchtool"
	item_state = "holoswitchtool"
	desc = "An object that can take on the holographic hardlight form of nearly any tool in use today."
	description_fluff = "Mankind's first tool was likely a blade crudely shaped from flint. Versatile, at the time - one could skin creatures, use it as a weapon, hack at trees and cut plants. This is, potentially, mankind's last tool- able to be dynamically upgraded to support different holoprojector setups, allowing even more tools to be used by one device, once a working holoprojector setup for an application is implemented."
	var/brightness_max = 4
	var/brightness_min = 2
	deploy_sound = "sound/weapons/switchsound.ogg"
	undeploy_sound = "sound/weapons/switchsound.ogg"
	light_color =  LIGHT_COLOR_CYAN
	switchingtype = "adminholo"
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

/obj/item/switchtool/holo/Initialize(mapload)
	. = ..()
	add_atom_colour(light_color, FIXED_COLOUR_PRIORITY)

/obj/item/switchtool/holo/deploy(var/obj/item/module) //We lightin' it up in here
	..()
	if(module.deploytype == "flashlight")
		set_light(brightness_max, 4, light_color)
	else
		set_light(brightness_min, 1, light_color)

/obj/item/switchtool/holo/undeploy()
	..()
	set_light(0)

/obj/item/switchtool/holo/CE
	name = "holotool"
	icon_state = "holoswitchtool"
	item_state = "holoswitchtool"
	desc = "A finely crafted device that uses a micro-scale hardlight emitter to form hardlight manipulators in the form of tools. Can also operate in low-power mode as a flashlight and in high-power mode as a UV cleaner."
	light_color = "#FED8B1" //lightcolororange sucks lmao
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

/obj/item/flashlight/holoswitch
	name = "low-power holoemitter"
	desc = "This should not exist"
	power_use = 0

/obj/item/tool/screwdriver/holoswitch
	name = "hardlight screwdriver"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/tool/wrench/holoswitch
	name = "hardlight bolt driver"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/tool/crowbar/holoswitch
	name = "hardlight pry bar"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/tool/wirecutters/holoswitch
	name = "hardlight wire cutting tool"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/weldingtool/holoswitch
	name = "laser welding tool"
	desc = "This should not exist."
	tool_speed = 0.9
	var/nextrefueltick = 0

/obj/item/weldingtool/holoswitch/process(delta_time)
	..()
	if(get_fuel() < get_max_fuel() && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent("fuel", 1)

/obj/item/multitool/holoswitch
	name = "hardlight electromagnetic microinducer"
	desc = "This should not exist."

/obj/item/surgical/scalpel/laser3/holoswitch
	name = "hybrid hardlight-laser scalpel"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/surgical/retractor/holoswitch
	name = "hardlight retractor"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/surgical/hemostat/holoswitch
	name = "hardlight haemostat"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/surgical/cautery/holoswitch
	name = "laser cautery"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/surgical/circular_saw/holoswitch
	name = "hardlight saw"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/surgical/surgicaldrill/holoswitch
	name = "hardlight surgical drill"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/surgical/bone_clamp/holoswitch
	name = "hardlight bone rectifier"
	desc = "This should not exist."
	tool_speed = 0.9

/obj/item/melee/energy/sword/holoswitch
	name = "hardlight blade"
	desc = "This should not exist."

/obj/item/shield/holoswitch
	name = "hardlight shield"
	desc = "This should not exist."

/obj/item/soap/holoswitch/pre_attack()
	wet()
	return ..()

/obj/item/tool/screwdriver/switchy
	name = "switchtool screwdriver"
	desc = "This should not exist."
	tool_speed = 1.2

/obj/item/tool/wrench/switchy
	name = "switchtool wrench"
	desc = "This should not exist."
	tool_speed = 1.2

/obj/item/tool/crowbar/switchy
	name = "switchtool crowbar"
	desc = "This should not exist."
	tool_speed = 1.2

/obj/item/tool/wirecutters/switchy
	name = "switchtool cutters"
	desc = "This should not exist."
	tool_speed = 1.2

/obj/item/multitool/switchy
	name = "switchtool micro-multitool"
	desc = "This should not exist."

/obj/item/surgical/scalpel/switchy
	name = "switchtool scalpel"
	desc = "This should not exist."
	tool_speed = 1.2

/obj/item/surgical/hemostat/switchy
	name = "switchtool hemostat"
	desc = "This should not exist."
	tool_speed = 1.2

/obj/item/surgical/retractor/switchy
	name = "switchtool retractor"
	desc = "This should not exist."
	tool_speed = 1.2

/obj/item/surgical/bonesetter/switchy
	name = "switchtool bone setter"
	desc = "This should not exist."
	tool_speed = 1.2
