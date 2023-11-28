/obj/item/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	origin_tech = list(TECH_POWER = 1)
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50)

	var/charge = 0
	var/max_charge = 1000

/obj/item/stock_parts/capacitor/Initialize(mapload)
	. = ..()
	max_charge *= rating	// this is garbage someone remove it later and hardcode

/obj/item/stock_parts/capacitor/proc/charge(amount)
	charge += amount
	if(charge > max_charge)
		charge = max_charge

/obj/item/stock_parts/capacitor/proc/use(amount)
	if(charge)
		charge -= amount
		if(charge < 0)
			charge = 0

/obj/item/stock_parts/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	icon_state = "capacitor_adv"
	origin_tech = list(TECH_POWER = 3)
	rating = 2
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/stock_parts/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "capacitor_super"
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	rating = 3
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/stock_parts/capacitor/hyper
	name = "hyper capacitor"
	desc = "A hyper-capacity capacitor used in the construction of a variety of devices."
	icon_state = "capacitor_hyper"
	origin_tech = list(TECH_POWER = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 1, TECH_ARCANE = 1)
	rating = 4
	materials_base = list(MAT_STEEL = 80, MAT_GLASS = 40)

/obj/item/stock_parts/capacitor/omni
	name = "omni-capacitor"
	desc = "A capacitor of immense capacity used in the construction of a variety of devices."
	icon_state = "capacitor_omni"
	origin_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PRECURSOR  = 1)
	rating = 5
	materials_base = list(MAT_STEEL = 80, MAT_GLASS = 40)
