
DEFINE_BITFIELD(vore_toggles, list(

))

GLOBAL_REAL_VAR(vore_toggle_names) = list(

)

/proc/vore_toggle_name(toggle)
	return vore_toggle_name[log(2, toggle)]
