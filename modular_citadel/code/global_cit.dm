//
/// Modular: Service Hounds, scary ambience sound.
//

/hook/startup/proc/modules_cit()
	robot_module_types += "Service-Hound"
	return 1

/hook/startup/proc/scary_sounds_cit()
	scarySounds += 'modular_citadel/sound/spooky/banned_from_life.ogg'
	return 1
