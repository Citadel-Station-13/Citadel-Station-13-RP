/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_EDIT_APPEARANCE, "Edit Appearance")

/mob/living/carbon/human/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_EDIT_APPEARANCE])
		#warn impl - shapeshift panel admin
