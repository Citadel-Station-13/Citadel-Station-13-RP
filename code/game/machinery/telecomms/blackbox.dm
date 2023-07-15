/datum/feedback_variable
	var/variable
	var/value
	var/details

/datum/feedback_variable/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, variable) || var_name == NAMEOF(src, value) || var_name == NAMEOF(src, details))
		return FALSE
	return ..()

/datum/feedback_variable/New(var/param_variable,var/param_value = 0)
	variable = param_variable
	value = param_value

/datum/feedback_variable/proc/inc(var/num = 1)
	if(isnum(value))
		value += num
	else
		value = text2num(value)
		if(isnum(value))
			value += num
		else
			value = num

/datum/feedback_variable/proc/dec(var/num = 1)
	if(isnum(value))
		value -= num
	else
		value = text2num(value)
		if(isnum(value))
			value -= num
		else
			value = -num

/datum/feedback_variable/proc/set_value(var/num)
	if(isnum(num))
		value = num

/datum/feedback_variable/proc/get_value()
	return value

/datum/feedback_variable/proc/get_variable()
	return variable

/datum/feedback_variable/proc/set_details(var/text)
	if(istext(text))
		details = text

/datum/feedback_variable/proc/add_details(var/text)
	if(istext(text))
		if(!details)
			details = text
		else
			details += " [text]"

/datum/feedback_variable/proc/get_details()
	return details

/datum/feedback_variable/proc/get_parsed()
	return list(variable,value,details)

var/obj/machinery/blackbox_recorder/blackbox

/obj/machinery/blackbox_recorder
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "blackbox"
	name = "Blackbox Recorder"
	density = 1
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
	var/list/messages = list()		//Stores messages of non-standard frequencies
	var/list/messages_admin = list()

	var/list/msg_common = list()
	var/list/msg_science = list()
	var/list/msg_command = list()
	var/list/msg_medical = list()
	var/list/msg_engineering = list()
	var/list/msg_security = list()
	var/list/msg_deathsquad = list()
	var/list/msg_syndicate = list()
	var/list/msg_raider = list()
	var/list/msg_cargo = list()
	var/list/msg_service = list()
	var/list/msg_explorer = list()

	var/list/datum/feedback_variable/feedback = new()

	//Only one can exist in the world!
/obj/machinery/blackbox_recorder/Initialize(mapload, newdir)
	. = ..()
	if(istype(blackbox,/obj/machinery/blackbox_recorder))
		return INITIALIZE_HINT_QDEL
	blackbox = src

/obj/machinery/blackbox_recorder/Destroy()
	var/turf/T = locate(1,1,2)
	if(T)
		blackbox = null
		var/obj/machinery/blackbox_recorder/BR = new/obj/machinery/blackbox_recorder(T)
		BR.msg_common = msg_common
		BR.msg_science = msg_science
		BR.msg_command = msg_command
		BR.msg_medical = msg_medical
		BR.msg_engineering = msg_engineering
		BR.msg_security = msg_security
		BR.msg_deathsquad = msg_deathsquad
		BR.msg_syndicate = msg_syndicate
		BR.msg_cargo = msg_cargo
		BR.msg_service = msg_service
		BR.feedback = feedback
		BR.messages = messages
		BR.messages_admin = messages_admin
		if(blackbox != BR)
			blackbox = BR
	..()

/obj/machinery/blackbox_recorder/proc/find_feedback_datum(var/variable)
	for(var/datum/feedback_variable/FV in feedback)
		if(FV.get_variable() == variable)
			return FV
	var/datum/feedback_variable/FV = new(variable)
	feedback += FV
	return FV

/obj/machinery/blackbox_recorder/proc/get_round_feedback()
	return feedback

/obj/machinery/blackbox_recorder/proc/round_end_data_gathering()

	var/pda_msg_amt = 0
	var/rc_msg_amt = 0

	for(var/obj/machinery/message_server/MS in GLOB.machines)
		if(MS.pda_msgs.len > pda_msg_amt)
			pda_msg_amt = MS.pda_msgs.len
		if(MS.rc_msgs.len > rc_msg_amt)
			rc_msg_amt = MS.rc_msgs.len

	feedback_set_details("radio_usage","")

	feedback_add_details("radio_usage","COM-[msg_common.len]")
	feedback_add_details("radio_usage","SCI-[msg_science.len]")
	feedback_add_details("radio_usage","HEA-[msg_command.len]")
	feedback_add_details("radio_usage","MED-[msg_medical.len]")
	feedback_add_details("radio_usage","ENG-[msg_engineering.len]")
	feedback_add_details("radio_usage","SEC-[msg_security.len]")
	feedback_add_details("radio_usage","DTH-[msg_deathsquad.len]")
	feedback_add_details("radio_usage","SYN-[msg_syndicate.len]")
	feedback_add_details("radio_usage","CAR-[msg_cargo.len]")
	feedback_add_details("radio_usage","SRV-[msg_service.len]")
	feedback_add_details("radio_usage","OTH-[messages.len]")
	feedback_add_details("radio_usage","PDA-[pda_msg_amt]")
	feedback_add_details("radio_usage","RC-[rc_msg_amt]")


	feedback_set_details("round_end","[time2text(world.realtime)]") //This one MUST be the last one that gets set.

/obj/machinery/blackbox_recorder/vv_edit_var(var_name, var_value)
	var/static/list/blocked_vars		//hacky as fuck kill me
	if(!blocked_vars)
		var/obj/machinery/M = new
		var/list/parent_vars = M.vars.Copy()
		blocked_vars = vars.Copy() - parent_vars
	if(var_name in blocked_vars)
		return FALSE
	return ..()

//This proc is only to be called at round end.
/obj/machinery/blackbox_recorder/proc/save_all_data_to_sql()
	if(!feedback) return

	round_end_data_gathering() //round_end time logging and some other data processing

	if(!SSdbcore.Connect())
		return

	var/round_id

	var/datum/db_query/query = SSdbcore.RunQuery(
		"SELECT MAX(round_id) AS round_id FROM [format_table_name("feedback")]",
		list()
	)

	while(query.NextRow())
		round_id = query.item[1]

	if(!isnum(round_id))
		round_id = text2num(round_id)
	round_id++

	for(var/datum/feedback_variable/FV in feedback)
		SSdbcore.RunQuery(
			"INSERT INTO [format_table_name("feedback")] VALUES (null, Now(), :round_id, :variable, :value, :details)",
			list(
				"round_id" = "[round_id]",
				"variable" = "[FV.get_variable()]",
				"value" = "[FV.get_value()]",
				"details" = "[FV.get_details()]"
			)
		)

/proc/feedback_set(variable, value)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV)
		return

	FV.set_value(value)

/proc/feedback_inc(variable, value)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV)
		return

	FV.inc(value)

/proc/feedback_dec(variable, value)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV)
		return

	FV.dec(value)

/proc/feedback_set_details(variable, details)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)
	details = sql_sanitize_text(details)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV)
		return

	FV.set_details(details)

/proc/feedback_add_details(variable, details)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)
	details = sql_sanitize_text(details)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV)
		return

	FV.add_details(details)
