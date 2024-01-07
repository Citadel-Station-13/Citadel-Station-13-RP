//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#define CREATE_WALL_MOUNTING_TYPES(TYPE) \
##TYPE/north_mount{ \
	dir = SOUTH; \
} \
##TYPE/south_mount{ \
	dir = NORTH; \
} \
##TYPE/east_mount{ \
	dir = WEST; \
} \
##TYPE/west_mount{ \
	dir = EAST; \
} \
##TYPE/auto_mount/Initialize(){ \
	auto_orient_wallmount_single_preinit(); \
	return ..(); \
}

#define CREATE_WALL_MOUNTING_TYPES_AUTOSPRITE(TYPE, AUTOSPRITE) \
##TYPE/north_mount{ \
	dir = SOUTH; \
} \
##TYPE/south_mount{ \
	dir = NORTH; \
} \
##TYPE/east_mount{ \
	dir = WEST; \
} \
##TYPE/west_mount{ \
	dir = EAST; \
} \
##TYPE/auto_mount { icon_state = AUTOSPRITE } \
##TYPE/auto_mount/Initialize(){ \
	auto_orient_wallmount_single_preinit(); \
	return ..(); \
}

#define CREATE_WALL_MOUNTING_TYPES_SHIFTED(TYPE, SHIFT) \
##TYPE/north_mount{ \
	dir = SOUTH; \
	pixel_y = SHIFT; \
} \
##TYPE/south_mount{ \
	dir = NORTH; \
	pixel_y = -SHIFT; \
} \
##TYPE/east_mount{ \
	dir = WEST; \
	pixel_x = SHIFT; \
} \
##TYPE/west_mount{ \
	dir = EAST; \
	pixel_x = -SHIFT; \
} \
##TYPE/auto_mount/Initialize(){ \
	auto_orient_wallmount_single_preinit(); \
	return ..(); \
}

#define CREATE_WALL_MOUNTING_TYPES_SHIFTED_AUTOSPRITE(TYPE, SHIFT, AUTOSPRITE) \
##TYPE/north_mount{ \
	dir = SOUTH; \
	pixel_y = SHIFT; \
} \
##TYPE/south_mount{ \
	dir = NORTH; \
	pixel_y = -SHIFT; \
} \
##TYPE/east_mount{ \
	dir = WEST; \
	pixel_x = SHIFT; \
} \
##TYPE/west_mount{ \
	dir = EAST; \
	pixel_x = -SHIFT; \
} \
##TYPE/auto_mount { icon_state = AUTOSPRITE } \
##TYPE/auto_mount/Initialize(){ \
	auto_orient_wallmount_single_preinit(); \
	return ..(); \
}
