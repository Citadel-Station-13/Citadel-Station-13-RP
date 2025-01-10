/obj/item/robot_upgrade/bluespaceorebag
	name = "bluespace mining satchel module"
	desc = "Improves the ore satchels of mining units to hold a lot more ores."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_MINER
	require_module = TRUE

/obj/item/robot_upgrade/bluespaceorebag/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	var/obj/item/storage/bag/ore/O = locate() in R.module
	if(!O)
		O = locate() in R.module.contents
	if(!O)
		O = locate() in R.module.modules
	if(!O) //there should be one though...
		R.module.modules += new/obj/item/storage/bag/ore/bluespace(R.module)
		return TRUE
	if(O)
		if(istype(O,/obj/item/storage/bag/ore/bluespace))
			to_chat(R, "Upgrade mounting error! Upgrade already present.")
			to_chat(usr, SPAN_WARNING("[R] already has this upgrade!"))
			return FALSE
		else
			R.uneq_all()
			O.deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED) //drops all ores previous satchel was carrying using this method
			R.module.modules += new/obj/item/storage/bag/ore/bluespace(R.module)
			return TRUE
