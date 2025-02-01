/datum/sprite_accessory/tail/shark_big
	name = "Shark, Big"
	id = "tail-shark_big"

	icon = 'icons/mob/sprite_accessory/tails/shark.dmi'
	icon_sidedness = SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND
	icon_alignment = SPRITE_ACCESSORY_ALIGNMENT_BOTTOM
	icon_dimension_x = 64
	icon_dimension_y = 32

	markings = list(
		"tips" = /datum/sprite_accessory_marking{
			name = "Tips";
			icon_state_append = "-tips";
			coloration_mode = COLORATION_MODE_MULTIPLY;
		},
		"stripes" = /datum/sprite_accessory_marking
			name = "Stripes";
			icon_state_append = "-stripes";
			coloration_mode = COLORATION_MODE_MULTIPLY;
		{},
		"stripes_underbelly" = /datum/sprite_accessory_marking{
			name = "Stripes (Underbelly)";
			icon_state_append = "-stripes_underbelly";
			coloration_mode = COLORATION_MODE_MULTIPLY;
		},
		"underbelly" = /datum/sprite_accessory_marking{
			name = "Underbelly";
			icon_state_append = "-underbelly";
			coloration_mode = COLORATION_MODE_MULTIPLY;
		},
	)

/datum/sprite_accessory/tail/shark_big_finless
	name = "Shark, Big (Finless)"
	id = "tail-shark_big-finless"

	icon = 'icons/mob/sprite_accessory/tails/shark.dmi'
	icon_sidedness = SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND
	icon_alignment = SPRITE_ACCESSORY_ALIGNMENT_BOTTOM
	icon_dimension_x = 64
	icon_dimension_y = 32

	markings = list(
		"tips" = /datum/sprite_accessory_marking{
			name = "Tips";
			icon_state_append = "-tips";
			coloration_mode = COLORATION_MODE_MULTIPLY;
		},
		"stripes" = /datum/sprite_accessory_marking
			name = "Stripes";
			icon_state_append = "-stripes";
			coloration_mode = COLORATION_MODE_MULTIPLY;
		{},
		"stripes_underbelly" = /datum/sprite_accessory_marking{
			name = "Stripes (Underbelly)";
			icon_state_append = "-stripes_underbelly";
			coloration_mode = COLORATION_MODE_MULTIPLY;
		},
		"underbelly" = /datum/sprite_accessory_marking{
			name = "Underbelly";
			icon_state_append = "-underbelly";
			coloration_mode = COLORATION_MODE_MULTIPLY;
		},
	)
