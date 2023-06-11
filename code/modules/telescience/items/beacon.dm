/obj/item/bluespace_beacon
	name = "bluespace signal flare"
	desc = "A miniature cell-powered flare used to provide an adequate signal for teleporters to lock onto. It doesn't look very energy-efficient."
	#warn icon, state

	/// on
	var/signal_active = FALSE
	/// tag
	var/signal_label = "SIG0"
	/// our signal
	var/datum/bluespace_signal/signal
	/// our transmission power
	var/signal_power = 10
	/// conversion rate of watts to power
	var/signal_cost = 100
	/// max transmission power
	var/signal_max = 100
	/// signal power adjustable?
	var/signal_adjust = TRUE
	/// our transimssion boost
	var/signal_boost_power = 0
	/// conversion rate of watts to boost power
	var/signal_boost_cost = 0
	/// signal boost power adjustable?
	var/signal_boost_adjust = FALSE
	/// inherent signal inaccuracy
	var/signal_inaccuracy = 0
	/// inherent signal instability
	var/signal_instability = 0
	/// can we encrypt our signal?
	var/signal_encryption = FALSE
	/// encryption key for signal
	var/signal_key
	/// obfuscation factor of effective power if encrypted, against anything that doesn't know the key
	var/signal_obfuscation = 0.01
	/// power cell
	var/obj/item/cell/cell
	/// starting cell
	var/cell_type = /obj/item/cell/high
	/// uses power? if false, we just don't draw power.
	var/cell_powered = TRUE

#warn impl all

/obj/item/bluespace_beacon/Initialize(mapload)
	. = ..()
	if(ispath(cell_type))
		cell = new cell_type
	reset_signal()

/obj/item/bluespace_beacon/proc/set_active(active)

/obj/item/bluespace_beacon/proc/set_label(label)

/obj/item/bluespace_beacon/proc/reset_signal()

#warn impl all

/obj/item/bluespace_beacon/proc/draw_power(amount)

/obj/item/bluespace_beacon/process(delta_time)
	#warn impl

/obj/item/bluespace_beacon/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/item/bluespace_beacon/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/bluespace_beacon/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/bluespace_beacon/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
