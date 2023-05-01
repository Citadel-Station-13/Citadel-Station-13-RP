/// Contains the modules applyable on omnicaskets


/obj/item/omnicasket_module
	name = "blank OmniCasket Module"
	desc =  "A blank OmniCasket Module, this one isnt even configured to fit any slots."
	slowdown = 0 //Some might give a minor slowdown
	//a variable with bitflags, MODULE_GAS_FILTER (24 bitflags might not be enough)

/obj/item/omnicasket_module/utility
	name = "blank OmniCasket Utility Module"
	desc =  "A blank OmniCasket Module, this one is configured to fit into utility slots."


/obj/item/omnicasket_kit
	name = "blank OmniCasket Kit"
	desc = "A blank Kit of OmniCasket Modules, neatly arranged in a single casing. This one seems to be emtpy..."
	var/list/obj/item/omnicasket_module/part_of_this = list()
