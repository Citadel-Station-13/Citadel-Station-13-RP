/obj/item/godfig
	name = "religious icon"
	desc = "A painted holy figure of a plain looking human man in a robe."
	description_info = "Right click to select a new sprite to fit your needs."
	icon = 'icons/obj/chaplain.dmi'
	icon_state = "mrobe"
	force = 10
	throw_speed = 1
	throw_range = 4
	throw_force = 10
	w_class = ITEMSIZE_SMALL

/obj/item/godfig/attack_self(mob/user)
	resprite_figure(user)

/obj/item/godfig/proc/resprite_figure(mob/living/L)
	var/obj/item/holy_icon
	var/list/holy_icons_list = subtypesof(/obj/item/godfig) + list(HOLY_ICONS)
	var/list/display_names = list()
	var/list/holy_icons = list()
	for(var/G in holy_icons_list)
		var/obj/item/godfig/figtype = G
		if (G)
			display_names[initial(figtype.name)] = figtype
			holy_icons += list(initial(figtype.name) = image(icon = initial(figtype.icon), icon_state = initial(figtype.icon_state)))

	holy_icons = sortList(holy_icons)

	var/choice = show_radial_menu(L, src , holy_icons, custom_check = CALLBACK(src, .proc/check_menu, L), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(L))
		return

	var/A = display_names[choice] // This needs to be on a separate var as list member access is not allowed for new
	holy_icon = new A

	GLOB.holy_icon_type = holy_icon.type

	if(holy_icon)
		qdel(src)
		L.put_in_active_hand(holy_icon)
		to_chat(usr, "The religious icon is now a [choice]. All hail!")

