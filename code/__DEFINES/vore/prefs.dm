
DEFINE_BITFIELD(vore_toggles, list(

))

GLOBAL_REAL_VAR(vore_toggle_names) = list(

)

/proc/vore_toggle_name(toggle)
	return global.vore_toggle_names[log(2, toggle)]
