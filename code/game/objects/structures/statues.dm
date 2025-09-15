//Ported from Cit Main.
// todo: refactor into sculpting, with categories/free choice of material & greyscaling
// todo: generate job state icons off of a given sprite, or off of their outfit
/obj/structure/statue
	name = "Statue"
	desc = "Placeholder. Yell at Firecage if you SOMEHOW see this."
	icon = 'icons/obj/statue.dmi'
	icon_state = ""
	density = TRUE
	anchored = FALSE
	armor_type = /datum/armor/object/medium
	material_parts = MATERIAL_DEFAULT_NONE

/obj/structure/statue/attackby(obj/item/tool/W, mob/living/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/tool/wrench))
		if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user.visible_message("[user] is loosening the [name]'s bolts.", \
								 "<span class='notice'>You are loosening the [name]'s bolts...</span>")
			if(do_after(user,40/W.tool_speed, target = src))
				if(!src.loc || !anchored)
					return
				user.visible_message("[user] loosened the [name]'s bolts!", \
									 "<span class='notice'>You loosen the [name]'s bolts!</span>")
				anchored = 0
		else
			if (!istype(src.loc, /turf/simulated/floor))
				user.visible_message("<span class='warning'>A floor must be present to secure the [name]!</span>")
				return
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user.visible_message("[user] is securing the [name]'s bolts...", \
								 "<span class='notice'>You are securing the [name]'s bolts...</span>")
			if(do_after(user, 40/W.tool_speed, target = src))
				if(!src.loc || anchored)
					return
				user.visible_message("[user] has secured the [name]'s bolts.", \
									 "<span class='notice'>You have secured the [name]'s bolts.</span>")
				anchored = 1
		return
	else if(istype(W, /obj/item/weldingtool) && !anchored)
		playsound(loc, 'sound/items/Welder.ogg', 40, 1)
		user.visible_message("[user] is slicing apart the [name].", \
							 "<span class='notice'>You are slicing apart the [name]...</span>")
		if(do_after(user, 40/W.tool_speed, target = src))
			if(!src.loc)
				return
			playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
			user.visible_message("[user] slices apart the [name].", \
								 "<span class='notice'>You slice apart the [name]!</span>")
			deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)
		return
	return ..()

/obj/structure/statue/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	add_fingerprint(user)
	user.visible_message("[user] rubs some dust off from the [name]'s surface.", \
						 "<span class='notice'>You rub some dust off from the [name]'s surface.</span>")

/obj/structure/statue/drop_products(method, atom/where)
	. = ..()
	var/datum/prototype/material/primary = get_primary_material()
	if(!isnull(primary))
		drop_product(method, primary.place_sheet(null, 10), where)

/obj/structure/statue/silver
	desc = "This is a valuable statue made from silver."
	material_parts = /datum/prototype/material/silver

/obj/structure/statue/silver/hos
	name = "Statue of a Head of Security"
	icon_state = "hos"

/obj/structure/statue/silver/md
	name = "Statue of a Medical Officer"
	icon_state = "md"

/obj/structure/statue/silver/janitor
	name = "Statue of a Janitor"
	icon_state = "jani"

/obj/structure/statue/silver/sec
	name = "Statue of a Security Officer"
	icon_state = "sec"

/obj/structure/statue/silver/secborg
	name = "Statue of a Security Cyborg"
	icon_state = "secborg"

/obj/structure/statue/silver/medborg
	name = "Statue of a Medical Cyborg"
	icon_state = "medborg"

//////////////////////gold///////////////////////////////////////

/obj/structure/statue/gold
	desc = "This is a highly valuable statue made from gold."
	material_parts = /datum/prototype/material/gold

/obj/structure/statue/gold/hos
	name = "Statue of the Head of Security"
	icon_state = "hos_g"

/obj/structure/statue/gold/hop
	name = "Statue of the Head of Personnel"
	icon_state = "hop"

/obj/structure/statue/gold/cmo
	name = "Statue of the Chief Medical Officer"
	icon_state = "cmo"

/obj/structure/statue/gold/ce
	name = "Statue of the Chief Engineer"
	icon_state = "ce"

/obj/structure/statue/gold/rd
	name = "Statue of the Research Director"
	icon_state = "rd"

////////////////////////////phoron///////////////////////////////////////////////////////////////////////

/obj/structure/statue/phoron
	desc = "This statue is suitably made from phoron."
	material_parts = /datum/prototype/material/phoron

/obj/structure/statue/phoron/scientist
	name = "Statue of a Scientist"
	icon_state = "sci"

/obj/structure/statue/phoron/xeno
	name = "Statue of a Xenomorph"
	icon_state = "xeno"

////////////////////////uranium///////////////////////////////////

/obj/structure/statue/uranium
	luminosity = 2
	desc = "If you can read this, go to Medical."
	material_parts = /datum/prototype/material/uranium

/obj/structure/statue/uranium/nuke
	name = "Statue of a Nuclear Fission Explosive"
	desc = "This is a grand statue of a Nuclear Explosive. It has a sickening green colour."
	icon_state = "nuke"

