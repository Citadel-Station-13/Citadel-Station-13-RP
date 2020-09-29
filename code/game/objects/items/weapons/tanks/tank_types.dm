/* Types of tanks!
 * Contains:
 *		Oxygen
 *		Anesthetic
 *		Air
 *		Phoron
 *		Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "oxygen"
	gauge_cap = 3
	gauge_icon = "indicator_bigtank"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD

/obj/item/tank/oxygen/Initialize()
	. = ..()
	air_contents.adjust_gas(/datum/gas/oxygen, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/oxygen/examine(mob/user)
	if(..(user, 0) && air_contents.gas[/datum/gas/oxygen] < 10)
		to_chat(user, text("<span class='warning'>The meter on \the [src] indicates you are almost out of oxygen!</span>"))
		//playsound(usr, 'sound/effects/alert.ogg', 50, 1)

/obj/item/tank/oxygen/yellow
	desc = "A tank of oxygen, this one is yellow."
	icon_state = "oxygen_f"

/obj/item/tank/oxygen/red
	desc = "A tank of oxygen, this one is red."
	icon_state = "oxygen_fr"

/*
 * Anesthetic
 */
/obj/item/tank/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "anesthetic"
	gauge_cap = 3
	gauge_icon = "indicator_bigtank"

/obj/item/tank/anesthetic/Initialize()
	. = ..()

	air_contents.gas[/datum/gas/oxygen] = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD
	air_contents.gas[/datum/gas/nitrous_oxide] = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD
	air_contents.update_values()

/*
 * Air
 */
/obj/item/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "oxygen"
	gauge_cap = 3
	gauge_icon = "indicator_bigtank"

/obj/item/tank/air/examine(mob/user)
	if(..(user, 0) && air_contents.gas[/datum/gas/oxygen] < 1 && loc==user)
		to_chat(user, "<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>")
		user << sound('sound/effects/alert.ogg')

/obj/item/tank/air/Initialize()
	. = ..()

	src.air_contents.adjust_multi(/datum/gas/oxygen, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD, /datum/gas/nitrogen, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD)

/*
 * Phoron
 */
/obj/item/tank/phoron
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "phoron"
	gauge_icon = null
	slot_flags = null	//they have no straps!

/obj/item/tank/phoron/Initialize()
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/phoron, (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/phoron/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if (istype(W, /obj/item/flamethrower))
		var/obj/item/flamethrower/F = W
		if ((!F.status)||(F.ptank))	return
		src.master = F
		F.ptank = src
		user.remove_from_mob(src)
		src.loc = F
	return

/obj/item/tank/vox	//Can't be a child of phoron or the gas amount gets screwey.
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon = 'icons/obj/tank_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	icon_state = "phoron_vox"
	gauge_icon = "indicator_double"
	gauge_cap = 3
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	slot_flags = SLOT_BACK	//these ones have straps!

/obj/item/tank/vox/Initialize()
	..()

	air_contents.adjust_gas(/datum/gas/phoron, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return

/*
 * Emergency Oxygen
 */

/obj/item/tank/emergency
	name = "emergency tank"
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	force = 4
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 2 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)

/obj/item/tank/emergency/oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/tank/emergency/oxygen/Initialize()
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/oxygen, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/emergency/oxygen/examine(mob/user)
	if(..(user, 0) && air_contents.gas[/datum/gas/oxygen] < 0.2 && loc==user)
		to_chat(user, text("<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>"))
		user << sound('sound/effects/alert.ogg')

/obj/item/tank/emergency/oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	volume = 6
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_engi"
	gauge_icon = "indicator_engi"
	gauge_cap = 3

/obj/item/tank/emergency/oxygen/double
	name = "double emergency oxygen tank"
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_double"
	gauge_icon = "indicator_double"
	gauge_cap = 3
	volume = 10

/obj/item/tank/stasis/oxygen // Stasis bags need to have initial pressure within safe bounds for human atmospheric pressure (NOT breath pressure)
	name = "stasis oxygen tank"
	desc = "Oxygen tank included in most stasis bag designs."
	icon_state = "emergency_double"
	gauge_icon = "indicator_emergency_double"
	volume = 10

/obj/item/tank/stasis/oxygen/Initialize()
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/oxygen, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/emergency/nitrogen
	name = "emergency nitrogen tank"
	desc = "An emergency air tank hastily painted red."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_nitrogen"
	gauge_icon = "indicator_smalltank"
	gauge_cap = 3

/obj/item/tank/emergency/nitrogen/Initialize()
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/nitrogen, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/emergency/nitrogen/double
	name = "double emergency nitrogen tank"
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "emergency_double_vox"
	gauge_icon = "indicator_double"
	gauge_cap = 3
	volume = 10

/obj/item/tank/emergency/phoron
	name = "emergency phoron tank"
	desc = "An emergency air tank hastily painted red."
	icon = 'icons/obj/tank_vr.dmi'
	icon_override = 'icons/mob/belt_vr.dmi'
	icon_state = "emergency_phoron_vox"
	gauge_icon = "indicator_smalltank"
	volume = 6
	gauge_cap = 3

/obj/item/tank/emergency/phoron/Initialize()
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/phoron, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

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
	air_contents.adjust_gas(/datum/gas/phoron, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/*
 * Nitrogen
 */
/obj/item/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "oxygen_fr"
	gauge_icon = "indicator_bigtank"
	gauge_cap = 3
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD

/obj/item/tank/nitrogen/Initialize()
	. = ..()

	src.air_contents.adjust_gas(/datum/gas/nitrogen, (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/nitrogen/examine(mob/user)
	if(..(user, 0) && air_contents.gas[/datum/gas/nitrogen] < 10)
		to_chat(user, text("<span class='danger'>The meter on \the [src] indicates you are almost out of nitrogen!</span>"))
		//playsound(user, 'sound/effects/alert.ogg', 50, 1)

/obj/item/tank/stasis/nitro_cryo // Synthmorph bags need to have initial pressure within safe bounds for human atmospheric pressure, but low temperature to stop unwanted degredation.
	name = "stasis cryogenic nitrogen tank"
	desc = "Cryogenic Nitrogen tank included in most synthmorph bag designs."
	icon_state = "emergency_double_nitro"
	gauge_icon = "indicator_emergency_double"
	volume = 10

/obj/item/tank/stasis/nitro_cryo/Initialize()
	. = ..()
	src.air_contents.adjust_gas_temp(/datum/gas/nitrogen, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*TN60C), TN60C)

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
	air_contents.adjust_gas(/datum/gas/carbon_dioxide, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/emergency/carbon_dioxide
	name = "emergency CO2 tank"
	icon = 'icons/obj/tank_vr.dmi'
	desc = "Used for plant emergencies. Contains very little CO2, so try to conserve it until you actually need it."
	icon_state = "emergency_co2"
	gauge_icon = "indicator_engi"
	volume = 6


/obj/item/tank/emergency/carbon_dioxide/Initialize()
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/carbon_dioxide, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/emergency/carbon_dioxide/examine(mob/user)
	if(..(user, 0) && air_contents.gas[/datum/gas/carbon_dioxide] < 0.2 && loc==user)
		to_chat(user, text("<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>"))
		user << sound('sound/effects/alert.ogg')
