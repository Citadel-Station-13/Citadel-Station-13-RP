

/**
  * Variable settings controller. Sorta like config but not as much as meant to be customized by config as much as adminbus purposes.
  */
/datum/variable_settings_controller
	/// Our user friendly name
	var/name = "Controller"
	/// List of entries by type.
	var/list/entries_by_type = list()
	/// List of entries by category
	var/list/entries_by_category = list()
	/// List of entries followed by default values.
	var/list/initial_entries = list()
	/// List of presets followed by a list of entries to set to specific values. Entries not included are not impacted
	var/list/presets = list()
	/// Default entry set name
	var/initial_preset_name = "RESET TO DEFAULT"

/datum/variable_settings_controller/New()
	for(var/path in initial_entries)
		var/datum/variable_setting_entry/E = new path(initial_entries[path])
		entries_by_type[path] = E
		LAZYINITLIST(entries_by_category[E.category])
		entries_by_category[E.category] += E

/datum/variable_settings_controller/Topic(href, href_list)
	if(..())
		return
	if(!check_rights())
		to_chat(usr, "<span class='boldwarning'>You must be an admin to modify this.</span>")
		var/logline = "[key_name(usr)] attempted to modify [src] without permissions."
		message_admins(logline)
		log_admin(logline)
		return TRUE

/datum/variable_settings_controller/proc/get_entries()
	. = list()
	for(var/path in entries_by_type)
		. += entries_by_type[path]

/datum/variable_settings_controller/proc/reset_to_default()
	for(var/datum/variable_setting_entry/E in get_entries())
		E.reset_to_default()

/datum/variable_settings_controller/proc/get_value(path)
	var/datum/variable_setting_entry/E = entries_by_type[path]
	return E.value

/datum/variable_settings_controller/proc/get_datum(path)
	return entries_by_path[path]

/**
  * Variable settings entry. There cannot be duplicate entries of the same typepath in a controller.
  */
/datum/variable_setting_entry
	/// User friendly name
	var/name = "Entry"
	/// User friendly description
	var/desc = "A bugged entry!"
	/// Category
	var/category = "General"
	/// Current value
	var/value
	/// Initial value
	var/initial_value
	/// VV class for the default implementation of prompt_value.
	var/value_vv_class
	/// Allow nulls?
	var/allow_null = FALSE

/datum/variable_setting_entry/New(_value)
	if(!islist(_value))
		value = initial_value = _value
	else
		value = deepCopyList(_value)
		initial_value = deepCopyList(_value)
	if(initial_value && isnull(value_vv_class))
		value_vv_class = vv_get_class(initial_value)
	// we do not handle datums yet.

/datum/variable_setting_entry/proc/reset_to_default()
	if(islist(initial_value))
		value = deepCopyList(initial_value)
	else
		value = initial_value

/datum/variable_setting_entry/proc/set_value(newvalue)
	value = newvalue

/datum/variable_setting_entry/proc/ui_html(datum/variable_settings_controller/host)
	. = list()
	. += "<h3>[name]</h3> - <b>\[<a href='?src=[REF(host)];target=[type];set=1'>SET</a>\]</b><br>"
	. += "[desc]"

/datum/variable_setting_entry/proc/prompt_value(mob/user)
	var/list/vv_return = user.client.vv_get_value(class = value_vv_class, current_value = value)
	return vv_return["value"]

/datum/variable_setting_entry/proc/OnTopic(href, href_list)
	if(href_list["set"])
		var/val = prompt_value(user)
		if(isnull(val) && !allow_null)
			return FALSE
		set_value(val)
		return TRUE
	if(href_list["initial"])
		reset_to_default()
		return TRUE
	return FALSE

/datum/variable_setting_entry/number
	value_vv_class = VV_NUM

GLOBAL_DATUM_INIT(atmos_vsc, /datum/variable_settings_controller/atmospherics, new)

