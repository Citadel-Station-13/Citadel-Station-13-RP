/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui_panel datum
 * Hosts tgchat and other nice features.
 */
/datum/tgui_panel
	var/client/client
	var/datum/tgui_window/window
	var/broken = FALSE
	var/initialized_at
	/// Each client notifies on protected playback, so this prevents spamming admins.
	var/static/admins_warned = FALSE

/datum/tgui_panel/New(client/client, id)
	src.client = client
	window = new(client, id)
	window.subscribe(src, PROC_REF(on_message))

/datum/tgui_panel/Del()
	window.unsubscribe(src)
	window.close()
	client = null
	window = null
	return ..()

/**
 * public
 *
 * TRUE if panel is initialized and ready to receive messages.
 */
/datum/tgui_panel/proc/is_ready()
	return !broken && window.is_ready()

/**
 * Initializes the chat panel.
 *
 * * This is asynchronous and will yield for an appropriate duration for the client's current state.
 */
/datum/tgui_panel/proc/initialize()
	if(!client.initialized)
		// todo: this should be a timer, but current MC doesn't really support that until we have
		//       MC init stages
		spawn(1 SECONDS)
			UNTIL(!client || client.initialized)
			if(!client)
				return
			boot()
	else
		spawn(0)
			boot()

/**
 * Boots the panel.
 *
 * * This is a blocking proc.
 */
/datum/tgui_panel/proc/boot()
	PRIVATE_PROC(TRUE)
	initialized_at = world.time
	// Perform a clean initialization
	window.initialize(
		strict_mode = TRUE,
		assets = list(/datum/asset_pack/simple/tgui_panel),
	)
	window.send_asset(/datum/asset_pack/simple/fontawesome)
	window.send_asset(/datum/asset_pack/simple/tgfont)
	window.send_asset(/datum/asset_pack/spritesheet/chat)
	// Other setup
	request_telemetry()
	addtimer(CALLBACK(src, PROC_REF(on_initialize_timed_out)), 5 SECONDS)
	window.send_message("testTelemetryCommand")

/**
 * private
 *
 * Called when initialization has timed out.
 */
/datum/tgui_panel/proc/on_initialize_timed_out()
	// Currently does nothing but sending a message to old chat.
	SEND_TEXT(client, SPAN_USERDANGER("Failed to load fancy chat, click <a href='byond://?src=[REF(src)];reload_tguipanel=1'>HERE</a> to attempt to reload it."))

/**
 * private
 *
 * Callback for handling incoming tgui messages.
 */
/datum/tgui_panel/proc/on_message(type, payload)
	if(type == "ready")
		broken = FALSE
		window.send_message("update", list(
			"config" = list(
				"client" = list(
					"ckey" = client.ckey,
					"address" = client.address,
					"computer_id" = client.computer_id,
				),
				"window" = list(
					"fancy" = FALSE,
					"locked" = FALSE,
				),
			),
		))
		return TRUE

	if(type == "audio/setAdminMusicVolume")
		client.admin_music_volume = payload["volume"]
		return TRUE

	if(type == "audio/protected")
		if(!admins_warned)
			message_admins(SPAN_NOTICE("Audio returned a protected playback error, likely due to being copyrighted."))
			admins_warned = TRUE
			addtimer(VARSET_CALLBACK(src, admins_warned, FALSE), 10 SECONDS)
		return TRUE

	if(type == "telemetry")
		analyze_telemetry(payload)
		return TRUE

/**
 * public
 *
 * Sends a round restart notification.
 */
/datum/tgui_panel/proc/send_roundrestart()
	window.send_message("roundrestart")
