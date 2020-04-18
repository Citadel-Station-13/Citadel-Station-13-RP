/obj/item/tank/emergency/phoron/double
	name = "double emergency phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon = 'icons/obj/tank_vr.dmi'
	icon_override = 'icons/mob/belt_vr.dmi'
	icon_state = "emergency_double_vox"
	gauge_icon = "indicator_double"
	gauge_cap = 3
	volume = 10

/obj/item/tank/emergency/phoron/double/New()
	..()
	air_contents.adjust_gas("phoron", (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

//New icons
/obj/item/tank/oxygen
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "oxygen"
	gauge_cap = 3
	gauge_icon = "indicator_bigtank"
// /obj/item/tank/oxygen/yellow
// /obj/item/tank/oxygen/red

/obj/item/tank/anesthetic
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "anesthetic"
	gauge_cap = 3
	gauge_icon = "indicator_bigtank"

/obj/item/tank/air
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "oxygen"
	gauge_cap = 3
	gauge_icon = "indicator_bigtank"

/obj/item/tank/phoron
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "phoron"

/obj/item/tank/vox	//Can't be a child of phoron or the gas amount gets screwey.
	icon = 'icons/obj/tank_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	icon_state = "phoron_vox"
	gauge_cap = 3
	gauge_icon = "indicator_double"

/obj/item/tank/emergency
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/tank/emergency/oxygen
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/tank/emergency/oxygen/engi
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_engi"
	gauge_icon = "indicator_engi"
	gauge_cap = 3

/obj/item/tank/emergency/oxygen/double
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_double"
	gauge_icon = "indicator_double"
	gauge_cap = 3

/obj/item/tank/emergency/nitrogen
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_nitrogen"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/tank/emergency/nitrogen/double
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_double_vox"
	gauge_icon = "indicator_double"
	gauge_cap = 3

/obj/item/tank/emergency/phoron
	icon = 'icons/obj/tank_vr.dmi'
	icon_override = 'icons/mob/belt_vr.dmi'
	icon_state = "emergency_phoron_vox"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/tank/nitrogen
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "oxygen_fr"
	gauge_icon = "indicator_bigtank"
	gauge_cap = 3

//co2
/obj/item/tank/carbon_dioxide
	name = "carbon dioxide tank"
	desc = "Contains co2. Do not inhale. Plants only."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "co2"
	gauge_icon = "indicator_bigtank"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	slot_flags //onmobs cringe tbh

/obj/item/tank/carbon_dioxide/Initialize()
	. = ..()
	air_contents.adjust_gas("carbon_dioxide", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/emergency/carbon_dioxide
	name = "emergency CO2 tank"
	icon = 'icons/obj/tank_vr.dmi'
	desc = "Used for plant emergencies. Contains very little CO2, so try to conserve it until you actually need it."
	icon_state = "emergency_co2"
	gauge_icon = "indicator_engi"
	volume = 6


/obj/item/tank/emergency/carbon_dioxide/Initialize()
	. = ..()
	src.air_contents.adjust_gas("carbon_dioxide", (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/emergency/carbon_dioxide/examine(mob/user)
	if(..(user, 0) && air_contents.gas["carbon_dioxide"] < 0.2 && loc==user)
		to_chat(user, text("<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>"))
		user << sound('sound/effects/alert.ogg')
