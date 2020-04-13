/obj/item/storage/briefcase/fission
	icon = 'icons/obj/machines/power/fission.dmi'
	name = "lead lined carrying case"
	desc = "It's made of AUTHENTIC sealed lead and has a trifoil tag attached. Should probably handle this one with care."
	icon_state = "carrycase"
	item_state_slots = list(slot_r_hand_str = "case", slot_l_hand_str = "case")

/obj/item/storage/briefcase/fission/uranium
	name = "lead lined uranium carrying case"
	icon_state = "carrycaserad"
	starts_with = list(
		/obj/item/fuelrod/uranium,
		/obj/item/fuelrod/uranium,
		/obj/item/fuelrod/uranium,
		/obj/item/fuelrod/uranium
	)

/obj/item/storage/briefcase/fission/plutonium
	name = "lead lined plutonium carrying case"
	icon_state = "carrycaserad"
	starts_with = list(
		/obj/item/fuelrod/plutonium,
		/obj/item/fuelrod/plutonium,
		/obj/item/fuelrod/plutonium,
		/obj/item/fuelrod/plutonium
	)

/obj/item/storage/briefcase/fission/beryllium
	name = "lead lined beryllium carrying case"
	starts_with = list(
		/obj/item/fuelrod/beryllium,
		/obj/item/fuelrod/beryllium,
		/obj/item/fuelrod/beryllium,
		/obj/item/fuelrod/beryllium
	)

/obj/item/storage/briefcase/fission/tungstencarbide
	name = "lead lined tungsten carbide carrying case"
	starts_with = list(
		/obj/item/fuelrod/tungstencarbide,
		/obj/item/fuelrod/tungstencarbide,
		/obj/item/fuelrod/tungstencarbide,
		/obj/item/fuelrod/tungstencarbide
	)

/obj/item/storage/briefcase/fission/silver
	name = "lead lined silver carrying case"
	starts_with = list(
		/obj/item/fuelrod/silver,
		/obj/item/fuelrod/silver,
		/obj/item/fuelrod/silver,
		/obj/item/fuelrod/silver
	)

/obj/item/storage/briefcase/fission/boron
	name = "lead lined boron carrying case"
	starts_with = list(
		/obj/item/fuelrod/boron,
		/obj/item/fuelrod/boron,
		/obj/item/fuelrod/boron,
		/obj/item/fuelrod/boron
	)

/obj/item/storage/briefcase/fission/fuelmixed
	name = "lead lined fuel rod case"
	icon_state = "carrycaserad"
	starts_with = list(
		/obj/item/fuelrod/uranium,
		/obj/item/fuelrod/uranium,
		/obj/item/fuelrod/plutonium,
		/obj/item/fuelrod/plutonium
	)

/obj/item/storage/briefcase/fission/reflectormixed
	name = "lead lined reflector rod case"
	starts_with = list(
		/obj/item/fuelrod/tungstencarbide,
		/obj/item/fuelrod/beryllium,
		/obj/item/fuelrod/beryllium,
		/obj/item/fuelrod/beryllium
	)

/obj/item/storage/briefcase/fission/controlmixed
	name = "lead lined control rod case"
	starts_with = list(
		/obj/item/fuelrod/boron,
		/obj/item/fuelrod/silver,
		/obj/item/fuelrod/silver,
		/obj/item/fuelrod/silver
	)
