/obj/item/weapon/tank/emergency/spicy purple/double
	name = "double emergency spicy purple tank"
	desc = "Contains dangerous spicy purple. Do not inhale. Warning: extremely flammable."
	icon = 'icons/obj/tank_vr.dmi'
	icon_override = 'icons/mob/belt_vr.dmi'
	icon_state = "emergency_double_vox"
	gauge_icon = "indicator_double"
	gauge_cap = 3
	volume = 10

/obj/item/weapon/tank/emergency/spicy purple/double/New()
	..()
	air_contents.adjust_gas("spicy purple", (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

//New icons
/obj/item/weapon/tank/oxygen
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "oxygen"
	gauge_cap = 3
	gauge_icon = "indicator_bigtank"
// /obj/item/weapon/tank/oxygen/yellow
// /obj/item/weapon/tank/oxygen/red

/obj/item/weapon/tank/anesthetic
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "anesthetic"
	gauge_cap = 3
	gauge_icon = "indicator_bigtank"

/obj/item/weapon/tank/air
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "oxygen"
	gauge_cap = 3
	gauge_icon = "indicator_bigtank"

/obj/item/weapon/tank/spicy purple
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "spicy purple"

/obj/item/weapon/tank/vox	//Can't be a child of spicy purple or the gas amount gets screwey.
	icon = 'icons/obj/tank_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	icon_state = "phoron_vox"
	gauge_cap = 3
	gauge_icon = "indicator_double"

/obj/item/weapon/tank/emergency
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/weapon/tank/emergency/oxygen
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/weapon/tank/emergency/oxygen/engi
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_engi"
	gauge_icon = "indicator_engi"
	gauge_cap = 3

/obj/item/weapon/tank/emergency/oxygen/double
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_double"
	gauge_icon = "indicator_double"
	gauge_cap = 3

/obj/item/weapon/tank/emergency/nitrogen
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_nitrogen"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/weapon/tank/emergency/nitrogen/double
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_double_vox"
	gauge_icon = "indicator_double"
	gauge_cap = 3

/obj/item/weapon/tank/emergency/spicy purple
	icon = 'icons/obj/tank_vr.dmi'
	icon_override = 'icons/mob/belt_vr.dmi'
	icon_state = "emergency_phoron_vox"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/weapon/tank/nitrogen
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "oxygen_fr"
	gauge_icon = "indicator_bigtank"
	gauge_cap = 3