/datum/variable_settings_controller/atmospherics
	initial_entries = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_Setting_entry/atmos/fire/firelevel_multiplier = 25,
		/datum/variable_setting_entry/atmos/fire/fuel_energy_release = 866000,
		/datum/variable_setting_entry/atmos/fire/ignition_level = 0.5,
		/datum/variable_setting_entry/atmos/airflow/lightest_pressure = 20,
		/datum/variable_setting_entry/atmos/airflow/light_pressure = 35,
		/datum/variable_setting_entry/atmos/airflow/medium_pressure = 50,
		/datum/variable_setting_entry/atmos/airflow/heavy_pressure = 65,
		/datum/variable_setting_entry/atmos/airflow/dense_pressure = 85,
		/datum/variable_setting_entry/atmos/airflow/stun_pressure = 60,
		/datum/variable_setting_entry/atmos/airflow/stun_cooldown = 60,
		/datum/variable_setting_entry/atmos/airflow/impact_stun = 1,
		/datum/variable_setting_entry/atmos/airflow/impact_damage = 2,
		/datum/variable_setting_entry/atmos/airflow/speed_decay = 1.5,
		/datum/variable_setting_entry/atmos/airflow/retrigger_delay = 30,
		/datum/variable_setting_entry/atmos/airflow/mob_slowdown = 1,
		/datum/variable_setting_entry/atmos/connection/insulation = TRUE,
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10
	)
	presets = list(

	)
	initial_preset_name = "RESET TO DEFAULT"

/datum/variable_setting_entry/atmos

/datum/variable_setting_entry/atmos/fire
	category = "Fire"

/datum/variable_setting_entry/atmos/fire/consumption_rate
	name = "Air Consumption Ratio"
	desc = "Ratio of air removed and combusted per tick."

/datum/variable_setting_entry/atmos/fire/firelevel_multiplier
	name = "Firelevel Constant"
	desc = "Multiplied by the equation for firelevel, affects mainly the extinguishing of fires."

/datum/variable_setting_entry/atmos/fire/fuel_energy_release
	name = "Fuel Energy Release"
	desc = "Joules released when burning one mol of a burnable substance."

/datum/variable_setting_entry/atmos/fire/ignition_level
	name = "Ignition Level"
	desc = "Point at which fire can ignite"

/datum/variable_setting_entry/atmos/airflow
	category = "Airflow"

/datum/variable_setting_entry/atmos/airflow/lightest_pressure
	name = "Small Movement Threshold %"
	desc = "Percent of 1 Atm. at which items with the small weight classes will move."

/datum/variable_setting_entry/atmos/airflow/light_pressure
	name = "Medium Movement Threshold %"
	desc = "Percent of 1 Atm. at which items with the medium weight classes will move."

/datum/variable_setting_entry/atmos/airflow/medium_pressure
	name = "Heavy Movement Threshold Threshold %"
	desc = "Percent of 1 Atm. at which items with the largest weight classes will move."

/datum/variable_setting_entry/atmos/airflow/heavy_pressure
	name = "Mob Movement Threshold %"
	desc = "Percent of 1 Atm. at which mobs will move."

/datum/variable_setting_entry/atmos/airflow/dense_pressure
	name = "Dense Movement Threshold %"
	desc = "Percent of 1 Atm. at which dense objects like canisters and closets will move."

/datum/variable_setting_entry/atmos/airflow/stun_pressure
	name = "Mob Stunning Threshold %"
	desc = "Percent of 1 Atm. at which mobs will be stunned by airflow."

/datum/variable_setting_entry/atmos/airflow/stun_cooldown
	name = "Stunning Cooldown"
	desc = "How long in deciseconds to wait before stunning mobs again."

/datum/variable_setting_entry/atmos/airflow/impact_stun
	name = "Impact Stun"
	desc = "How much a mob is stunned when hit by an object."

/datum/variable_setting_entry/atmos/airflow/impact_damage
	name = "Impact Damage"
	desc = "How much damage to deal on airflow impacts."

/datum/variable_setting_entry/atmos/airflow/speed_decay
	name = "Speed Decay"
	desc = "How rapidly the speed gained from airflow decays."

/datum/variable_setting_entry/atmos/airflow/retrigger_delay
	name = "Retrigger Delay"
	desc = "Time in deciseconds before things can be moved by airflow agian."

