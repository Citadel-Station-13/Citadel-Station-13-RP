//Ported from Cit Main.
/obj/structure/statue
	name = "Statue"
	desc = "Placeholder. Yell at Firecage if you SOMEHOW see this."
	icon = 'icons/obj/statue.dmi'
	icon_state = ""
	density = 1
	anchored = 0
	var/hardness = 1
	var/oreAmount = 7
	var/materialType = "steel"
	var/material = "steel"

/obj/structure/statue/Destroy()
	density = 0
	return ..()

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

	else if(istype(W, /obj/item/pickaxe/plasmacutter))
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		user.visible_message("[user] is slicing apart the [name]...", \
							 "<span class='notice'>You are slicing apart the [name]...</span>")
		if(do_after(user,30, target = src))
			if(!src.loc)
				return
			user.visible_message("[user] slices apart the [name].", \
								 "<span class='notice'>You slice apart the [name].</span>")
			Dismantle(1)

	else if(istype(W, /obj/item/pickaxe))
		if(!src.loc)
			return
		user.visible_message("[user] destroys the [name]!", \
							 "<span class='notice'>You are destroying the [name].</span>")
		if(do_after(user,30, target = src))
			if(!src.loc)
				return
			user.visible_message("[user] smashes the [name].", \
								 "<span class='notice'>You destroy the [name].</span>")
			qdel(src)

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
			Dismantle(1)

	else
		hardness -= W.force/100
		..()
		CheckHardness()

/obj/structure/statue/attack_hand(mob/living/user)
	add_fingerprint(user)
	user.visible_message("[user] rubs some dust off from the [name]'s surface.", \
						 "<span class='notice'>You rub some dust off from the [name]'s surface.</span>")

/obj/structure/statue/bullet_act(obj/item/projectile/Proj)
	hardness -= Proj.damage
	..()
	CheckHardness()
	return

/obj/structure/statue/proc/CheckHardness()
	if(hardness <= 0)
		Dismantle(1)

/obj/structure/statue/proc/Dismantle(devastated = 0)
	if(!devastated)
		if (materialType == "steel")
			var/ore = /obj/item/stack/material/steel
			for(var/i = 1, i <= oreAmount, i++)
				new ore(get_turf(src))
		else
			var/ore = text2path("/obj/item/stack/material/[materialType]")
			if(!ispath(ore))
				qdel(src)
				CRASH("Invalid ore [ore].")
			for(var/i = 1, i <= oreAmount, i++)
				new ore(get_turf(src))
	else
		if (materialType == "steel")
			var/ore = /obj/item/stack/material/steel
			for(var/i = 3, i <= oreAmount, i++)
				new ore(get_turf(src))
		else
			var/ore = text2path("/obj/item/stack/material/[materialType]")
			if(!ispath(ore))
				qdel(src)
				CRASH("Invalid ore [ore].")
			for(var/i = 3, i <= oreAmount, i++)
				new ore(get_turf(src))
	qdel(src)

/obj/structure/statue/legacy_ex_act(severity = 1)
	switch(severity)
		if(1)
			Dismantle(1)
		if(2)
			if(prob(20))
				Dismantle(1)
			else
				hardness--
				CheckHardness()
		if(3)
			hardness -= 0.1
			CheckHardness()
	return

//////////////////////////////////////STATUES/////////////////////////////////////////////////////////////
//////////////////////////silver///////////////////////////////////////

/obj/structure/statue/silver
	hardness = 3
	materialType = "silver"
	material = "silver"
	desc = "This is a valuable statue made from silver."

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
	hardness = 3
	materialType = "gold"
	material = "gold"
	desc = "This is a highly valuable statue made from gold."

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
	hardness = 2
	materialType = "phoron"
	material = "phoron"
	desc = "This statue is suitably made from phoron."

/obj/structure/statue/phoron/scientist
	name = "Statue of a Scientist"
	icon_state = "sci"

/obj/structure/statue/phoron/xeno
	name = "Statue of a Xenomorph"
	icon_state = "xeno"

////////////////////////uranium///////////////////////////////////

/obj/structure/statue/uranium
	hardness = 3
	luminosity = 2
	materialType = "uranium"
	material = "uranium"
	desc = "If you can read this, go to Medical."

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
	hardness = 10
	materialType = "diamond"
	material = "diamond"
	desc = "This is a very expensive diamond statue"

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
	hardness = 3
	materialType = "bananium"
	material = "bananium"
	desc = "A bananium statue with a small engraving:'HOOOOOOONK'."

/obj/structure/statue/bananium/clown
	name = "Statue of a clown"
	icon_state = "clown"

/////////////////////sandstone/////////////////////////////////////////

/obj/structure/statue/sandstone
	hardness = 0.5
	materialType = "sandstone"
	material = "sandstone"

/obj/structure/statue/sandstone/assistant
	name = "Statue of an assistant"
	desc = "A cheap statue of sandstone for a greyshirt."
	icon_state = "assist"

/////////////////////marble/////////////////////////////////////////

/obj/structure/statue/marble
	hardness = 3
	materialType = "marble"
	material = "marble"
	desc = "This is a shiny statue made from marble."

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

/obj/structure/statue/bone
	name = "bone statue"
	desc = "A towering menhir of bone, perhaps the colossal rib of some fallen beast."
	icon = 'icons/obj/statuelarge.dmi'
	icon_state = "rib"

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
	desc = "An obsidian memorial wall listing the names of NanoTrasen employees who have fallen in the pursuit of the Company's goals - both scientific and political."
	icon = 'icons/obj/structures_64x.dmi'
	icon_state = "memorial"

	density = TRUE
	anchored = TRUE
	pass_flags_self = ATOM_PASS_THROWN | ATOM_PASS_OVERHEAD_THROW
	climbable = TRUE
