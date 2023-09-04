/**
 * Gun firing modes
 *
 * Handles a bunch of things, like overriding firing sounds, burst amounts, etc.
 */
/datum/firemode
	/// player-facing name - this is rendered as '[gun] is now firing in [name] mode.'
	var/name = "an unknown"
	/// shots in burst
	var/burst_amount = 1
	/// burst spacing in deciseconds
	var/burst_spacing = 0.5
	/// override fire delay after shooting before the gun can be shot again
	/// this overrides clickdelay!
	var/fire_delay
	/// override fire sound
	/// priority:
	/// projectile fire sound --> firemode fire sound --> gun fire sound
	var/fire_sound

