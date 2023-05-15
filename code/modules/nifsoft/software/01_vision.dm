//////////////////
// AR HUD Overlays
/datum/nifsoft/hud
	abstract_type = /datum/nifsoft/hud
	var/list/data_huds = list()

/datum/nifsoft/hud/activate(force)
	. = ..()
	if(.)
		// i'd refactor nifsofts but i have a personal goddamn vendetta against nifs
		for(var/i in data_huds)
			var/datum/atom_hud/H = GLOB.huds[i]
			H.add_hud_to(nif.human)

/datum/nifsoft/hud/deactivate(force)
	. = ..()
	if(.)
		for(var/i in data_huds)
			var/datum/atom_hud/H = GLOB.huds[i]
			H.remove_hud_from(nif.human)

/datum/nifsoft/hud/ar_civ
	name = "AR Overlay (Civ)"
	desc = "Provides a general identification and health status overlay on your vision with no frills."
	list_pos = NIF_CIVILIAN_AR
	cost = 50
	a_drain = 0.01
	planes_enabled = list(/atom/movable/screen/plane_master/augmented)
	vision_flags = (NIF_V_AR_CIVILIAN)
	data_huds = list(DATA_HUD_ID_JOB)
	incompatible_with = list(NIF_MEDICAL_AR,NIF_SECURITY_AR,NIF_ENGINE_AR,NIF_SCIENCE_AR,NIF_OMNI_AR)

/datum/nifsoft/hud/ar_med
	name = "AR Overlay (Med)"
	desc = "Like the civilian model, but provides medical records access and virus database lookup."
	list_pos = NIF_MEDICAL_AR
	cost = 150
	access = ACCESS_MEDICAL_MAIN
	a_drain = 0.01
	planes_enabled = list(/atom/movable/screen/plane_master/augmented)
	data_huds = list(DATA_HUD_MEDICAL)
	vision_flags = (NIF_V_AR_MEDICAL)
	incompatible_with = list(NIF_CIVILIAN_AR,NIF_SECURITY_AR,NIF_ENGINE_AR,NIF_SCIENCE_AR,NIF_OMNI_AR)

/datum/nifsoft/hud/ar_sec
	name = "AR Overlay (Sec)"
	desc = "Like the civilian model, but provides access to arrest status and security records."
	list_pos = NIF_SECURITY_AR
	cost = 150
	access = ACCESS_SECURITY_EQUIPMENT
	a_drain = 0.01
	data_huds = list(DATA_HUD_SECURITY_ADVANCED)
	planes_enabled = list(/atom/movable/screen/plane_master/augmented)
	vision_flags = (NIF_V_AR_SECURITY)
	incompatible_with = list(NIF_CIVILIAN_AR,NIF_MEDICAL_AR,NIF_ENGINE_AR,NIF_SCIENCE_AR,NIF_OMNI_AR)

/datum/nifsoft/hud/ar_eng
	name = "AR Overlay (Eng)"
	desc = "Like the civilian model, but provides station alert notices."
	list_pos = NIF_ENGINE_AR
	cost = 150
	access = ACCESS_ENGINEERING_MAIN
	a_drain = 0.01
	data_huds = list(DATA_HUD_ID_JOB)
	planes_enabled = list(/atom/movable/screen/plane_master/augmented)
	vision_flags = (NIF_V_AR_ENGINE)
	incompatible_with = list(NIF_CIVILIAN_AR,NIF_MEDICAL_AR,NIF_SECURITY_AR,NIF_SCIENCE_AR,NIF_OMNI_AR)

/datum/nifsoft/hud/ar_science
	name = "AR Overlay (Sci)"
	desc = "Like the civilian model, but provides ... well, nothing. For now."
	list_pos = NIF_SCIENCE_AR
	cost = 50
	access = ACCESS_SCIENCE_MAIN
	a_drain = 0.01
	data_huds = list(DATA_HUD_ID_JOB)
	planes_enabled = list(/atom/movable/screen/plane_master/augmented)
	vision_flags = (NIF_V_AR_SCIENCE)
	incompatible_with = list(NIF_CIVILIAN_AR,NIF_MEDICAL_AR,NIF_SECURITY_AR,NIF_ENGINE_AR,NIF_OMNI_AR)

