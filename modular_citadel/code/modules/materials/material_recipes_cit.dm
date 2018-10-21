/material/generate_recipes()
	..()
	if(hardness>50)
		recipes += new/datum/stack_recipe("[display_name] bastard sword", /obj/item/weapon/material/twohanded/bsword, 20, time = 60, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
