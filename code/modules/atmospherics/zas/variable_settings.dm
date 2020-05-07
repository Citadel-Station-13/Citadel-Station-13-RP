GLOBAL_DATUM_INIT(atmos_vsc, /datum/variable_settings_controller/atmospherics, new)

/datum/variable_settings_controller/atmospherics
	initial_entries = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_setting_entry/atmos/fire/firelevel_multiplier = 25,
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
		/datum/variable_setting_entry/atmos/connection/temperature_delta = 10,
		/datum/variable_setting_entry/atmos/phoron/damage = 3,
		/datum/variable_setting_entry/atmos/phoron/contamination = TRUE,
		/datum/variable_setting_entry/atmos/phoron/phoronguard_only = FALSE,
		/datum/variable_setting_entry/atmos/phoron/genetic_corruption = 0,
		/datum/variable_setting_entry/atmos/phoron/skin_burns = 0,
		/datum/variable_setting_entry/atmos/phoron/eye_burns = 1,
		/datum/variable_setting_entry/atmos/phoron/contamination_loss = 0.02,
		/datum/variable_setting_entry/atmos/phoron/hallucination = FALSE,
		/datum/variable_setting_entry/atmos/n2o/hallucination = TRUE
	)
	presets = list(
	"ZAS - Standard" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_setting_entry/atmos/fire/firelevel_multiplier = 25,
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
		/datum/variable_setting_entry/atmos/fire/firelevel_multiplier = 25,
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
		),
	"ZAS - Dangerous" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_setting_entry/atmos/fire/firelevel_multiplier = 25,
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
		),
	"ZAS - Hell" = list(
		/datum/variable_setting_entry/atmos/fire/consumption_rate = 0.25,
		/datum/variable_setting_entry/atmos/fire/firelevel_multiplier = 25,
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
		),
	"Phoron - Standard" = list(
		/datum/variable_setting_entry/atmos/phoron/damage = 3,
		/datum/variable_setting_entry/atmos/phoron/contamination = TRUE,
		/datum/variable_setting_entry/atmos/phoron/phoronguard_only = FALSE,
		/datum/variable_setting_entry/atmos/phoron/genetic_corruption = 0,
		/datum/variable_setting_entry/atmos/phoron/skin_burns = 0,
		/datum/variable_setting_entry/atmos/phoron/eye_burns = 1,
		/datum/variable_setting_entry/atmos/phoron/contamination_loss = 0.02,
		/datum/variable_setting_entry/atmos/phoron/hallucination = FALSE,
		),
	"Phoron - Low Hazard" = list(
		/datum/variable_setting_entry/atmos/phoron/damage = 3,
		/datum/variable_setting_entry/atmos/phoron/contamination = FALSE,
		/datum/variable_setting_entry/atmos/phoron/phoronguard_only = FALSE,
		/datum/variable_setting_entry/atmos/phoron/genetic_corruption = 0,
		/datum/variable_setting_entry/atmos/phoron/skin_burns = 0,
		/datum/variable_setting_entry/atmos/phoron/eye_burns = 1,
		/datum/variable_setting_entry/atmos/phoron/contamination_loss = 0.01,
		/datum/variable_setting_entry/atmos/phoron/hallucination = FALSE,
		),
	"Phoron - High Hazard" = list(
		/datum/variable_setting_entry/atmos/phoron/damage = 3,
		/datum/variable_setting_entry/atmos/phoron/contamination = TRUE,
		/datum/variable_setting_entry/atmos/phoron/phoronguard_only = FALSE,
		/datum/variable_setting_entry/atmos/phoron/genetic_corruption = 0,
		/datum/variable_setting_entry/atmos/phoron/skin_burns = 1,
		/datum/variable_setting_entry/atmos/phoron/eye_burns = 1,
		/datum/variable_setting_entry/atmos/phoron/contamination_loss = 0.05,
		/datum/variable_setting_entry/atmos/phoron/hallucination = TRUE,
		),
	"Phoron - Oh Shit!" = list(
		/datum/variable_setting_entry/atmos/phoron/damage = 3,
		/datum/variable_setting_entry/atmos/phoron/contamination = TRUE,
		/datum/variable_setting_entry/atmos/phoron/phoronguard_only = TRUE,
		/datum/variable_setting_entry/atmos/phoron/genetic_corruption = 5,
		/datum/variable_setting_entry/atmos/phoron/skin_burns = 1,
		/datum/variable_setting_entry/atmos/phoron/eye_burns = 1,
		/datum/variable_setting_entry/atmos/phoron/contamination_loss = 0.075,
		/datum/variable_setting_entry/atmos/phoron/hallucination = TRUE,
		)
	)
	initial_preset_name = "RESET TO DEFAULT"

/datum/variable_setting_entry/atmos

/datum/variable_setting_entry/atmos/fire
	category = "Fire"

/datum/variable_setting_entry/atmos/fire/consumption_rate
	name = "Air Consumption Ratio"
	desc = "Ratio of air removed and combusted per tick."

// WARNING: This should be reworked at some point, it is a serious misnomer and at the time of writing it's not clear what this does.
/datum/variable_setting_entry/atmos/fire/firelevel_multiplier
	name = "Firelevel Constant"
	desc = "Multiplied by the equation for firelevel, affects mainly the extinguishing of fires. (WARNING: Really confusing variable. Assume that the lower this is, the more lethal and dangerous fires can get.)"

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

/datum/variable_setting_entry/atmos/phoron
	category = "Phoron"

/datum/variable_setting_entry/atmos/phoron/damage
	name = "Damage Amount"
	desc = "Self Descriptive"

/datum/variable_setting_entry/atmos/phoron/contamination
	name = "Cloth Contamination"
	desc = "If this is on, phoron does damage by getting into cloth."

/datum/variable_setting_entry/atmos/phoron/phoronguard_only
	name = "Phoronguard Only"
	desc = "If this is on, only biosuits and spacesuits and other PHORONGUARD flagged items can protect against contamination and ill effects."

/datum/variable_setting_entry/atmos/phoron/genetic_corruption
	name = "Genetic Corruption"
	desc = "X in 10,000 chance of doing genetic corruption on damage ticks."

/datum/variable_setting_entry/atmos/phoron/skin_burns
	name = "Skin Burns"
	desc = "Phoron has an effect similar to mustard gas on the un-suited."

/datum/variable_setting_entry/atmos/phoron/eye_burns
	name = "Eye Burns"
	desc = "Phoron burns the eyes of anyone not wearing eye protection."

/datum/variable_setting_entry/atmos/phoron/contamination_loss
	name = "Contamination Loss"
	desc = "Toxin damage dealt by contaminated clothing."

/datum/variable_setting_entry/atmos/phoron/hallucination
	name = "Hallucinations"
	desc = "Does being in phoron cause hallucinations?"

/datum/variable_setting_entry/atmos/n2o
	category = "N2O"

/datum/variable_setting_entry/atmos/n2o/hallucination
	name = "Hallucinations"
	desc = "Does being in sleeping gas cause hallucinations?"
