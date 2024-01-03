//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#define COMMAND_LOG_LIMIT 20

/**
 * rigsuit command line
 */
/datum/rig_console
	/// owner
	var/obj/item/rig/host
	/// list of log strings
	var/list/command_logs = list()

/datum/rig_console/New(obj/item/rig/rig)
	src.host = rig

/datum/rig_console/Destroy()
	src.host = null
	return ..()

/datum/rig_console/proc/input_command(mob/user, string, log_command)
	string = trim(string)
	if(!length(string))
		return
	if(log_command)
		command_logs += "[string]"
		if(length(command_logs) > COMMAND_LOG_LIMIT)
			command_logs.Cut(1, length(command_logs) - COMMAND_LOG_LIMIT + 1)
	var/list/split = split_command(string)
	if(!length(split))
		return
	var/result = process_command(split)
	command_logs += "> [result]"
	#warn admin logging
	return result

/datum/rig_console/proc/split_command(mob/user, raw)
	. = list()
	var/pos = 1
	var/in_space = FALSE
	for(var/i in 1 to length_char(raw))
		if(raw[i] != " ")
			if(in_space)
				in_space = FALSE
				pos = i
			continue
		if(!in_space)
			. += copytext_char(raw, 1, i)
			in_space = TRUE

/datum/rig_console/proc/tgui_console_data()
	return list(
		"lines" = command_logs,
	)

/**
 * @return list(text, log text override)
 */
/datum/rig_console/proc/process_command(mob/user, list/fragments)
	RETURN_TYPE(/list)
	switch(fragments[1])
		if("help")
			var/list/built = list(
				"-- Valid commands --",
				"system \[command\]- Send a command to the hardsuit's OS; omit command for help.",
				"piece \[id\] \[command\] - Send a command to one of the hardsuit's pieces; omit command for help, omit id for list.",
				"module \[id\] \[command\] - Send a command to one of the hardsuit's modules; omit command for help, omit id for list.",
				"deploy \[id\] \['seal'?\] - Send a command to a piece to deploy.",
				"retract \[id\] - Send a command to a piece to retract.",
				"seal \[id\] - Send a command to a piece to seal.",
				"unseal \[id\] - Send a command to a piece to unseal.",
			)
			return list(jointext(built, "<br>"), "<help text>")
		if("system")
			if(length(fragments) >= 2)
				return host.console_process(user, fragments[2], fragments.Copy(3))
			else
				var/list/query = host.console_query(user)
				var/list/built = list()
				for(var/command in query)
					built += "[command] - [query[command]]"
				return list(jointext(built, "<br>"), "<system - help>")
		if("module")
			switch(length(fragments))
				if(1)
					var/list/built = list("-- Module List --")
					for(var/id in host.module_lookup)
						built += id
					return list(jointext(built, "<br>"), "<module - list>")
				if(2)
					var/id = fragments[2]
					if(isnull(host.module_lookup[id]))
						return list("invalid module", "<module - not found>")
					var/obj/item/rig_module/module = host.module_lookup[id]
					var/list/query = module.console_query(user)
					var/list/built = list("-- [id] commands --")
					for(var/command in query)
						built += "[command] - [query[command]]"
					return list(jointext(built, "<br>"), "<module ([id]) - help>")
				else
					var/id = fragments[2]
					if(isnull(host.module_lookup[id]))
						return list("invalid module", "<module - not found>")
					var/obj/item/rig_module/module = host.module_lookup[id]
					return module.console_process(user, fragments[3], fragments.Copy(4))
		if("piece")
			switch(length(fragments))
				if(1)
					var/list/built = list("-- Piece List --")
					for(var/id in host.piece_lookup)
						built += id
					return list(jointext(built, "<br>"), "<piece - list>")
				if(2)
					var/id = fragments[2]
					if(isnull(host.piece_lookup[id]))
						return list("invalid piece", "<piece - not found>")
					var/datum/component/rig_piece/piece = host.piece_lookup[id]
					var/list/query = piece.console_query(user)
					var/list/built = list("-- [id] commands --")
					for(var/command in query)
						built += "[command] - [query[command]]"
					return list(jointext(built, "<br>"), "<piece ([id]) - help>")
				else
					var/id = fragments[2]
					if(isnull(host.piece_lookup[id]))
						return list("invalid piece", "<piece - not found>")
					var/datum/component/rig_piece/piece = host.piece_lookup[id]
					return piece.console_process(user, fragments[3], fragments.Copy(4))

		if("deploy", "retract", "seal", "unseal")
			switch(length(fragments))
				if(1)
					var/list/built = list("-- Piece List --")
					for(var/id in host.piece_lookup)
						built += id
					return list(jointext(built, "<br>"), "<piece - list>")
				else
					var/id = fragments[2]
					if(isnull(host.piece_lookup[id]))
						return list("invalid piece", "<piece - not found>")
					var/datum/component/rig_piece/piece = host.piece_lookup[id]
					return piece.console_process(user, fragments[1], fragments.Copy(3))

		else
			return list("unknown command - type 'help' for help.", "<invalid>")

#warn impl all

#undef COMMAND_LOG_LIMIT
