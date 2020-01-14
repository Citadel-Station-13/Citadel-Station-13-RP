/obj/item/weapon/storage/briefcase/fission
	icon = 'icons/obj/machines/power/fission.dmi'
	name = "lead lined carrying case"
	desc = "It's made of AUTHENTIC sealed lead and has a trifoil tag attached. Should probably handle this one with care."
	icon_state = "carrycase"
	item_state_slots = list(slot_r_hand_str = "case", slot_l_hand_str = "case")

/obj/item/weapon/storage/briefcase/fission/uranium
	name = "lead lined uranium carrying case"
	icon_state = "carrycaserad"
	starts_with = list(
		/obj/item/weapon/fuelrod/uranium,
		/obj/item/weapon/fuelrod/uranium,
		/obj/item/weapon/fuelrod/uranium,
		/obj/item/weapon/fuelrod/uranium
	)

/obj/item/weapon/storage/briefcase/fission/plutonium
	name = "lead lined plutonium carrying case"
	icon_state = "carrycaserad"
	starts_with = list(
		/obj/item/weapon/fuelrod/plutonium,
		/obj/item/weapon/fuelrod/plutonium,
		/obj/item/weapon/fuelrod/plutonium,
		/obj/item/weapon/fuelrod/plutonium
	)

/obj/item/weapon/storage/briefcase/fission/beryllium
	name = "lead lined beryllium carrying case"
	starts_with = list(
		/obj/item/weapon/fuelrod/beryllium,
		/obj/item/weapon/fuelrod/beryllium,
		/obj/item/weapon/fuelrod/beryllium,
		/obj/item/weapon/fuelrod/beryllium
	)

/obj/item/weapon/storage/briefcase/fission/tungstencarbide
	name = "lead lined tungsten carbide carrying case"
	starts_with = list(
		/obj/item/weapon/fuelrod/tungstencarbide,
		/obj/item/weapon/fuelrod/tungstencarbide,
		/obj/item/weapon/fuelrod/tungstencarbide,
		/obj/item/weapon/fuelrod/tungstencarbide
	)

/obj/item/weapon/storage/briefcase/fission/silver
	name = "lead lined silver carrying case"
	starts_with = list(
		/obj/item/weapon/fuelrod/silver,
		/obj/item/weapon/fuelrod/silver,
		/obj/item/weapon/fuelrod/silver,
		/obj/item/weapon/fuelrod/silver
	)

/obj/item/weapon/storage/briefcase/fission/boron
	name = "lead lined boron carrying case"
	starts_with = list(
		/obj/item/weapon/fuelrod/boron,
		/obj/item/weapon/fuelrod/boron,
		/obj/item/weapon/fuelrod/boron,
		/obj/item/weapon/fuelrod/boron
	)

/obj/item/weapon/storage/briefcase/fission/fuelmixed
	name = "lead lined fuel rod case"
	icon_state = "carrycaserad"
	starts_with = list(
		/obj/item/weapon/fuelrod/uranium,
		/obj/item/weapon/fuelrod/uranium,
		/obj/item/weapon/fuelrod/plutonium,
		/obj/item/weapon/fuelrod/plutonium
	)

/obj/item/weapon/storage/briefcase/fission/reflectormixed
	name = "lead lined reflector rod case"
	starts_with = list(
		/obj/item/weapon/fuelrod/tungstencarbide,
		/obj/item/weapon/fuelrod/beryllium,
		/obj/item/weapon/fuelrod/beryllium,
		/obj/item/weapon/fuelrod/beryllium
	)

/obj/item/weapon/storage/briefcase/fission/controlmixed
	name = "lead lined control rod case"
	starts_with = list(
		/obj/item/weapon/fuelrod/boron,
		/obj/item/weapon/fuelrod/silver,
		/obj/item/weapon/fuelrod/silver,
		/obj/item/weapon/fuelrod/silver
	)