/datum/nifsoft/hud/ar_omni
	name = "AR Overlay (Omni)"
	desc = "Like the civilian model, but provides most of the features of the medical and security overlays as well."
	list_pos = NIF_OMNI_AR
	cost = 250
	access = ACCESS_COMMAND_CAPTAIN
	a_drain = 0.01
	data_huds = list(DATA_HUD_SECURITY_ADVANCED, DATA_HUD_MEDICAL)
	planes_enabled = list(/atom/movable/screen/plane_master/augmented)
	vision_flags = (NIF_V_AR_OMNI)
	incompatible_with = list(NIF_CIVILIAN_AR,NIF_MEDICAL_AR,NIF_SECURITY_AR,NIF_ENGINE_AR,NIF_SCIENCE_AR)

//////////////
// Misc Vision
/datum/nifsoft/corrective
	name = "Corrective AR"
	desc = "Subtly alters perception to compensate for cataracts and retinal misalignment, among other common disabilities."
	list_pos = NIF_CORRECTIVE_GLASS
	cost = 50
	a_drain = 0.025
	vision_flags = (NIF_V_CORRECTIVE)

/datum/nifsoft/uvblocker
	name = "Nictating Membrane"
	desc = "A synthetic nictating membrane (aka 'third eyelid') that protects the eyes from UV or hostile atmospheres. Does not protect from photonic stun weapons."
	list_pos = NIF_UVFILTER
	cost = 150
	a_drain = 0.2
	vision_flags = (NIF_V_UVFILTER)

/datum/nifsoft/flashprot
	name = "Responsive Filter"
	desc = "Enables a high-speed shielding response to intense light, such as flashes, to block them."
	list_pos = NIF_FLASHPROT
	cost = 250
	access = ACCESS_SECURITY_EQUIPMENT
	a_drain = 0.05
	vision_flags = (NIF_V_FLASHPROT)

////////////////
// Goggle-alikes
/datum/nifsoft/mesons
	name = "Meson Scanner"
	desc = "Similar to the worn Optical Meson Scanner Goggles, these allow you to see the base structure and terrain through walls."
	list_pos = NIF_MESONS
	cost = 250
	a_drain = 0.1
	access = ACCESS_ENGINEERING_MAIN
	tick_flags = NIF_ACTIVETICK
	vision_holder = /datum/vision/augmenting/legacy_ghetto_nvgs
	vision_flags = (NIF_V_MESONS)
	vision_flags_mob = SEE_TURFS
	vision_flags_mob_remove = SEE_BLACKNESS
	incompatible_with = list(NIF_MATERIAL,NIF_THERMALS,NIF_NIGHTVIS)
	vision_exclusive = TRUE

/datum/nifsoft/material
	name = "Material Scanner"
	desc = "Similar to the worn Optical Material Scanner Goggles, these allow you to see objects through walls."
	list_pos = NIF_MATERIAL
	cost = 250
	a_drain = 0.1
	access = ACCESS_SCIENCE_MAIN
	tick_flags = NIF_ACTIVETICK
	vision_holder = /datum/vision/augmenting/legacy_ghetto_nvgs
	vision_flags = (NIF_V_MATERIAL)
	vision_flags_mob = SEE_OBJS
	vision_flags_mob_remove = SEE_BLACKNESS
	incompatible_with = list(NIF_MESONS,NIF_THERMALS,NIF_NIGHTVIS)
	vision_exclusive = TRUE

/datum/nifsoft/thermals
	name = "Thermal Scanner"
	desc = "Similar to the worn Thermal Goggles, these allow you to see heat-emitting creatures through walls."
	list_pos = NIF_THERMALS
	cost = 1000 // this doesn't get its price adjusted because thermals are fucking op.
	a_drain = 0.1
	illegal = TRUE
	access = 999
	tick_flags = NIF_ACTIVETICK
	vision_holder = /datum/vision/augmenting/legacy_ghetto_nvgs
	planes_enabled = list(/atom/movable/screen/plane_master/cloaked)
	vision_flags = (NIF_V_THERMALS)
	vision_flags_mob = SEE_MOBS
	vision_flags_mob_remove = SEE_BLACKNESS
	incompatible_with = list(NIF_MESONS,NIF_MATERIAL,NIF_NIGHTVIS)
	vision_exclusive = TRUE

/datum/nifsoft/nightvis
	name = "Low-Light Amp"
	desc = "Similar to the worn Night Vision Goggles, these allow you to see in complete darkness."
	list_pos = NIF_NIGHTVIS
	cost = 300 // op as shit
	a_drain = 0.1
	access = ACCESS_SECURITY_EQUIPMENT
	tick_flags = NIF_ACTIVETICK
	vision_flags = (NIF_V_NIGHTVIS)
	vision_holder = /datum/vision/baseline/nvg_lowtech
	incompatible_with = list(NIF_MESONS,NIF_MATERIAL,NIF_THERMALS)
	vision_exclusive = TRUE