/obj/structure/statue/uranium/eng
	name = "Statue of an engineer"
	desc = "This statue has a sickening green colour."
	icon_state = "eng"

/////////////////////////diamond/////////////////////////////////////////

/obj/structure/statue/diamond
	desc = "This is a very expensive diamond statue"
	material_parts = /datum/prototype/material/diamond

/obj/structure/statue/diamond/captain
	name = "Statue of THE Captain."
	icon_state = "cap"

/obj/structure/statue/diamond/ai1
	name = "Statue of the AI hologram."
	icon_state = "ai1"

/obj/structure/statue/diamond/ai2
	name = "Statue of the AI core."
	icon_state = "ai2"

////////////////////////bananium///////////////////////////////////////

/obj/structure/statue/bananium
	desc = "A bananium statue with a small engraving:'HOOOOOOONK'."
	material_parts = /datum/prototype/material/bananium

/obj/structure/statue/bananium/clown
	name = "Statue of a clown"
	icon_state = "clown"

/////////////////////sandstone/////////////////////////////////////////

/obj/structure/statue/sandstone
	material_parts = /datum/prototype/material/sandstone

/obj/structure/statue/sandstone/assistant
	name = "Statue of an assistant"
	desc = "A cheap statue of sandstone for a greyshirt."
	icon_state = "assist"

/////////////////////marble/////////////////////////////////////////

/obj/structure/statue/marble
	desc = "This is a shiny statue made from marble."
	material_parts = /datum/prototype/material/marble

/obj/structure/statue/marble/male
	name = "male statue"
	desc = "This marble statue is shockingly lifelike."
	icon_state = "human_male"

/obj/structure/statue/marble/female
	name = "female statue"
	desc = "This marble statue is shockingly lifelike."
	icon_state = "human_female"

/obj/structure/statue/marble/monkey
	name = "monkey statue"
	desc = "This marble statue is shockingly lifelike."
	icon_state = "monkey"

/obj/structure/statue/marble/corgi
	name = "corgi statue"
	desc = "This marble statue is shockingly lifelike."
	icon_state = "corgi"

/obj/structure/statue/marble/venus
	name = "venusian statue"
	desc = "This statue pays homage to an ancient Terran sculpture. Or it's a depiction of someone from Venus. Records are unclear."
	icon = 'icons/obj/statuelarge.dmi'
	icon_state = "venus"

/////////////////////wood/////////////////////////////////////////

/obj/structure/statue/wood
	name = "wood statue"
	desc = "A simple wooden mannequin, generally used to display clothes or equipment. Water frequently."
	icon_state = "fashion_m"
	material_parts = /datum/prototype/material/wood_log

/obj/structure/statue/bone
	name = "bone statue"
	desc = "A towering menhir of bone, perhaps the colossal rib of some fallen beast."
	icon = 'icons/obj/statuelarge.dmi'
	icon_state = "rib"
	material_parts = /datum/prototype/material/bone

/obj/structure/statue/bone/skull
	name = "skull statue"
	desc = "A towering bone pillar depicting the skull of some forgotten beast."
	icon_state = "skull"

/obj/structure/statue/bone/skull/half
	name = "eroded skull statue"
	desc = "An eroded pillar depicting the skull of some forgotten beast."
	icon_state = "skull-half"

//////////////////Memorial/////////////////
/obj/structure/memorial
	name = "Memorial Wall"
	desc = "An obsidian memorial wall listing the names of Nanotrasen employees who have fallen in the pursuit of the Company's goals - both scientific and political."
	icon = 'icons/obj/structures_64x.dmi'
	icon_state = "memorial"

	density = TRUE
	anchored = TRUE
	pass_flags_self = ATOM_PASS_THROWN | ATOM_PASS_OVERHEAD_THROW
	climb_allowed = TRUE
	depth_projected = TRUE
	depth_level = 24

/obj/structure/memorial/small
	icon = 'icons/obj/structures.dmi'

/obj/structure/memorial/small/left
	icon_state = "memorial_l"
	description_fluff = "This slab has a Nanotrasen logo emblazoned across the top. Below the logo, an inscription has been etched with painstaking precision: 'This memorial stands as a testament to the bravery and ingenuity of the human spirit. Nanotrasen takes great pride in the exemplary service of its employees, and no contributors are more valued than those who made the ultimate sacrifice. Regardless of how far into the stars we reach, we must never forget whose hands have raised us there. Aeternum in Memoria'"

/obj/structure/memorial/small/right
	icon_state = "memorial_r"
	description_fluff = "This slab is marked with a list of names, over which is engraved 'Honor to the Fallen'. The names that appear on this slab are the local Nanotrasen employees who have died in the line of duty. The list is too long to fit on the slab normally - so the stone utilizes a nanotech etch/fill cycle to 'scroll' names from one slot, down to the next. The soft rumbling of stone etching away and filling in is referred to as the 'March of Progress'. Scrolling past on the list are several familiar names: '...Dean Fitzgerald, Demetrius Hill...'"
