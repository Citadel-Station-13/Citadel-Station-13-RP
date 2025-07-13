//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/dyntool_image_neutral(function)
	return image('icons/screen/radial/tools/generic.dmi', icon_state = _dyntool_image_states[function] || "unknown")

/proc/dyntool_image_forward(function)
	return image('icons/screen/radial/tools/generic.dmi', icon_state = "[_dyntool_image_states[function] || "unknown"]_up")

/proc/dyntool_image_backward(function)
	return image('icons/screen/radial/tools/generic.dmi', icon_state = "[_dyntool_image_states[function] || "unknown"]_down")