/obj/item/godfig/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/godfig/verb/rename_fig()
	set name = "Name Figure"
	set category = "Object"
	set desc = "Rename your icon."

	var/mob/M = usr
	if(!M.mind)	return 0

	var/input = sanitizeSafe(input("What do you want to name the icon?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = "icon of " + input
		to_chat(M, "You name the figure. Glory to [input]!.")
		return 1

//Icon Types made fancy

/obj/item/godfig/frobe
	name = "Painted - Robed Human Female"
	desc = "A painted holy figure of a plain looking human woman in a robe."
	icon_state = "frobe"

/obj/item/godfig/mrobe
	name = "Painted - Robed Human Male (Pale)"
	desc = "A painted holy figure of a plain looking human man in a robe."
	icon_state = "mrobe"

/obj/item/godfig/mrobedark
	name = "Painted - Robed Human Male (Dark)"
	desc = "A painted holy figure of a plain looking human man in a robe."
	icon_state = "mrobedark"

/obj/item/godfig/mpose
	name = "Painted - Bearded Human"
	desc = "A painted holy figure of a rather grandiose bearded human."
	icon_state = "mpose"

/obj/item/godfig/mwarrior
	name = "Painted - Human Male Warrior"
	desc = "A painted holy figure of a powerful human male warrior."
	icon_state = "mwarrior"

/obj/item/godfig/fwarrior
	name = "Painted - Human Female Warrior"
	desc = "A painted holy figure of a powerful human female warrior."
	icon_state = "fwarrior"

/obj/item/godfig/hammer
	name = "Painted - Human Male Hammer"
	desc = "A painted holy figure of a human holding a hammer aloft."
	icon_state = "hammer"

/obj/item/godfig/horned
	name = "Painted - Horned God"
	desc = "A painted holy figure of a human man crowned with antlers."
	icon_state = "horned"

/obj/item/godfig/onyxking
	name = "Obsidian - Human Male"
	desc = "An obsidian holy figure of a human man wearing a grand hat."
	icon_state = "onyxking"

/obj/item/godfig/onyxqueen
	name = "Obsidian - Human Female"
	desc = "An obsidian holy figure of a human woman wearing a grand hat."
	icon_state = "onyxqueen"

/obj/item/godfig/onyxanimalm
	name = "Obsidian - Animal Headed Male"
	desc = "An obsidian holy figure of a human man with the head of an animal."
	icon_state = "onyxanimalm"

/obj/item/godfig/onyxanimalf
	name = "Obsidian - Animal Headed Female"
	desc = "An obsidian holy figure of a human woman with the head of an animal."
	icon_state = "onyxanimalf"

/obj/item/godfig/onyxbird
	name = "Obsidian - Bird Headed Figure"
	desc = "An obsidian holy figure of a human with the head of a bird."
	icon_state = "onyxbird"

/obj/item/godfig/stoneseat
	name = "Stone - Seated Figure"
	desc = "A stone holy figure of a cross-legged human."
	icon_state = "stoneseat"

/obj/item/godfig/stonehead
	name = "Stone - Head"
	desc = "A stone holy figure of an imposing crowned head."
	icon_state = "stonehead"

/obj/item/godfig/stonedwarf
	name = "Stone - Dwarf"
	desc = "A stone holy figure of a somewhat ugly dwarf."
	icon_state = "stonedwarf"

/obj/item/godfig/stoneanimal
	name = "Stone - Animal"
	desc = "A stone holy figure of a four-legged animal of some sort."
	icon_state = "stoneanimal"

/obj/item/godfig/stonevenus
	name = "Stone - Fertility"
	desc = "A stone holy figure of a lovingly rendered pregnant woman."
	icon_state = "stonevenus"

/obj/item/godfig/stonesnake
	name = "Stone - Snake"
	desc = "A stone holy figure of a coiled snake ready to strike."
	icon_state = "stonesnake"

/obj/item/godfig/elephant
	name = "Bronze - Elephantine"
	desc = "A bronze holy figure of a dancing human with the head of an elephant."
	icon_state = "elephant"

/obj/item/godfig/bronzearms
	name = "Bronze - Many-armed"
	desc = "A bronze holy figure of a human.with four arms."
	icon_state = "bronzearms"

/obj/item/godfig/robot
	name = "Robot"
	desc = "A titanium holy figure of a synthetic humanoid."
	icon_state = "robot"

/obj/item/godfig/singularity
	name = "Singularity"
	desc = "A holy figure of some kind of energy formation."
	icon_state = "singularity"

/obj/item/godfig/gemeye
	name = "Gemstone Eye"
	desc = "A gemstone holy figure of a sparkling eye."
	icon_state = "gemeye"

/obj/item/godfig/skull
	name = "Golden Skull"
	desc = "A golden holy figure of a humanoid skull."
	icon_state = "skull"

/obj/item/godfig/devil
	name = "Goatman"
	desc = "A painted holy figure of a seated humanoid goat with wings."
	icon_state = "devil"

/obj/item/godfig/sun
	name = "Sun Gem"
	desc = "A holy figure of a star."
	icon_state = "sun"

/obj/item/godfig/moon
	name = "Moon Gem"
	desc = "A holy figure of a small planetoid."
	icon_state = "moon"

/obj/item/godfig/catrobe
	name = "Tajaran Figure"
	desc = "A painted holy figure of a plain looking Tajaran in a robe."
	icon_state = "catrobe"

/obj/item/godfig/ema
	name = "Shinto Ema"
	desc = "A plain wooden board with a prayer painted on it."
	icon_state = "ema"

// Legacy system. Maintained for future reference.
/*
/obj/item/godfig/verb/resprite_figure()
	set name = "Customize Figure"
	set category = "Object"
	set desc = "Click to choose an appearance for your icon."

	var/mob/M = usr
	var/list/options = list()
	options["Painted - Robed Human Female"] = "frobe"
	options["Painted - Robed Human Male (Pale)"] = "mrobe"
	options["Painted - Robed Human Male (Dark)"] = "mrobedark"
	options["Painted - Bearded Human"] = "mpose"
	options["Painted - Human Male Warrior"] = "mwarrior"
	options["Painted - Human Female Warrior"] = "fwarrior"
	options["Painted - Human Male Hammer"] = "hammer"
	options["Painted - Horned God"] = "horned"
	options["Obsidian - Human Male"] = "onyxking"
	options["Obsidian - Human Female"] = "onyxqueen"
	options["Obsidian - Animal Headed Male"] = "onyxanimalm"
	options["Obsidian - Animal Headed Female"] = "onyxanimalf"
	options["Obsidian - Bird Headed Figure"] = "onyxbird"
	options["Stone - Seated Figure"] = "stoneseat"
	options["Stone - Head"] = "stonehead"
	options["Stone - Dwarf"] = "stonedwarf"
	options["Stone - Animal"] = "stoneanimal"
	options["Stone - Fertility"] = "stonevenus"
	options["Stone - Snake"] = "stonesnake"
	options["Bronze - Elephantine"] = "elephant"
	options["Bronze - Many-armed"] = "bronzearms"
	options["Robot"] = "robot"
	options["Singularity"] = "singularity"
	options["Gemstone Eye"] = "gemeye"
	options["Golden Skull"] = "skull"
	options["Goatman"] = "devil"
	options["Sun Gem"] = "sun"
	options["Moon Gem"] = "moon"
	options["Tajaran Figure"] = "catrobe"
	options["Shinto Ema"] = "ema"

	var/choice = input(M,"Choose your icon!","Customize Figure") in options
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		if(options[choice] == "frobe")
			desc = "A painted holy figure of a plain looking human woman in a robe."
		else if(options[choice] == "mrobe")
			desc = "A painted holy figure of a plain looking human man in a robe."
		else if(options[choice] == "mrobedark")
			desc = "A painted holy figure of a plain looking human man in a robe.."
		else if(options[choice] == "mpose")
			desc = "A painted holy figure of a rather grandiose bearded human."
		else if(options[choice] == "mwarrior")
			desc = "A painted holy figure of a powerful human male warrior."
		else if(options[choice] == "fwarrior")
			desc = "A painted holy figure of a powerful human female warrior."
		else if(options[choice] == "hammer")
			desc = "A painted holy figure of a human holding a hammer aloft."
		else if(options[choice] == "horned")
			desc = "A painted holy figure of a human man crowned with antlers."
		else if(options[choice] == "onyxking")
			desc = "An obsidian holy figure of a human man wearing a grand hat."
		else if(options[choice] == "onyxqueen")
			desc = "An obsidian holy figure of a human woman wearing a grand hat."
		else if(options[choice] == "onyxanimalm")
			desc = "An obsidian holy figure of a human man with the head of an animal."
		else if(options[choice] == "onyxanimalf")
			desc = "An obsidian holy figure of a human woman with the head of an animal."
		else if(options[choice] == "onyxbird")
			desc = "An obsidian holy figure of a human with the head of a bird."
		else if(options[choice] == "stoneseat")
			desc = "A stone holy figure of a cross-legged human."
		else if(options[choice] == "stonehead")
			desc = "A stone holy figure of an imposing crowned head."
		else if(options[choice] == "stonedwarf")
			desc = "A stone holy figure of a somewhat ugly dwarf."
		else if(options[choice] == "stoneanimal")
			desc = "A stone holy figure of a four-legged animal of some sort."
		else if(options[choice] == "stonevenus")
			desc = "A stone holy figure of a lovingly rendered pregnant woman."
		else if(options[choice] == "stonesnake")
			desc = "A stone holy figure of a coiled snake ready to strike."
		else if(options[choice] == "elephant")
			desc = "A bronze holy figure of a dancing human with the head of an elephant."
		else if(options[choice] == "bronzearms")
			desc = "A bronze holy figure of a human.with four arms."
		else if(options[choice] == "robot")
			desc = "A titanium holy figure of a synthetic humanoid."
		else if(options[choice] == "singularity")
			desc = "A holy figure of some kind of energy formation."
		else if(options[choice] == "gemeye")
			desc = "A gemstone holy figure of a sparkling eye."
		else if(options[choice] == "skull")
			desc = "A golden holy figure of a humanoid skull."
		else if(options[choice] == "devil")
			desc = "A painted holy figure of a seated humanoid goat with wings."
		else if(options[choice] == "sun")
			desc = "A holy figure of a star."
		else if(options[choice] == "moon")
			desc = "A holy figure of a small planetoid."
		else if(options[choice] == "catrobe")
			desc = "A painted holy figure of a plain looking Tajaran in a robe."
		else if(options[choice] == "ema")
			desc = "A plain wooden board with a prayer painted on it."

		to_chat(M, "The religious icon is now a [choice]. All hail!")
		return 1
*/