/datum/variable_setting_entry/atmos/airflow/mob_slowdown
	name = "Mob Slowdown"
	desc = "Movespeed delay to add to a mob fighting the pull of airflow."

/datum/variable_setting_entry/atmos/connection
	category = "Connection"

/datum/variable_setting_entry/atmos/connection/insulation
	name = "Insulation"
	desc = "Should things like doors forbid heat transfer?"

/datum/variable_setting_entry/atmos/connection/temperature_delta
	name = "Temperature Difference"
	desc = "Smallest temperature difference that will cause heat to pass through things like doors."


/pl_control
	var/PHORON_DMG = 3
	var/PHORON_DMG_NAME = "Phoron Damage Amount"
	var/PHORON_DMG_DESC = "Self Descriptive"

	var/CLOTH_CONTAMINATION = 1
	var/CLOTH_CONTAMINATION_NAME = "Cloth Contamination"
	var/CLOTH_CONTAMINATION_DESC = "If this is on, phoron does damage by getting into cloth."

	var/PHORONGUARD_ONLY = 0
	var/PHORONGUARD_ONLY_NAME = "\"PhoronGuard Only\""
	var/PHORONGUARD_ONLY_DESC = "If this is on, only biosuits and spacesuits protect against contamination and ill effects."

	var/GENETIC_CORRUPTION = 0
	var/GENETIC_CORRUPTION_NAME = "Genetic Corruption Chance"
	var/GENETIC_CORRUPTION_DESC = "Chance of genetic corruption as well as toxic damage, X in 10,000."

	var/SKIN_BURNS = 0
	var/SKIN_BURNS_DESC = "Phoron has an effect similar to mustard gas on the un-suited."
	var/SKIN_BURNS_NAME = "Skin Burns"

	var/EYE_BURNS = 1
	var/EYE_BURNS_NAME = "Eye Burns"
	var/EYE_BURNS_DESC = "Phoron burns the eyes of anyone not wearing eye protection."

	var/CONTAMINATION_LOSS = 0.02
	var/CONTAMINATION_LOSS_NAME = "Contamination Loss"
	var/CONTAMINATION_LOSS_DESC = "How much toxin damage is dealt from contaminated clothing" //Per tick?  ASK ARYN

	var/PHORON_HALLUCINATION = 0
	var/PHORON_HALLUCINATION_NAME = "Phoron Hallucination"
	var/PHORON_HALLUCINATION_DESC = "Does being in phoron cause you to hallucinate?"

	var/N2O_HALLUCINATION = 1
	var/N2O_HALLUCINATION_NAME = "N2O Hallucination"
	var/N2O_HALLUCINATION_DESC = "Does being in sleeping gas cause you to hallucinate?"



