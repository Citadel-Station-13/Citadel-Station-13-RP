#define APPEARANCEIFY(origin, target) \
	if (istext(origin)) { \
		target = iconstate2appearance(icon, origin); \
	} \
	else if (isicon(origin)) { \
		target = icon2appearance(origin); \
	} \
	else { \
		appearance_bro.appearance = origin; \
		if (!ispath(origin)) { \
			appearance_bro.dir = origin.dir; \
		} \
		target = appearance_bro.appearance; \
	}
