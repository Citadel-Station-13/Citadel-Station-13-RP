/datum/security_level
	/// The name of this security level, ie: "Green" 
	var/name
	/// The #define for this security level, ie: SEC_LEVEL_GREEN
	var/number_level
	/// The soundbyte that should play when lowered to this level
	var/datum/soundbyte/down_sound = /datum/soundbyte/announcer/notice
	/// The soundbyte that should play when raised to this level
	var/datum/soundbyte/up_sound = /datum/soundbyte/security_level/raised
	/// Config key for the announcement when lowered to this level
	var/lowered_to_announcement
	/// Config key for the announcement when raised to this level
	var/raised_to_announcement
	/// Config key for the announcement when lowered to this level
	var/lowered_to_key
	/// Config key for the announcement when raised to this level
	var/raised_to_key

/datum/security_level/New()
	. = ..()
	if(lowered_to_key) // There doesn't seem to be a better way of doing this.
		lowered_to_announcement = global.config.Get(lowered_to_key)
	if(raised_to_key)
		raised_to_announcement = global.config.Get(raised_to_key)


/datum/security_level/green // No threats, all normal.
	name = "green"
	number_level = SEC_LEVEL_GREEN
	lowered_to_key = /datum/config_entry/string/alert_desc_green

/datum/security_level/blue // Possible threats, be cautious.
	name = "blue"
	number_level = SEC_LEVEL_BLUE
	lowered_to_key = /datum/config_entry/string/alert_desc_blue_downto
	raised_to_key = /datum/config_entry/string/alert_desc_blue_upto
	down_sound = /datum/soundbyte/security_level/blue_alert
	up_sound = /datum/soundbyte/security_level/blue_alert

/datum/security_level/yellow // Security emergency
	name = "yellow"
	number_level = SEC_LEVEL_YELLOW
	lowered_to_key = /datum/config_entry/string/alert_desc_yellow_downto
	raised_to_key = /datum/config_entry/string/alert_desc_yellow_upto

/datum/security_level/violet // Medical emergency
	name = "violet"
	number_level = SEC_LEVEL_VIOLET
	lowered_to_key = /datum/config_entry/string/alert_desc_violet_downto
	raised_to_key = /datum/config_entry/string/alert_desc_violet_upto
	

/datum/security_level/orange // Engineering emergency
	name = "orange"
	number_level = SEC_LEVEL_ORANGE
	lowered_to_key = /datum/config_entry/string/alert_desc_orange_downto
	raised_to_key = /datum/config_entry/string/alert_desc_orange_upto
	

/datum/security_level/red // Threats to the station, all hands on deck.
	name = "red"
	number_level = SEC_LEVEL_RED
	lowered_to_key = /datum/config_entry/string/alert_desc_red_downto
	raised_to_key = /datum/config_entry/string/alert_desc_red_upto
	down_sound = /datum/soundbyte/security_level/red_alert_lowered
	up_sound = /datum/soundbyte/security_level/red_alert_raised
	

/datum/security_level/delta // Scuttling procedure in progress, evacuate immediately.
	name = "delta"
	number_level = SEC_LEVEL_DELTA
	raised_to_key = /datum/config_entry/string/alert_desc_delta
	up_sound = /datum/soundbyte/security_level/delta_alert