/vs_control/proc/SetDefault(var/mob/user)
	var/list/setting_choices = list("Phoron - Standard", "Phoron - Low Hazard", "Phoron - High Hazard", "Phoron - Oh Shit!",\
	"ZAS - Normal", "ZAS - Forgiving", "ZAS - Dangerous", "ZAS - Hellish", "ZAS/Phoron - Initial")
	var/def = input(user, "Which of these presets should be used?") as null|anything in setting_choices
	if(!def)
		return
	switch(def)
		if("Phoron - Standard")
			plc.CLOTH_CONTAMINATION = 1 //If this is on, phoron does damage by getting into cloth.
			plc.PHORONGUARD_ONLY = 0
			plc.GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 1000.
			plc.SKIN_BURNS = 0       //Phoron has an effect similar to mustard gas on the un-suited.
			plc.EYE_BURNS = 1 //Phoron burns the eyes of anyone not wearing eye protection.
			plc.PHORON_HALLUCINATION = 0
			plc.CONTAMINATION_LOSS = 0.02

		if("Phoron - Low Hazard")
			plc.CLOTH_CONTAMINATION = 0 //If this is on, phoron does damage by getting into cloth.
			plc.PHORONGUARD_ONLY = 0
			plc.GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 1000
			plc.SKIN_BURNS = 0       //Phoron has an effect similar to mustard gas on the un-suited.
			plc.EYE_BURNS = 1 //Phoron burns the eyes of anyone not wearing eye protection.
			plc.PHORON_HALLUCINATION = 0
			plc.CONTAMINATION_LOSS = 0.01

		if("Phoron - High Hazard")
			plc.CLOTH_CONTAMINATION = 1 //If this is on, phoron does damage by getting into cloth.
			plc.PHORONGUARD_ONLY = 0
			plc.GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 1000.
			plc.SKIN_BURNS = 1       //Phoron has an effect similar to mustard gas on the un-suited.
			plc.EYE_BURNS = 1 //Phoron burns the eyes of anyone not wearing eye protection.
			plc.PHORON_HALLUCINATION = 1
			plc.CONTAMINATION_LOSS = 0.05

		if("Phoron - Oh Shit!")
			plc.CLOTH_CONTAMINATION = 1 //If this is on, phoron does damage by getting into cloth.
			plc.PHORONGUARD_ONLY = 1
			plc.GENETIC_CORRUPTION = 5 //Chance of genetic corruption as well as toxic damage, X in 1000.
			plc.SKIN_BURNS = 1       //Phoron has an effect similar to mustard gas on the un-suited.
			plc.EYE_BURNS = 1 //Phoron burns the eyes of anyone not wearing eye protection.
			plc.PHORON_HALLUCINATION = 1
			plc.CONTAMINATION_LOSS = 0.075





	"ZAS - Standard" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_Setting_entry/atmos/fire/firelevel_multiplier = 25,
		/datum/variable_setting_entry/atmos/fire/fuel_energy_release = 866000,
		/datum/variable_setting_entry/atmos/fire/ignition_level = 0.5,
		/datum/variable_setting_entry/atmos/airflow/lightest_pressure = 20,
		/datum/variable_setting_entry/atmos/airflow/light_pressure = 35,
		/datum/variable_setting_entry/atmos/airflow/medium_pressure = 50,
		/datum/variable_setting_entry/atmos/airflow/heavy_pressure = 65,
		/datum/variable_setting_entry/atmos/airflow/dense_pressure = 85,
		/datum/variable_setting_entry/atmos/airflow/stun_pressure = 60,
		/datum/variable_setting_entry/atmos/airflow/stun_cooldown = 60,
		/datum/variable_setting_entry/atmos/airflow/impact_stun = 1,
		/datum/variable_setting_entry/atmos/airflow/impact_damage = 2,
		/datum/variable_setting_entry/atmos/airflow/speed_decay = 1.5,
		/datum/variable_setting_entry/atmos/airflow/retrigger_delay = 30,
		/datum/variable_setting_entry/atmos/airflow/mob_slowdown = 1,
		/datum/variable_setting_entry/atmos/connection/insulation = TRUE,
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10
	),
	"ZAS - Forgiving" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_Setting_entry/atmos/fire/firelevel_multiplier = 25,
		/datum/variable_setting_entry/atmos/fire/fuel_energy_release = 866000,
		/datum/variable_setting_entry/atmos/fire/ignition_level = 0.5,
		/datum/variable_setting_entry/atmos/airflow/lightest_pressure = 45,
		/datum/variable_setting_entry/atmos/airflow/light_pressure = 60,
		/datum/variable_setting_entry/atmos/airflow/medium_pressure = 120,
		/datum/variable_setting_entry/atmos/airflow/heavy_pressure = 110,
		/datum/variable_setting_entry/atmos/airflow/dense_pressure = 200,
		/datum/variable_setting_entry/atmos/airflow/stun_pressure = 150,
		/datum/variable_setting_entry/atmos/airflow/stun_cooldown = 90,
		/datum/variable_setting_entry/atmos/airflow/impact_stun = 0.15,
		/datum/variable_setting_entry/atmos/airflow/impact_damage = 0.15,
		/datum/variable_setting_entry/atmos/airflow/speed_decay = 1.5,
		/datum/variable_setting_entry/atmos/airflow/retrigger_delay = 50,
		/datum/variable_setting_entry/atmos/airflow/mob_slowdown = 0,
		/datum/variable_setting_entry/atmos/connection/insulation = TRUE,
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10
	),	"ZAS - Dangerous" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_Setting_entry/atmos/fire/firelevel_multiplier = 25,
		/datum/variable_setting_entry/atmos/fire/fuel_energy_release = 866000,
		/datum/variable_setting_entry/atmos/fire/ignition_level = 0.5,
		/datum/variable_setting_entry/atmos/airflow/lightest_pressure = 15,
		/datum/variable_setting_entry/atmos/airflow/light_pressure = 30,
		/datum/variable_setting_entry/atmos/airflow/medium_pressure = 45,
		/datum/variable_setting_entry/atmos/airflow/heavy_pressure = 55,
		/datum/variable_setting_entry/atmos/airflow/dense_pressure = 70,
		/datum/variable_setting_entry/atmos/airflow/stun_pressure = 50,
		/datum/variable_setting_entry/atmos/airflow/stun_cooldown = 50,
		/datum/variable_setting_entry/atmos/airflow/impact_stun = 2,
		/datum/variable_setting_entry/atmos/airflow/impact_damage = 3,
		/datum/variable_setting_entry/atmos/airflow/speed_decay = 1.2,
		/datum/variable_setting_entry/atmos/airflow/retrigger_delay = 25,
		/datum/variable_setting_entry/atmos/airflow/mob_slowdown = 2,
		/datum/variable_setting_entry/atmos/connection/insulation = TRUE,
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10
	),	"ZAS - Hell" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_Setting_entry/atmos/fire/firelevel_multiplier = 25,
		/datum/variable_setting_entry/atmos/fire/fuel_energy_release = 866000,
		/datum/variable_setting_entry/atmos/fire/ignition_level = 0.5,
		/datum/variable_setting_entry/atmos/airflow/lightest_pressure = 20,
		/datum/variable_setting_entry/atmos/airflow/light_pressure = 30,
		/datum/variable_setting_entry/atmos/airflow/medium_pressure = 40,
		/datum/variable_setting_entry/atmos/airflow/heavy_pressure = 50,
		/datum/variable_setting_entry/atmos/airflow/dense_pressure = 60,
		/datum/variable_setting_entry/atmos/airflow/stun_pressure = 40,
		/datum/variable_setting_entry/atmos/airflow/stun_cooldown = 40,
		/datum/variable_setting_entry/atmos/airflow/impact_stun = 3,
		/datum/variable_setting_entry/atmos/airflow/impact_damage = 4,
		/datum/variable_setting_entry/atmos/airflow/speed_decay = 1,
		/datum/variable_setting_entry/atmos/airflow/retrigger_delay = 20,
		/datum/variable_setting_entry/atmos/airflow/mob_slowdown = 3,
		/datum/variable_setting_entry/atmos/connection/insulation = FALSE,
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10
	),	"Preset" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_Setting_entry/atmos/fire/firelevel_multiplier = 25,
		/datum/variable_setting_entry/atmos/fire/fuel_energy_release = 866000,
		/datum/variable_setting_entry/atmos/fire/ignition_level = 0.5,
		/datum/variable_setting_entry/atmos/airflow/lightest_pressure = 20,
		/datum/variable_setting_entry/atmos/airflow/light_pressure = 35,
		/datum/variable_setting_entry/atmos/airflow/medium_pressure = 50,
		/datum/variable_setting_entry/atmos/airflow/heavy_pressure = 65,
		/datum/variable_setting_entry/atmos/airflow/dense_pressure = 85,
		/datum/variable_setting_entry/atmos/airflow/stun_pressure = 60,
		/datum/variable_setting_entry/atmos/airflow/stun_cooldown = 60,
		/datum/variable_setting_entry/atmos/airflow/impact_stun = TRUE,
		/datum/variable_setting_entry/atmos/airflow/impact_damage = 2,
		/datum/variable_setting_entry/atmos/airflow/speed_decay = 1.5,
		/datum/variable_setting_entry/atmos/airflow/retrigger_delay = 30,
		/datum/variable_setting_entry/atmos/airflow/mob_slowdown = 1,
		/datum/variable_setting_entry/atmos/connection/insulation = TRUE,
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10
	),	"Preset" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_Setting_entry/atmos/fire/firelevel_multiplier = 25,
		/datum/variable_setting_entry/atmos/fire/fuel_energy_release = 866000,
		/datum/variable_setting_entry/atmos/fire/ignition_level = 0.5,
		/datum/variable_setting_entry/atmos/airflow/lightest_pressure = 20,
		/datum/variable_setting_entry/atmos/airflow/light_pressure = 35,
		/datum/variable_setting_entry/atmos/airflow/medium_pressure = 50,
		/datum/variable_setting_entry/atmos/airflow/heavy_pressure = 65,
		/datum/variable_setting_entry/atmos/airflow/dense_pressure = 85,
		/datum/variable_setting_entry/atmos/airflow/stun_pressure = 60,
		/datum/variable_setting_entry/atmos/airflow/stun_cooldown = 60,
		/datum/variable_setting_entry/atmos/airflow/impact_stun = TRUE,
		/datum/variable_setting_entry/atmos/airflow/impact_damage = 2,
		/datum/variable_setting_entry/atmos/airflow/speed_decay = 1.5,
		/datum/variable_setting_entry/atmos/airflow/retrigger_delay = 30,
		/datum/variable_setting_entry/atmos/airflow/mob_slowdown = 1,
		/datum/variable_setting_entry/atmos/connection/insulation = TRUE,
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10
	),	"Preset" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_Setting_entry/atmos/fire/firelevel_multiplier = 25,
		/datum/variable_setting_entry/atmos/fire/fuel_energy_release = 866000,
		/datum/variable_setting_entry/atmos/fire/ignition_level = 0.5,
		/datum/variable_setting_entry/atmos/airflow/lightest_pressure = 20,
		/datum/variable_setting_entry/atmos/airflow/light_pressure = 35,
		/datum/variable_setting_entry/atmos/airflow/medium_pressure = 50,
		/datum/variable_setting_entry/atmos/airflow/heavy_pressure = 65,
		/datum/variable_setting_entry/atmos/airflow/dense_pressure = 85,
		/datum/variable_setting_entry/atmos/airflow/stun_pressure = 60,
		/datum/variable_setting_entry/atmos/airflow/stun_cooldown = 60,
		/datum/variable_setting_entry/atmos/airflow/impact_stun = TRUE,
		/datum/variable_setting_entry/atmos/airflow/impact_damage = 2,
		/datum/variable_setting_entry/atmos/airflow/speed_decay = 1.5,
		/datum/variable_setting_entry/atmos/airflow/retrigger_delay = 30,
		/datum/variable_setting_entry/atmos/airflow/mob_slowdown = 1,
		/datum/variable_setting_entry/atmos/connection/insulation = TRUE,
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10
	),	"Preset" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_Setting_entry/atmos/fire/firelevel_multiplier = 25,
		/datum/variable_setting_entry/atmos/fire/fuel_energy_release = 866000,
		/datum/variable_setting_entry/atmos/fire/ignition_level = 0.5,
		/datum/variable_setting_entry/atmos/airflow/lightest_pressure = 20,
		/datum/variable_setting_entry/atmos/airflow/light_pressure = 35,
		/datum/variable_setting_entry/atmos/airflow/medium_pressure = 50,
		/datum/variable_setting_entry/atmos/airflow/heavy_pressure = 65,
		/datum/variable_setting_entry/atmos/airflow/dense_pressure = 85,
		/datum/variable_setting_entry/atmos/airflow/stun_pressure = 60,
		/datum/variable_setting_entry/atmos/airflow/stun_cooldown = 60,
		/datum/variable_setting_entry/atmos/airflow/impact_stun = TRUE,
		/datum/variable_setting_entry/atmos/airflow/impact_damage = 2,
		/datum/variable_setting_entry/atmos/airflow/speed_decay = 1.5,
		/datum/variable_setting_entry/atmos/airflow/retrigger_delay = 30,
		/datum/variable_setting_entry/atmos/airflow/mob_slowdown = 1,
		/datum/variable_setting_entry/atmos/connection/insulation = TRUE,
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10
	)
