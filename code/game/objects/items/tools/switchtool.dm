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
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_switchtool.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_switchtool.dmi')
	throw_force = 6
	throw_speed = 3
	throw_range = 6
	var/deploy_sound = "sound/weapons/switchblade.ogg"
	var/undeploy_sound = "sound/weapons/switchblade.ogg"

	/// modules; initial modules are as typepath. will associate object to module type at runtime
	var/list/tools = list(
		/obj/item/tool/screwdriver/switchy = SWITCHTOOL_SCREWDRIVER,
		/obj/item/tool/wrench/switchy = SWITCHTOOL_WRENCH,
		/obj/item/tool/wirecutters/switchy = SWITCHTOOL_WIRECUTTERS,
		/obj/item/tool/crowbar/switchy = SWITCHTOOL_CROWBAR,
		/obj/item/multitool/switchy = SWITCHTOOL_MULTITOOL
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
	/// currently used dynamic tool function
	var/deploying_function

	var/static/list/default_switchtool_radials = _default_switchtool_radials()

/proc/_default_switchtool_radials()
	return list(
		SWITCHTOOL_SCREWDRIVER = image(icon = 'icons/obj/tools.dmi', icon_state = "screwdriver"),
		SWITCHTOOL_WRENCH = image(icon = 'icons/obj/tools.dmi', icon_state = "wrench"),
		SWITCHTOOL_CROWBAR = image(icon = 'icons/obj/tools.dmi', icon_state = "crowbar"),
		SWITCHTOOL_WIRECUTTERS = image(icon = 'icons/obj/tools.dmi', icon_state = "cutters"),
		SWITCHTOOL_MULTITOOL = image(icon = 'icons/obj/device.dmi', icon_state = "multitool"),
		SWITCHTOOL_WELDER = image(icon = 'icons/obj/tools.dmi', icon_state = "tubewelder"),
		SWITCHTOOL_SCALPEL = image(icon = 'icons/obj/surgery.dmi', icon_state = "scalpel"),
		SWITCHTOOL_CAUTERY = image(icon = 'icons/obj/surgery.dmi', icon_state = "cautery"),
		SWITCHTOOL_HEMOSTAT = image(icon = 'icons/obj/surgery.dmi', icon_state = "hemostat"),
		SWITCHTOOL_RETRACTOR = image(icon = 'icons/obj/surgery.dmi', icon_state = "retractor"),
		SWITCHTOOL_BONECLAMP = image(icon = 'icons/obj/surgery.dmi', icon_state = "bone_setter"),
		SWITCHTOOL_SAW = image(icon = 'icons/obj/surgery.dmi', icon_state = "saw"),
		SWITCHTOOL_DRILL = image(icon = 'icons/obj/surgery.dmi', icon_state = "drill"),
		SWITCHTOOL_LIGHT = image(icon = 'icons/obj/lighting.dmi', icon_state = "flashlight_yellow-on"),
		SWITCHTOOL_SOAP = image(icon = 'icons/obj/device.dmi', icon_state = "uv_on"),
		SWITCHTOOL_SHIELD = image(icon = 'icons/obj/weapons.dmi', icon_state = "riot_alt"),
		SWITCHTOOL_SWORD = image(icon = 'icons/obj/weapons.dmi', icon_state = "blade"),
	)

/obj/item/switchtool/Initialize(mapload)
	. = ..()
	var/list/adding = list()
	for(var/path in tools)
		if(isdatum(path))
			// wtf?
			continue
		if(!ispath(path))
			// wtf?
			continue
		adding[path] = tools[path]
		tools -= path
	for(var/path in adding)
		var/enum = adding[path]
		add_module(new path(src), enum)

/obj/item/switchtool/examine(mob/user)
	. = ..()
	. += "This holds [get_formatted_modules()]."

//makes the string list of modules ie "a screwdriver, a knife, and a clown horn"
//does not end with a full stop, but does contain commas
/obj/item/switchtool/proc/get_formatted_modules()
	var/counter = 0
	var/module_string = ""
	for(var/obj/item/module in tools)
		counter++
		if(counter == tools.len)
			module_string += "and \a [module.name]"
		else
			module_string += "\a [module.name], "
	return module_string

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
	if(module.loc != src)
		module.forceMove(src)
	tools[module] = switchtool_enum

/obj/item/switchtool/proc/remove_module(obj/item/module)
	if(module == deployed)
		undeploy()
	tools -= module

/obj/item/switchtool/proc/undeploy()
	playsound(src, undeploy_sound, 10, 1)
	if(istype(deployed, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = deployed
		W.setWelding(FALSE)
	deployed = null
	cut_overlays()
	w_class = initial(w_class)
	update_icon()
	tool_locked = FALSE

/obj/item/switchtool/proc/deploy(obj/item/I)
	if(!(I in tools))
		return FALSE
	if(deployed)
		return FALSE
	playsound(src, deploy_sound, 10, 1)
	deployed = I
	update_icon()
	if(istype(I, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = I
		W.setWelding(TRUE)
	tool_locked = TRUE
	return TRUE

/obj/item/switchtool/proc/choose_deploy(mob/user)
	var/list/options = list()
	for(var/obj/item/I as anything in tools)
		var/enum = tools[I]
		options[I] = default_switchtool_radials[enum]
	if(options.len < 1)
		to_chat(user, "\The [src] doesn't have any available modules!")
		return
	var/obj/item/choice
	choice = show_radial_menu(user, src, options)
	if(deploy(choice))
		to_chat(user, "You deploy \the [deployed].")
		return TRUE

/obj/item/switchtool/proc/get_switchtool_enum(obj/item/I)
	return tools[I]

/obj/item/switchtool/handle_shield(mob/user)
	if(get_switchtool_enum(deployed) == SWITCHTOOL_SHIELD)
		return TRUE
	return FALSE

/obj/item/switchtool/update_overlays()
	. = ..()
	if(!deployed)
		return
	var/enum = get_switchtool_enum(deploying_function? tool_function_to_enum(deploying_function) : deployed)
	if(!enum)
		return
	var/state_append = switchtool_enum_to_state(enum)
	if(!state_append)
		return
	var/mutable_appearance/MA = mutable_appearance(icon, "[icon_state]_[state_append]")
	if(light_color)
		MA.color = light_color
	. += MA

/obj/item/switchtool/proc/tool_function_to_enum(function)
	switch(function)
		if(TOOL_SCREWDRIVER)
			return SWITCHTOOL_SCREWDRIVER
		if(TOOL_WRENCH)
			return SWITCHTOOL_WRENCH
		if(TOOL_CROWBAR)
			return SWITCHTOOL_CROWBAR
		if(TOOL_MULTITOOL)
			return SWITCHTOOL_MULTITOOL
		if(TOOL_WELDER)
			return SWITCHTOOL_WELDER
		if(TOOL_WIRECUTTER)
			return SWITCHTOOL_WIRECUTTERS
		if(TOOL_CAUTERY)
			return SWITCHTOOL_CAUTERY
		if(TOOL_SAW)
			return SWITCHTOOL_SAW
		if(TOOL_DRILL)
			return SWITCHTOOL_DRILL
		if(TOOL_BONESET)
			return SWITCHTOOL_BONECLAMP
		if(TOOL_SCALPEL)
			return SWITCHTOOL_SCALPEL
		if(TOOL_RETRACTOR)
			return SWITCHTOOL_RETRACTOR
		if(TOOL_HEMOSTAT)
			return SWITCHTOOL_HEMOSTAT

/obj/item/switchtool/proc/switchtool_enum_to_state(enum)
	switch(enum)
		if(SWITCHTOOL_SCREWDRIVER)
			return "driver"
		if(SWITCHTOOL_WRENCH)
			return "wrench"
		if(SWITCHTOOL_CROWBAR)
			return "crowbar"
		if(SWITCHTOOL_WIRECUTTERS)
			return "cutter"
		if(SWITCHTOOL_MULTITOOL)
			return "multitool"
		if(SWITCHTOOL_WELDER)
			return "welder"
		if(SWITCHTOOL_LIGHT)
			return "light"
		if(SWITCHTOOL_SOAP)
			return "soap"
		if(SWITCHTOOL_SCALPEL)
			return "scalpel"
		if(SWITCHTOOL_BONECLAMP)
			return "boneclamp"
		if(SWITCHTOOL_HEMOSTAT)
			return "hemostat"
		if(SWITCHTOOL_RETRACTOR)
			return "retractor"
		if(SWITCHTOOL_CAUTERY)
			return "cautery"
		if(SWITCHTOOL_SAW)
			return "saw"
		if(SWITCHTOOL_DRILL)
			return "drill"
		if(SWITCHTOOL_SWORD)
			return "blade"
		if(SWITCHTOOL_SHIELD)
			return "shield"

//? tool redirection
/obj/item/switchtool/tool_check(function, mob/user, atom/target, flags, usage)
	return (function in tool_functions)? tool_quality : null

//? tool redirection
/obj/item/switchtool/tool_query(mob/user, atom/target, flags, usage)
	. = list()
	for(var/i in tool_functions)
		.[i] = tool_quality

//? tool redirection
/obj/item/switchtool/tool_behaviour()
	return deployed?.tool_behaviour()

//? tool redirection
/obj/item/switchtool/tool_feedback_start(function, flags, mob/user, atom/target, time, cost, usage)
	. = ..()
	deploying_function = function
	update_icon()

//? tool redirection
/obj/item/switchtool/tool_feedback_end(function, flags, mob/user, atom/target, time, cost, usage, success)
	. = ..()
	deploying_function = null
	update_icon()

//? click redirection
/obj/item/switchtool/melee_attack_chain(atom/target, mob/user, clickchain_flags, params)
	if(!deployed)
		return ..()
	. = deployed.melee_attack_chain(target, user, clickchain_flags | CLICKCHAIN_REDIRECTED, params)
	if(deployed && deployed.loc != src)
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
	tools = list(/obj/item/surgical/scalpel/switchy = SWITCHTOOL_SCALPEL,
						/obj/item/surgical/hemostat/switchy = SWITCHTOOL_HEMOSTAT,
						/obj/item/surgical/retractor/switchy = SWITCHTOOL_RETRACTOR,
						/obj/item/surgical/bonesetter/switchy = SWITCHTOOL_BONECLAMP)
	tool_functions = list(
		TOOL_SCALPEL,
		TOOL_HEMOSTAT,
		TOOL_RETRACTOR,
		TOOL_BONESET
	)

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
	tool_speed = 0.8
	tools = list(
		/obj/item/surgical/scalpel/laser3/holoswitch = SWITCHTOOL_SCALPEL,
		/obj/item/surgical/hemostat/holoswitch = SWITCHTOOL_HEMOSTAT,
		/obj/item/surgical/retractor/holoswitch = SWITCHTOOL_RETRACTOR,
		/obj/item/surgical/bone_clamp/holoswitch = SWITCHTOOL_BONECLAMP,
		/obj/item/surgical/circular_saw/holoswitch = SWITCHTOOL_SAW,
		/obj/item/surgical/surgicaldrill/holoswitch = SWITCHTOOL_DRILL,
		/obj/item/surgical/cautery/holoswitch = SWITCHTOOL_CAUTERY,
		/obj/item/tool/screwdriver/holoswitch = SWITCHTOOL_SCREWDRIVER,
		/obj/item/tool/wrench/holoswitch = SWITCHTOOL_WRENCH,
		/obj/item/tool/crowbar/holoswitch = SWITCHTOOL_CROWBAR,
		/obj/item/tool/wirecutters/holoswitch = SWITCHTOOL_WIRECUTTERS,
		/obj/item/weldingtool/holoswitch = SWITCHTOOL_WELDER,
		/obj/item/multitool/holoswitch = SWITCHTOOL_MULTITOOL,
		/obj/item/flashlight/holoswitch = SWITCHTOOL_LIGHT,
		/obj/item/soap/holoswitch = SWITCHTOOL_SOAP,
		/obj/item/melee/energy/sword/holoswitch = SWITCHTOOL_SWORD,
		/obj/item/shield/holoswitch = SWITCHTOOL_SHIELD
	)
	tool_functions = list(
		TOOL_SCALPEL,
		TOOL_HEMOSTAT,
		TOOL_RETRACTOR,
		TOOL_BONESET,
		TOOL_WELDER,
		TOOL_WRENCH,
		TOOL_CROWBAR,
		TOOL_WIRECUTTER,
		TOOL_MULTITOOL,
		TOOL_SCREWDRIVER,
		TOOL_SAW,
		TOOL_DRILL
	)

/obj/item/switchtool/holo/Initialize(mapload)
	. = ..()
	add_atom_colour(light_color, FIXED_COLOUR_PRIORITY)

/obj/item/switchtool/holo/deploy(var/obj/item/module) //We lightin' it up in here
	..()
	if(get_switchtool_enum(module) == SWITCHTOOL_LIGHT)
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
	tools = list(
		/obj/item/tool/screwdriver/holoswitch = SWITCHTOOL_SCREWDRIVER,
		/obj/item/tool/wrench/holoswitch = SWITCHTOOL_WRENCH,
		/obj/item/tool/crowbar/holoswitch = SWITCHTOOL_CROWBAR,
		/obj/item/tool/wirecutters/holoswitch = SWITCHTOOL_WIRECUTTERS,
		/obj/item/weldingtool/holoswitch = SWITCHTOOL_WELDER,
		/obj/item/multitool/holoswitch = SWITCHTOOL_MULTITOOL,
		/obj/item/flashlight/holoswitch = SWITCHTOOL_LIGHT,
		/obj/item/soap/holoswitch = SWITCHTOOL_SOAP,
	)
	tool_functions = list(
		TOOL_WELDER,
		TOOL_WRENCH,
		TOOL_CROWBAR,
		TOOL_WIRECUTTER,
		TOOL_MULTITOOL,
		TOOL_SCREWDRIVER
	)

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
